numVals = 20;
numIterations = 100;
soln = cell(numVals,1);
cost = zeros(numVals,1);
i = zeros(numVals,1);
timing = zeros(numVals,numIterations);
for ii = 1:numVals
    [soln{ii},cost(ii),i(ii),timing(ii,:)] = aco(boundary,sections,cameras,@DetermineCost,300,numIterations,1,0.3,1.2,1,1,0.1,0.95,5);
end
mean(cost)