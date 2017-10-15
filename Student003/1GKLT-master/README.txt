The usage of gKLT tracker binary

1, In the folder of video frame, there should be one file imageList.txt, which contains all the names of frames to be processed. The first frame is assumed as background image. Refer to the sample_video folder for example.

2, The command line: 
klt_tracker.exe path frame_num(number of frames to be processed) nfeatures(number of initialized klt features) scale(10 is the original size, 20 is 2x size) foregroundthreshold

Example:
klt_tracker.exe D:\\code\\release_collectiveness\\tracker_bin\\sample_video\\ 101 3000 10 16
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 50 3000 10 16
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 50 3000 10 160
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 50 3000 10 100
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 50 3000 10 120
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 500 3000 10 120
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 2500 3000 10 120
klt_tracker.exe D:\\code\\TEMP\\Student003\\GKLT-master\\student003\\ 5400 3000 10 120
3, We also provide a python script run_script.py, in which you can slightly revise it to make the gKLT tracker sequentially process many folders of video frames (it also can automatically list frame names into imageList.txt).

Bolei Zhou
Mar.20, 2013

If you use our codes, please cite our paper 
B. Zhou, X. Tang and X. Wang. "Measuring Crowd Collectiveness." In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2013 ) 