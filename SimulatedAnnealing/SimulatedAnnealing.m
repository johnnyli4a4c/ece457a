function [ CamSoln, CamSolnCost, n ] = SimulatedAnnealing( CalcCostFn, CamList, SectionCosts, BoundaryMap, InitialTemp, FinalTemp, alpha)
    %SIMULATEDANNEALING Summary of this function goes here
    %   Detailed explanation goes here

    curTemp = InitialTemp;
    n = 0;

    %   Generate initial random solution
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
        
    % Calculate the cost of the solution
    [CamSolnCost] = feval(CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln);

    % Simulated Annealing
    while curTemp > FinalTemp
        
        % move a random camera randomly
        tmpCamSoln = CamSoln;
        
        x = randi(MaxWidth,1);
        y = randi(MaxLength,1);
        direction = randi(2,1);
 
        tmpCamSoln(randi(CamCount),:) = [x, y, direction];
        
        % calculate cost of new solution
        [tmpCamCost] = feval(CalcCostFn, CamList, SectionCosts, BoundaryMap, tmpCamSoln);
        
        % decide whether to accept new solution
        if tmpCamCost < CamSolnCost
            CamSolnCost = tmpCamCost;
            CamSoln = tmpCamSoln;
        else
            r = rand;
            p = exp(((CamSolnCost - tmpCamCost)/curTemp));

            if p > r
                CamSolnCost = tmpCamCost;
                CamSoln = tmpCamSoln;
            end
        end
        
        n = n + 1;
        curTemp = InitialTemp * alpha^n;
    end
end

