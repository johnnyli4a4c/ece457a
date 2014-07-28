function [CamSoln, CamSolnCost] = GenNeighbourSoln(CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln)

% This function gets a random neighbour of a given camera placement
% solution. It uses a heuristic of 20% chance to swap camera positions and
% 80% chance of moving a camera randomly and changing its orientation.
% 
%
% Inputs:
%   CostCalcFn: A handle to a function that determines the cost of the soln
%   CamList: List of cameras to be placed
%   SectionCosts: Array containing the costs associated with each section. Value at position 1 should indicate cost of section 1
%   BoundaryMap: Map containing which sections each point belongs to. The element (i, j) represents
%       the section that position on the grid belongs to
%   CamSoln: An array that represents the current solution of the cameras

% Get the number Cameras of dimensions of the BoundaryMap
[MaxLength, MaxWidth] = size(BoundaryMap);
CamCount = size(CamList, 1);
% Generate a random number to decide whether to move a camera or swap two
% cameras
r = randi(5,1);

if r < 5
    % move one camera randomly
    x = randi(MaxWidth,1);
    y = randi(MaxLength,1);
    direction = randi(2,1);

    CamSoln(randi(CamCount),:) = [x, y, direction];
else
    % swap two random cameras
    available = linspace(1,CamCount,CamCount);
    ranCam1 = available(randi(size(available),1));
    available(ranCam1) = [];
    ranCam2 = available(randi(size(available),1));
    CamSoln([ranCam1,ranCam2],:) = CamSoln([ranCam2,ranCam1],:);

end
% calculate cost of new solution
[CamSolnCost] = feval(CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln);

