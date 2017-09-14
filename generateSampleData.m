% generate synthetic data
% n1: number of instances in the 1st cluster, 
% n2: number of instances in the 2nd cluster
% D: number of features
function [X1, X2, mu1, mu2, sigma1, sigma2] = generateSampleData (n1, n2, D) % 
  mu1 = randi(5, 1, 2) /2;
  mu2 = randi(6, 1, 2) * (-1/3);
  
  
  S1 = randn(2, 2);
  S2 = randn(2, 2);
  
  S1 = S1' * S1;
  S2 = S2' * S2;
 
  % create correlation matrix
  s1 = sqrt(diag(S1));
  s2 = sqrt(diag(S2));
  sigma1 = diag(1./s1) * S1 * diag(1./s1);
  sigma2 = diag(1./s2) * S2 * diag(1./s2);
  
  
  X1 = randn(n1, D) * chol(sigma1) + repmat(mu1, n1, 1);
  X2 = randn(n2, D) * chol(sigma2) + repmat(mu2, n2, 1);
  
end