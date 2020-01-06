% Author: Elias Datler 11775795
classdef GrayScale
	%GRAYSCALE Converts an image to a grayscale image
	
	methods(Static)
		function returnedImage = Gray(image)
			i = image;
			
			% separate color channels
			R = i(:, :, 1);
			G = i(:, :, 2);
			B = i(:, :, 3);
			
			% standard NTSC conversion formula
			returnedImage = 0.2989*R + 0.5970*G + 0.1140*B;
		end
		
	end
end

