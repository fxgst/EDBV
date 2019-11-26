classdef TemplateMatching
    %TEMPLATEMATCHING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        % parameters
		
		% TODO: calculate values based on image size
        match_spacing = 30;
        consider_top_matches = 70;
		min_score = 0.35;
		
        usb_highlight_color = 'red';
		line_width = 3;

    end
    
    methods(Static)
        
        function scales = getScaleFactors(image, template)
			% TODO: calculate scales for template based on size
			scales = flip(linspace(0.6,1,5)); % 1, 0.9, ..., 0.6
			%scales = linspace(1,1,1); % 1
        end
      
        
        function outputImage = Match(original, image, template)
            scales = TemplateMatching.getScaleFactors(image, template);
            Matches = []; % Y; X; width; height; score
            
            for s = 1:size(scales, 2)
                
                rTemplate = imresize(template, scales(s));
                [width, height] = size(rTemplate);

                c = normxcorr2(rTemplate, image); % VERY slow

                bestMatches = maxk(c(:), TemplateMatching.consider_top_matches);
               
                for i = 1:size(bestMatches)
					shouldAdd = true;

					score = bestMatches(i);

					if score < TemplateMatching.min_score
						shouldAdd = false;
						continue;
					end
                    [cur_ypeak, cur_xpeak] = find(c==score);
                   
                    p1 = [cur_ypeak(1); cur_xpeak(1); width; height; score]; % current match point
                    
                    %fprintf('%f, %d, %d\n', score, cur_ypeak, cur_xpeak);

                    % check distance to other matches                 
                    for j = 1:size(Matches, 2)
                        p2 = Matches(:, j);
                                                
                        % detect duplicate matches 
                        % TODO: a gscheide heuristik die duplikate erkennt
                        if norm(p1(1:2)-p2(1:2)) < TemplateMatching.match_spacing % if distance to any other match smaller than n, don't add
                            shouldAdd = false;
							break;
                        end
                    end

                    if shouldAdd
                        % append new match
                        Matches = [Matches p1];
                    end

                end
			end
            
			Matches
			
            % draw rectangles
            for i = 1:size(Matches, 2)
                Coords = (Matches(1:2, i))';
                Dimension = (Matches(3:4, i))';
                
                width = Dimension(1);
                height = Dimension(2);
                yoffset = Coords(1)-width;
                xoffset = Coords(2)-height;

                original = insertShape(original, 'rectangle', [xoffset, yoffset, height, width], 'LineWidth', TemplateMatching.line_width, 'Color', TemplateMatching.usb_highlight_color);
            end

            % return image
            outputImage = original;
        
        end
        
    end
end

