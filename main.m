addpath('Filter');
addpath('Images');

mainFunc(imread('Images/image_0.jpg'), 'sobel');

function mainFunc(original, edgeDetection)
	disp('START');
    
    % apply filters to original for processing
    image = original;
    %image = GaussFilter.Filter(image);
    image = EdgeDetection.Filter(image,edgeDetection);
    %image = BinaryImage.Binary(image);

    
	% load templates
    hdmiTemplate = imread('Images/hdmi_template_1.jpg');
	usbTemplate = imread('Images/usb_template_5.jpg');
	auxTemplate = imread('Images/aux_template_1.jpg');
    
    % apply filters to templates for processing
    %Gauss
    %hdmiTemplate = GaussFilter.Filter(hdmiTemplate,0);
    %usbTemplate = GaussFilter.Filter(usbTemplate,0);
    %auxTemplate = GaussFilter.Filter(auxTemplate,0);
    %Edge Detection
    hdmiTemplate = EdgeDetection.Filter(hdmiTemplate,edgeDetection);
    usbTemplate = EdgeDetection.Filter(usbTemplate,edgeDetection);
    auxTemplate = EdgeDetection.Filter(auxTemplate,edgeDetection);
    %Binary
	%hdmiTemplate = BinaryImage.Binary(hdmiTemplate);
	%usbTemplate = BinaryImage.Binary(usbTemplate);
	%auxTemplate = BinaryImage.Binary(auxTemplate);
    
    % emphasize matches in original image
    result = original;
	disp('hdmi');
    result = TemplateMatching.Match(result, image, hdmiTemplate, 'hdmi', 0.5, 70);
	disp('usb');
	result = TemplateMatching.Match(result, image, usbTemplate, 'usb', 0.46, 70);
	disp('aux');
	result = TemplateMatching.Match(result, image, auxTemplate, 'aux', 0.5, 70);
    
    % initialize GUI
    % GUI.init();
	
    % display image
    imshowpair(result,image,'montage');

    disp('DONE');
end
