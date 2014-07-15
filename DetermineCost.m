function [SolnCost] = DetermineCost( Cameras, CostMap, BoundaryMap, Soln )

% This function determines cost of solution for placing cameras on a map
%
% Inputs:
% 	Cameras: 2 by n matrix containing coverage of each camera.
%	CostMap: Cost map of grid to be monitored by cameras. Each value of position (i,j) in the matrix is cost 
%		of not covering that position. Ex. A value of 2 has higher cost/higher priority that value of 1
%	BoundaryMap: Map marking the sections of the map. Value of position (i,j) indicates the section of the map
%		ex. 1 indicates point is part of section 1, 2 indicates point is part of section 2, etc.
%	Soln: 3 by n matrix containing position and direction of cameras. Direction is set as 1 for horizontal, 2 for vertical.
% Outputs:
% 	SolnCost: Cost of the soln measured as total sum of costs for positions not covered by the cameras.

[CamCount, Dimensions] = size(Cameras);
[SolnCamCount, Properties] = size(Soln);

% check number of rows is the same
if SolnCamCount ~= CamCount
	error('Soln size is not the same as camera size');
end

if Properties ~= 3
	error('Soln needs to be 3 by n matrix');
end

CostMatrix = CostMap;

[MaxLength, MaxWidth] = size(CostMatrix);
[LengthBound, WidthBound] = size(BoundaryMap);

% check that boundary map and cost map have same dimensions
if MaxLength ~= LengthBound || MaxWidth ~= WidthBound
	error('Boundary Map does not have same dimensions as cost map');
end

for Cam = 1:CamCount
	x = Soln(Cam, 1);
	y = Soln(Cam, 2);
	width = Cameras(Cam, 1);
	length = Cameras(Cam, 2);

	%if direction in solution is set to vertical swap width and length
	if Soln(Cam, 3) == 1
		temp = width;
		width = length;
		length = temp;
	end

	% for each position on map that the camera covers
	for i = x:(x + width - 1)
		for j = y:(y + length - 1)

			% if i and j are within bounds of coverage matrix
			% mark point i,j in coverage matrix as covered by setting cost to zero
			if i > 0 && i <= MaxWidth && j > 0 && j <= MaxLength
				CostMatrix(i, j) = 0;
			end

			% if next iteration will break a boundary between sections, exit out of loop
			if j+1 <= MaxLength && BoundaryMap(i,j) ~= BoundaryMap(i,j+1)
				break;
			end
		end

		if i+1 <= MaxWidth && BoundaryMap(i,y) ~= BoundaryMap(i+1, y)
			break;
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