classdef EdgeDetection

    methods(Static)
        
         function outputImage = Filter(image,sigma,T_Low,T_High)

            matrixX = [-1 0 1;
                       -2 0 2;
                       -1 0 1];
            matrixY = [-1 -2 -1;
                        0 0 0;
                        1 2 1];
            
            %Gaussfilter step 1
            grayGauss = GaussFilter.Filter(image, sigma);
            
            % to gray
            gray = rgb2gray(grayGauss);
            
            xGray = gray;
            yGray = gray;
            
            %Sobeloperator in both directions step 2
            imageX = EdgeDetection.evc_filter(xGray, matrixX);
            imageY = EdgeDetection.evc_filter(yGray, matrixY);
            
            %imageBoth = max(imageX, imageY); 
            
            %Calculate magnitude
            magnitude = (imageX.^2) + (imageY.^2);
            magnitude2 = sqrt(magnitude);
                        
            %edgeDirection step 3 
            theta = atan2(imageY, imageX);
            theta = theta*180/pi;
            
            inputSize = size(theta);
            xLength = inputSize(1);
            yLength = inputSize(2);
                      
            %Adjustment for negative directions, making all directions positive
            for i=1:xLength
                for j=1:yLength
                    if (theta(i,j)<0) 
                        theta(i,j)=360+theta(i,j);
                    end;
                end;
            end;
            
            
            theta2 = zeros(xLength, yLength); 
            
            %edge direction step 4
            for i = 1  : xLength
                for j = 1 : yLength
                    if ((theta(i, j) >= 0 ) && (theta(i, j) < 22.5) || (theta(i, j) >= 157.5) && (theta(i, j) < 202.5) || (theta(i, j) >= 337.5) && (theta(i, j) <= 360))
                        theta2(i, j) = 0;
                    elseif ((theta(i, j) >= 22.5) && (theta(i, j) < 67.5) || (theta(i, j) >= 202.5) && (theta(i, j) < 247.5))
                        theta2(i, j) = 45;
                    elseif ((theta(i, j) >= 67.5 && theta(i, j) < 112.5) || (theta(i, j) >= 247.5 && theta(i, j) < 292.5))
                        theta2(i, j) = 90;
                    elseif ((theta(i, j) >= 112.5 && theta(i, j) < 157.5) || (theta(i, j) >= 292.5 && theta(i, j) < 337.5))
                        theta2(i, j) = 135;
                    end;
                end;
            end;

            
            %unterdruecken von nicht maximas step 5
            BW = zeros (xLength, yLength);
            BW = double (BW);
            %Non-Maximum Supression
            for i=2:xLength-1
                for j=2:yLength-1
                    if (theta2(i,j)==0)
                        BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i,j+1), magnitude2(i,j-1)]));
                    elseif (theta2(i,j)==45)
                        BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j-1), magnitude2(i-1,j+1)]));
                    elseif (theta2(i,j)==90)
                        BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j), magnitude2(i-1,j)]));
                    elseif (theta2(i,j)==135)
                        BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j+1), magnitude2(i-1,j-1)]));
                    end;
                end;
            end;
            BW = BW.*magnitude2;

            
            %Schwellenwertbildung step 6
            %Value for Thresholding T_Low and T_High set by input
            
            %Hysteresis Thresholding
            T_Low = T_Low * max(max(BW));
            T_High = T_High * max(max(BW));
            T_res = zeros (xLength, yLength);
            T_res = double (T_res);
            for i = 2  : xLength-1
                for j = 2 : yLength-1
                    if (BW(i, j) < T_Low)
                        T_res(i, j) = 0;
                    elseif (BW(i, j) > T_High)
                        T_res(i, j) = 1;
                    %Using 8-connected components
                    elseif ( BW(i+1,j)>T_High || BW(i-1,j)>T_High || BW(i,j+1)>T_High || BW(i,j-1)>T_High || BW(i-1, j-1)>T_High || BW(i-1, j+1)>T_High || BW(i+1, j+1)>T_High || BW(i+1, j-1)>T_High)
                        T_res(i,j) = 1;
                    end;
                end;
            end;
            
            %return 
            T_res = T_res(1:xLength-1,1:yLength-1) + (gray.^1.5);
            outputImage = uint8(T_res.*255);
            
            %figure('Name','outputImage')
            %imshow(outputImage);

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

            calcMatrix(1:(xLength+2),1:(yLength+2)) = 0;
            calcMatrix(2:(xLength+1),2:(yLength+1)) = useInput;
            

            calcMatrixSize = size(calcMatrix);
            xCalcLength = calcMatrixSize(1);
            yCalcLength = calcMatrixSize(2);
            
            newCalcMatrix = zeros(xLength, yLength);
            
            for row = 2:(xCalcLength-1)
                for colum = 2:(yCalcLength-1)
                    newValue = 0;
                    for rowKernel = 1:xKernelLength
                        for columKernel = 1:yKernelLength
                        newValue = newValue + (kernel(rowKernel,columKernel)*calcMatrix(row+rowKernel-2,colum+columKernel-2));
                        end
                    end
                    newCalcMatrix(row,colum) = newValue;
                end
            end
            
            result = newCalcMatrix;

        end
    end
end
