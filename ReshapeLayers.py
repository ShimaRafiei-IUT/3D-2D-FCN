import numpy as np
import sys


caffe_root = '/usr/local/caffe/'  # this file is expected to be in {caffe_root}/examples
sys.path.insert(0, caffe_root + 'python')

import caffe
sys.path.insert(0, caffe_root)
import yaml
import copy
import skimage.measure

#===========================================================================================      
class CropSlice(caffe.Layer):
    def setup(self, bottom, top):
        if len(bottom) == 100:
            raise Exception("Need one ...inputs to compute distance.")

    def reshape(self, bottom, top): 
        sizeInput=bottom[0].data.shape[3]
        
        top[0].reshape(1,38,sizeInput,sizeInput)#--for cropSlice
        top[1].reshape(1,1,sizeInput,sizeInput)#--for croplabel
        top[2].reshape(1,1,sizeInput,sizeInput)#--for CurSlice
        top[3].reshape(1,1,sizeInput,sizeInput)#--for weight

   
    def forward(self, bottom, top):
        top[0].data[...]=0
        percent=bottom[2].data[0,:]        
        self.indexSlice=np.random.randint(0,85)
            
        
        startBot=self.indexSlice-18
        endBot=self.indexSlice+19+1
        startTop=0
        endTop=38
        if(startBot<0):
            startTop=startTop-startBot
            startBot=0
        if(endBot>85):
            endTop=endTop-(endBot-85)
            endBot=85

        
        top[0].data[:,int(startTop):int(endTop),:,:]=bottom[0].data[:,int(startBot):int(endBot),:,:]
        ss=self.indexSlice
        
        top[1].data[...]=bottom[1].data[:,int(ss),:,:]#--for croplabel
        top[2].data[...]=bottom[0].data[:,int(ss),:,:]#--for CurSlice
        top[3].data[...]=bottom[2].data[:,int(ss),:,:]#for weight
       # top[4].data[...]=bottom[0].data[:,int(ss)-2:int(ss)+3,:,:]#for DFCN
        

            
            
    def backward(self, top, propagate_down, bottom):
        pass


#===========================================================================================      
class BalanceLayer(caffe.Layer):
    def setup(self, bottom, top):
        if len(bottom) == 100:
            raise Exception("Need one ...inputs to compute distance.")

    def reshape(self, bottom, top):       
        top[0].reshape(bottom[0].shape[0],bottom[0].shape[1],bottom[0].shape[2],bottom[0].shape[3]) 
    def forward(self, bottom, top):
        top[0].data[...]=bottom[0].data 
    def backward(self, top, propagate_down, bottom):
        #print "size weight =",bottom[1].data.shape
        #print "size diff bottom =",bottom[0].diff.shape
        #print "size diff top =",top[0].diff.shape
        bottom[0].diff[0,0,:,:]=np.multiply(top[0].diff[0,0,:,:],(bottom[1].data)) 
        bottom[0].diff[0,1,:,:]=np.multiply(top[0].diff[0,1,:,:],(bottom[1].data) )
        #bottom[0].diff[...]=top[0].diff;    

#===========================================================================================      
class Convert3DTo2D(caffe.Layer):
    def setup(self, bottom, top):
        if len(bottom) == 100:
            raise Exception("Need one ...inputs to compute distance.")

    def reshape(self, bottom, top):       
        top[0].reshape(bottom[0].shape[0],bottom[0].shape[1],bottom[0].shape[3],bottom[0].shape[4])
 
    def forward(self, bottom, top):
        top[0].data[...]=bottom[0].data[:,:,int(np.floor(bottom[0].shape[2]/2)),:,:]
 
    def backward(self, top, propagate_down, bottom):
        bottom[0].diff[:,:,int(np.floor(bottom[0].shape[2]/2)),:,:]=top[0].diff
#===========================================================================================      
class Convert2DTo3D(caffe.Layer):
    def setup(self, bottom, top):
        if len(bottom) == 100:
            raise Exception("Need one ...inputs to compute distance.")

    def reshape(self, bottom, top):       
        top[0].reshape(bottom[0].shape[0],1,bottom[0].shape[1],bottom[0].shape[2],bottom[0].shape[3])
 
    def forward(self, bottom, top):
        top[0].data[:,0,:,:,:]=bottom[0].data[:,:,:,:]
 
    def backward(self, top, propagate_down, bottom):
        pass
#===========================================================================================      

class Pooling3D(caffe.Layer):
    def setup(self, bottom, top):
        if len(bottom) == 100:
            raise Exception("Need one ...inputs to compute distance.")

    def reshape(self, bottom, top):       
        top[0].reshape(bottom[0].shape[0],bottom[0].shape[1],bottom[0].shape[2]/2,bottom[0].shape[3]/2,bottom[0].shape[4]/2)
 
    def forward(self, bottom, top):
        top[0].data[...]=skimage.measure.block_reduce(bottom[0].data, (1,1,2,2,2), np.max)
        test=top[0].data.repeat(2, axis=2).repeat(2, axis=3).repeat(2, axis=4)
        self.mask = np.equal(test, bottom[0].data).astype(int)
 
    def backward(self, top, propagate_down, bottom):
        bottom[0].diff[...]=np.multiply(top[0].diff.repeat(2, axis=2).repeat(2, axis=3).repeat(2, axis=4),self.mask)
                                        
#===========================================================================================      
#===========================================================================================      
class CropCenterSlice(caffe.Layer):
    def setup(self, bottom, top):
        if len(bottom) == 100:
            raise Exception("Need one ...inputs to compute distance.")

    def reshape(self, bottom, top):       
        top[0].reshape(bottom[0].shape[0],1,bottom[0].shape[2],bottom[0].shape[3])
 
    def forward(self, bottom, top):
        top[0].data[...]=bottom[0].data[:,int(np.floor(bottom[0].shape[1]/2)),:,:]
 
    def backward(self, top, propagate_down, bottom):
        bottom[0].diff[:,int(np.floor(bottom[0].shape[1]/2)),:,:]=top[0].diff



