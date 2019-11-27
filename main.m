addpath('Filter');
addpath('Images');

mainFunc();

function mainFunc()
    % load initial Image
    original = LoadImage.Load('Images/image_0.jpg');
    
    % apply filters to original for processing
    image = BinaryImage.Binary(original);
    
    % apply filters to template for processing
    hdmiTemplate = LoadImage.Load('Images/hdmi_template_1.jpg');
	usbTemplate = LoadImage.Load('Images/usb_template_5.jpg');
	auxTemplate = LoadImage.Load('Images/aux_template_1.jpg');


	auxTemplate = BinaryImage.Binary(auxTemplate);
	usbTemplate = BinaryImage.Binary(usbTemplate);
	hdmiTemplate = BinaryImage.Binary(hdmiTemplate);

    % emphasize matches in original image
    result = original;
	disp('hdmi');
    result = TemplateMatching.Match(result, image, hdmiTemplate, 'hdmi', 0.4, 70);
	disp('usb');
	result = TemplateMatching.Match(result, image, usbTemplate, 'usb', 0.35, 70);
	disp('aux');
	result = TemplateMatching.Match(result, image, auxTemplate, 'aux', 0.38, 70);

    
    % initialize GUI
    % GUI.init();
	
    % display image
    imshow(result);
    disp('DONE');
end
