% Author: Elias Datler 11775795
classdef ColorRecognition
	%COLORRECOGNITION Returns an image with filtered colors
	
	methods(Static)
		function result = colors(original, color)
			switch color
				case 'blue'
					mode = 1;
			end
			lab_he = rgb2lab(original);
			ab = lab_he(:,:,2:3);
			ab = im2single(ab);
			
			nColors = 3;
			
			% repeat the clustering 3 times to avoid local minima
			pixel_labels = imsegkmeans(ab, nColors, 'NumAttempts', 3);
			
			mask1 = pixel_labels==mode;
			cluster1 = original .* uint8(mask1);
			
			L = lab_he(:,:,1);
			L_blue = L .* double(mask1);
			L_blue = rescale(L_blue);
			idx_light_blue = imbinarize(nonzeros(L_blue));
			
			blue_idx = find(mask1);
			mask2 = mask1;
			mask2(blue_idx(idx_light_blue)) = 0;

			cluster1 = original .* uint8(mask2);
			
			for x = 1:size(cluster1, 1)
				for y = 1:size(cluster1, 2)
					color = squeeze(cluster1(x,y,:));
					if cluster1(x,y, :) > 240
						cluster1(x,y,:) = 0;
					end
					if (color ~= 0)
						%fprintf('r%f g%f b%f \n', color(1), color(2), color(3));
					end

				end
			end
			
			result = cluster1;
		end
	end
end
