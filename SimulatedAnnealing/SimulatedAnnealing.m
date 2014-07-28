function [ CamSoln, CamSolnCost, N, Timing] = SimulatedAnnealing(CalcCostFn, GenInitialSoln, GenNeighbourSoln, CamList, SectionCosts, BoundaryMap, InitialTemp, FinalTemp, Alpha, FreezeFactor, AdaptiveCounter, AdaptiveFactor)
    % This function runs simulated annealing algorithm to generate an
    % optimal to near optimal solution. It starts off with an initial and
    % final temperature and generates neighbouring solutions that are
    % compared against the current solution. An improving solution is
    % always excepted where a non improving solution is probabilistically
    % accepted based on the current energy of the system. The energy of the
    % system is based on a geometric cooling function.
    %
    % Inputs:
    %   CostCalcFn: A handle to a function that determines the cost of the soln
    %   GenInitialSoln: A handle to a function that generates an initial soln
    %   GenNeighbourSoln: A handle to a function that generates a random neighbouring soln
    %   CamList: List of cameras to be placed
    %   SectionCosts: Array containing the costs associated with each section. Value at position 1 should indicate cost of section 1
    %   BoundaryMap: Map containing which sections each point belongs to. The element (i, j) represents
    %       the section that position on the grid belongs to
    %   InitialTemp: Initial temperature of the system
    %   FinalTemp: Final temperature of the system
    %   Alpha: Cooling factor for geometric cooling function
    %   FreezeFactor: The number of iterations that the same solution is 
    %       seen to indicate a frozen or stable state of the system
    %   AdaptiveCounter: How many times to go back to find a better
    %       solution when state is frozen
    %   AdaptiveFactor: Percentage of iterations to reset current
    %       temperature to
    %
    % Outputs:
    %   BestSoln: The best solution obtained
    %   BestSolnCost: The best solution cost
    %   N: The number of iterations that took place
    %   Timing: Average time per iteration

    % Initialization
    startTime = cputime;
    curTemp = InitialTemp;
    prevSolnCost = 0;
    N = 0;
    freezeCount = 0;
    BestSolnCost = -1;
    % Generate initial random solution
    [CamSoln CamSolnCost] = feval(GenInitialSoln, CalcCostFn, CamList, SectionCosts, BoundaryMap);

    % While the system is still cooling
    while curTemp > FinalTemp
        % Generate a neighbouring solution
        [tmpCamSoln tmpCamSolnCost] = feval(GenNeighbourSoln, CalcCostFn, CamList, SectionCosts, BoundaryMap, CamSoln);
                
        % Accept improving solutions
        % Otherwise probabilistically accept non-improving
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
        
        % Count repeated solutions
        if CamSolnCost == prevSolnCost
            freezeCount = freezeCount + 1;
        else
            freezeCount = 0;
        end
        
        % Stop when system has reached a frozen state
        % Adaptive: Instead of stopping when system has reached a frozen
        %   state, increase the current temperature by some AdaptiveFactor 
        %   AdapativeCounter many times in hopes of generating a 
        %   better solution
        if freezeCount > FreezeFactor
            if AdaptiveCounter > 0
                freezeCount = 0;
                AdaptiveCounter = AdaptiveCounter - 1;
                curTemp = InitialTemp * Alpha^(N*AdaptiveFactor);
                if (CamSolnCost < BestSolnCost)
                    BestSolnCost = CamSolnCost;
                    BestSoln = CamSoln;
                end
            else
                break
            end
        end
        
        % Run cooling function
        N = N + 1;
        curTemp = curTemp * Alpha;
        prevSolnCost = CamSolnCost;
        [CamSolnCost, freezeCount, AdaptiveCounter, N]
    end
    Timing = (cputime - startTime)/N;
    % If adaptive was used and had a better solution, take it, otherwise
    % take current best solution
    % BestSolnCost = -1 indicates that adaptive was not used
    if (BestSolnCost >= 0) 
        if (BestSolnCost < CamSolnCost)
            CamSolnCost = BestSolnCost;
            CamSoln = BestSoln;
        end
    end
        
end

