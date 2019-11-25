classdef BinaryImage
    properties
        Property1 % not used
    end
    
    methods(Static)
        
        function outputImage = Binary(image)
            gray = rgb2gray(image);
            outputImage = imbinarize(gray, 'adaptive');
        end
        
    end
end

