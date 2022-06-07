BioFiber App GUI

The pipeline including Gabor detection, graph-based fiber representation
and parametric maps analysis can be tested through a MATLAB-based
graphical user interface (GUI), which can run on MATLAB
versions as early as 2015a version. It allows testing of intermediate
steps of the methods of one sample image, and additional parallel
testing of multiple images. Results are stored as either .png files or
.csv files, as detailed below.

![Graphical user interface, application Description automatically
generated](./readme_images//media/image1.png)


**Start: select image **

Test sample images are found in the *fiberGraphApp/sample\_img*
directory which can be selected once Start:select image button is
pressed and directory explorer is enabled. 
Figure . Image type selection

**Fiber extraction pipeline **

The fiber extraction pipeline is divided into multiple steps
and can be tested on one sample image that has been previously loaded
with 'Start:select' image button. The results of these steps will be
directly stored as .png files in a pre-created directory,
*fiberGraphApp/stats/img/'file\_name'*.



**Batch processing**

To apply the fiber extraction - feature extraction - map analysis
pipeline to multiple images in parallel, the user can press 'select
files' button and subsequently select a folder, not a file (e.g.
*fiberGraphApp/sample\_img/sample\_batch*.) by opening it from the
directory explorer. The test folder sample\_batch contains a few images
already; the user can create a different directory or simply place all
images intended for analysis in this one. Ideally, images should be of
the same type, as the user will be asked to confirm the acquisition
type.

To restart the analysis and reset the data values, the user can press
'reset'. This will close all figures and re-open the GUI application.


