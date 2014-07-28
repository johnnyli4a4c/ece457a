function [ Soln, Value ] = pso2( iterations )
    iterations = 100;
    %Could be parameters instead so you can pass in maps and stuff
    %-------------------------------------------------------------------------------------------------
    %%{
    Cameras = [ 2 4;
                3 5; 
                2 6; 
                3 4; 
                2 7];
    %}
    %{        
    Cameras = [
                    2,9;
                    2,15;
                    2,16;
                    2,19;
                    3,9;
                    3,10;
                    3,11;
                    3,12;
                    3,12;
                    3,14;
                    4,5;
                    4,6;
                    4,7;
                    4,7;
                    4,7;
                    4,8;
                    4,8;
                    4,9;
                    4,9;
                    4,9;
                    5,6;
                    5,7;
                    5,7;
                    5,8;
                    5,8;
                    5,8;
                    5,8;
                    5,9;
                    5,9;
                    6,7;
                ];
    %}
    [numCameras, y] = size(Cameras);
    
    SectionCosts = [2 1 1 1];
    %SectionCosts = [5,3,1,3,1,4,2,4,1,3,2];
    
    

    %%{
    BoundaryMap = [1 1 1 1 1 1 1 1;
                   1 1 1 1 1 1 1 1;
                   1 1 1 1 1 1 1 1;
                   2 2 2 2 2 2 2 2;
                   3 3 3 4 4 4 4 4;
                   3 3 3 4 4 4 4 4;
                   3 3 3 4 4 4 4 4;
                   4 4 4 4 4 4 4 4];
    %}
        %{
        BoundaryMap = [
            1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
            1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
            1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
            1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
            2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2;
            2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2;
            2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2;
            3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5;
            3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5;
            3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5;
            3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5;
            3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5;
            4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4;
            4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4;
            6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8;
            6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8;
            6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8;
            6,6,6,6,6,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8;
            6,6,6,6,6,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8;
            6,6,6,6,6,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8;
            6,6,6,6,6,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8;
            6,6,6,6,6,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8;
            6,6,6,6,6,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8;
            10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10;
            10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10;
            10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10;
            10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10;
            11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11;
            11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11;
            11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11;
            11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11;
            11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11;
        ];
        %}
        [xSize,ySize] = size(BoundaryMap);
   %-------------------------------------------------------------------------------------------------
   %default stuff
   c1 = 1.4944;
   c2 = 1.4944;
   inertia = 0;
   
   numParticles = 125 * numCameras; %4 particles with 5 cameras each in different orientation
   
   %initializing all the particles
   %each particle contains 5 cameras
   for i = 1:numParticles;
        particle(i) = struct('xpos', randi([1,xSize]), 'ypos', randi([1,ySize]), 'xvel', 0, 'yvel', 0, 'dir', randi([1,2]), 'pbx', 0, 'pby', 0, 'obj', 3000);
        particleValue(i) = 3000;
   end
   for i = 1:numParticles;
        for j = 1:numCameras
            particle(i).xpos(j) = randi([1,xSize]);
            particle(i).ypos(j) = randi([1,ySize]);
            particle(i).xvel(j) = 0;
            particle(i).yvel(j) = 0;
            particle(i).dir(j) = randi([1,2]);
            particle(i).pbx(j) = particle(i).xpos(j);
            particle(i).pby(j) = particle(i).ypos(j);
        end
   end
   
   %5 gbests so that each camera in each particle can move towards the global best
   for i = 1:numCameras
       gbest(i) = struct('x', 1, 'y', 1, 'dir', 1);
   end
   
   
   %loop through and do however many iterations are needed based on input
   for i = 1:iterations
       time1 = cputime;
       %loop through particles to determin the objective function
       for j = 1:numParticles
           val1 = findSoln(Cameras, SectionCosts, BoundaryMap, particle(j));
           
           particleValue(j) = val1; %min(val1, val2);
           
           if particleValue(j) < particle(j).obj(1)
                for k = 1:numCameras
                    particle(j).obj(1) = particleValue(j);
                    particle(j).pbx(k) = particle(j).xpos(k);
                    particle(j).pby(k) = particle(j).ypos(k);
                end
           end
       end

       %determine the global best
       index = find( particleValue == min(particleValue(:)));
       index = min(index);

       bestVal = min( particleValue(:));
       bestVal = min(bestVal);

       for d = 1:numCameras
           gbest(d).x = particle(index).xpos(d);
           gbest(d).y = particle(index).ypos(d);
 %          gbest(d).dir = particle(index).dir(d);
       end

       %disp(returnSoln( particle(index), Cameras));
       disp(bestVal)

       for i = 1:numParticles
            for j = 1:numCameras
                particle(i).xvel(j) =  particle(i).xvel(j) * inertia + c1 * rand * (particle(i).pbx(j) - particle(i).xpos(j)) + c2 * rand * (gbest(j).x - particle(i).xpos(j));
                particle(i).yvel(j) =  particle(i).yvel(j) * inertia + c1 * rand * (particle(i).pby(j) - particle(i).ypos(j)) + c2 * rand * (gbest(j).y - particle(i).ypos(j));
                particle(i).xpos(j) = round(particle(i).xvel(j)) + particle(i).xpos(j);
                particle(i).ypos(j) = round(particle(i).yvel(j)) + particle(i).ypos(j);
%                particle(i).dir(j) = gbest(j).dir;

               if(particle(i).xpos(j) <= 0)
                   particle(i).xpos(j) = 1;
               end
               if(particle(i).ypos(j) <= 0)
                   particle(i).ypos(j) = 1;
               end
               if(particle(i).xpos(j) >= xSize + 1)
                   particle(i).xpos(j) = xSize;
               end
               if(particle(i).ypos(j) >= ySize + 1)
                   particle(i).ypos(j) = ySize;
               end
            end
       end
       time2 = cputime;
       disp((time2 - time1))
   end
   
end

function [ value ] = findSoln( Cameras, SectionCosts, BoundaryMap, Particle )
    [numCameras, y] = size(Cameras);
    soln = [];
    for a = 1:numCameras
        cam = [Particle.xpos(a) Particle.ypos(a) Particle.dir(a)];
        soln = vertcat(soln, cam);
    end
    value = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);
end

function [ value ] = findOtherDirSoln( Cameras, SectionCosts, BoundaryMap, Particle )
    [numCameras, y] = size(Cameras);
    for a = 1:numCameras
        if (Particle.dir(a) == 1)
            Particle.dir(a) = 2;
        elseif ( Particle.dir(a) == 2)
            Particle.dir(a) = 1;
        end
    end
    soln = [];
    for a = 1:numCameras
        cam = [Particle.xpos(a) Particle.ypos(a) Particle.dir(a)];
        soln = vertcat(soln, cam);
    end

    value = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);
end

function [ soln ] = returnSoln( Particle, Cameras )
    [numCameras, y] = size(Cameras);
    soln =[]
    for a = 1:numCameras
        cam = [Particle.xpos(a) Particle.ypos(a) Particle.dir(a)];
        soln = vertcat(soln, cam);
    end

end
