import java.awt.Robot;
import java.awt.event.*;
global debug;
debug = true;

% Create the webcam object
mouse = Robot;
cam = webcam('Facetime');

pause(2);

% status = 0 : no click, status = 1 : left click, status = 2 : right click
% count is used for determining exit condition
status = 0;
count = 0;
point = [0,0];
i = 0;

while(i < 100)
    tic;
    % Take a snapshot of the current frame and flip the image ?
    img = snapshot(cam);
    img = flip(img ,2);
    
    % Subtract the colored component of the image and filter it.
    % Crrently using the green component of the image.
    subtracted_img = imsubtract(img(:,:,2), rgb2gray(img));
    G = fspecial('gaussian', 2*ceil(3*3)+1, 3);
    filtered_img = imfilter(subtracted_img, G);
    
    % Threshold and morph the image.
    thresholded_img = filtered_img > 20;
    morphed_img = bwmorph(thresholded_img, 'close');
    morphed_img = imfill(morphed_img, 'holes');
    
    % Obtain the centroid of the large regions in the image
    [L, num] = bwlabel(morphed_img, 8);
    large_components_img = bwareaopen(L,70,8);
    [ centroids ] = getRegionProperty(large_components_img);
    
    % Display images for debugging
    if (debug==true)
        disp('Centroids are');
        disp(centroids);
        subplot(2,2,1);
        imshow(img);
        subplot(2,2,2);
        imshow(subtracted_img);
        subplot(2,2,3);
        imshow(thresholded_img);
        subplot(2,2,4);
        imshow(large_components_img);
    end
    
    % Initiate the appropriate action based on the previous cursor
    % location, previous mouse state and current detected regions.
    [count,status,point] = movemouse(centroids,count,status,point);
    
    % Stop gesture recognition if corresponding gesture is detected.
    if(status==4)
        break;
    end
    
    pause(0.00001);
    toc;
    i = i + 1;
end

% Releasing all mouse clicks and the camera
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON3_MASK);
clear('cam');
disp('cleared cam object');