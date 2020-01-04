classdef TemplateMatching
	%TEMPLATEMATCHING Summary of this class goes here
	%   Detailed explanation goes here
	
	properties(Constant)
		
	end
	
	methods(Static)
		
		function scales = getScaleFactors(image, template)
			% TODO: calculate scales for template based on size
			scales = [0.7, 0.8];%flip(linspace(0.4,1,7)); % 1, 0.9, ..., 0.4
		end
		
		
		function [Matches] = Match(Matches, image, template, type, minScore, considerTopMatches)
			scales = TemplateMatching.getScaleFactors(image, template);
			[imageWidth, imageHeight] = size(image);
			
			for s = 1:size(scales, 2)
				
				rTemplate = imresize(template, scales(s));
				[width, height] = size(rTemplate);
				
				c = normxcorr2(rTemplate, image); % VERY slow
				
				bestMatches = maxk(c(:), considerTopMatches);
				
				for i = 1:size(bestMatches)
					shouldAdd = true;
					score = bestMatches(i);
					
					if score < minScore
						continue;
					end
					
					[cur_xpeak, cur_ypeak] = find(c==score);
					
					xoffset = cur_xpeak(1)-width;
					yoffset = cur_ypeak(1)-height;
					
					% check if match partially outside of image
					if (yoffset < 0) || (xoffset < 0) || ((yoffset+height) > imageHeight) || ((xoffset+width) > imageWidth)
						continue;
					end
					
					p1 = [yoffset; xoffset; height; width; score; type]; % current match point
					
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
			
		end
		
		
		function result = DrawRectangles(original, Matches)
			result = original;
			for i = 1:size(Matches, 2)
				switch Matches(6, i)
					case 1 % usb
						color = 'green';
					case 2 % hdmi
						color = 'yellow';
					case 3 % aux
						color = 'red';
				end
				result = insertShape(result, 'rectangle', Matches(1:4, i)', 'LineWidth', 3, 'Color', color);
			end
		end
		
	end
	
end
