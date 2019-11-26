classdef TemplateMatching
    %TEMPLATEMATCHING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        matchTolerance = 15;
        usb_color = 'red';
    end
    
    methods(Static)
        
        function outputImage = Match(original, image, template)
            [width, height] = size(template);
           
            c = normxcorr2(template, image);
            best_matches = maxk(c(:), 50);
            
            [ypeak, xpeak] = find(c==best_matches(1));
            
            Matches = [ypeak; xpeak];  % add best match
            
            for i = 2:size(best_matches)
                [cur_ypeak, cur_xpeak] = find(c==best_matches(i));
                p1 = [cur_ypeak; cur_xpeak]; % current match point
                shouldAdd = true;
                
                % check distance to other matches                 
                for j = 1:size(Matches, 2)
                    p2 = Matches(:, j);
                    if norm(p1-p2) < TemplateMatching.matchTolerance % if distance to any other match smaller than 15px, don't add
                        shouldAdd = false;
                    end
                end
                       
                if shouldAdd
                    % append new match
                    Matches = [Matches p1];
                end
            
            end
            
            Matches
            
            % highlight matches in original image
            for i = 1:size(Matches, 2)
                Coords = (Matches(:, i))';
                
                yoffset = Coords(1)-width;
                xoffset = Coords(2)-height;
                
                original = insertShape(original, 'rectangle', [xoffset, yoffset, height, width], 'LineWidth', 10, 'Color', TemplateMatching.usb_color);
            end
            
            % return image
            outputImage = original;
            
        end
        
    end
end

