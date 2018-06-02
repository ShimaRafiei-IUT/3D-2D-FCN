import copy
import numpy as np
#import matplotlib.pyplot as plt
import sys
caffe_root = '/usr/local/caffe/'  # this file is expected to be in {caffe_root}/examples
sys.path.insert(0, caffe_root + 'python')
import caffe
from PIL import Image
import scipy.io




    
caffe.set_device(0)
caffe.set_mode_gpu()
solver1 = caffe.SGDSolver('./solver_PFCN.prototxt')
solver1.step(1)
########################################################33
ww=solver1.net.params['deconv1'][0].data
temp=ww[0,0,:,:].copy()
ww[...]=0
for n in range(ww.shape[0]):
    ww[n,n,:,:]=temp
solver1.net.params['deconv1'][0].data[...]=ww

ww=solver1.net.params['deconv2'][0].data
ww[...]=0
for n in range(ww.shape[0]):
    ww[n,n,:,:]=temp
solver1.net.params['deconv2'][0].data[...]=ww


ww=solver1.net.params['deconv3'][0].data
ww[...]=0
for n in range(ww.shape[0]):
    ww[n,n,:,:]=temp
solver1.net.params['deconv3'][0].data[...]=ww


ww=solver1.net.params['deconv4'][0].data
ww[...]=0
for n in range(ww.shape[0]):
    ww[n,n,:,:]=temp
solver1.net.params['deconv4'][0].data[...]=ww

ww=solver1.net.params['deconv5'][0].data
ww[...]=0
for n in range(ww.shape[0]):
    ww[n,n,:,:]=temp
solver1.net.params['deconv5'][0].data[...]=ww





solver1.step(1)



for n in range(100000):
  solver1.net.save("./DeployFold4/deploy"+str(n)+"k.caffemodel")
  solver1.step(1000)








                            
                        
            

        
    
    
