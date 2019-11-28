classdef GaussFilter
    properties
        Property1 % not used
    end
    
    methods(Static)
               
        function outputImage = Filter(image, sigma)
            if ~exist('sigma','var')
                sigma = 0.5;
            end
            if sigma > 0
                outputImage = imgaussfilt(image,sigma);
            else
                outputImage = image;
            end
        end
        
    end
end

