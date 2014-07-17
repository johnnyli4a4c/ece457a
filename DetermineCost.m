function [SolnCost] = DetermineCost( Cameras, SectionCosts, BoundaryMap, Soln )

% This function determines cost of solution for placing cameras on a map
%
% Inputs:
% 	Cameras: 2 by n matrix containing coverage of each camera. format: [width, height]
%	SectionCosts: array containing the costs associated with each section. Value at position 1 should indicate cost of section 1
%	BoundaryMap: Map marking the sections of the map. Value of position (i,j) indicates the section of the map
%		ex. 1 indicates point is part of section 1, 2 indicates point is part of section 2, etc.
%	Soln: 3 by n matrix containing position and direction of cameras. Direction is set as 1 for horizontal, 2 for vertical.
%			format: [row, column, direction]
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

SectionMatrix = BoundaryMap;

[CostRows, CostColumns] = size(SectionCosts);
[MaxLength, MaxWidth] = size(BoundaryMap);

% check that Section Cost map is an array
if CostRows ~= 1
	error('Section Costs should be a horizontal array');
end

for Cam = 1:CamCount
	x = Soln(Cam, 1);
	y = Soln(Cam, 2);
	width = Cameras(Cam, 1);
	length = Cameras(Cam, 2);

	%if direction in solution is set to vertical swap width and length
	if Soln(Cam, 3) == 2
		temp = width;
		width = length;
		length = temp;
	end

	% calculate end bounds for camera coverage
	xEnd = x + width - 1;
	yEnd = y + length - 1;
	if yEnd > MaxLength;
		yEnd = MaxLength;
	end

	if xEnd > MaxWidth;
		xEnd = MaxWidth;
	end

	% for each position on map that the camera covers
	for i = y:yEnd
		for j = x:xEnd

			% mark point i,j in coverage matrix as covered by setting section to zero
			SectionMatrix(i, j) = 0;

			% if next iteration will break a boundary between sections, exit out of loop
			if j+1 <= MaxWidth && BoundaryMap(i,j) ~= BoundaryMap(i,j+1)
				break;
			end
		end

		% if next iteration will break a boundary between sections, exit out of loop
		if i+1 <= MaxLength && BoundaryMap(i,y) ~= BoundaryMap(i+1, y)
			break;
		end
	end
end

SolnCost = 0;
%Sum up total cost by iterating through section matrix
for i = 1:MaxLength
	for j = 1:MaxWidth
		if(SectionMatrix(i,j) ~= 0)
			SolnCost = SolnCost + SectionCosts(SectionMatrix(i, j));
		end
	end
end