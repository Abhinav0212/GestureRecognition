import java.awt.Robot;
import java.awt.event.*;
warning('off', 'signal:findpeaks:largeMinPeakHeight');
global debug;
debug = false;
mouse = Robot;
% Create the webcam object
cam = webcam;

% Capture a frame to get its size.
frame = snapshot(cam);
frameSize = size(frame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Capture the background Image after a delay to prevent complete black img
pause(2);
bgImg = (snapshot(cam));
imshow(bgImg);
pause(2);

% status = 0 : no click, status = 1 : left click, status = 2 : right click
% count is used for determining exit condition
status = 0;
count = 0;
point = [0,0];
runLoop = true;
while runLoop
    % Take an image of the current scene.
    Img = (snapshot(cam));
    
    % Get the subtracted and thresholded image.
    thresholdedImage = simple_backgroud_subtraction(Img,bgImg,true);
    
    % Perform morphological transforms and use connected components to
    % determine useful parts.
    detectedComponent = dilateAndGetLargestComponent(thresholdedImage);
    
    if(debug==true)
        showRegionProperties(detectedComponent);
        [peakSize,locations,~] = getRegionProperties(detectedComponent);
        runLoop = false;
    else
        % Get the number and location of the detected peaks and the
        % centroid of the region.
        [peakSize,locations,centroid] = getRegionProperties(detectedComponent);
        
        % Initiate the appropriate action based on the previous cursor
        % location, previous mouse state and current peaks.
        [count,status,point] = movemouse(locations,count,status,point);
        
        % Display the detected peak (fingers) and the centroid (center of
        % the hand).
        frame = insertMarker(uint8(detectedComponent*255), locations, '+', 'Color', 'red','size', 10);
        frame = insertMarker(frame, centroid, '*', 'Color', 'blue','size', 10);
        frame = flip(frame,1);
        
        % Display the detected component using the video player object.
        step(videoPlayer, frame);
        
        % Stop gesture recognition if the video player window has been
        % closed or if corresponding gesture is detected.
        runLoop = isOpen(videoPlayer);
        if(status==4)
            runLoop = false;
        end
    end
end

% Releasing all mouse clicks and the camera
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON3_MASK);
clear('cam');