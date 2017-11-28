import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;
cam = webcam('Facetime');
%preview(cam);
global debug;
debug = true;
pause(2);
i = 0;

pause(3);
count = 0;
status = 0; % no click
point = [0,0];
while(i < 100)
    tic;
    img = snapshot(cam);
    img = flip(img ,2);

    red = imsubtract(img(:,:,2), rgb2gray(img));

    G = fspecial('gaussian', 2*ceil(3*3)+1, 3);
    filtered_red = imfilter(red, G);

    thresholded_red = filtered_red > 20;
    %red = imbinarize(red, 0.1);
    
    morphed_red = bwmorph(thresholded_red, 'close');
    morphed_red = imfill(morphed_red, 'holes');
    
    [L, num] = bwlabel(morphed_red, 8);
    largeComponents_red = bwareaopen(L,70,8);
    [ centroids ] = getRegionProperty(largeComponents_red);
 
    if (debug==true)
        disp('Centroids are');
        disp(centroids);
        
        subplot(2,2,1);
        imshow(img);
        subplot(2,2,2);
        imshow(red);
        subplot(2,2,3);
        imshow(thresholded_red);
        subplot(2,2,4);
        imshow(largeComponents_red);
    end
    
    [count,status,point] = movemouse(centroids,count,status,point);
    if(status==4)
        break;
    end
    pause(0.00001);
    toc;
    i = i + 1;
end
%pause;
% mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
% mouse.mousePress(InputEvent.BUTTON3_MASK);
mouse.mouseRelease(InputEvent.BUTTON3_MASK);
clear('cam');
disp('cleared cam object');