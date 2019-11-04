classdef LoadImage
    properties
        Property1 % not used
    end
    
    methods(Static)
        function image = loadImage()
            image = imread('pout.tif');
        end
    end
    
end

