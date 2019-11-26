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

function [S,c,r, w, h] = SSDXCORR(f,t)
    % source: doi:10.1117/1.2786469 
    % By Yue Wu
    % ECE Dept
    % Tufts University
    % 04/10/2011
    % -------------------------------------------------------------------------

    t = double(t);
    f = double(f);

    tc = 2*t*1i-1;
    fc = f.^2+f*1i;

    tc = rot90(tc,2);
    m = conv2(fc,conj(tc),'same');
    S = real(m);

    %figure,imshow(uint8(f),[]),colormap(gray)
    [v,ind] = max(S(:));
    [c,r] = ind2sub([size(S,1),size(S,2)],ind);
    [w,h] = size(t);
end
