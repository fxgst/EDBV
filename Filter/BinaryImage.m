classdef BinaryImage
    properties
        Property1 % not used
    end
    
    methods(Static)
        
        function outputImage = Binary(image)
            outputImage = imbinarize(image,0.5);
        end
        
    end
end

