function [assignment, cost] = hungarian (costMat)
  %costMat = [0 1 2 3; 3 2 1 0; 0 3 2 4; 1 0 0 8];
	N = size(costMat, 1);
	assignment = zeros(N, 1);
	cost = 0;
	
	% check if it's exist a row with all zeros and a column with all zeros
	cRow = any(costMat, 1);
	cColumn = any(costMat, 2);
	
	n = max(sum(cRow), sum(cColumn));
	if n < N
		return;
	end
	
	tCostMat =  costMat;
	%%STEP 1: Subtract the lowest value of each row from each element in the row
	tCostMat = tCostMat -  min(tCostMat, [], 2);
	%%STEP 2: subtract the lowest value of each column from each element in the column
	tCostMat = tCostMat - min(tCostMat, [], 1);
	
	
	while 1
	%%STEP 3: Cover the matrix by marking as fews rows/colums as possible
		markingRows = zeros(N, 1);
		markingMatrix = (tCostMat==0);
		while(any(markingMatrix(:)))% check if it's exist any non-zeros in matrix
			[r, c] = find(markingMatrix, 1);
			markingRows(r) = c;
			markingMatrix(r, :) = 0;
			markingMatrix(:, c) = 0;	
		end
		
	
		if all(markingRows) > 0
			break;
		end
    
    coverRow = ones(N, 1);
    coverColumn = zeros(1, N);
    
    
    nRow = find(~markingRows);
    coverRow(nRow) = 0;
    markingRows(nRow) = -1;
		while(!isempty(nRow)) % exist non-assigned rows
      
      nColumn = find(max(tCostMat(nRow, :)==0 & ~coverColumn, [], 1));  %  find columns having zeros in newly marked rows
      if isempty(nColumn)
        break;
      end
      coverColumn(nColumn) = 1 ; 
      nRow = find(max((tCostMat(:, nColumn) ==0) & (markingRows > 0),[], 2));
      coverRow(nRow) =0;
      
    end
    
		if (sum(coverRow) + sum(coverColumn)) ==N
      break;
    end
    
    
    
    %STEP 4: Subtract the lowest value that are left from every unmarked elements and add it to every covered elements
    nonCovering = tCostMat(~coverRow, ~coverColumn);
    minNonCovering = min(nonCovering(:));
    tCostMat(~coverRow, ~coverColumn) -= minNonCovering;
    tCostMat(coverRow == 1, coverColumn == 1) += minNonCovering;

	end
  % compute assignment and cost
  i = 0;
  assignment = zeros(N, 1);
  tCostMat = tCostMat== 0;
  cost = 0;
  while(i<N)
    sumR = sum(tCostMat, 2);
    rIndex = sumR ==1;
    [t cIndex] = max((tCostMat(rIndex, :)),[], 2);
    assignment(rIndex) = cIndex;
    tCostMat(rIndex, :) = 0;
    tCostMat(:, cIndex) = 0;
    i += sum(rIndex);
    
    
    sumC = sum(tCostMat, 1);
    
    cIndex = find(sumC == 1);
    [t rIndex] = max((tCostMat(:, cIndex)),[], 1);

    assignment(rIndex) = cIndex;
    tCostMat(:, cIndex) = 0;
    tCostMat(rIndex, :) = 0;
    i += sum(sumC == 1);
  end
  for i = 1: N
    cost += costMat(i, assignment(i));
  end

end