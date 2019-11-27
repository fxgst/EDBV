classdef TemplateMatching
    %TEMPLATEMATCHING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        % parameters
		
		% TODO: calculate values based on image size
        consider_top_matches = 70;
		min_score = 0.2;
		
        usb_highlight_color = 'red';
		line_width = 3;

    end
    
    methods(Static)
        
        function scales = getScaleFactors(image, template)
			% TODO: calculate scales for template based on size
			scales = flip(linspace(0.6,2,5)); % 1, 0.9, ..., 0.6
			%scales = linspace(1,1,1); % 1
        end
      
        
        function outputImage = Match(original, image, template)
            scales = TemplateMatching.getScaleFactors(image, template);
            Matches = []; % Y; X; height; width; score
            
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
					
                    [cur_xpeak, cur_ypeak] = find(c==score);
                   
					xoffset = cur_xpeak(1)-width;
					yoffset = cur_ypeak(1)-height;
					
                    p1 = [yoffset; xoffset; height; width; score]; % current match point

                    % check whether matches overlap               
                    for j = 1:size(Matches, 2)
                        p2 = Matches(1:4, j);
					
						overlapArea = rectint(p1(1:4)', p2');

						if (overlapArea ~= 0) 
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
            
			format shortg
			disp(Matches);
			
            outputImage = TemplateMatching.drawRectangles(original, Matches);
		end
		
		
		function result = drawRectangles(original, Matches)
			result = original;
            for i = 1:size(Matches, 2)
                result = insertShape(result, 'rectangle', Matches(1:4, i)', 'LineWidth', TemplateMatching.line_width, 'Color', TemplateMatching.usb_highlight_color);
			end
		end
        
	end
	
end

