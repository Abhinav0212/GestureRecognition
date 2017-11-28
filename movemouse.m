function [count,status,point] = movemouse(centroids,count,status,point)
    global debug;
    import java.awt.Robot;
    import java.awt.event.*;
    mouse = Robot;
    
    % If there exists no points of interest then either we do nothing or
    % we reset everything to 0.
    if size(centroids,1) == 1 && all(centroids==[0,0])
        disp('No centroids');
        
    % If there is just one region of interest, move the mouse to the 
    % location of the centroid of that region. If necessary, release the 
    % left or right click event and set status to 0.
    elseif size(centroids,1) == 1
       count = 0;
       point = [ centroids(1, 1), centroids(1, 2) ] ;
       % (screen x position, screen y position)
       mouse.mouseMove(point(1),point(2)); 
       if status == 1
           status = 0;
           mouse.mouseRelease(InputEvent.BUTTON1_MASK);
       elseif status == 2
           status = 0;
           mouse.mouseRelease(InputEvent.BUTTON3_MASK);
       end
       
    % When there are two regions of interest, determine if it a right or
    % left click based on position of the newly detected region relative to 
    % the already detected region.
    elseif size(centroids, 1) == 2
        count = 0;
        % Get the distance between each of the two regions and the position
        % of the cursor in the previous frame.
        X = [point ; centroids(1, 1), centroids(1, 2)];
        d1 = pdist(X,'euclidean');
        X2 = [point ; centroids(2, 1), centroids(2, 2)];
        d2 = pdist(X2,'euclidean');
        
        % The region closer to the previous cursor is location is assumed
        % to be the already detected region and the other region to be the
        % newly detected region.
        if d1 < d2
            point = [ centroids(1, 1), centroids(1, 2) ] ;
            p2 = [ centroids(2, 1), centroids(2, 2) ] ;
        else
            point = [ centroids(2, 1), centroids(2, 2) ] ;
            p2 = [ centroids(1, 1), centroids(1, 2) ] ;
        end
        
        % If the newly detected region is to the left and below the
        % existing region (thumb and index) then the action is a left click
        % else it is a left click.
        if p2(1) < point(1) && p2(2) > point(2)
            if status ~= 1
                mouse.mousePress(InputEvent.BUTTON1_MASK);
                status = 1;
            end
        else
            if status ~= 2
                mouse.mousePress(InputEvent.BUTTON3_MASK);
                status = 2;
            end
        end
        if debug==true
             plot(point(1), point(2), 'rx');
             if status == 1
                plot(p2( 1), p2(2), 'g.');
             elseif status == 2
                plot(p2( 1), p2(2), 'b.');
             end
        end
        mouse.mouseMove(point(1),point(2)); % (screen x position, screen y position)
        
    % If there are three regions of interest detected for 6 continuous
    % iterations the stop the gesture recognition program.
    elseif size(centroids,1) == 3
        count = count + 1;
        if count == 6
            status = 4;
            disp('Exiting');
        end
     
    % More than 3 regions of interest does not have any actions associated
    % with them yet.
    else
       disp('Too many centroids');
    end
end
