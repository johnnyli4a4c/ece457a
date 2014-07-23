numVals = 20;
numIterations = 100;
soln = cell(numVals,1);
cost = cell(numVals,1);
i = zeros(numVals,1);
timing = zeros(numVals,numIterations);
for ii = 1:numVals
    [soln{ii},cost(ii),i(ii),timing(ii,:)] = aco(map,sens,cam,@DetermineCost,500, numIterations, 1, 0.8, 1.2, 1.1, 0.9, 25);
end
mean(cell2mat(cost))