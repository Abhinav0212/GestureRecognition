function [thresholded_Image] = simple_backgroud_subtraction(Im,bgIm,isColor)
    global debug
    sigma = 2;
    G = fspecial('gaussian', 2*ceil(3*sigma)+1, sigma); 
    if(isColor==true)
        bgIm = imfilter(double(bgIm), G, 'replicate');
        Im = imfilter(double(Im), G, 'replicate');
        diff = uint8(sqrt(((Im(:,:,1)-bgIm(:,:,1)).^2)+((Im(:,:,2)-bgIm(:,:,2)).^2)+((Im(:,:,3)-bgIm(:,:,3)).^2)));
    else
        bgGrayIm = double(rgb2gray(bgIm));
        grayIm = double(rgb2gray(Im));
        diff = uint8(abs(bgGrayIm-grayIm));
    end    
    T = graythresh(diff);
    thresholded_Image = imbinarize(diff, T);
    
    if(debug==true)
        figure(1);subplot(3,3,1);imshow(bgIm/255);title('Background');
        figure(1);subplot(3,3,2);imshow(Im/255);title('Gesture');
        figure(1);subplot(3,3,3);imshow(diff);title('Difference');
        figure(1);subplot(3,3,4);imshow(thresholded_Image);title('Thresholded');
    end
end
    