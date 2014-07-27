% For the reduced size problem:
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

function [soln, cost, iteration, timing] = aco(boundaryMap, sensitivityMap, cameras, determineCostFn, numAnts, iterations, ...
    pheromone_initial, pheromone_decay, pheromone_deposit_scaling, influence_pheromone, influence_cost, overlap_probability, confidence, convergence)

    mapHeight = size(boundaryMap,1);
    mapWidth = size(boundaryMap,2);    
    numElements = numel(boundaryMap);    
    numCameras = size(cameras,1);
    
    sensitivityVector = repmat(sensitivityMap(boundaryMap(1:end)),1,2);    
    pheromoneMap = ones(numCameras,numElements*2)*pheromone_initial;
    probabilityDistribution = zeros(numCameras,numElements*2);
    for cam_k = 1:numCameras
        probabilityDistribution(cam_k,:) = cumsum(((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost))/sum((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost)));
    end
    
    timing = zeros(1,iterations);
    shouldStop = 0;

    for i = 1:iterations % or converged
        tic
        globalSoln = zeros(numAnts, 3 * numCameras);
        globalCost = zeros(numAnts, 1);
        for ant_k = 1:numAnts
            localSoln = zeros(numCameras,3);
%             tempProb = probabilityDistribution;
%             tempSens = sensitivityVector;
            for cam_k = 1:numCameras
                r = rand;
                
%                 idx = find(tempProb(cam_k,:) > r, 1);
                idx = find(probabilityDistribution(cam_k,:) > r, 1);
                
                dir = floor(idx/(numElements+1))+1;
                idx = idx - floor(idx/(numElements+1))*numElements;
                [y,x] = ind2sub([mapHeight,mapWidth],idx);

%                 camWidth = cameras(cam_k,dir);
%                 camLength = cameras(cam_k,mod(dir,2)+1);
%                 for camY = y:min(y+camLength-1,mapHeight)
%                     for camX = x:min(x+camWidth-1,mapHeight)
%                         if (boundaryMap(y,x) == boundaryMap(camY,camX))
%                             shiftedX = max(1,camX - 1);
%                             shiftedY = max(1,camY - 1);
%                             tempIdx = sub2ind(size(boundaryMap),shiftedY,shiftedX);
%                             tempSens(tempIdx) = tempSens(tempIdx) * overlap_probability;
%                             tempIdx = tempIdx+numElements;
%                             tempSens(tempIdx) = tempSens(tempIdx) * overlap_probability;
%                         end
%                     end
%                 end
%                 
%                 if (cam_k < numCameras)
%                     tempProb(cam_k+1,:) = cumsum(((pheromoneMap(cam_k+1,:).^influence_pheromone).*(tempSens.^influence_cost))/sum((pheromoneMap(cam_k+1,:).^influence_pheromone).*(tempSens.^influence_cost)));
%                 end

                localSoln(cam_k,:) = [x,y,dir];
            end
            cost = feval(determineCostFn, cameras, sensitivityMap, boundaryMap, localSoln);
            globalSoln(ant_k,:) = localSoln(1:end);
            globalCost(ant_k,:) = cost;
        end
        
%         find value of best and worst
        [best,bestIdx] = min(globalCost);
        [worst,worstIdx] = max(globalCost);
        best
        
        if(sum(globalCost==best) / length(globalCost) > confidence)
            shouldStop = shouldStop + 1;
            if (shouldStop == convergence)
                break;
            end
        else
            shouldStop = 0;
        end
        
        reducedGlobalSoln = globalSoln(globalCost == best,:);

        improveFactor = pheromone_deposit_scaling * 1 * worst / best;
        
        pheromoneMap = pheromoneMap.*(1-pheromone_decay);
        for row = 1:size(reducedGlobalSoln,1)
            localSoln = reshape(reducedGlobalSoln(row,:),numCameras,3); 
            for cam_k = 1:numCameras                
                camPos = localSoln(cam_k,:);
                index = sub2ind(size(boundaryMap),camPos(1,2),camPos(1,1))+(camPos(1,3)-1)*numElements;
                pheromoneMap(cam_k,index) = pheromoneMap(cam_k,index)+improveFactor;
            end
        end
        for cam_k = 1:numCameras
            probabilityDistribution(cam_k,:) = cumsum(((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost))/sum((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost)));
        end
        timing(i) = toc;
    end
    soln = reshape(globalSoln(bestIdx,:),numCameras,3);
    cost = globalCost(bestIdx);
    iteration = i;
end

