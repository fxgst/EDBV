classdef GeoTransformation
    %GEOTRANSFORMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
        function obj = GeoTransformation(inputArg1,inputArg2)
            %GEOTRANSFORMATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function clippedPic = usage_assistedMode_function(targetImageData)
            %USAGE_ASSISTEDMODE Summary of this function goes here
            %   Detailed explanation goes here

            % 5.1 Undoing Perspective Distortion of Planar Surface
            % a)

            %book=imread('trapezoid.jpg');
            figure('Name','InputImage')
            imshow(targetImageData);

            % b)
            fprintf('Corner selection must be clockwise or anti-clockwise.\n');
            [X, Y] = ginput(4);

            close('InputImage');

            %if ispolycw(X, Y) % if the coordinates are not clockwise, sort them clockwise    
            %    [X, Y] = poly2cw(X, Y)
            %end

            %X = uint8(X);
            %Y = uint8(Y);
            [X, Y] = GeoTransformation.sortPolyFromClockwiseStartingFromTopLeft( X, Y );


            x=[1;210;210;1];
            y=[1;1;297;297];

            % c)
            A=zeros(8,8);
            A(1,:)=[X(1),Y(1),1,0,0,0,-1*X(1)*x(1),-1*Y(1)*x(1)];
            A(2,:)=[0,0,0,X(1),Y(1),1,-1*X(1)*y(1),-1*Y(1)*y(1)];

            A(3,:)=[X(2),Y(2),1,0,0,0,-1*X(2)*x(2),-1*Y(2)*x(2)];
            A(4,:)=[0,0,0,X(2),Y(2),1,-1*X(2)*y(2),-1*Y(2)*y(2)];

            A(5,:)=[X(3),Y(3),1,0,0,0,-1*X(3)*x(3),-1*Y(3)*x(3)];
            A(6,:)=[0,0,0,X(3),Y(3),1,-1*X(3)*y(3),-1*Y(3)*y(3)];

            A(7,:)=[X(4),Y(4),1,0,0,0,-1*X(4)*x(4),-1*Y(4)*x(4)];
            A(8,:)=[0,0,0,X(4),Y(4),1,-1*X(4)*y(4),-1*Y(4)*y(4)];

            v=[x(1);y(1);x(2);y(2);x(3);y(3);x(4);y(4)];

            u=A\v;
            %which reshape

            U=reshape([u;1],3,3)';

            % d)
            T = projective2d(U');
            P2 = imwarp(targetImageData,T);

            figure('Name','CutImage')
            OUT = imcrop(P2);
            close('CutImage');
            
            % e)
            clippedPic = OUT;
        end
        
        function coordinates = sortCoordinatesAccordToX( coordinates )
            %SORTCOORDINATESACCORDTOX Summary of this function goes here

            X_sorted_coordinates = sort(coordinates);

                for i=1:length(coordinates)
                    for j=1:length(coordinates) % scan thru the X_sorted_coordinates set
                        if X_sorted_coordinates(j,1) == coordinates(i,1)
                        reordered_coordinates(j,:) = coordinates(i,:);
                        end
                    end        
                end

                coordinates = reordered_coordinates;
        end
          
        function [X, Y] = sortPolyFromClockwiseStartingFromTopLeft( X, Y )

            % The 1st 2 high values for the y-axis are the top 2 edges
            % <upper corners identified>
            %top_vertices_Y = sort(Y,2);
            top_vertices_Y = GeoTransformation.sortCoordinatesAccordToX(Y);

                for i=1:4
                    for j=1:4
                        if top_vertices_Y(i) == Y(j)
                            top_vertices_X(i) = X(j);
                        end
                    end
                end

               top_vertices_X = top_vertices_X'; 
               X = top_vertices_X;
               Y = top_vertices_Y;

               % The larger of the x values for the 1st 2 high values for the y-axis
               % belongs to the top-right hand corner
               % <upper left and right corners identified>
               if X(1) > X(2)
                   top_vertices_X(1) = X(2); 
                   top_vertices_Y(1) = Y(2);        
                   top_vertices_X(2) = X(1); 
                   top_vertices_Y(2) = Y(1);         
               end

               X = top_vertices_X;
               Y = top_vertices_Y;

            % The larger of the x values for the last 2 high values for the y-axis
            % belongs to the bottom-right hand corner
               % <lower left and right corners identified>
               if X(3) < X(4)
                   top_vertices_X(3) = X(4); 
                   top_vertices_Y(3) = Y(4);        
                   top_vertices_X(4) = X(3); 
                   top_vertices_Y(4) = Y(3);         
               end

               X = top_vertices_X;
               Y = top_vertices_Y;

               % Notes
            % [X,Y] to be sorted as
            %       top_left
            %       top_right
            %       bottom_right
            %       bottom_left
        end

        function justClipping = justClipp(toClipImage)
            figure('Name','ClippImage')
            justClipping = imcrop(toClipImage);
            close('ClippImage');
        end
        
    end
end

