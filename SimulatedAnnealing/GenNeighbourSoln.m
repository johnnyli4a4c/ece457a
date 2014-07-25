function [CamSoln CamSolnCost] = GenNeighbourSoln(CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln)

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

