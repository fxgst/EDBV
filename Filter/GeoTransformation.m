classdef GeoTransformation
    %GEOTRANSFORMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
        
        function [result] = justClipp(input)

            figure('Name','InputImage')
            imshow(input);

            imrectData = imrect;
            % recPosition 4-element vector [xmin ymin rectWidth rectHeight]
            % Position vom Rechteck im Orginal
            recPosition = getPosition(imrectData);

            close('InputImage');

            minX = round(recPosition(1));
            maxX = round(minX + recPosition(3));
            minY = round(recPosition(2));
            maxY = round(minY + recPosition(4));

            R = input(:,:,1);
            G = input(:,:,2);
            B = input(:,:,3);

            newR = R(minY:maxY,minX:maxX,1);
            newG = G(minY:maxY,minX:maxX,1);
            newB = B(minY:maxY,minX:maxX,1);
            cutImage = cat(3, newR, newG, newB);
            
            result = struct('image','recPos');
            result.image = cutImage;
            result.recPos = recPosition;
        end
        
    end
end

