function [SolnCost] = DetermineCost( Cameras, Map, Soln )

% This function determines cost of solution for placing cameras on a map
%
% Inputs:
% 	Cameras: 2 by n matrix containing coverage of each camera.
%	Map: Map to be monitored by cameras. Each value in matrix is cost 
%		 of not covering that position. Ex. A value of 2 has higher cost/higher priority that value of 1
%	Soln: 2 by n matrix containing positions of cameras
% Outputs:
% 	SolnCost: Cost of the soln measured as total sum of costs for positions not covered by the cameras.

[CamCount, Dimensions] = size(Cameras);
[SolnCamCount, Positions] = size(Soln);

% check number of rows is the same
if SolnCamCount ~= CamCount
	error('Soln size is not the same as camera size');
end

CostMatrix = Map;

[MaxLength, MaxWidth] = size(CostMatrix);

for Cam = 1:CamCount
	x = Soln(Cam, 1);
	y = Soln(Cam, 2);
	width = Cameras(Cam, 1);
	length = Cameras(Cam, 2);

	% for each position on map that the camera covers
	for i = x:(x + width - 1)
		for j = y:(y + length - 1)

			% if i and j are within bounds of coverage matrix
			% mark point i,j in coverage matrix as covered by setting cost to zero
			if i > 0 && i <= MaxWidth && j > 0 && j <= MaxLength
				CostMatrix(i, j) = 0;
			end
		end
	end
end

SolnCost = 0;
%Sum up total cost
for i = 1:MaxLength
	for j = 1:MaxWidth
		SolnCost = SolnCost + CostMatrix(i, j);
	end
end