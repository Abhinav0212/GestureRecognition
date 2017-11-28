function[peakSize, locations, centroid] = getRegionProperties(Im)
    global debug
    regionProperties=regionprops(Im,'all');
    boundaries = bwboundaries(Im,'noholes');
    peakSize = 0;
    locations = [0 0];
    centroid = [0 0];
  
    for k =1:length(boundaries)
        centroid = regionProperties.Centroid;
        peakOffset = 1.85*centroid(:,2);
        boundary = boundaries{k};
        boundaryX = boundary(:,2);
        boundaryY = boundary(:,1);
        
        [peaks,indices] = findpeaks(boundaryY,'minpeakheight',peakOffset);
        peakSize = size(peaks,1);
        locations = [boundaryX(indices),peaks];
        if(debug==true)
            figure(1);subplot(3,3,9);imshow(Im);title('Finger detections');
            hold on
            plot(boundaryX, boundaryY, 'b', 'LineWidth', 1);
            plot(centroid(:,1),centroid(:,2), '+');
            plot(boundaryX(indices),peaks,'rv','MarkerFaceColor','r','lineWidth',1);
            hold off
        end
    end
    
end