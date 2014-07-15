function  [BestSoln BestSolnCost] = TabuCamSearch( ...
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

% Generate the initial solution given the problem data
[Soln SolnCost TabuList] = feval(GenInitialSolnFn, CostCalcFn, SectionCosts, BoundaryMap, CamList);

% Set the best solution to the initial solution
BestSoln = Soln;
BestSolnCost = SolnCost;

for nIt = 1 : NumIterations
    % Get the best solution in the neighbourhood of the current solution
    % avoiding Tabu moves
    [Soln SolnCost TabuList] = feval(GetBestNeighbourSolnFn, CostCalcFn, SectionCosts, ...
                                BoundaryMap, CamList, Soln, TabuList, TabuLength);
            
    % Update the best solution
    if SolnCost < BestSolnCost
        BestSoln = Soln;
        BestSolnCost = SolnCost;
    end
end