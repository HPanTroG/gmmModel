% plot data in 2-dimensional space
function plotData(X1, X2, mu, sigma)
	plot(X1(:, 1), X1(:, 2), "ro");
	hold on;
	plot(X2(:, 1), X2(:, 2), "k*");
	
	set(gcf,'color','white') % White background for the figure.
	hold on;
	plot(mu(1, 1), mu(1, 2), 'yx','LineWidth', 2, 'MarkerSize', 7);
	plot(mu(2, 1), mu(2, 2), 'rx', 'LineWidth', 2, 'MarkerSize', 7);
	

	% First, create a matrix 'gridX' of coordinates representing
	% the input values over the grid.
	gridSize = 100;
	u = linspace(-6, 6, gridSize);
	[A B] = meshgrid(u, u);
	gridX = [A(:), B(:)];

	% Calculate the Gaussian response for every value in the grid.
	z1 = gaussianND(gridX, mu(1, :), sigma{1});
	z2 = gaussianND(gridX, mu(2, :), sigma{2});

	% Reshape the responses back into a 2D grid to be plotted with contour.
	Z1 = reshape(z1, gridSize, gridSize);
	Z2 = reshape(z2, gridSize, gridSize);

	% Plot the contour lines 
	[C, h] = contour(u, u, Z1);
	[C, h] = contour(u, u, Z2);
	
	
end