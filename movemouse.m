function [count,status,point] = movemouse(centroids,count,status,point)
    global debug;
    import java.awt.Robot;
    import java.awt.event.*;
    mouse = Robot;

    if size(centroids,1) == 1 && all(centroids==[0,0])
        disp('No centroids');
    elseif size(centroids,1) == 1
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
        if debug==true
             plot(point(1), point(2), 'rx');
             if click == 1
                plot(p2( 1), p2(2), 'g.');
             elseif click == 2
                plot(p2( 1), p2(2), 'b.');
             end
        end
        mouse.mouseMove(point(1),point(2)); % (screen x position, screen y position)
    elseif size(centroids,1) ==3
        count = count + 1;
        if count == 6
            status = 4;
            disp('Exiting');
        end
    else
       disp('Too many centroids');
    end

end
