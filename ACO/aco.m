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
    pheromone_initial, pheromone_decay, pheromone_deposit_scaling, influence_pheromone, influence_cost, confidence, convergence)

% This function uses ant colony optimization to find an optimal solution
% for camera placement to provide the most coverage
%
% Inputs:
% 	boundaryMap: Map marking the sections of the map. Value of position (i,j) indicates the section of the map
%		ex. 1 indicates point is part of section 1, 2 indicates point is part of section 2, etc.
%	sensitivityMap: array containing the costs associated with each section. Value at position 1 should indicate cost of section 1
%	cameras: 2 by n matrix containing coverage of each camera. format: [width, height]
%	determineCostFn: handle to function that determines the optimality of the provided solution
%   numAnts: each ant places all the cameras for each iteration, in other words, n ants would provide n possible solutions each iteration
%   iterations: maximum number of iterations to run for
%   pheromone_initial: assign an initial pheromone amount to each possible camera position
%   pheromone_decay: how much to decrease the pheromone by for each iteration, 0.3 means 70% of the pheromone would remain
%   pheromone_deposit_scaling: the amount of pheromone deposited is (worst soln cost)/(best soln cost) * pheromone_deposiit_scaling
%   influence_pheromone: how much does pheromone affect ant's decision (alpha in the lecture slides)
%   influence_cost: how much does the sensitivity of the airport area affect the ant's decision (beta in the lecture slides)
%   confidence: how many ants should be getting the same cost before counting as a convergence, 0.9 means 90% of the ants
%   convergence: how many times should 90% (confidence) of the ants be getting the same cost before stopping
% Outputs:
% 	soln: the solution in which the ants converged to, it is a 3 by n matrix containing position and direction of cameras. 
%       Direction is set as 1 for horizontal, 2 for vertical. format: [row, column, direction]
%   cost: the result of determineCostFn based on the provided best solution
%   iteration: the number of iteration that occurred before the algorithm stopped
%   timing: an n vector where n is the number of iterations, each element of the vector correspond to the cputime it took for the 
%       iteration to run. it is calculated with tic and toc

%     initialize common variables based on parameters
    mapHeight = size(boundaryMap,1);
    mapWidth = size(boundaryMap,2);    
    numElements = numel(boundaryMap);    
    numCameras = size(cameras,1);
    
%     initialize variables used to calculate a probability distribution for
%     each possible camera position

%     a vector that corresponds the region with its associated sensitivity, multiplied by 2 for each direction, 1-64 for direction 1,
%     65-128 for direction 2
    sensitivityVector = repmat(sensitivityMap(boundaryMap(1:end)),1,2);    
%     an n by m matrix where n is the number of cameras and m is the number of elements times 2 (for each direction), set to initial pheromone amount
    pheromoneMap = ones(numCameras,numElements*2)*pheromone_initial;
%     calculate a probability distribution based on pheromone and sensitivity
%     ex. [0.25, 0.50, 0.75, 1.00] means that each possible position has a 25% chance of getting selected, can easily randomize a uniform (0,1) and find a corresponding placement
%     it is an n by m matrix where n is the number of cameras and m is the number of elements times 2 (for each direction), in other words, each row corresponds to 1 camera
    probabilityDistribution = zeros(numCameras,numElements*2);
    for cam_k = 1:numCameras
        probabilityDistribution(cam_k,:) = cumsum(((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost))/sum((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost)));
    end
    
%     used to record timing of each iteration
    timing = zeros(1,iterations);
    shouldStop = 0;

    for i = 1:iterations % or converged
        startTime = cputime;
%         each row corresponds to a solution provided by an ant, it is flattened and can be made back into a matrix by doing reshape(row, numCameras, 3)
        globalSoln = zeros(numAnts, 3 * numCameras);
        globalCost = zeros(numAnts, 1);
        for ant_k = 1:numAnts
            localSoln = zeros(numCameras,3);
            for cam_k = 1:numCameras
                r = rand;
                
                idx = find(probabilityDistribution(cam_k,:) > r, 1);
                
%                 convert the index to an [x y dir] vector
                dir = floor(idx/(numElements+1))+1;
                idx = idx - floor(idx/(numElements+1))*numElements;
                [y,x] = ind2sub([mapHeight,mapWidth],idx);

                localSoln(cam_k,:) = [x,y,dir];
            end
            cost = feval(determineCostFn, cameras, sensitivityMap, boundaryMap, localSoln);
            globalSoln(ant_k,:) = localSoln(1:end);
            globalCost(ant_k,:) = cost;
        end
        
%         find cost of best and worst solution
        [best,bestIdx] = min(globalCost);
        [worst,worstIdx] = max(globalCost);
        best
        
%         see if a percentage of the ant provided a solution that has the best cost
        if(sum(globalCost==best) / length(globalCost) > confidence)
            shouldStop = shouldStop + 1;
            if (shouldStop == convergence)
                break;
            end
        else
            shouldStop = 0;
        end
        
%         get all the best solutions
        reducedGlobalSoln = globalSoln(globalCost == best,:);

        improveFactor = pheromone_deposit_scaling * 1 * worst / best;
        
%         decay all pheromones
        pheromoneMap = pheromoneMap.*(1-pheromone_decay);
%         deposit pheromones for each ant that has a solution which gives the best cost
        for row = 1:size(reducedGlobalSoln,1)
            localSoln = reshape(reducedGlobalSoln(row,:),numCameras,3); 
            for cam_k = 1:numCameras                
                camPos = localSoln(cam_k,:);
                index = sub2ind(size(boundaryMap),camPos(1,2),camPos(1,1))+(camPos(1,3)-1)*numElements;
                pheromoneMap(cam_k,index) = pheromoneMap(cam_k,index)+improveFactor;
            end
        end
%         recalculate the probability distribution after the pheromones have changed
        for cam_k = 1:numCameras
            probabilityDistribution(cam_k,:) = cumsum(((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost))/sum((pheromoneMap(cam_k,:).^influence_pheromone).*(sensitivityVector.^influence_cost)));
        end
        endTime = cputime;
        timing(i) = endTime - startTime;
    end
    soln = reshape(globalSoln(bestIdx,:),numCameras,3);
    cost = globalCost(bestIdx);
    iteration = i;
end

