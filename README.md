# EDBV

# Usage

Open the App.mlapp by double clicking on it.

## Male Ports
For male ports, click 'Load Male Plug Image', and choose an image from the Images folder named `port[1-4].jpg`.
After the image appears in the gui, click 'Calculate'. If the button's line turnes blue, it is calculating. This may take a while. After the detection is done, the ports in the image should be highlighted.

## Female Ports
For female ports, click 'Load Female Plug Image', and choose an image from the Images folder named `image[0-5].jpg` to see good examples. The other images can be chosen as well, but they might not deliver good results. After the image appeared in the gui, click calculate.
Now a new window will open, where you have to draw a rectangle on the standardized part where the ports are. After this step, the window closes and the results will be shown in the gui.

## Using own dataset
If you want to use your own dataset, you have to consider the following tips to get useable results from the program:

* for male ports, the rotation of the port has to be exactly the same as in our given examples
* for male ports, we only detect hdmi and usb ports
* for male ports, the ports must each be held vertically and must be about 10-15cm away from the camera
* for female ports, we only support standardized computer backs like in our examples
* for female and male ports, the images must be taken in good lighting and without any rotation or distortions
* for female ports, you must be able to draw the rectangle onto the standardized part where the ports are without cutting off anything, and without distortions
