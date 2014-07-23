function [ output_args ] = helper( idx )
%HELPER Summary of this function goes here
%   Detailed explanation goes here
output_args = [];
for i = idx
                dir = 1;
                if (i > 64)
                    dir = 2;
                    i = i - 64;
                end
                [y,x] = ind2sub([8,8],i);
                output_args = [output_args; [x,y,dir]];
end     

end

