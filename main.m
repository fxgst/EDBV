addpath('Filter');
mainFunc();

function mainFunc()
    % load initial Image
    Image = LoadImage.Load();
    
    % apply filters
    Image = BinaryImage.Binary(Image);
    
    % display image
    imshow(Image);
end

