# 3D to 2D FULLY Convoltional Network For Medical Organ( e.g. Liver) Segmentation. 
The code, related to liver segmentation in abdominal CT scans, is provided here. 3D-2D-FCN is implemented on "caffe" framework; thus, your system requires "caffe" framework as prerequisite to run this project.

You may follow these steps:

First, run "CreateDataBase.m" in matlab to create the liver dataset and prepare it for network training.

Next, run "TrainModel.py" to start network training on the python platform.

Last, run "TestModel.py" to test the network under python platform.

Do not forget to change all address path according to yours. 
In this project, some of the implemented layers of FCN like center selector and 3D pooling layers, are available in "ReshapeLayers.py".

Should you have any question, contact us via email: sh.rafiei.90@gmail.com
