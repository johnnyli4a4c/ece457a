function [ Soln, Value ] = pso2( iterations )
    iterations = 10;
    %Could be parameters instead so you can pass in maps and stuff
    %-------------------------------------------------------------------------------------------------
    Cameras = [ 2 4;
                3 5; 
                2 6; 
                3 4; 
                2 7];

    SectionCosts = [2 1 1 1];

    BoundaryMap = [1 1 1 1 1 1 1 1;
                   1 1 1 1 1 1 1 1;
                   1 1 1 1 1 1 1 1;
                   2 2 2 2 2 2 2 2;
                   3 3 3 4 4 4 4 4;
                   3 3 3 4 4 4 4 4;
                   3 3 3 4 4 4 4 4;
                   4 4 4 4 4 4 4 4];
   %-------------------------------------------------------------------------------------------------
   %default stuff
   c1 = 1.4944;
   c2 = 1.4944;
   inertia = 0;
   
   numParticles = 625; %4 particles with 5 cameras each in different orientation

   %initializing all the particles
   %each particle contains 5 cameras
   for i = 1:numParticles;
        particle(i) = struct('xpos', randi([1,8]), 'ypos', randi([1,8]), 'xvel', 0, 'yvel', 0, 'dir', randi([1,2]), 'pbx', 0, 'pby', 0, 'obj', 88);
        particleValue(i) = 88;
   end
   for i = 1:numParticles;
        for j = 1:5
            particle(i).xpos(j) = randi([1,8]);
            particle(i).ypos(j) = randi([1,8]);
            particle(i).xvel(j) = 0;
            particle(i).yvel(j) = 0;
            particle(i).dir(j) = randi([1,2]);
            particle(i).pbx(j) = particle(i).xpos(j);
            particle(i).pby(j) = particle(i).ypos(j);
        end
   end
   
   %5 gbests so that each camera in each particle can move towards the global best
   for i = 1:5
       gbest(i) = struct('x', 1, 'y', 1, 'dir', 1);
   end
   
   %loop through and do however many iterations are needed based on input
   for i = 1:iterations
       %loop through particles to determin the objective function
       for j = 1:numParticles
           val1 = findSoln(Cameras, SectionCosts, BoundaryMap, particle(j));
           val2 = findOtherDirSoln(Cameras, SectionCosts, BoundaryMap, particle(j));
           
           if(val2 < val1)
               for a = 1:5
                   if (particle(j).dir(a) == 1)
                       particle(j).dir(a) = 2;
                   elseif ( particle(j).dir(a) == 2)
                       particle(j).dir(a) = 1;
                    end
               end
           end
           
           particleValue(j) = min(val1, val2);
           
           if particleValue(j) < particle(j).obj(1)
                for k = 1:5 
                    particle(j).pbx(k) = particle(j).xpos(k);
                    particle(j).pby(k) = particle(j).ypos(k);
                end
                %determine the global best
                   index = find( particleValue == min(particleValue(:)));
                   index = min(index);

                   bestVal = min( particleValue(:));
                   bestVal = min(bestVal)

                   for d = 1:5
                       gbest(d).x = particle(index).xpos(d);
                       gbest(d).y = particle(index).ypos(d);
                       gbest(d).dir = particle(index).dir(d);
                   end
           end
       end

       

       disp(returnSoln( particle(index)));
       disp(bestVal)

       for i = 1:numParticles
            for j = 1:5
                particle(i).xvel(j) =  particle(i).xvel(j) * inertia + c1 * rand * (particle(i).pbx(j) - particle(i).xpos(j)) + c2 * rand * (gbest(j).x - particle(i).xpos(j));
                particle(i).yvel(j) =  particle(i).yvel(j) * inertia + c1 * rand * (particle(i).pby(j) - particle(i).ypos(j)) + c2 * rand * (gbest(j).y - particle(i).ypos(j));
                particle(i).xpos(j) = round(particle(i).xvel(j)) + particle(i).xpos(j);
                particle(i).ypos(j) = round(particle(i).yvel(j)) + particle(i).ypos(j);
                particle(i).dir(j) = gbest(j).dir;

               if(particle(i).xpos(j) <= 0)
                   particle(i).xpos(j) = 1;
               end
               if(particle(i).ypos(j) <= 0)
                   particle(i).ypos(j) = 1;
               end
               if(particle(i).xpos(j) >= 9)
                   particle(i).xpos(j) = 8;
               end
               if(particle(i).ypos(j) >= 9)
                   particle(i).ypos(j) = 8;
               end
            end
       end
    end
end

function [ value ] = findSoln( Cameras, SectionCosts, BoundaryMap, Particle )
    soln = [Particle.xpos(1) Particle.ypos(1) Particle.dir(1);
            Particle.xpos(2) Particle.ypos(2) Particle.dir(2);
            Particle.xpos(3) Particle.ypos(3) Particle.dir(3);
            Particle.xpos(4) Particle.ypos(4) Particle.dir(4);
            Particle.xpos(5) Particle.ypos(5) Particle.dir(5)];
    value = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);
end

function [ value ] = findOtherDirSoln( Cameras, SectionCosts, BoundaryMap, Particle )
    for a = 1:5
        if (Particle.dir(a) == 1)
            Particle.dir(a) = 2;
        elseif ( Particle.dir(a) == 2)
            Particle.dir(a) = 1;
        end
    end
    soln = [Particle.xpos(1) Particle.ypos(1) Particle.dir(1);
            Particle.xpos(2) Particle.ypos(2) Particle.dir(2);
            Particle.xpos(3) Particle.ypos(3) Particle.dir(3);
            Particle.xpos(4) Particle.ypos(4) Particle.dir(4);
            Particle.xpos(5) Particle.ypos(5) Particle.dir(5)];
    value = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);
end

function [ soln ] = returnSoln( Particle )
soln = [Particle.xpos(1) Particle.ypos(1) Particle.dir(1);
        Particle.xpos(2) Particle.ypos(2) Particle.dir(2);
        Particle.xpos(3) Particle.ypos(3) Particle.dir(3);
        Particle.xpos(4) Particle.ypos(4) Particle.dir(4);
        Particle.xpos(5) Particle.ypos(5) Particle.dir(5)];
end
