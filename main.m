addpath('Filter');
addpath('Images');

mainFunc();

function mainFunc()
    % load initial Image
    original = LoadImage.Load('Images/image_0.jpeg');
    
    % apply filters to original for processing
    image = BinaryImage.Binary(original);
    
    % apply filters to template for processing
    usbTemplate = LoadImage.Load('Images/usb_template_2.jpeg');
    usbTemplate = BinaryImage.Binary(usbTemplate);

    % emphasize matches in original image
    result = original;
    result = TemplateMatching.Match(result, image, usbTemplate);
    
    

    % initialize GUI
    % GUI.init();
	
    % display image
    imshow(result);
    disp('Done');
end
