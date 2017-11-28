function[peakSize, locations, centroid] = getRegionProperties(Im)
    global debug;
    % Get all properties and boundaries of regions in the image.
    regionProperties=regionprops(Im,'all');
    boundaries = bwboundaries(Im,'noholes');
    
    peakSize = 0;
    locations = [0 0];
    centroid = [0 0];
    
    for k =1:length(boundaries)
        % Set the peak offset to approx 1.5 - 2 the centroid.
        % TODO - Use something else instead of peak offset.
        centroid = regionProperties.Centroid;
        peakOffset = 1.85*centroid(:,2);
        
        % Get the x and y coords of the boundary points of the region
        boundary = boundaries{k};
        boundaryX = boundary(:,2);
        boundaryY = boundary(:,1);
        
        % Find the peaks and their locations along the y axis
        [peaks,indices] = findpeaks(boundaryY,'minpeakheight',peakOffset);
        peakSize = size(peaks,1);
        locations = [boundaryX(indices),peaks];
        
        % Plot the boundary of the detected region (hand), its centroid and
        % the detected peaks (fingers).
        if(debug==true)
            disp(peakSize);
            figure(1);subplot(3,3,9);imshow(Im);title('Finger detections');
            hold on
            plot(boundaryX, boundaryY, 'b', 'LineWidth', 1);
            plot(centroid(:,1),centroid(:,2), '+');
            plot(boundaryX(indices),peaks,'rv','MarkerFaceColor','r','lineWidth',1);
            hold off
        end
    end
    
end