addpath('Filter');
addpath('Images');

mainFunc();

function mainFunc()
    % load initial Image
    original = LoadImage.Load('Images/image_14.jpg');
    
    % apply filters to original for processing
    image = BinaryImage.Binary(original);
    
    % apply filters to template for processing
    usbTemplate = LoadImage.Load('Images/usb_template_1.jpg');
    usbTemplate = BinaryImage.Binary(usbTemplate);

    % emphasize matches in original image
    original = TemplateMatching.Match(original, image, usbTemplate);

    % initialize GUI
    % GUI.init();
    
    % display image
    imshow(original);
    disp('Done');
end

