function  [BestSoln, BestSolnCost] = TabuCamSearch( ...
                SectionCosts, BoundaryMap, CamList, TabuLength, NumIterations, ...      
                GenInitialSolnFn, GetBestNeighbourSolnFn, CostCalcFn)

% This function implements the tabu search algorithm.
%
% Inputs:
%   ProbData: The data of the problem to be solved.
%   TabuLength: The length of the tabu list
%   NumIterations: The maximum number of iterations
%   GenInitialSolnFn: A handle to a function that generates an initial
%                     solution to the problem.
%   GetBestNeighbourSolnFn: A hanlde to a function that generates the 
%                         neighbourhood of a given solution and update
%                         the best neighborhood.
%	CostCalcFn: A handle to a function that determines the cost of the soln
%
% Outputs:
%   BestSoln: The best solution obtained
%   BestSolnCost: The best solution cost

startTime = cputime;
clockStart = clock;

% Generate the initial solution given the problem data
[Soln SolnCost TabuList] = feval(GenInitialSolnFn, CostCalcFn, SectionCosts, BoundaryMap, CamList);

% Set the best solution to the initial solution
BestSoln = Soln;
BestSolnCost = SolnCost;

convergenceCount = 0;

for nIt = 1 : NumIterations
    % Get the best solution in the neighbourhood of the current solution
    % avoiding Tabu moves
    [Soln SolnCost TabuList] = feval(GetBestNeighbourSolnFn, CostCalcFn, SectionCosts, ...
                                BoundaryMap, CamList, Soln, TabuList, TabuLength);
            
    OldBestCost = BestSolnCost;
                            
    % Update the best solution
    if SolnCost < BestSolnCost
        BestSoln = Soln;
        BestSolnCost = SolnCost;
    end
    
    if OldBestCost==BestSolnCost
        convergenceCount = convergenceCount+1;
        
        %if our solution is not improving try to diversify more by
        %increasing Tabu length
        if convergenceCount >= 10 && TabuLength < (size(CamList,1)-2)
            TabuLength = TabuLength + 1;
        end
            
    else
        convergenceCount = 0;
        
        %if our solution is improving try to intensify search
        %by decreasing Tabu length. Intensify faster than diversifying
        TabuLength = TabuLength - 2;
        if TabuLength < 1
            TabuLength = 1;
        end
    end
end

finishTime = cputime;
clockFinish = clock;

fprintf('cputime: %g\n', finishTime - startTime);
fprintf('clock: %g\n', etime(clockFinish,clockStart));