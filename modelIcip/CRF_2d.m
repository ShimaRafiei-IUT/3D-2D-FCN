clc;close all; clear;
addpath(genpath('D:\matlab_recycle\tez'));
tic
load('img0001.mat');%Y22 loaded as an original image or read it by .nii libs
% Y22 = readpath('img0001.nii'); 
Y22=double(Y22)/255;

load('label0001.mat'); %Y2 loaded as a ground truth
grt3d = Y2;grt3d(grt3d~=6)=0;grt3d(grt3d==6)=1;% 3 is label of organ

probName = 'person1_54.mat';%name of the network result 
prob3d = load(probName);
cell_cat=struct2cell(prob3d);
prob3d=cell2mat(cell_cat);%prob of organ
prob3d_backup = prob3d;
prob3d(prob3d>=0.5) = 1;
prob3d(prob3d<0.5) = 0;
CC = bwconncomp(prob3d, 26);    
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW = zeros(size(prob3d));
BW(CC.PixelIdxList{idx}) = 1;
prob3d = prob3d_backup .* BW;
prob3d = imrotate(prob3d,90);
prob3d = flip(prob3d,1);
mask = prob3d; mask(mask<0.5)=0;mask(mask>=0.5)=1;
dice = 2*nnz(mask & grt3d)/(nnz(mask) + nnz(grt3d))%dice after RG
% %figure,imshow3D(prob3d);
%%%%%%%%%%%% cutting the box around %%%%%%%%%%%%%%%%%%%%
[~,SingleBOX,X_min,X_max, Y_min,Y_max , Z_min,Z_max] = giveFitedBox(prob3d); %not whole body but a box 
Y22    =  Y22(X_min:X_max, Y_min:Y_max , Z_min:Z_max); %img cutting
prob3d =  prob3d(X_min:X_max , Y_min:Y_max  , Z_min:Z_max); %prob cutting
grt3d  =  grt3d(X_min:X_max , Y_min:Y_max  , Z_min:Z_max);%grt cutting
labels3d = mask;%initial labeling
%dice = 2*nnz(mask & grt3d)/(nnz(mask) + nnz(grt3d))%dice after RG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 for indz = 1 :  size(Y22,3) %slices
    
    disp(indz);
    img = Y22(:,:,indz);
   

    prob = prob3d(:,:,indz);

    unary = (prob);% .^0.1);
    %figure,imshow(unary);
    labels = labels3d(:,:,indz);
    grt = grt3d(:,:,indz);
    grad = imgradient(img); 
    grad(grad<1)=0;
%     imshow(grad);
%% first QF & QB , QF+QB=1 is checked 
    ForeProb = exp(unary); BackProb = exp(1-unary);
    %figure,imshow(ForeProb,[]);
    %figure,imshow(BackProb,[]);
    QB = BackProb./(ForeProb+BackProb);QF = ForeProb./(ForeProb+BackProb);%%normalization of Qs
    %figure,imshow(QB,[]);
    %figure,imshow(QF,[]);
    
    margin = 5;%neighbourhood size
    pos = zeros(2*margin+1,2*margin+1);
    for m=-margin:margin %matrix of distance
        for n=-margin:margin
            pos(m+margin+1,n+margin+1)= m^2+n^2;%euclidean distance
        end
    end  
    P  = pos ;

    for iter=1 :5 %iteration 0-10
        for i=1: size(img,1)%each pixel
            for j=1 :size(img,2)

              if( i+margin+15>=size(img,1)|| j+margin+15>=size(img,2)|| i-margin-15<1 || j-margin-15<1)
                      continue;
              end
              
              
              [QFOut, QBOut] = Bilaterl_Energy2d(unary,img,labels,P,i,j,QF,QB,margin,grad);%Fore & background energy
                
                QF(i,j) = QFOut;
                QB(i,j) = QBOut;
                
                if(QB(i,j) > QF(i,j) && labels(i,j)==1)
                   labels(i,j)=0;
                   
                elseif(QB(i,j)<QF(i,j) && labels(i,j)==0)
                    labels(i,j)=1;  
                   
                end
            end
        end 

        ALLlabel(:,:,indz,iter) = labels;
    end%iter
end %indz
    lastlabel = ALLlabel(:,:,:,4);
    figure,imshow3D(lastlabel);
    dice = 2*nnz(lastlabel & grt3d)/(nnz(lastlabel) + nnz(grt3d));%dice after RG
    dice = dice*100;
    fprintf('\n%.2f\n',dice);
    toc
%     save(''