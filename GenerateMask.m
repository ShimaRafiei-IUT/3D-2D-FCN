function [mask]=GenerateMask(maskIn,thre)
    newMask=maskIn;
    newMask(maskIn(:)>=thre)=1;
    newMask(maskIn(:)<=thre)=0;
    if(sum(newMask(:))==0)
        mask=zeros(size(maskIn));
        return
        
    end
    newMask=logical(newMask);
    CC = bwconncomp(newMask);
    CC=CC.PixelIdxList;
    indxMax=1;
    maxNum=-inf;
    for n=1:size(CC,2)
        if(length(CC{n})>maxNum)
            maxNum=length(CC{n});
            indxMax=n;
        end
    end
    finalIndex=CC{indxMax};
    mask=zeros(size(maskIn));
    mask(finalIndex)=1;        
 end