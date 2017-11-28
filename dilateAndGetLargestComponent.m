function[flipped_Image] = dilateAndGetLargestComponent(Image)
    global debug
    % perform morphological operations to improve the image.
    dilated_Image = bwmorph(Image, 'close');
    filled_Image = imfill(dilated_Image, 'holes');
    
    % Get the connected component details and obtain the largest component.
    [L, num] = bwlabel(filled_Image, 8);
    hist_counts = histcounts(L,1:num);
    max_count = max(hist_counts);
    largest_comp = bwareaopen(L,max_count,8);
    
    % Flip the image for future computation (peak finding).
    flipped_Image = flip(largest_comp,1);
    
    % Diplay the morphed image, largest component and flipped image.
    if(debug==true)
        figure(1);subplot(3,3,5);imshow(filled_Image);title('Morphed Image');
        figure(1);subplot(3,3,6);imshow(largest_comp);title('Largest Component');
        figure(1);subplot(3,3,7);imshow(flipped_Image);title('Flipped Image');
    end
end