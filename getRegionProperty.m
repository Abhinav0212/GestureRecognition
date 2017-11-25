function[ centroids ] = getRegionProperty(Im)
    regionProperties=regionprops(Im,'centroid');
    
    if size(regionProperties,1) > 0   
        centroids = cat(1, regionProperties.Centroid);
        %centroids = regionProperties.Centroid;   
    else
        centroids = [0 0];
    end
end
        
    