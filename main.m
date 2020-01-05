addpath('Filter');
addpath('Images');

female = 1;
male = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Specify whether male or female ports should be detected

mode = female;

%%%%% Specify on which image the ports should be detected

%%% Good examples of computer case backs: image_[0,6].jpg
%%% Good examples of male handheld ports: port_[1,4].jpg
filename = 'image_0.jpg';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imageSigma = 1;
templateSigma = 1;

if mode == female
    templateSigma = 2;
    imageSigma = 0.5;
    templateT_Low = 0.075;
    templateT_High = 0.175;
    imageT_Low = 0.055;
    imageT_High = 0.105;
	mainFunc(imread(strcat('Images/', filename)), female, templateSigma, imageSigma, imageT_Low, imageT_High, templateT_Low, templateT_High);
else
    templateSigma = 1;
    imageSigma = 0.5;
    templateT_Low = 0.115;
    templateT_High = 0.175;
    imageT_Low = 0.055;
    imageT_High = 0.155;
	mainFunc(imread(strcat('Images/', filename)), male, templateSigma, imageSigma, imageT_Low, imageT_High, templateT_Low, templateT_High);
end


function mainFunc(original, mode, templateSigma, imageSigma, imageT_Low, imageT_High, templateT_Low, templateT_High)
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
		image = EdgeDetection.Filter(imageCut, imageSigma, imageT_Low, imageT_High);
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
  		mouseTemplate = imresize(EdgeDetection.Filter(mouseTemplate, templateSigma, templateT_Low, templateT_High), [60,60]);
        auxTemplate = imresize(EdgeDetection.Filter(auxTemplate, templateSigma, templateT_Low, templateT_High), [50,50]);
		vgaTemplate = imresize(EdgeDetection.Filter(vgaTemplate, templateSigma, templateT_Low, templateT_High), [165,60]);
        usbTemplate = imresize(EdgeDetection.Filter(usbTemplate, templateSigma, templateT_Low, templateT_High), [80,40]);
		hdmiTemplate = imresize(EdgeDetection.Filter(hdmiTemplate, templateSigma, templateT_Low, templateT_High), [80,35]);

		%Binary
		%hdmiTemplate = BinaryImage.Binary(hdmiTemplate);
		%usbTemplate = BinaryImage.Binary(usbTemplate);
		%auxTemplate = BinaryImage.Binary(auxTemplate);


		Matches = []; % x; y; height; width; score; type
		scales = [0.7, 0.8];
		
		% find matches
        disp('mouse');
		Matches = TemplateMatching.Match(Matches, image, mouseTemplate, mouse, 0.3, 70, scales);
		disp('vga');
		Matches = TemplateMatching.Match(Matches, image, vgaTemplate, vga, 0.23, 70, scales);
		disp('aux');
		Matches = TemplateMatching.Match(Matches, image, auxTemplate, aux, 0.25, 70, scales);
        disp('usb');
		Matches = TemplateMatching.Match(Matches, image, usbTemplate, usb, 0.35, 70, scales);
		disp('hdmi');
		Matches = TemplateMatching.Match(Matches, image, hdmiTemplate, hdmi, 0.35, 70, scales);
		

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
        figure,
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
		
		image = EdgeDetection.Filter(original, imageSigma, imageT_Low, imageT_High);

		% load templates
        usbTemplate = imread('Images/male_usb_template.jpg');
		hdmiTemplate = imread('Images/male_hdmi_template.jpg');
		
		usbTemplate = EdgeDetection.Filter(usbTemplate, templateSigma, templateT_Low, templateT_High);
		hdmiTemplate = EdgeDetection.Filter(hdmiTemplate, templateSigma, templateT_Low, templateT_High);

		Matches = [];
		
		%scales = flip(linspace(0.4, max((maxx/x),(maxy/y)),7)); % 7 sizes up to the size of scaled image 
		scales = flip(linspace(0.2, 2, 20)); % 20 sizes between 0.2 and 2 

        disp('usb');
		Matches = TemplateMatching.Match(Matches, image, usbTemplate, usb, 0.4, 200, scales);
		disp('hdmi');
		Matches = TemplateMatching.Match(Matches, image, hdmiTemplate, hdmi, 0.4, 200, scales);
		
		format shortg
		disp(Matches);

		% highlight matches in original
		result = TemplateMatching.DrawRectangles(original, Matches);
        figure,
		imshowpair(result, image, 'montage');
		disp('DONE');
	end
	
	
end
