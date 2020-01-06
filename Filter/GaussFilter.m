classdef GaussFilter
    
    methods(Static)
               
        function outputImage = Filter(image, sigma)
            
            if ~exist('sigma','var') || sigma <= 0
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

        function [result] = bilateralFilter(input, sigmaS, sigmaI, sizeXY)

            useInput = im2double(input);
            
            %TODO: Add your code here
            inputSize = size(useInput);
            xLength = inputSize(1);
            yLength = inputSize(2);
            
            xKernelLength = sizeXY;
            yKernelLength = sizeXY;

            xKernelminus1 = xKernelLength-1;
            yKernelminus1 = yKernelLength-1;
            
            xKernelHalf = ((xKernelLength-1)/2);
            yKernelHalf = ((yKernelLength-1)/2);

            calcMatrix(1:(xLength+xKernelminus1),1:(yLength+yKernelminus1),1:3) = 0;
            calcMatrix(1+xKernelHalf:(xLength+xKernelHalf),1+yKernelHalf:(yLength+yKernelHalf),1:3) = useInput;

            calcMatrixSize = size(calcMatrix);
            xCalcLength = calcMatrixSize(1);
            yCalcLength = calcMatrixSize(2);
            
            R = calcMatrix(:,:,1);
            G = calcMatrix(:,:,2);
            B = calcMatrix(:,:,3);


            for row = 1+xKernelHalf:(xCalcLength-xKernelHalf)
                for colum = 1+yKernelHalf:(yCalcLength-yKernelHalf)
                    newValueRSum1 = 0;
                    newValueRSum2 = 0;
                    newValueGSum1 = 0;
                    newValueGSum2 = 0;
                    newValueBSum1 = 0;
                    newValueBSum2 = 0;
                    p = [row colum];
                    ipR = R(p(1),p(2));
                    ipG = G(p(1),p(2));
                    ipB = B(p(1),p(2));
                    for rowKernel = 1:xKernelLength
                        for columKernel = 1:yKernelLength
                            q = [(row+rowKernel-xKernelHalf-1) (colum+columKernel-yKernelHalf-1)];
                            iqR = R(q(1),q(2));
                            iqG = G(q(1),q(2));
                            iqB = B(q(1),q(2));
                            
                            newValueRSum1 = newValueRSum1 + exp(((abs(norm(p - q)))^2)/(2*(sigmaS^2))) * exp(((abs(ipR - iqR))^2)/(2*(sigmaI^2))) * iqR;
                            newValueRSum2 = newValueRSum2 + exp(((abs(norm(p - q)))^2)/(2*(sigmaS^2))) * exp(((abs(ipR - iqR))^2)/(2*(sigmaI^2)));

                            newValueGSum1 = newValueGSum1 + exp(((abs(norm(p - q)))^2)/(2*(sigmaS^2))) * exp(((abs(ipG - iqG))^2)/(2*(sigmaI^2))) * iqG;
                            newValueGSum2 = newValueGSum2 + exp(((abs(norm(p - q)))^2)/(2*(sigmaS^2))) * exp(((abs(ipG - iqG))^2)/(2*(sigmaI^2)));

                            newValueBSum1 = newValueBSum1 + exp(((abs(norm(p - q)))^2)/(2*(sigmaS^2))) * exp(((abs(ipB - iqB))^2)/(2*(sigmaI^2))) * iqB;
                            newValueBSum2 = newValueBSum2 + exp(((abs(norm(p - q)))^2)/(2*(sigmaS^2))) * exp(((abs(ipB - iqB))^2)/(2*(sigmaI^2)));
                        end
                    end
                    R(row,colum) = (1/newValueRSum2) * newValueRSum1;
                    G(row,colum) = (1/newValueGSum2) * newValueGSum1;
                    B(row,colum) = (1/newValueBSum2) * newValueBSum1;
                end
            end

            calcMatrix = cat(3, R, G, B);

            output(1:xLength,1:yLength,1:3) = calcMatrix(2:(xLength+1),2:(yLength+1),1:3);
            result = output;

        end
        
    end
end

