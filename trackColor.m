import java.awt.*;
import java.awt.event.*;

cam = webcam('Facetime');
mouse = Robot();
%preview(cam);
debug = false;
pause(2);
i = 0;


pause(3);
count = 0;
status = 0; % no click
while(i < 600)
    tic;
    img = snapshot(cam);
    img = flip(img ,2);
    if debug
        subplot(2,3,2);
        imshow(img);
    end

    red = imsubtract(img(:,:,2), rgb2gray(img));

    G = fspecial('gaussian', 2*ceil(3*3)+1, 3);
    red = imfilter(red, G);

    red = red > 20;
    %red = imbinarize(red, 0.1);

    
    red = bwmorph(red, 'open');

    red = imfill(red, 'holes');
    [L, num] = bwlabel(red, 8);
    red = bwareaopen(L,70,8);
    [ centroids ] = getRegionProperty(red);

    if debug
        disp('Centroids are');
        disp(centroids);

        subplot(2,3,3);
        imshow(red);
        hold on
    end
    if size(centroids,1) == 1
       count = 0;
       point = [ centroids(1, 1), centroids(1, 2) ] ;
       mouse.mouseMove(point(1),point(2)); % (screen x position, screen y position)
       if status == 1
           status = 0;
           mouse.mouseRelease(InputEvent.BUTTON1_MASK);
       elseif status ==2
           status =0;
           mouse.mouseRelease(InputEvent.BUTTON3_MASK);
       end
    elseif size(centroids, 1) == 2
        count = 0;
        X = [point ; centroids(1, 1), centroids(1, 2)];
        d1 = pdist(X,'euclidean');
        X2 = [point ; centroids(2, 1), centroids(2, 2)];
        d2 = pdist(X2,'euclidean');
        if d1 < d2
            point = [ centroids(1, 1), centroids(1, 2) ] ;
            p2 = [ centroids(2, 1), centroids(2, 2) ] ;
        else
            point = [ centroids(2, 1), centroids(2, 2) ] ;
            p2 = [ centroids(1, 1), centroids(1, 2) ] ;
        end
        %d = pdist([point; p2], 'cityblock');
        if p2(1) < point(1) && p2(2) > point(2)
            click = 1;
            if status ~= 1
                mouse.mousePress(InputEvent.BUTTON1_MASK);
            end
            status = 1;
        else
            click = 2;
            if status ~= 2
                mouse.mousePress(InputEvent.BUTTON3_MASK);
            end
            status = 2;
        end
        if debug
             plot(point(1), point(2), 'rx');
             if click == 1
                plot(p2( 1), p2(2), 'g.');
             else
                plot(p2( 1), p2(2), 'b.');
             end
        end
        mouse.mouseMove(point(1),point(2)); % (screen x position, screen y position)
    elseif size(centroids,1) ==3
        count = count + 1;
        if count == 6
            break
        end
    else
       disp('Too many centroids'); 
    end
%     for index = 1:size(centroids, 1)
%         if debug
%             plot(centroids(index, 1), centroids(index, 2), 'rx');
%         end
%         mouse.mouseMove(centroids(index, 1),centroids(index, 2)); % (screen x position, screen y position)
%     end
    pause(0.00001);
    toc;
    i = i + 1;
end
%pause;
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

mouse.mousePress(InputEvent.BUTTON3_MASK);
mouse.mouseRelease(InputEvent.BUTTON3_MASK);
clear('cam');
disp('cleared cam object');