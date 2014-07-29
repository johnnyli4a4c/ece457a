addpath('../');
load('../largeProblem.mat');
[soln,cost,i,timing] = SimulatedAnnealing(@DetermineCost,@GenInitialSoln,@GenNeighbourSoln,cameras,sections,boundary,4080,0,0.8,10000,10,0.4);