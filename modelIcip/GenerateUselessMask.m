function [boxx]=GenerateUselessMask(boxx)
    boxx(boxx>-450)=1;
    boxx(boxx<=-450)=0;
    for s=1:size(boxx,3)
        slice=boxx(:,:,s);
        slice = imfill(slice, 'holes') ;
        boxx(:,:,s)=GenerateMask(slice,0.5);
    end    
end