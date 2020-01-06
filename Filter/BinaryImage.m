% Author: Elias Datler 11775795
classdef BinaryImage
	%BINARYIMAGE Returns black white image based on threshhold

    methods(Static)
        
		% matlab implementation
        function outputImage = Binary(image)
            gray = rgb2gray(image);
            outputImage = imbinarize(gray, 'adaptive');
            %outputImage = edge(gray);
		end
		
		% own implementation
		function binImg = Binary_implementation(Image, params)

			if ~isfield(params,'threshold'); params.threshold = 0.01; end

			binImg = Image;

			% black or white depending on the threshold
			binImg(Image <= params.threshold) = 0;
			binImg(Image > params.threshold) = 256;

			%convert to logical image
			binImg = logical(binImg);
		end
        
    end
end

