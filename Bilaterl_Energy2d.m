%unary ,img ,label,i,j,
%QF---> QF_prob,QB --> Background_prob
%margin is dimension of ROI(neighbourhood), grad is gradient
function [QFOut, QBOut] = Bilaterl_Energy2d(unary,img,labels,P,i,j,QF,QB,margin,grad) 
    
    alpha = 0.01;
    beta = 20;%should be more than 10
    gama = 20;
    w1 = 2;
    w2 = 0.5;

    Q_F = QF( (i - margin : i + margin) , (j-margin : j + margin) );%10x10 neighbours;
    Q_B = QB( (i - margin : i + margin) , (j-margin : j + margin) );%10x10 neighbours;
    %    figure,imshow(Q_F,[]);
    neighbour = img( (i - margin : i + margin) , (j-margin : j + margin) );%10x10 neighbours

    labell = labels((i - margin : i + margin) , (j-margin : j + margin));%10x10 labels   
    Iij = img(i,j);

%%%%%%%%%%%%%% Intensity %%%%%%%%%%%%%    
    I = Iij .*ones(size(neighbour));
    I = ((I-neighbour).^2);

%%%%%%%%%%%%%% Energy %%%%%%%%%%%%%   
    k =  w1*exp(-I/(2*alpha) - P/(2*beta) )+ w2*exp( -P/(2*gama));%+ exp(-textr/10000);%;%
    
%%%%% Message passing from all Xj to all Xi %%%%%%%%%%%%%
    Qmad_F = k .* Q_F;
    Qmad_B = k .* Q_B;
    
%%%%%%%%%%%%%%%% compatibility transform %%%%%%%%%%%%%%
    Qhat_B = sum(sum( (ones(2*margin+1,2*margin+1)-labell).* Qmad_B  )); %l=0 penalty for background
    Qhat_F = sum(sum( labell.* Qmad_F  )); %l=1 penalty for foregrounds
   % figure,imshow(ForeEnergy,[]);
    
%%%%%%%%%%%%%%%%%% local update %%%%%%%%%%%%%%%%%%%%    
    QFOut = exp(unary(i,j)- Qhat_B);
    QBOut = exp(1-unary(i,j)- Qhat_F);
%%%%%%%%%%%%%%%%%% normalization %%%%%%%%%%%%%%%%%%%%  
    temp =  QFOut./(QFOut+QBOut);
    QBOut = QBOut./(QFOut+QBOut);
    QFOut = temp;
% sum(sum(QFOut))
end