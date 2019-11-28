classdef EdgeDetection
    properties
        Property1 % not used
    end
    
    methods(Static)
               
        function outputImage = Filter(image, filter)
            if ~exist('filter','var') || ~isstring(filter)
                filter = 'canny';
            end
            gray = rgb2gray(image);
            filtered = edge(gray,filter);
            outputImage = imfuse(filtered,gray,'blend');
        end
        
    end
end



