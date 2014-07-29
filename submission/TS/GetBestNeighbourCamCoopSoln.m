function [BestNeighbourSoln BestNeighbourSolnCost TabuCameras] ...
                = GetBestNeighbourCamCoopSoln(CostCalcFn, SectionCosts, BoundaryMap, CamList, Soln, ... 
                TabuCameras, TabuLength)

% This function gets the neighbour of a given camera placement oslution
% with the lowest cost.
%
% Inputs:
%   SectionCosts: Array containing the costs associated with each section. Value at position 1 should indicate cost of section 1
%   BoundaryMap: Map containing which sections each point belongs to. The element (i, j) represents
%       the section that position on the grid belongs to
%   CamList: List of cameras to be placed
%   CostCalcFn: A handle to a function that determines the cost of the soln
%   TabuCameras: An array that represents the cameras that cannot be moved
%   TabuLength: The length of the tabu list

[MaxLength, MaxWidth] = size(BoundaryMap);

spmd
    
    %distribute array
    distributedSoln = codistributed(Soln, codistributor1d(1));
    workerSolnIndices = globalIndices(distributedSoln,1);

    BestNeighbourWorkerSoln = Soln;
    BestNeighbourWorkerSolnCost = Inf;

    SolnLength = size(Soln, 1);

    % A variable to keep track of which camera should be added to the tabu list
    TabuCam = -1;
    TabuCam2 = -1;

    % Repeat for each camera
    for cam = workerSolnIndices(1):workerSolnIndices(size(workerSolnIndices,2))
        % Consider moving the camera or changing its direction

        % If camera is tabu don't move it
        if TabuCameras(cam) ~= 0
            continue
        end

        % Make copy of solution
        NewSoln = Soln;

        % evaluate all possible alternate positions
        for i = 1:MaxWidth
            for j = 1:MaxLength
                for dir = 1:2
                    % if this is not the same as the current position
                    if i ~= Soln(cam, 1) || j ~= Soln(cam, 2) || dir ~= Soln(cam, 3)
                        NewSoln(cam,:) = [i, j, dir];
                        [NewSolnCost] = feval(CostCalcFn, CamList, SectionCosts, BoundaryMap, NewSoln);

                        if NewSolnCost < BestNeighbourWorkerSolnCost
                            TabuCam = cam;
                            BestNeighbourWorkerSolnCost = NewSolnCost;
                            BestNeighbourWorkerSoln = NewSoln;
                        end
                    end
                end
            end
        end

        % consider swapping the camera with another one, avoid checking swaps twice
        if cam ~= SolnLength
            % only solutions against the ones that come after it in the list (avoid duplicate checking)
            for cam2 = (cam+1):SolnLength
                % if the 2nd camera is not in the TabuList
                if TabuCameras(cam2) ~= 0 

                    % reset new solution to evaluate
                    NewSoln = Soln;

                    % swap camera positions (not directions)
                    tempXSwap = NewSoln(cam,1);
                    tempYSwap = NewSoln(cam,2);
                    NewSoln(cam,1) = NewSoln(cam2,1);
                    NewSoln(cam,2) = NewSoln(cam2,2);
                    NewSoln(cam2,1) = tempXSwap;
                    NewSoln(cam2,2) = tempYSwap;

                    [NewSolnCost] = feval(CostCalcFn, CamList, SectionCosts, BoundaryMap, NewSoln);
                    if NewSolnCost < BestNeighbourWorkerSolnCost
                        TabuCam = cam;
                        TabuCam2 = cam2;
                        BestNeighbourWorkerSolnCost = NewSolnCost;
                        BestNeighbourWorkerSoln = NewSoln;
                    end
                end
            end
        end

    end
end

[BestNeighbourSolnCost, index] = min( [BestNeighbourWorkerSolnCost{:}] );
BestNeighbourSoln = BestNeighbourWorkerSoln{index};

% Update the Tabu list
TabuCameras = TabuCameras - 1;
TabuCameras(TabuCameras<0) = 0;

% Add camera to the tabu list (if any)
if TabuCam{index} ~= -1
    % When a camera is moved, it should not be removed from the 
    % list during the next TabuLenghth iterations
    TabuCameras(TabuCam{index}) = TabuLength;
end

% Add camera 2 to the tabu list (if any). This will be the case if a swap is the best solution.
if TabuCam2{index} ~= -1
    % When a camera is moved, it should not be removed from the 
    % list during the next TabuLenghth iterations
    TabuCameras(TabuCam2{index}) = TabuLength;
end

