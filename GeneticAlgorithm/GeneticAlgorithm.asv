function [CamSoln, CamSolnCost, n] = GeneticAlgorithm( ...
    CalcCostFn, CamList, SectionCosts, BoundaryMap, MaxGens)
%%  Variables
%   Global Variables
global solution newsolution;
global population newpopulation;
global fitness newfitness;
global yMax xMax nCameras;
global func clist cmap bmap;

%   Problem Specific Parameters
func = CalcCostFn;
cmap = SectionCosts;
clist = CamList;
bmap = BoundaryMap;
[yMax , xMax] = size(BoundaryMap);
nCameras = size(CamList, 1);

%   Genetic Algorithm Parameters

populationSize =    nCameras;   % This is a correlation to problem complexity
maxGenerations =    MaxGens
chanceCrossover =   0.85;
chanceMutation =    0.05;
mutationPoints =    ceil(log2(nCameras)); 
count =             0;



bestSolution = zeros(nCameras, 3, maxGenerations);
bestFitness = zeros(maxGenerations, 1);

%% Function Core
% Create the first generation

newpopulation = generatePopulation(populationSize, getGeneLength(yMax, xMax, nCameras));
newsolution = zeros(nCameras, 3, nCameras);
newfitness = zeros(1, populationSize);
for p=1:populationSize,
        newsolution(:,:,p) = bin2CameraList(newpopulation(p,:));
        newfitness(p) =  feval(func, clist, cmap, bmap, squeeze(newsolution(:,:,p)));
end
% GA Loop
for i=1:maxGenerations,
    % Record old values
    solution=newsolution; population=newpopulation; fitness=newfitness;
    
    for p=1:populationSize,
        %Perform Crossover
        ii=floor(populationSize*rand)+1; jj=floor(populationSize*rand)+1;
        if chanceCrossover > rand,
            [newpopulation(ii,:),newpopulation(jj,:)] = genCrossover(population(ii,:),population(jj,:));
            count = count + 2;
            evolve(ii);
            evolve(jj);
        end
        
        if chanceMutation > rand,
            kk = floor(populationSize * rand) +1; count = count+1;
            newpopulation(kk,:) = mutate(population(kk,:), mutationPoints);
            evolve(kk);
        end
    end
    
    [bestFitness(i), mI] = min(newfitness);
    bestSolution(:, :, i) = newsolution(:,:,mI);
end
    index = find(bestFitness == min(bestFitness(:)));
    CamSoln = bestSolution(:, :, index(1));
    CamSolnCost = bestFitness(index(1));
    n = index(1);
    
    %Display Fitness Graph
    set(gcf, 'color', 'w');
    subplot(2,1,2); plot(bestFitness); title('Fitness');
end

% Other Functions
%==
% Generate new population

function [geneLength] = getGeneLength(MaxHeight, MaxWidth, numCameras)
    yBits =  ceil(log2(MaxHeight));
    xBits =  ceil(log2(MaxWidth));
    geneLength = numCameras * (yBits + xBits + 1);
end

% CBS = Camera Bit String
function [cbs] = getCBSLength(MaxHeight, MaxWidth)
    cbs = ceil(log2(MaxHeight)) + ceil(log2(MaxWidth));
end

function [newpop] = generatePopulation(popSize, lenStr)
    newpop = rand(popSize,lenStr)>0.5;
end

function listCameras = bin2CameraList(binary)
    global xMax yMax nCameras;
    
    listCameras = zeros(nCameras, 3, 1);
    ybits   = ceil(log2(yMax));
    xbits   = ceil(log2(xMax));
    i = 1;

    for j=1:nCameras,
        listCameras(j,1,1) = 1 + bi2de(binary(i:i+xbits-1));
        i = i + xbits;
        listCameras(j,2,1) = 1 + bi2de(binary(i:i+ybits-1));
        i = i + ybits;
        listCameras(j,3,1) = binary(i);
        i = i + 1;
    end
end

function evolve(j)
    % Evolves the new generation
    global newsolution newpopulation newfitness fitness population solution func clist bmap cmap;
    a = bin2CameraList(newpopulation(j,:));
    newsolution(:,:,j)=bin2CameraList(newpopulation(j,:));
    newfitness(j)=feval(func, clist, cmap, bmap, squeeze(newsolution(:,:,j)));
    if newfitness(j) < fitness(j), % Min question
       population(j,:) = newpopulation(j,:);
       solution(:,:,j) = newsolution(:,:,j);
    end
end

function x = mutate(a, mrate)
    % Mutate the binary string
nn = length(a);
x = a;
for i = 1:nn,
    if mrate > rand,
        x(i) = mod(a(i) + 1, 2);
    end
end
end

function [c,d] = genCrossover(a,b)
    nn = length(a) - 1;
    crossPoint = floor (nn * rand) + 1;
    c = [a(1:crossPoint) b(crossPoint + 1:end)];
    d = [b(1:crossPoint) a(crossPoint + 1:end)];
end