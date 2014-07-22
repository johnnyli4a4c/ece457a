function [ Soln, Value ] = pso( iterations )
    iterations = 1000;

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

    %initializing all the particles
    for j = 1:5
        pixel(j) = struct('x_pos', randi([1,8]), 'y_pos', randi([1,8]), 'x_speed', 0, 'y_speed', 0, 'dir', randi([1,2]), 'pbest_x', 0, 'pbest_y', 0, 'obj_val', 88); 
        pixel(j).obj_val = 88;  
        pixel(j).pbest_x = pixel(j).x_pos;
        pixel(j).pbest_y = pixel(j).y_pos;
    end
    
    soln = [pixel(1).x_pos pixel(1).y_pos pixel(1).dir;
            pixel(2).x_pos pixel(2).y_pos pixel(2).dir;
            pixel(3).x_pos pixel(3).y_pos pixel(3).dir;
            pixel(4).x_pos pixel(4).y_pos pixel(4).dir;
            pixel(5).x_pos pixel(5).y_pos pixel(5).dir];

    %just setting a random pbest as converging to anyone of them should be
    %equal
    bestVal = 88;
    index = randi([1,5]);
    gbestX = pixel(index).x_pos;
    gbestY = pixel(index).y_pos;

    c1 = 1.4944;
    c2 = 1.4944;

    inertia = 0;
    
    prev_val = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);
    
    for i = 1:iterations,
        %calculate the objective function value
        for j = 1:5
           %calculate fitness value
           %-------------------------------------------------------------------------------------------------
           soln = [pixel(1).x_pos pixel(1).y_pos pixel(1).dir;
                   pixel(2).x_pos pixel(2).y_pos pixel(2).dir;
                   pixel(3).x_pos pixel(3).y_pos pixel(3).dir;
                   pixel(4).x_pos pixel(4).y_pos pixel(4).dir;
                   pixel(5).x_pos pixel(5).y_pos pixel(5).dir];
           currentObjVal1 = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);

           %determine which direction is better
           if(pixel(j).dir == 1)
               pixel(j).dir = 2;
           else
               pixel(j).dir = 1;
           end           
           soln = [pixel(1).x_pos pixel(1).y_pos pixel(1).dir;
                   pixel(2).x_pos pixel(2).y_pos pixel(2).dir;
                   pixel(3).x_pos pixel(3).y_pos pixel(3).dir;
                   pixel(4).x_pos pixel(4).y_pos pixel(4).dir;
                   pixel(5).x_pos pixel(5).y_pos pixel(5).dir];
           currentObjVal2 = DetermineCost(Cameras, SectionCosts, BoundaryMap, soln);
           %compare which value was better, if 1 was better revert back to old direcection
           if(currentObjVal1 < currentObjVal2)
               if(pixel(j).dir == 1)
                   pixel(j).dir = 2;
               else
                   pixel(j).dir = 1;
               end           
           end
           %-------------------------------------------------------------------------------------------------
           
           %if current obj_val better than original update personal best
           if(currentObjVal1 < pixel(j).obj_val || currentObjVal2 < pixel(j).obj_val )
                pixel(j).pbest_x = pixel(j).x_pos; 
                pixel(j).pbest_y = pixel(j).y_pos;
                %update obj_val for the particle
                if(currentObjVal1 < currentObjVal2)
                    pixel(j).obj_val = currentObjVal1;
               else
                    pixel(j).obj_val = currentObjVal2;
               end
           end
           
           %get the best value so far
           if((currentObjVal1 < bestVal || currentObjVal2 < bestVal))
               if(currentObjVal1 < currentObjVal2 )
                        bestVal = currentObjVal1;
               else
                        bestVal = currentObjVal2;
               end
               gbestX = pixel(j).x_pos;
               gbestY = pixel(j).y_pos;
           end
        end
        disp(bestVal)
        for j=1:5
           test1 = c1 * rand * (pixel(j).pbest_x - pixel(j).x_pos);
           test2 = c2 * rand * (gbestX - pixel(j).x_pos);
           pixel(j).x_speed = pixel(j).x_speed * inertia + c1 * rand * (pixel(j).pbest_x - pixel(j).x_pos) + c2 * rand * (gbestX - pixel(j).x_pos);
           pixel(j).y_speed = pixel(j).y_speed * inertia + c1 * rand * (pixel(j).pbest_y - pixel(j).y_pos) + c2 * rand * (gbestY - pixel(j).y_pos);
           test3 = pixel(j).x_pos;
           test4 = pixel(j).y_pos;
           
           pixel(j).x_pos = round(pixel(j).x_pos + pixel(j).x_speed);
           pixel(j).y_pos = round(pixel(j).y_pos + pixel(j).y_speed);
           
           test1 = pixel(j).x_speed;
           test2 = pixel(j).y_speed;
           test3 = pixel(j).x_pos;
           test4 = pixel(j).y_pos;
           
           if(pixel(j).x_pos <= 0)
               pixel(j).x_pos = 1;
           end
           if(pixel(j).y_pos <= 0)
               pixel(j).y_pos = 1;
           end
           if(pixel(j).x_pos >= 9)
               pixel(j).x_pos = 8;
           end
           if(pixel(j).y_pos >= 9)
               pixel(j).y_pos = 8;
           end
        end
        disp(soln)
    end
    
end

