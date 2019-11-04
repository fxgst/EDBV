addpath('Filter');
addpath('Images');

mainFunc();

function mainFunc()
    % load initial Image
    Image = LoadImage.Load('Images/example.jpeg');
    
    % apply filters
    Image = BinaryImage.Binary(Image);
    
    % display image
    imshow(Image);
end

