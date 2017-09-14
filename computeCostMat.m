function costMat = computeCostMat(gMu, pMu)
  K = size(gMu, 1);
  costMat = zeros(K, K);
  for i = 1: K
    costMat(i, :) = (sqrt(sum((gMu(i, :) - pMu(:, :)).^2, 2)))';
    %costMat(i, :) =  (sum((gMu(i, :).*pMu(:, :)), 2) / norm(gMu(i, :), 2) .* sqrt(sum(pMu.^2, 2)))';
  end
    
end