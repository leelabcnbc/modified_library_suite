function [cost, grad] = sparseCodingFeatureCost(weightMatrix, featureMatrix, visibleSize, numFeatures, patches, gamma, lambda, epsilon, groupMatrix)
%sparseCodingFeatureCost - given the weights in weightMatrix,
%                          computes the cost and gradient with respect to
%                          the features, given in featureMatrix
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

    weightMatrix = reshape(weightMatrix, visibleSize, numFeatures);
    featureMatrix = reshape(featureMatrix, numFeatures, numExamples);

    % -------------------- YOUR CODE HERE --------------------
    % Instructions:
    %   Write code to compute the cost and gradient with respect to the
    %   features given in featureMatrix.     
    %   You may wish to write the non-topographic version, ignoring
    %   the grouping matrix groupMatrix first, and extend the 
    %   non-topographic version to the topographic version later.
    % -------------------- YOUR CODE HERE --------------------
    
    residual = weightMatrix*featureMatrix - patches; % this is [visibleSize x numExamples].
    squareFeature = featureMatrix.^2; % used later to compute the penalty term.
    % size [numFeatures x numExamples].
    
    cost = (1/numExamples)*sum(residual(:).^2); % this is 1/m*||As-x||_2^2 term.
    
    groupCost = groupMatrix*squareFeature + epsilon; % this is numGroup x numExamples.
    groupCostSqrt = sqrt(groupCost); % sqrt version. used to compute gradient.
%     cost = cost + lambda*sum(groupCostSqrt(:)); % this is \sum_group sqrt(sum(s^2) + epsilon)) term.
    cost = cost + (1/numExamples)*lambda*sum(groupCostSqrt(:)); % this is \sum_group sqrt(sum(s^2) + epsilon)) term.
    
    grad = (1/numExamples)*2*weightMatrix'*residual; % grad for ||As-x||_2^2 term.
    grad = grad + (1/numExamples)*lambda*(featureMatrix.*(groupMatrix'*(1./groupCostSqrt)));  %   for \sum_group sqrt(sum(s^2) + epsilon)) term.
%     grad = grad + lambda*(featureMatrix.*(groupMatrix'*(1./groupCostSqrt)));  %   for \sum_group sqrt(sum(s^2) + epsilon)) term.
    
    grad = grad(:);
    
end