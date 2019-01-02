function [weight]=ComputeDistancFromBordereWeight3D(patch)
    %patch is binary patch, formula of weight is 20*exp(-d^2/(2*3^2))
    weight=zeros(size(patch));
      
    SE=ones(3,3,1);
    border=patch-imerode(patch,SE); %extract border
    distance=0;
    delta=5;
	%to give weights to pixels based on their distance to borders
    while(distance<50) 
        x=5*exp(-distance^2/(2*delta^2));
        weight(weight==0 & border==1)=x; 
        border=imdilate(border,SE);        
        distance=distance+1;
    end
    weight=weight+0.5; 

end