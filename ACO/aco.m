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

function [soln, cost, iteration] = aco(boundaryMap, sensitivityMap, cameras, numAnts, iterations, determineCostFn)
%     check boundaryMap = sensitivityMap

    pheromone_initial = 1;
    pheromone_decay = 0.9;
    pheromone_deposit_scaling = 1;
    influence_pheromone = 1;
    influence_cost = 2;

    mapHeight = size(boundaryMap,1);
    mapWidth = size(boundaryMap,2);    
    numElements = numel(boundaryMap);    
    numCameras = size(cameras,1);
    
    sensitivityVector = repmat(sensitivityMap(boundaryMap(1:end)),1,2);    
    pheromoneMap = cell(numCameras,1);
    pheromoneMap(:) = {ones(1,numElements*2)*pheromone_initial};
    probabilityDistribution = cell(numCameras,1);
    probabilityDistribution(:) = {cumsum(((pheromoneMap{1}.^influence_pheromone).*(sensitivityVector.^influence_cost))/sum((pheromoneMap{1}.^influence_pheromone).*(sensitivityVector.^influence_cost)))};

    for i = 1:iterations % or converged
        globalSoln = cell(numAnts,2);
        for ant_k = 1:numAnts
            localSoln = zeros(numCameras,3);
            for cam_k = 1:numCameras
                r = rand;
                
                idx = find(probabilityDistribution{cam_k} > r, 1);
                
                dir = 1;
                if (idx > numElements)
                    dir = 2;
                    idx = idx - numElements;
                end
                [y,x] = ind2sub([mapHeight,mapWidth],idx);

                localSoln(cam_k,:) = [x,y,dir];
            end
            cost = feval(determineCostFn, cameras, sensitivityMap, boundaryMap, localSoln);
            globalSoln{ant_k,1} = localSoln;
            globalSoln{ant_k,2} = cost;
        end
        
        globalSolnMat = cell2mat(globalSoln(:,2));
        
%         find value of best and worst
        [best,index] = min(globalSolnMat);
        worst = max(globalSolnMat);
        
        soln = globalSoln{index,1};
        cost = globalSoln(index,2);
        iteration = i;
        
        if (best == worst)
            break;
        end
        
%         find all indexes of best solutions
        bestIdx = find(globalSolnMat == best);

        improveFactor = pheromone_deposit_scaling * worst / best;
        
        for cam_k = 1:numCameras
            pheromoneMap{cam_k} = pheromoneMap{cam_k}.*pheromone_decay;
            indices = [];
            for best_k = bestIdx'
                camPos = globalSoln{best_k,1}(cam_k,:);
                indices = [indices; sub2ind(size(boundaryMap),camPos(1,2),camPos(1,1))+(camPos(1,3)-1)*64];
            end
            pheromoneMap{cam_k}(indices) = pheromoneMap{cam_k}(indices).*improveFactor;
            probabilityDistribution{cam_k} = cumsum(((pheromoneMap{cam_k}.^influence_pheromone).*(sensitivityVector.^influence_cost))/sum((pheromoneMap{cam_k}.^influence_pheromone).*(sensitivityVector.^influence_cost)));
        end
    end
end