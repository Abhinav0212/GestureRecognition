warning('off', 'signal:findpeaks:largeMinPeakHeight');
global debug
debug = false;
% Create the webcam object
cam = webcam;

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

pause;
bgImg = (snapshot(cam));
imshow(bgImg);
pause;

runLoop = true;

while runLoop
    Img = (snapshot(cam));
    thresholdedImage = simple_backgroud_subtraction(Img,bgImg,true);
    detectedComponent = dilateAndGetLargestComponent(thresholdedImage);
    if(debug==true)
        showRegionProperties(detectedComponent);
        runLoop = false;
        [peakSize,locations,~] = getRegionProperties(detectedComponent);
        disp(peakSize);
    else
        [peakSize,locations,centroid] = getRegionProperties(detectedComponent);
        movemouse(peakSize);
        videoFrame = insertMarker(uint8(detectedComponent*255), locations, '+', 'Color', 'red','size', 10);
        videoFrame = insertMarker(videoFrame, centroid, '*', 'Color', 'blue','size', 10);
        videoFrame = flip(videoFrame,1);
        % Display the detected component using the video player object.
        step(videoPlayer, videoFrame);
        % Check whether the video player window has been closed.
        runLoop = isOpen(videoPlayer);
    end
end
clear('cam');