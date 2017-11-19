function [] = movemouse(peakSize)
    import java.awt.Robot;
    import java.awt.event.*;
    mouse = Robot;

    if peakSize==1
        
    elseif peakSize==2
        mouse.mousePress(InputEvent.BUTTON1_MASK); %left click
        mouse.mouseRelease(InputEvent.BUTTON1_MASK); %release left button for the click to complete
        
    elseif peakSize==3
    end

end