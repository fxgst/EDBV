classdef LoadImage
    properties
        Property1 % not used
    end
    
    methods(Static)
        
        function image = Load(filePath)
            image = imread(filePath);
        end
        
    end
end

