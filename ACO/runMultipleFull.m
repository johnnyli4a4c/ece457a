numVals = 20;
numIterations = 250;
soln = cell(numVals,1);
cost = cell(numVals,1);
i = zeros(numVals,1);
timing = zeros(numVals,numIterations);
for ii = 1:numVals
    [soln{ii},cost(ii),i(ii),timing(ii,:)] = aco(map,sens,cam,@DetermineCost,100, numIterations, 1, 0.6, 1.8, 1.8, 0.8, 25);
end
mean(cell2mat(cost))