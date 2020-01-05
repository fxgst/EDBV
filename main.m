addpath('Filter');
addpath('Images');

female = 1;
male = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Specify whether male or female ports should be detected

mode = male;

%%%%% Specify on which image the ports should be detected

%%% Good examples of computer case backs: image_[0,6].jpg
%%% Good examples of male handheld ports: port_[1,4].jpg
filename = 'port_1.jpg';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if mode == female
	mainFunc(imread(strcat('Images/', filename)), female);
else
	mainFunc(imread(strcat('Images/', filename)), male);
end


function mainFunc(original, mode)
	disp('START');
	
	if mode == 1
	
		usb = 1;
		hdmi = 2;
		aux = 3;
		mouse = 4;
		vga = 5;

		% cropping
		cutResult = GeoTransformation.justClipp(original);
		imageCut = cutResult.image;
		%rectPos = cutResult.recPos;

		% resize
		imageCut = imresize(imageCut, [600,164]);


		% apply filters to original for processing

		%image = GaussFilter.Filter(image);
		image = EdgeDetection.Filter(imageCut, 0.2);
		%image = BinaryImage.Binary(image);

		% load templates
		hdmiTemplate = imread('Images/hdmi_template_3.jpg');
		vgaTemplate = imread('Images/vga_template_1.jpg');
		usbTemplate = imread('Images/usb_template_2.jpg');
		auxTemplate = imread('Images/aux_template_2.jpg');
		mouseTemplate = imread('Images/mouse_template_1.jpg');


		% apply filters to templates for processing

		%Gauss
		%hdmiTemplate = GaussFilter.Filter(hdmiTemplate, 0);
		%usbTemplate = GaussFilter.Filter(usbTemplate, 0);
		%auxTemplate = GaussFilter.Filter(auxTemplate, 0);

		%Edge Detection
		hdmiTemplate = imresize(EdgeDetection.Filter(hdmiTemplate, 3), [80,35]);
		usbTemplate = imresize(EdgeDetection.Filter(usbTemplate, 3), [80,40]);
		auxTemplate = imresize(EdgeDetection.Filter(auxTemplate, 3), [50,50]);
		mouseTemplate = imresize(EdgeDetection.Filter(mouseTemplate, 3), [60,60]);
		vgaTemplate = imresize(EdgeDetection.Filter(vgaTemplate, 3), [165,60]);

		%Binary
		%hdmiTemplate = BinaryImage.Binary(hdmiTemplate);
		%usbTemplate = BinaryImage.Binary(usbTemplate);
		%auxTemplate = BinaryImage.Binary(auxTemplate);


		Matches = []; % x; y; height; width; score; type
		scales = [0.7, 0.8];
		
		% find matches
		disp('hdmi');
		Matches = TemplateMatching.Match(Matches, image, hdmiTemplate, hdmi, 0.30, 70, scales);
		disp('mouse');
		Matches = TemplateMatching.Match(Matches, image, mouseTemplate, mouse, 0.25, 70, scales);
		disp('vga');
		Matches = TemplateMatching.Match(Matches, image, vgaTemplate, vga, 0.25, 70, scales);
		disp('usb');
		Matches = TemplateMatching.Match(Matches, image, usbTemplate, usb, 0.35, 70, scales);
		disp('aux');
		Matches = TemplateMatching.Match(Matches, image, auxTemplate, aux, 0.28, 70, scales);
		

		format shortg
		disp(Matches);

		% highlight matches in original
		result = TemplateMatching.DrawRectangles(imageCut, Matches);

		% color recognition
	% 	i = ColorRecognition.colors(original, 'blue');
	% 	imshow(i);


		% initialize GUI
		% GUI.init();

		% display image
		imshowpair(result, image, 'montage');
		disp('DONE');
		
	else 
		usb = 1;
		hdmi = 2;
		
		[x,y,z] = size(original);
		
		maxy = 800;
		maxx = 800;
		
		if y > maxy
			original = imresize(original, [(x * (maxy/y)), maxy]);
			
		end
		
		if x > maxx
			original = imresize(original, [maxx, (y * (maxx/x))]);
		end
		
		image = EdgeDetection.Filter(original, 0.2);

		% load templates
		hdmiTemplate = imread('Images/male_hdmi_template.jpg');
		usbTemplate = imread('Images/male_usb_template.jpg');
		
		hdmiTemplate = EdgeDetection.Filter(hdmiTemplate, 3);
		usbTemplate = EdgeDetection.Filter(usbTemplate, 3);
		
		Matches = [];
		
		%scales = flip(linspace(0.4, max((maxx/x),(maxy/y)),7)); % 7 sizes up to the size of scaled image 
		scales = flip(linspace(0.2, 2, 20)); % 20 sizes between 0.2 and 2 

		disp('hdmi');
		Matches = TemplateMatching.Match(Matches, image, hdmiTemplate, hdmi, 0.3, 200, scales);
		disp('usb');
		Matches = TemplateMatching.Match(Matches, image, usbTemplate, usb, 0.1, 200, scales);
		
		format shortg
		disp(Matches);

		% highlight matches in original
		result = TemplateMatching.DrawRectangles(original, Matches);
		imshowpair(result, image, 'montage');
		disp('DONE');
	end
	
	
end
