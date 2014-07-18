% 1  9 17 25 33 41 49 57
% 2 10 18 26 34 42 50 58
% 3 11 19 27 35 43 51 59
% 4 12 20 28 36 44 52 60
% 5 13 21 29 37 45 53 61
% 6 14 22 30 38 46 54 62
% 7 15 23 31 39 47 55 63
% 8 16 24 32 40 48 56 64
% 
% A second matrix ranging from 65-128 to represent the vertical orientation

function [soln] = aco(boundaryMap, sensitivityMap, cameras, numAnts, iterations, determineCostFn)
%     check boundaryMap = sensitivityMap

    mapHeight = size(boundaryMap,1);
    mapWidth = size(boundaryMap,2);
    
    numElements = numel(boundaryMap);
    
    numCameras = size(cameras,1);
    
    sens = repmat(sensitivityMap(boundaryMap(1:end)),1,2);
    pheromoneMap = {};
    for i = 1:numCameras
        pheromoneMap = [pheromoneMap; cumsum(sens/sum(sens))];
    end

    for i = 1:iterations % or converged
        globalSoln = cell([numAnts,2]);
        for ant_k = 1:numAnts
            localSoln = [];
            for cam_k = 1:numCameras
                r = rand;
                
                idx = find(pheromoneMap{cam_k} > r, 1);
                
                dir = 1;
                if (idx > numElements)
                    dir = 2;
                    idx = idx - numElements;
                end
%                 dir = (idx > numElements) + 1;
%                 idx = mod(idx, numElements);
                [y,x] = ind2sub([mapHeight,mapWidth],idx);

                localSoln = [localSoln; [x,y,dir]];
            end
            cost = feval(determineCostFn, cameras, sensitivityMap, boundaryMap, localSoln);
            globalSoln{ant_k,1} = localSoln;
            globalSoln{ant_k,2} = cost;
        end
        
        if isequal(globalSoln{:,1})
            break;
        end
        
        globalSolnMat = cell2mat(globalSoln(:,2));
        
%         find value of best and worst
        best = min(globalSolnMat);
        worst = max(globalSolnMat);
        
%         find all indexes of best solutions
        bestIdx = find(globalSolnMat == best);

        improveFactor = worst / best;
        
        for cam_k = 1:numCameras
            indices = [];
            for best_k = bestIdx'
                camPos = globalSoln{best_k,1}(cam_k,:);
                indices = [indices; sub2ind(size(boundaryMap),camPos(1,2),camPos(1,1))+(camPos(1,3)-1)*64];
            end
            pheromoneMap{cam_k} = [0 pheromoneMap{cam_k}];
            pheromoneMap{cam_k} = diff(pheromoneMap{cam_k});
            pheromoneMap{cam_k} = pheromoneMap{cam_k} * 0.8; % decay factor
            pheromoneMap{cam_k}(indices) = pheromoneMap{cam_k}(indices) * improveFactor;
            pheromoneMap{cam_k} = cumsum(pheromoneMap{cam_k}/sum(pheromoneMap{cam_k}));
        end
    end
    soln = globalSoln;
end