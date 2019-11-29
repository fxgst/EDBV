addpath('Filter');
addpath('Images');

mainFunc(imread('Images/image_0.jpg'));

function mainFunc(original)
	disp('START');
	
	usb = 1;
	hdmi = 2;
	aux = 3;
    
    % apply filters to original for processing
    image = original;
    %image = GaussFilter.Filter(image);
    image = EdgeDetection.Filter(image, 'sobel');
    %image = BinaryImage.Binary(image);

    
	% load templates
    hdmiTemplate = imread('Images/hdmi_template_1.jpg');
	usbTemplate = imread('Images/usb_template_1.jpg');
	auxTemplate = imread('Images/aux_template_1.jpg');
    
    % apply filters to templates for processing
    %Gauss
    %hdmiTemplate = GaussFilter.Filter(hdmiTemplate, 0);
    %usbTemplate = GaussFilter.Filter(usbTemplate, 0);
    %auxTemplate = GaussFilter.Filter(auxTemplate, 0);
    %Edge Detection
    hdmiTemplate = EdgeDetection.Filter(hdmiTemplate, 'sobel');
    usbTemplate = EdgeDetection.Filter(usbTemplate, 'sobel');
    auxTemplate = EdgeDetection.Filter(auxTemplate, 'sobel');
    %Binary
	%hdmiTemplate = BinaryImage.Binary(hdmiTemplate);
	%usbTemplate = BinaryImage.Binary(usbTemplate);
	%auxTemplate = BinaryImage.Binary(auxTemplate);
    
	
	Matches = []; % x; y; height; width; score

	% find matches
	disp('hdmi');
    Matches = TemplateMatching.Match(Matches, image, hdmiTemplate, hdmi, 0.5, 70);
	disp('usb');
	Matches = TemplateMatching.Match(Matches, image, usbTemplate, usb, 0.1, 70);
	disp('aux');
	Matches = TemplateMatching.Match(Matches, image, auxTemplate, aux, 0.3, 70);
    
	% highlight matches in original
	result = TemplateMatching.DrawRectangles(original, Matches);
	
	% color recognition
	%color = ColorRecognition;
	%i = colors(color, original, 'blue');
	%imshow(i);
	

    % initialize GUI
    % GUI.init();
	
    % display image
    imshowpair(result, image, 'montage');
    disp('DONE');
	
end
