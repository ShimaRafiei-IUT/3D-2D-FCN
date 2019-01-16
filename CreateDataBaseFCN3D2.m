clc ;close all;clear all


imageAddress='./Dataset/Original/Train'; %change this path to refer to train dataset
totalPerson=30;

%%-----------read all file name (if you have folded your data e.g. folds for trains)------
     dirData = dir([imageAddress '/img/']);       
     dirIndex = [dirData.isdir];     
     fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files    
     for n=1:numel(fileList)
        fileName=fileList{n};
        fileName = strsplit(fileName,'img');
        fileList{n}=fileName{2};
     end

%%-----------------------------------


for foldNum=1:1
     address='./Dataset/DataBaseFCN3D2/'; %%create this folder

    %% -----------    
    for n=1:30
        
        fileList{n}
        fileName=[imageAddress '/img/img' fileList{n}];         
        load(fileName)
        fileName=[imageAddress '/label/label' fileList{n}];         
        load(fileName)
        personIndex = strsplit(fileList{n},'.');personIndex=personIndex{1};
        personIndex=str2num(personIndex)

        
        
        Y22=double(Y22);
       % Y22=imresize(Y22,0.25);
        
      %  Y2=imresize(Y2,0.25,'nearest');
        Y2=double(Y2);        

   
        Y2(Y2~=6)=0;
        Y2(Y2==6)=1;
        weightY2=ComputeDistancFromBordereWeight3D(Y2);
        weightY2=BalancingWeightMat3D(weightY2,Y22);
        
        thresh =-450;
        t=Y22(Y22>thresh);
        mm=mean(t);
        st=std(t(:));
        Y222=double(Y22);
        Y222=(Y222-mm)/st;
        Y222(Y22<thresh)=0;
        Y22=Y222;
        clear Y222;        
        orgI=Y22;
        orgI=double(orgI); 

        index=sum(Y2,1);
        index=sum(index,2);
        index=index(:);
        [index ~]=find(index>0);
        startSlice=min(index);endSlice=max(index);
        z=startSlice:endSlice;
        Y22=single(Y22);
        Y2=single(Y2);
        z=single(z(:));
        top=max(z);
        bottom=min(z);
        while(1)
            if(top-bottom)==84  % the largest Liver is not contain more than 84 slices
                break;
            end
            if(top<size(Y2,3))
                top=top+1;
            end
            if(top-bottom)==84
                break;
            end
            if(bottom>1)
                bottom=bottom-1;
            end
        end
        Y2=Y2(:,:,bottom:top);
        Y22=Y22(:,:,bottom:top);
        weight=single(weightY2(:,:,bottom:top));
        
        z=z-bottom+1;
        zz=zeros(100,1);
        zz(1:numel(z))=z;
        zz=zz(:);
            
        size(Y2)

        
        system(['rm ' address 'person' num2str(n) '.h5']);
        
        h5create([address 'person' num2str(n) '.h5'],'/locationMax',[1 1],'Datatype','single');     
        h5create([address 'person' num2str(n) '.h5'],'/location',[100 1],'Datatype','single');     
        h5create([address 'person' num2str(n) '.h5'],'/Label',[512 512 size(Y2,3) 1 ],'Datatype','single');
        h5create([address 'person' num2str(n) '.h5'],'/Slice',[512 512 size(Y2,3) 1 ],'Datatype','single');     
        h5create([address 'person' num2str(n) '.h5'],'/Weight',[512 512 size(Y2,3) 1 ],'Datatype','single');     
             
        h5write([address 'person' num2str(n) '.h5'], '/locationMax',single(numel(z)),[ 1 1],[1 1]);
        h5write([address 'person' num2str(n) '.h5'], '/location',single(zz),[ 1 1],[100 1]);
        h5write([address 'person' num2str(n) '.h5'], '/Label',Y2,[1 1 1  1],[ 512 512 size(Y2,3)  1 ]);
        h5write([address 'person' num2str(n) '.h5'], '/Slice',Y22,[1 1 1 1],[512 512 size(Y2,3)  1]);
        h5write([address 'person' num2str(n) '.h5'], '/Weight',weight,[1 1 1 1],[512 512 size(Y2,3)  1]);
        
    end
    
    
end
