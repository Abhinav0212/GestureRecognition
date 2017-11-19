function[] = showRegionProperties(Im)
    colormap('gray');
    figure(1);subplot(3,3,8);imshow(Im);title('Region Properties');
    regionProperties = regionprops('table',Im,'Area','Centroid','BoundingBox');
    objectRegions = find(regionProperties.Area > 0);
    hold on;
    % Get the area, boundary and centroid for all regions in the image
    for i=1:size(objectRegions)
        objReg = regionProperties(objectRegions(i),:);
        plot(objReg.Centroid(1),objReg.Centroid(2),'r.');
        rectangle('Position',[objReg.BoundingBox(1),objReg.BoundingBox(2),objReg.BoundingBox(3),objReg.BoundingBox(4)],'EdgeColor','r','LineWidth',2 );
        text(objReg.BoundingBox(1)+1,objReg.BoundingBox(2)+5,sprintf('Area: %g',objReg.Area),'Color','r');
        text(objReg.Centroid(1)+1,objReg.Centroid(2)+5,sprintf('Centroid: (%g,%g)',objReg.Centroid(1),objReg.Centroid(2)),'Color','r');
    end
    hold off;
end