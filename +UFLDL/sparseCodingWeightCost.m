function [cost, grad] = sparseCodingWeightCost(weightMatrix, featureMatrix, visibleSize, numFeatures,  patches, gamma, lambda, epsilon, groupMatrix)
%sparseCodingWeightCost - given the features in featureMatrix, 
%                         computes the cost and gradient with respect to
%                         the weights, given in weightMatrix
% parameters
%   weightMatrix  - the weight matrix. weightMatrix(:, c) is the cth basis
%                   vector.
%   featureMatrix - the feature matrix. featureMatrix(:, c) is the features
%                   for the cth example
%   visibleSize   - number of pixels in the patches
%   numFeatures   - number of features
%   patches       - patches
%   gamma         - weight decay parameter (on weightMatrix)
%   lambda        - L1 sparsity weight (on featureMatrix)
%   epsilon       - L1 sparsity epsilon
%   groupMatrix   - the grouping matrix. groupMatrix(r, :) indicates the
%                   features included in the rth group. groupMatrix(r, c)
%                   is 1 if the cth feature is in the rth group and 0
%                   otherwise.

    if exist('groupMatrix', 'var')
        assert(size(groupMatrix, 2) == numFeatures, 'groupMatrix has bad dimension');
    else
        groupMatrix = eye(numFeatures);
    end

    numExamples = size(patches, 2);

    weightMatrix = reshape(weightMatrix, visibleSize, numFeatures); % this is A
    featureMatrix = reshape(featureMatrix, numFeatures, numExamples); % this is s.
    
    % -------------------- YOUR CODE HERE --------------------
    % Instructions:
    %   Write code to compute the cost and gradient with respect to the
    %   weights given in weightMatrix.     
    % -------------------- YOUR CODE HERE --------------------    
    
    residual = weightMatrix*featureMatrix - patches; % this is [visibleSize x numExamples].
    
    cost = (1/numExamples)*sum(residual(:).^2); % this is 1/m*||As-x||_2^2 term. Normalized by number of examples to make sure that the second penalty term will not be overwhelmed.
    cost = cost + gamma*sum(weightMatrix(:).^2); % this is the ||A||_2^2 term. Notice that actually this is F-norm, rather than 2 norm.
    
    
    grad = (1/numExamples)*2*residual*(featureMatrix)'; % grad for 1/m*||As-x||_2^2 term.
    grad = grad + 2*gamma*weightMatrix; % grad for ||A||_2^2 term..
    
    grad = grad(:);
end