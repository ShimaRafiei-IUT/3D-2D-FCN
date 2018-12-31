clc;clear;close all;
addpath('..');
for person=1 : 6 %test index (according to the fold you 're testing on)
    load(['/home/user/Desktop/Abdomen/Dataset/Original/Train/label/label000' num2str(person) '.mat']); %load ground truth
    % load('/home/user/Desktop/Abdomen/Dataset/Original/Train/img/img0002.mat'); % loading image
     load(['/home/user/Desktop/Abdomen/Model/ModelDFCN3D/DeployFold1Label3/Validation/person__' num2str(person) '_50.mat']); %load results
    Y2(Y2~=6) = 0;
    Y2(Y2==6) = 1;
    figure,imshow3D(Y2);
	
    result=GenerateMask3D(result,0.5);
    result = imrotate(result,-90);
    result = flip(result,2);
    dice(person,1) = (2*nnz(Y2 & result))/(nnz(Y2)+nnz(result))
    figure,imshow3D(result);
   
end
mean(dice) 