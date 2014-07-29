addpath('../');
load('../reducedProblem.mat');
[soln,cost,i,timing] = SimulatedAnnealing(@DetermineCost,@GenInitialSoln,@GenNeighbourSoln,cam,sens,map,127,0,0.7,100,5,0.4)