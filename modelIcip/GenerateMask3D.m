
function [mask]=GenerateMask3D(maskIn,thre)
    newMask=maskIn;
    newMask(maskIn(:)>=thre)=1;
    newMask(maskIn(:)<=thre)=0;
    newMask=logical(newMask);
    CC = bwconncomp(newMask,26);
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
    
    
    
%    for i=1:size(mask,3)
%         tempMask=mask(:,:,i);
%         if(sum(tempMask(:))==0)
%             continue
%         end
%         CC = bwconncomp(tempMask,4);
%         CC=CC.PixelIdxList;
%         indxMax=1;
%         maxNum=-inf;
%         for n=1:size(CC,2)
%             if(length(CC{n})>maxNum)
%                 maxNum=length(CC{n});
%                 indxMax=n;
%             end
%         end
%         finalIndex=CC{indxMax};
%         tempMask=zeros(size(tempMask));
%         tempMask(finalIndex)=1; 
%         mask(:,:,i)=tempMask;
%    end
 end