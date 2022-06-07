ECM-fiber-graph MATLAB GUI

The pipeline including Gabor detection, graph-based fiber representation and parametric maps analysis can be tested through a MATLAB-based graphical user interface (GUI), (Figure 1), which can run on MATLAB versions starting from 2015a onwards. 

The current app version can only be run on machines with MATLAB installed. Next steps can include the development of a standalone application that would not require prior installation of MATLAB.
Files should typically be stored for analysis in the following formats: ‘jpg/jpeg’, ‘tif’, ‘png’, etc. 
Most tests have been performed on average sample size smaller or equal to 1024x1024 pixels. Skeleton Reconnection is a time-consuming step which is deemed optional. 

After downloading the project on a local machine, the user can run the GUI (ECM_fiber_graph.fig) to test intermediate steps of the methods of one sample image, and additional parallel testing of multiple images. Results are stored as either .png files or .csv files, as detailed below.

We recommend testing on one/few samples visualizing the intermediate steps (e.g. Fiber extraction pipeline, followed by Fiber features and parametric maps), before deciding to apply the whole analysis on groups of images with Batch processing.


![Graphical user interface, application Description automatically
generated](./readme_images//media/image1.png)

For further information, please see attached tutorial.