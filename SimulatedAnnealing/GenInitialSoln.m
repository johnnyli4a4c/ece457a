function [CamSoln CamSolnCost] = GenInitialSoln(CalcCostFn, CamList, SectionCosts, BoundaryMap)

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
[CamSolnCost] = feval(CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln);
