function [ CSoln, CSolnCost ] = GA( ...
    CostFunc, Cameras, SectionCosts, BoundaryMap, MaxGens)
global pop popa popb;
global sol;
global fit;
global nCameras ybits xbits cbits;
global func clist scost bmap;

% Problem Specific Variables
func = CostFunc;
clist = Cameras;
scost = SectionCosts;
bmap = BoundaryMap;
[yMax , xMax] = size(BoundaryMap);
nCameras = size(Cameras, 1);

% Genetic Algorithm Variables
popSize = nCameras * 10;
rateElite = 0.2;
sizeElite = ceil(popSize * rateElite);
nCrossovers = floor((popSize - sizeElite) /2);
rateMutate = 0.05;
nMutate = nCameras;
ybits = ceil(log2(yMax));
xbits = ceil(log2(xMax));
cbits = ybits + xbits + 1;
nbits = cbits * nCameras;

tSize = sizeElite + 2 * nCrossovers;
if popSize ~= sizeElite + 2 * nCrossovers,
    if (tSize > popSize)
        sizeElite = sizeElite - 1;
    else
        sizeElite = sizeElite + 1;
    end
end

% Recording Variables
bestFitness = inf(1, MaxGens);
bestSolution = zeros(nCameras, 3, MaxGens);

%% Function Core
%   First Generation
pop = genPop(popSize, nbits);
popb = zeros(sizeElite, nbits); 
fit = inf(1,popSize);
sol = zeros(nCameras, 3, popSize);
for a = 1 :popSize,
    [sol(:,:,a), fit(a)] = decodeEval(pop(a, :));
end
[fit, ix] = sort(fit);
pop = pop(ix, :);
sol = sol (:, :, ix);
%   GA Loop
for i = 1:MaxGens,
    % Select the Elite
    popa = pop(1:sizeElite, :);
    
    % Crossover
    for j = 1:nCrossovers,
        ii=floor(popSize*rand)+1; jj=floor(popSize*rand)+1;
        while (ii == jj)
            ii=floor(popSize*rand)+1; jj=floor(popSize*rand)+1;
        end
        [popb(j*2-1, :),popb(j*2,:)] = genCrossover(pop(ii,:), pop(jj,:));
    end
    
    % Mutation
    for j = 1:nCrossovers,
        if rateMutate > rand,
        popb(j,:) = mutate(popb(j,:), nMutate);
        end
    end
    
    % Update population
    pop = [popa; popb];
    for a = 1 :popSize,
        [sol(:,:,a), fit(a)] = decodeEval(pop(a, :));
    end
    [fit, ix] = sort(fit);
    pop = pop(ix, :);
    sol = sol (:, :, ix);
    
    % Store Current best
    bestFitness(i) = fit(1);
    bestSolution(:,:,i) = sol(:,:,1);
end
CSoln = bestSolution(:,:,MaxGens);
CSolnCost = bestFitness(MaxGens);
index = find(bestFitness == min(bestFitness(:)));
n = bestFitness(index(1));

%Display Fitness Graph
    set(gcf, 'color', 'w');
    subplot(2,1,2); plot(bestFitness); title('Fitness');
end

function [pop] = genPop(popSize, nbits)
pop = rand(popSize, nbits)>0.5;
end

function [sol, fit] = decodeEval(bin)
global ybits xbits nCameras;
global func clist scost bmap;

sol = zeros(nCameras, 3);
i = 1;
for j=1:nCameras,
    sol(j,1) = 1 + bi2de(bin(i:i+xbits-1));
    i = i + xbits;
    sol(j,2) = 1 + bi2de(bin(i:i+ybits-1));
    i = i + ybits;
    sol(j,3) = bin(i);
    i = i + 1;
end

fit = feval(func, clist, scost, bmap, sol);
end

function [c,d] = genCrossover(a,b)
nn = length(a) - 1;
crossPoint = floor (nn * rand) + 1;
c = [a(1:crossPoint) b(crossPoint + 1:end)];
d = [b(1:crossPoint) a(crossPoint + 1:end)];
end

function mutated = mutate(a, msite)
% Mutate the binary string
nn = length(a); mutated=a;
for i=1:msite,
    j=floor(rand*nn)+1;
    mutated(j)=mod(a(j)+1,2);
end
end
