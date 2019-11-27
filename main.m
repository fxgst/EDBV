addpath('Filter');
addpath('Images');

mainFunc(imread('Images/image_0.jpg'));

function mainFunc(original)
	disp('START');
    
    % apply filters to original for processing
    image = BinaryImage.Binary(original);
    
	% load templates
    hdmiTemplate = imread('Images/hdmi_template_1.jpg');
	usbTemplate = imread('Images/usb_template_5.jpg');
	auxTemplate = imread('Images/aux_template_1.jpg');

    % apply filters to templates for processing
	auxTemplate = BinaryImage.Binary(auxTemplate);
	usbTemplate = BinaryImage.Binary(usbTemplate);
	hdmiTemplate = BinaryImage.Binary(hdmiTemplate);

    % emphasize matches in original image
    result = original;
	disp('hdmi');
    result = TemplateMatching.Match(result, image, hdmiTemplate, 'hdmi', 0.5, 70);
	disp('usb');
	result = TemplateMatching.Match(result, image, usbTemplate, 'usb', 0.39, 70);
	disp('aux');
	result = TemplateMatching.Match(result, image, auxTemplate, 'aux', 0.38, 70);
    
    % initialize GUI
    % GUI.init();
	
    % display image
    imshow(result);
    disp('DONE');
end
