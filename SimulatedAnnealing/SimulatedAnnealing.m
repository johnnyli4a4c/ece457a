function [ CamSoln, CamSolnCost, n ] = SimulatedAnnealing( CalcCostFn, GenInitialSoln, GenNeighbourSoln, CamList, SectionCosts, BoundaryMap, InitialTemp, FinalTemp, alpha, freezeFactor)
    %SIMULATEDANNEALING Summary of this function goes here
    %   Detailed explanation goes here

    curTemp = InitialTemp;
    prevSolnCost = 0;
    n = 0;
    freezeCount = 0;

    % Generate initial random solution
    [CamSoln CamSolnCost] = feval(GenInitialSoln, CalcCostFn, CamList, SectionCosts, BoundaryMap);

    % Simulated Annealing
    while curTemp > FinalTemp
        
        % move a random camera randomly
        [tmpCamSoln tmpCamSolnCost] = feval(GenNeighbourSoln, CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln);
                
        % decide whether to accept new solution
        if tmpCamSolnCost < CamSolnCost
            CamSolnCost = tmpCamSolnCost;
            CamSoln = tmpCamSoln;
        else
            r = rand;
            p = exp(((CamSolnCost - tmpCamSolnCost)/curTemp));

            if p > r
                CamSolnCost = tmpCamSolnCost;
                CamSoln = tmpCamSoln;
            end
        end
        
        if CamSolnCost == prevSolnCost
            freezeCount = freezeCount + 1;
        else
            freezeCount = 0;
        end
        
        if freezeCount > freezeFactor
            break;
        end
        
        n = n + 1;
        curTemp = InitialTemp * alpha^n;
        prevSolnCost = CamSolnCost;
    end
end

