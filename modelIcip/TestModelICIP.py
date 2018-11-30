import numpy as np
import scipy.io
#import matplotlib.pyplot as plt
import sys
import time
caffe_root = '/usr/local/caffe/'  # this file is expected to be in {caffe_root}/examples
sys.path.insert(0, caffe_root + 'python')
import caffe
#from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from PIL import Image
#import scipy.misc.imresize

from os import listdir
from os.path import isfile, join
import PIL
import Image
    
caffe.set_device(0)
caffe.set_mode_gpu()
curSlice=107+39
for deploy in [9,12,14,24,26,36,45,63]:
# [6,9,10,13,14,19,23,32,33,63,77,84]: 
    directoryAddress='/home/nasr/Desktop/Abdomen/Dataset/Original/Train/img/'
    print "start -----------------"
    
    net =  caffe.Net('/home/nasr/Desktop/Abdomen/Model/ModelICIP/deploy_BN.prototxt','/home/nasr/Desktop/Abdomen/Model/ModelICIP/DeployFold3Label6/deploy'+str(deploy)+'k.caffemodel', caffe.TEST)
    fileList = [f for f in listdir(directoryAddress) if isfile(join(directoryAddress, f))]
    for person in  range(7,13): 
        print "person=",person
        tempMat=scipy.io.loadmat(directoryAddress+'img000'+str(person)+'.mat' )
        im=tempMat['Y22']
        temp=im[im>-450]
        meanTemp=np.mean(temp)
        stdTemp=np.std(temp)
        im[im<-450]=meanTemp
        im=(im-meanTemp)/stdTemp
        maxSlice=im.shape[2]
        
        allSlice=np.zeros((512,512,maxSlice+36))
        allSlice[:,:,18:maxSlice+18]=im
        curSlices=np.zeros((1,38,512,512))
        #result=np.zeros((512,512,maxSlice))
        curSlice2D=np.zeros((1,1,512,512))

        result=np.zeros((64,64,maxSlice))
        
        for slice in range(1,im.shape[2]-2):
            print slice,'_',deploy
            for n in range(0,38):
                t=allSlice[:,:,slice+n]
                t=t.transpose(1,0)
                curSlices[0,n,:,:]=t

            net.blobs['cropSlice'].data[...] = curSlices
            t2=allSlice[:,:,slice+18]
            t2=t2.transpose(1,0)
            curSlice2D[0,0,:,:]=t2
            net.blobs['CurSlice'].data[...] = curSlice2D

            net.forward()    
            #score= net.blobs['prob'].data  
            score= net.blobs['FCN_C1'].data  
            
            #result[:,:,slice]=score[0,1,:,:]
            result[:,:,slice]=score[0,1,8,:,:]
            #if(slice>80):
            #    break;
        scipy.io.savemat('./Deploy/person'+str(person)+'_'+str(deploy)+'.mat', mdict={'result': result})


            

     
         
        
    
    
