function [sparse_coding_result, pars] =  sparse_coding(X,argsChanged)
% SPARSE_CODING
%
%   repackaging of UFLDL sparse coding code.
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 01-Feb-2015 19:45:17 $
%% DEVELOPED : 8.3.0.532 (R2014a)
%% FILENAME  : sparse_coding.m

% X should be of size N x numPixels.

import UFLDL.sparse_coding_default_pars
import UFLDL.sparseCodingFeatureCost
import UFLDL.display_network

if nargin < 2 || isempty(argsChanged)
    argsChanged = {};
end

pars = parseArgs(argsChanged,sparse_coding_default_pars());
pars = rmfield(pars,'NumericArguments');
visibleSize = size(X,2);
assert(ismatrix(X));

%% unpacking parameters.
lambda = pars.lambda;
epsilon = pars.epsilon;
gamma = pars.gamma;
numFeatures = pars.numFeatures;
batchNumPatches = pars.batchNumPatches;
numPatches = size(X,1);
assert(batchNumPatches<=numPatches); % don't allow a batch bigger than number of available images.

%% set minFunc parameters.
options = struct();
options.Method = pars.optMethod;  % cg seems better than lbfgs.
options.display = 'off';
options.verbose = 0;
options.maxIter = pars.optMaxIter;

%% initialize matrices

if isempty(pars.initSeed)
    rng('shuffle');
else
    rng(pars.initSeed,'twister');
end

% initFunctionHandle = [];
if isequal(pars.initFunction,'rand')
    initFunctionHandle = @rand;
else
    assert(isequal(pars.initFunction,'randn'));
    initFunctionHandle = @randn;
end

weightMatrixInit = pars.initMultiplier*initFunctionHandle(visibleSize, numFeatures);
featureMatrixInit = pars.initMultiplier*initFunctionHandle(numFeatures, batchNumPatches);

weightMatrix = weightMatrixInit;
featureMatrix = featureMatrixInit;

%% Initialize grouping matrix
groupMatrix = eye(numFeatures);
if pars.topography
    poolDim = pars.poolDim;
    assert(poolDim>0);
    assert(floor(sqrt(numFeatures)) ^2 == numFeatures, 'numFeatures should be a perfect square when topography is on');
    donutDim = floor(sqrt(numFeatures));
    assert(donutDim * donutDim == numFeatures,'donutDim^2 must be equal to numFeatures');
    groupMatrix = zeros(numFeatures, donutDim, donutDim);
    groupNum = 1;
    for row = 1:donutDim
        for col = 1:donutDim
            groupMatrix(groupNum, 1:poolDim, 1:poolDim) = 1;
            groupNum = groupNum + 1;
            groupMatrix = circshift(groupMatrix, [0 0 -1]);
        end
        groupMatrix = circshift(groupMatrix, [0 -1, 0]);
    end
    groupMatrix = reshape(groupMatrix, numFeatures, numFeatures);
end


% Initial batch.
% I'd better records the indices for future reference.

X = X';

indices = randperm(numPatches);
indices = indices(1:batchNumPatches);
batchPatches = X(:, indices);                           

fprintf('%6s%12s%12s%12s%12s\n','Iter', 'fObj','fResidue','fSparsity','fWeight');

regularTerm = eye(numFeatures)*gamma;

for iteration = 1:pars.iterationTotal                      
    error = weightMatrix * featureMatrix - batchPatches;
    error = sum(error(:) .^ 2) / batchNumPatches;
    
    fResidue = error;
    
    R = groupMatrix * (featureMatrix .^ 2);
    R = sqrt(R + epsilon);    
    fSparsity = lambda * sum(R(:));  
    fSparsity = fSparsity/batchNumPatches; % I like to normalize this.
    
    fWeight = gamma * sum(weightMatrix(:) .^ 2);
    
    fprintf('  %4d  %10.4f  %10.4f  %10.4f  %10.4f\n', iteration, fResidue+fSparsity+fWeight, fResidue, fSparsity, fWeight)
               
    % Select a new batch
    indices = randperm(numPatches);
    indices = indices(1:batchNumPatches);
    batchPatches = X(:, indices);                    
    
    % Reinitialize featureMatrix with respect to the new batch
    featureMatrix = weightMatrix' * batchPatches;
    normWM = sum(weightMatrix .^ 2)';
    featureMatrix = bsxfun(@rdivide, featureMatrix, normWM); 
    
    % Optimize for feature matrix    
    [featureMatrix, ~] = minFunc( @(x) sparseCodingFeatureCost(weightMatrix, x, visibleSize, numFeatures, batchPatches, gamma, lambda, epsilon, groupMatrix), ...
                                           featureMatrix(:), options);
    featureMatrix = reshape(featureMatrix, numFeatures, batchNumPatches);                                      
       
    % Optimize for weight matrix  
%     weightMatrix = zeros(visibleSize, numFeatures);     
    % -------------------- YOUR CODE HERE --------------------
    % Instructions:
    %   Fill in the analytic solution for weightMatrix that minimizes 
    %   the weight cost here.     
    %   Once that is done, use the code provided below to check that your
    %   closed form solution is correct.
    %   Once you have verified that your closed form solution is correct,
    %   you should comment out the checking code before running the
    %   optimization.   
    
    featureTerm = (1/batchNumPatches)*(featureMatrix*featureMatrix');
    weightMatrix = ( (1/batchNumPatches)* batchPatches*featureMatrix')/(regularTerm+featureTerm);
    
%     [cost, grad] = sparseCodingWeightCost(weightMatrix, featureMatrix, visibleSize, numFeatures, batchPatches, gamma, lambda, epsilon, groupMatrix);
%     assert(norm(grad) < 1e-12, 'Weight gradient should be close to 0. Check your closed form solution for weightMatrix again.')
%     error('Weight gradient is okay. Comment out checking code before running optimization.');
    % -------------------- YOUR CODE HERE --------------------   
    
    % Visualize learned basis
    if pars.visualize
        figure(1);
        display_network(weightMatrix);   
    end
end

sparse_coding_result = struct();
sparse_coding_result.weightMatrix = weightMatrix;
sparse_coding_result.featureMatrix = featureMatrix;

end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [sparse_coding.m] ======
