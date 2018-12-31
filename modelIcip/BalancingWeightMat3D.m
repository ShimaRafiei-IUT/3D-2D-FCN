function [BalancedWeight]=BalancingWeightMat3D(weight,rawData)
    uselessMask=GenerateUselessMask(rawData);   
    BalancedWeight=weight.*uselessMask;
    BalancedWeight(uselessMask==0)=0.01;
end
