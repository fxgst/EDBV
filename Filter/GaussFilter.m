classdef GaussFilter
    properties
        Property1 % not used
    end
    
    methods(Static)
               
        function outputImage = Filter(image, sigma)
            
            if ~exist('sigma','var')
                sigma = 0.5;
            end
            if sigma > 0
                gauss_kernel = fspecial('gaussian', [5 5], sigma);
                outputImage = GaussFilter.evc_filter(image,gauss_kernel);
            else
                outputImage = image;
            end
        end
        
        % Returns the input image filtered with the kernel
        % input: An rgb-image
        % kernel: The filter kernel
        function [result] = evc_filter(input, kernel)

            useInput = im2double(input);
            
            %TODO: Add your code here
            inputSize = size(useInput);
            xLength = inputSize(1);
            yLength = inputSize(2);
            
            kernelSize = size(kernel);
            xKernelLength = kernelSize(1);
            yKernelLength = kernelSize(2);

            calcMatrix(1:(xLength+4),1:(yLength+4),1:3) = 0;
            calcMatrix(3:(xLength+2),3:(yLength+2),1:3) = useInput;

            calcMatrixSize = size(calcMatrix);
            xCalcLength = calcMatrixSize(1);
            yCalcLength = calcMatrixSize(2);
            
            R = calcMatrix(:,:,1);
            G = calcMatrix(:,:,2);
            B = calcMatrix(:,:,3);

            for row = 3:(xCalcLength-2)
                for colum = 3:(yCalcLength-2)
                    newValue = 0;
                    for rowKernel = 1:xKernelLength
                        for columKernel = 1:yKernelLength
                        newValue = newValue + (kernel(rowKernel,columKernel)*R(row+rowKernel-3,colum+columKernel-3));
                        end
                    end
                    R(row,colum) = newValue;
                end
            end

            for row = 3:(xCalcLength-2)
                for colum = 3:(yCalcLength-2)
                    newValue = 0;
                    for rowKernel = 1:xKernelLength
                        for columKernel = 1:yKernelLength
                        newValue = newValue + (kernel(rowKernel,columKernel)*G(row+rowKernel-3,colum+columKernel-3));
                        end
                    end
                    G(row,colum) = newValue;
                end
            end

            for row = 3:(xCalcLength-2)
                for colum = 3:(yCalcLength-2)
                    newValue = 0;
                    for rowKernel = 1:xKernelLength
                        for columKernel = 1:yKernelLength
                        newValue = newValue + (kernel(rowKernel,columKernel)*B(row+rowKernel-3,colum+columKernel-3));
                        end
                    end
                    B(row,colum) = newValue;
                end
            end

            calcMatrix = cat(3, R, G, B);

            output(1:xLength,1:yLength,1:3) = calcMatrix(3:(xLength+2),3:(yLength+2),1:3);
            result = output;

        end

    end
end

