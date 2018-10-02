clc;clear;close all
addpath(genpath('..'));%% addpath the whole folder to make everything available
address = './hd5/'; %where to generate hd5 dataset for network 
   
path1 = '/home/user/Desktop/FCN_abdomen/img';  %insert directory of train 
path2 = '/home/user/Desktop/FCN_abdomen/label';  %%insert dir of labels

Dir1 = dir(fullfile(path1 ,'*.mat')); %img
Dir2 = dir(fullfile(path2 ,'*.mat')); %label
box_img   =  zeros(512,512,11,50);
box_prob  =  zeros(512,512,11,50);
box_label =  zeros(512,512,1,50);

for ii =3:numel(Dir1) %.nii

	disp(Dir1(ii).name);

%% or use 'nii_read_volume(path)' to read '.nii' extension

%%      Y22 = nii_read_volume([path1 '' Dir1(ii).name]); 
%%      Y22 = Y22.img;
%%      Y2 = nii_read_volume([path2 '' Dir2(ii).name]); 
%%      Y2 = Y2.img;

%% load dataset with '.mat' extension if available

%%		load(Dir1(ii).name);
%%		load(Dir2(ii).name);
	 
     if ii>=11 
         tt= ii+10;
     else
         tt=ii;
     end
       load(['liver_' num2str(tt) '_3d.mat']);
       liver = liver/29;
%     figure,imshow3D(liver);

    Y2 = double(Y2);Y22=double(Y22);
    Y2(Y2~=6)=0;Y2(Y2==6)=1; %label of Liver in this dataset is 6 _ so binarize labels
	%%%%%%%%%%%%% preprocessing %%%%%%%%%%%%%%%
    thresh =-450;
    t=Y22(Y22 > thresh);
    mm=mean(t);
    st=std(t(:));
    Y222=double(Y22);
    Y222=(Y222-mm)/st;
    Y222(Y22 < thresh)=0;
    Y22=Y222;
    clear Y222;        
    orgI=Y22;
    orgI=double(orgI);
   %---------------------------------------------
      %%%%% the first & last slice containing liver*** 
    project = sum(sum(Y2,1),2);
    start_slice = min(find(project~=0))-2;
    end_slice = max(find(project~=0))+2; 

     %%%****************************************** 
     cnt = 1;
     while(cnt< 50)
     indx = randi([start_slice, end_slice]);
       if(indx+5 < size(Y2,3))
         box_img  (:,:,:,cnt) = orgI(:,:,indx-5:indx+5);
         
       
         box_label(:,:,1,cnt) = Y2(:,:,indx);
         
         box_prob (:,:,:,cnt) = liver(:,:,indx-5:indx+5);
         cnt = cnt+1;
       end%if
       
     end%while
%  figure,imshow3D(box_prob(:,:,:,1));     
%  figure,imshow3D(box_label(:,:,:,1));   
%  figure,imshow3D(box_img(:,:,:,1));   
   
        box_img = single(box_img);
        box_label= single(box_label);
        box_prob = single(box_prob);
        h5create([address 'person' num2str(tt)  '.h5'],'/Reg'  ,[512 512 11 50],'Datatype','single');
        h5create([address 'person' num2str(tt)  '.h5'],'/label',[512 512 1  50],'Datatype','single');
        h5create([address 'person' num2str(tt)  '.h5'],'/IM'   ,[512 512 11 50],'Datatype','single');     

        h5write([address 'person' num2str(tt) '.h5'], '/Reg'  ,box_prob ,[1 1 1 1] ,[512 512 11 50]);
        h5write([address 'person' num2str(tt) '.h5'], '/label',box_label,[1 1 1 1] ,[512 512 1 50]);
        h5write([address 'person' num2str(tt) '.h5'], '/IM'   ,box_img  ,[1 1 1 1] ,[512 512 11 50]);

%*************************************************** 

 end%ii


        
