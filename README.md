# 3D to 2D FULLY Convoltional Network For Medical Organ (e.g. Liver) Segmentation. 
The code, related to liver segmentation in abdominal CT scans, is provided here. 3D-2D-FCN [1] is implemented on "caffe" framework; thus, your system requires "caffe" framework as prerequisite to run this project.

You may follow these steps:

First, Download abdominal CT scans from https://www.synapse.org/ (just 30 train images & their labels). These have .nii extension, just extract them if they are ziped. Name them as their ziped name to preserve their sequence (img0001.nii.gz -> img0001.nii).
You'd better to change all .nii scans to .mat to work with them easily just by loading them in matlab every time you want to investigate a scan (e.g. showing them with imshow3D.m, enhancing and saving them again etc.), for this purpose I provided a code for converting .nii to .mat and showing scans by imshow3D.m .

Second, run "CreateDataBase3D2.m" in matlab to load the dataset and create it in hd5 format, to be prepared for network training. please change the first part of code when you want to load scans from a folder according to your code style. 

Third, run "TrainModel.py" to start network training on the python platform.

Next, run "TestModel.py" to test the network under python platform.

Last, run CRF_2d.m in matlab to perform conditional random field [2] for enhancing the segmented masks and finally check your result with dice_score.m . 


In this project, some of the implemented layers of FCN like center selector and 3D pooling layers, are available in "ReshapeLayers.py".


[1] Rafiei, S., Nasr-Esfahani, E., Najarian, K., Karimi, N., Samavi, S., & Soroushmehr, S. R. (2018, October). Liver Segmentation in CT Images Using Three Dimensional to Two Dimensional Fully Convolutional Network. In 2018 25th IEEE International Conference on Image Processing (ICIP) (pp. 2067-2071). IEEE.

[2] P. Krähenbühl and V. Koltun, “Efficient Inference in Fully Connected CRFs with Gaussian Edge Potentials,” in Advances in neural information processing systems, pp. 1–9, Oct. 2012.

Should you have any question, contact us via email: sh.rafiei.90@gmail.com
