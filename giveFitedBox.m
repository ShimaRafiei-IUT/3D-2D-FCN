function [mask3d,SingleBOX,X_min,X_max, Y_min,Y_max , Z_min,Z_max] = giveFitedBox(box)
    %mask3d is one & zero
    %SingleBOX is real box
    X_P = sum(sum(box,2 ),3);%project on x 
    X_P = (X_P ~=0);
    [X_min, ~]=find(X_P,1,'first');
    [X_max, ~]=find(X_P,1,'last');
    
    if(isempty(X_min))     
        disp('null hapened');
        return;
    end

    Y_P = sum(sum( box,1 ),3);%project on y
    Y_P = (Y_P(:) ~=0);
    [Y_min, ~]=find(Y_P,1,'first');
    [Y_max, ~]=find(Y_P,1,'last');

    Z_P = sum(sum( box,1 ),2);%project on z
    Z_P = (Z_P(:) ~=0);
    [Z_min, ~]= find(Z_P,1,'first');
    [Z_max, ~]= find(Z_P,1,'last');
    %%%%%%%%%%saving%%%%%%%%%%
    
   SingleBOX = box(X_min:X_max, Y_min:Y_max , Z_min:Z_max);
   box(X_min:X_max, Y_min:Y_max , Z_min:Z_max) = 1;
   mask3d = box;
end