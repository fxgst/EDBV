classdef TemplateMatching
    %TEMPLATEMATCHING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1 % not used
    end
    
    methods(Static)
        
        function outputImage = Match(original, image, template)
            [width, height] = size(template);
           
            c = normxcorr2(template, image);

            % find coordinates of max correlation
            [ypeak, xpeak] = find(c==max(c(:)));
            
            yoffset = ypeak-width;
            xoffset = xpeak-height;
            
            result = insertShape(original, 'rectangle', [xoffset, yoffset, height, width], 'LineWidth', 10, 'Color', 'red');
            outputImage = result;
            
        end
        
    end
end

