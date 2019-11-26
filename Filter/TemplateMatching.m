classdef TemplateMatching
    %TEMPLATEMATCHING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        % parameters
        match_spacing = 150;
        consider_top_matches = 50;
        usb_highlight_color = 'red';

    end
    
    methods(Static)

        function outputImage = Match(original, image, template)
            
            scales = linspace(0.4,1,7); % 0.4, 0.5, ..., 1
            Matches = [];
            
            for s = 1:size(scales, 2)
                
                rTemplate = imresize(template, scales(s));
                [width, height] = size(rTemplate);

                c = normxcorr2(rTemplate, image); % VERY slow

                bestMatches = maxk(c(:), TemplateMatching.consider_top_matches);
               
                for i = 1:size(bestMatches)
                    [cur_ypeak, cur_xpeak] = find(c==bestMatches(i));
                    p1 = [cur_ypeak; cur_xpeak; width; height]; % current match point
                    shouldAdd = true;
                    
                    %fprintf('%f, %d, %d\n', bestMatches(i), cur_ypeak, cur_xpeak);

                    % check distance to other matches                 
                    for j = 1:size(Matches, 2)
                        p2 = Matches(:, j);
                        % FIXME: p2 sometimes not matches p1 dimensions (e.g. for small template)
                        
                        % detect duplicate matches 
                        % TODO: a gscheide heuristik die duplikate erkennt
                        if norm(p1-p2) < TemplateMatching.match_spacing % if distance to any other match smaller than n, don't add
                            shouldAdd = false;
                        end
                    end

                    if shouldAdd
                        % append new match
                        Matches = [Matches p1];
                    end

                end
                Matches
            end
            

            % highlight matches in original image
            for i = 1:size(Matches, 2)
                Coords = (Matches(1:2, i))';
                Dimension = (Matches(3:4, i))';
                
                width = Dimension(1);
                height = Dimension(2);
                yoffset = Coords(1)-width;
                xoffset = Coords(2)-height;

                original = insertShape(original, 'rectangle', [xoffset, yoffset, height, width], 'LineWidth', 10, 'Color',TemplateMatching.usb_highlight_color);
            end

            % return image
            outputImage = original;
        
        end
        
    end
end

