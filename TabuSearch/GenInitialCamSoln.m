function [CamSoln CamSolnCost TabuList] = GenInitialCamSoln(CostCalcFn, CostMap, BoundaryMap, CamList)

% This function generates a camera placement solution
% 
% Inputs:
%   CostMap: The element (i, j) represents the cost of not covering that position on the grid
% 	BoundaryMap: Map containing which sections each point belongs to. The element (i, j) represents
%		the section that position on the grid belongs to
%	CamList: List of cameras to be placed
%
% Outputs:
%   CamSoln:  A spare matrix that represents the spanning tree obtained. 
%        The element (i,j) is 1 if nodes i and j are connected in the tree, 
%        otherwise it's 0. The matrix is symmetric.
%   CamSolnCost: The cost of the output spanning tree

% Get the number Cameras of dimensions of the CostMap
[MaxLength, MaxWidth] = size(CostMap);
CamCount = size(CamList, 1);

%create 3 by n matrix for solution
CamSoln = zeros(CamCount, 3);

% For each camera, generate a random position
for i = 1:CamCount
	x = random(1..maxWidth);
	y = random(1..maxLength);
	direction = random(1,2);
	CamSoln(i,:) = [x, y, direction];
end

% Calculate the cost of the spanning tree
[CamSolnCost] = feval(CalcCostFn, CamList, CostMap, BoundaryMap, CamSoln);


% Initialize the tabu list. The tabu list represents that set of cameras
% that can't be moved to find the neighbourhood of the current solution
TabuList = zeros(CamCount, 1);
