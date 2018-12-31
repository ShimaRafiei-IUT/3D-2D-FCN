clc;close all;clear all

addpath('/home/user/Desktop/Abdomen/NIfTI_tools/');
imageAddress='/home/nuserasr/Desktop/Abdomen/Dataset/Original/nii/RawData/Training';
index=[1:10 21:40];  %11 to 20 index are not provided in dataset
for n=index
    n
    if(n<10)
        Y22 = nii_read_volume([imageAddress '/img/img000' num2str(n) '.nii']);
        %Y22 = imrotate(Y22,90);        
        save([imageAddress '/img/img000' num2str(n) '.mat'],'Y22');
        Y2 = nii_read_volume([imageAddress '/label/label000' num2str(n) '.nii']);
        %Y2 = imrotate(Y2,90);        
		figure,imshow3D(Y2);
        save([imageAddress '/label/label000' num2str(n) '.mat'],'Y2');
        
    else
        Y22 = nii_read_volume([imageAddress '/img/img00' num2str(n) '.nii']);
        %Y22 = imrotate(Y22,90);        
        
        save([imageAddress '/img/img00' num2str(n) '.mat'],'Y22');        
        Y2 = nii_read_volume([imageAddress '/label/label00' num2str(n) '.nii']);
        %Y2 = imrotate(Y2,90);        
        
		figure,imshow3D(Y22);
        save([imageAddress '/label/label00' num2str(n) '.mat'],'Y2');
        
    end  

end





