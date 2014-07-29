addpath('../');
load('../reducedProblem.mat');
[soln,cost,i,timing] = aco(map,sens,cam,@DetermineCost,500,100,1,0.3,1.2,1,1,0.95,25);