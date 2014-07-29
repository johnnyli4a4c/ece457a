addpath('../');
load('../largeProblem.mat');
[soln,cost,i,timing] = aco(boundary,sections,cameras,@DetermineCost,300,100,1,0.3,1.2,1,1,0.95,5);