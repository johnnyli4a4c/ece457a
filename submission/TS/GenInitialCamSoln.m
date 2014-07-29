function [CamSoln CamSolnCost TabuList] = GenInitialCamSoln(CostCalcFn, SectionCosts, BoundaryMap, CamList)

% This function generates a camera placement solution
% 
% Inputs:
%   SectionCosts: Array containing the costs associated with each section. Value at position 1 should indicate cost of section 1
% 	BoundaryMap: Map containing which sections each point belongs to. The element (i, j) represents
%		the section that position on the grid belongs to
%	CamList: List of cameras to be placed
%	CostCalcFn: A handle to a function that determines the cost of the soln
%
% Outputs:
%   CamSoln:  A spare matrix that represents the spanning tree obtained. 
%        The element (i,j) is 1 if nodes i and j are connected in the tree, 
%        otherwise it's 0. The matrix is symmetric.
%   CamSolnCost: The cost of the output spanning tree

% Get the number Cameras of dimensions of the BoundaryMap
[MaxLength, MaxWidth] = size(BoundaryMap);
CamCount = size(CamList, 1);

%create 3 by n matrix for solution
CamSoln = zeros(CamCount, 3);

% For each camera, generate a random position
for i = 1:CamCount
	x = randi(MaxWidth,1);
	y = randi(MaxLength,1);
	direction = randi(2,1);
	CamSoln(i,:) = [x, y, direction];
end

% Calculate the cost of the soln
[CamSolnCost] = feval(CostCalcFn, CamList, SectionCosts, BoundaryMap, CamSoln);


% Initialize the tabu list. The tabu list represents that set of cameras
% that can't be moved to find the neighbourhood of the current solution
TabuList = zeros(CamCount, 1);

