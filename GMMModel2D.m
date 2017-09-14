%%% implement EM algorithm in GMM model
% implement GMM model
function GMMModel2D
    n1 = 40;
    n2 = 32;
    D = 2;% 2  features
    [X1, X2, mu1, mu2, sigma1, sigma2] = generateSampleData(n1, n2, D);
    
    % parameters of original data
    C1 = ones(n1, 1); %C1: 1st clustering label
    C2 = ones(n2, 1) * 2; %C2: 2nd clustering label
    C = [C1; C2];

    muI = [mu1; mu2];
    sigmaI = [];
    sigmaI{1} = sigma1;
    sigmaI{2} = sigma2;
    figure(1);
    plotData(X1, X2, muI, sigmaI);
    hold off;
    
    X = [X1; X2];
    % training model
    N = size(X, 1);
    K =  2; % number of Gaussians

    Nk = zeros(1, K);

    %% Step 1:  initialize the parameters
    [mu, sigma, pik] = initializeParameters(X, K);
    gamma = zeros(N, K);

    for (iter = 1:1000)

      %fprintf('  EM Iteration %d\n', iter);

      %%===============================================
      %% STEP 2 (E step): Expectation
      % evaluate the responsibilities
      for i = 1 : K
        gamma(:, i) = pik(i)*gaussianND(X, mu(i, :), sigma{i});
        
      end

      sumofgammaRow = sum(gamma, 2);
      gamma = gamma ./ repmat(sumofgammaRow, 1, K);


      %%===============================================
      %% STEP 3 (M- step): Re-estimate
      Nk = sum(gamma, 1);
      for i = 1: K
        mu(i, :) = sum(repmat(gamma(:, i), 1, D) .* X, 1)/Nk(i);
        sigma{i} = ((repmat(gamma(:, i), 1, D) .* (X - repmat(mu(i, :), N, 1)))' * (X-repmat(mu(i, :), N, 1)))/Nk(i);
        pik(i) = Nk(i)/N;
      end
    end
    
      %%===============================================
      %% STEP 4:  evaluate model
    %% 1st : 
    [maxValues, maxIndexs] = max(gamma, [], 2);
   

%    
%    fprintf("accuracy: ");
%    disp(CI');
%    fprintf("/////////////////////////////");
%    acc1 = sum(C == maxIndexs);
%    acc2 = sum(CI == maxIndexs);
%    acc = max(acc1, acc2);
%    disp(acc);
%    disp(maxIndexs');
   
     %% 2: 
     
     %assign each row of original data with corresponding muy

     costMat = computeCostMat(muI, mu);
     [assignment,cost] = hungarian(costMat);
     
     maxIndexs = (assignment(maxIndexs(:)));
     fprintf("acc: ");
     acc = sum(C == maxIndexs)*100/N;
     disp(acc);
     output1 = X(maxIndexs == 1, :);
     output2 = X(maxIndexs == 2, :);
     figure(2);
     plotData(output1, output2, mu, sigma);
     hold off;
 

end

% initialize the values of parameters
function [mu, sigma, pik] = initializeParameters(X, K) % k clusters
  D =size(X, 2);
	N = size(X, 1);
  mu = zeros(K, D);
  sigma = [];
  pik = zeros(K, 1);
  
	C = zeros(N, 1); % randomly assign each instance to one of K clusters
  C = randi(K, N, 1);
  
  % inilitalize the mean and covariance of each cluster by its empirical mean and empirical covariance
  for i = 1: K
    sigma_k = zeros(D, D);
    X_k = X(C == i, :);
    mu(i, :) = sum(X_k, 1)/size(X_k, 1);
    sigma_k = (X_k - repmat(mu(i, :), size(X_k, 1), 1))' * (X_k - repmat(mu(i, :), size(X_k, 1), 1)) / size(X_k, 1);
    sigma{i} = sigma_k;
  end
  
  pik = ones(1, K) /K;
  
end



