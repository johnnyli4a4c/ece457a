function [ listCameras] = convertToTable( x , y, cameras, binary )

listCameras = zeros (cameras , 3, 1);
xbits = ceil(log2(x));
ybits = ceil(log2(y));

i = 1;

for j=1:cameras,
    listCameras(j,1,1) = 1 + bi2de(binary(i:i+xbits-1));
    i = i + xbits;
    listCameras(j,2,1) = 1 + bi2de(binary(i:i+ybits-1));
    i = i + ybits;
    listCameras(j,3,1) = binary(i);
    i = i + 1;
end
end
