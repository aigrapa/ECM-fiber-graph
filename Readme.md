ECM-fiber-graph MATLAB GUI
=====================

## Description

The ECM-fiber-graph MATLAB GUI can be used to achieve a 2D graph-based representation of fiber networks such as extracellular matrix (ECM) proteins (e.g. cellular fibronectin). It can additionally compute meaningful fiber features using graphs and morphological skeletons, as well as derive parametric maps for subsequent (statistical) analyses.

## Documentation

The pipeline including Gabor detection, graph-based fiber representation and parametric maps analysis can be tested through a MATLAB-based graphical user interface (GUI), see Figure 1. 

**Requirements**: The current app version can only be run on machines with MATLAB installed, starting from 2015a onwards. Future work can include the development of a standalone application that would not require prior installation of MATLAB.

Files should typically be stored for analysis in the following formats: ‘.jpg/jpeg’, ‘.tif’, ‘.png’, etc.

**Additional info**: Most tests have been performed on average sample size smaller or equal to 1024x1024 pixels. Skeleton Reconnection is a time-consuming step which is deemed optional. 

After downloading the project, the user can run the GUI (ECM_fiber_graph.fig) to test intermediate steps of the methods of one sample image, and additional parallel testing of multiple images. Results are stored as either .png files or .csv files, as detailed below.

We recommend testing on one/few samples visualizing the intermediate steps (e.g. Fiber extraction pipeline, followed by Fiber features and parametric maps), before deciding to apply the whole analysis on groups of images with Batch processing.

[For further information, please consult the tutorial.](https://github.com/aigrapa/ECM-fiber-graph/blob/main/Tutorial_ECM-fiber-graph.pdf)

![Graphical user interface, application Description automatically
generated](./readme_images//media/image1.png)


