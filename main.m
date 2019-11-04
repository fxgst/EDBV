import LoadImage

mainFunc();

function mainFunc()
    % load initial Image
    Image = LoadImage.loadImage();
    
    
    % Show image
    imshow(Image);
end

