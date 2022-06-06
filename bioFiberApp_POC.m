
function varargout = bioFiberApp_POC(varargin)
% BIOFIBERAPP_POC MATLAB code for bioFiberApp_POC.fig
%      BIOFIBERAPP_POC, by itself, creates a new BIOFIBERAPP_POC or raises the existing
%      singleton*.
%
%      H = BIOFIBERAPP_POC returns the handle to a new BIOFIBERAPP_POC or the handle to
%      the existing singleton*.
%
%      BIOFIBERAPP_POC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIOFIBERAPP_POC.M with the given input arguments.
%
%      BIOFIBERAPP_POC('Property','Value',...) creates a new BIOFIBERAPP_POC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bioFiberApp_POC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bioFiberApp_POC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bioFiberApp_POC

% Last Modified by GUIDE v2.5 05-Feb-2022 22:43:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bioFiberApp_POC_OpeningFcn, ...
                   'gui_OutputFcn',  @bioFiberApp_POC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bioFiberApp_POC is made visible.
function bioFiberApp_POC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bioFiberApp_POC (see VARARGIN)
% global startingFolder
% Choose default command line output for bioFiberApp_POC
handles.output = hObject;

% Clear old stuff from console.
% if isdeployed && ismac
%     NameOfDeployedApp = 'bioFiberApp'; % do not include the '.app' extension
%     [~, result] = system(['top -n100 -l1 | grep ' NameOfDeployedApp ' | awk ''{print $1}''']);
%     result=strtrim(result);
%     [status, result] = system(['ps xuwww -p ' result ' | tail -n1 | awk ''{print $NF}''']);
%     if status==0
%         diridx=strfind(result,[NameOfDeployedApp '.app']);
%         realpwd=result(1:diridx-2);
%     else
%         msgbox({'realpwd not set:',result})
%     end
% else
%     realpwd = pwd;
% end

%startingFolder = realpwd;

clc;
clear global;

if ~isdeployed
    addpath(genpath('Codes'));
    addpath(genpath('sample_img'));
    addpath(genpath('stats'));
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bioFiberApp_POC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bioFiberApp_POC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectImg.
function selectImg_Callback(hObject, eventdata, handles)
% hObject    handle to selectImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles = guidata(hObject)
% dir1=uigetdir(pwd,'Set the path to script files')
% handles.maindir=char(dir1);
% % Update handles structure
% guidata(hObject, handles);
global pgmFileName
global startingFolder
global imageData
global bGround


bGround = 1;
 %
 if ~isdeployed
    startingFolder = pwd;
 else
    startingFolder = ctfroot;  
 end
 defaultFileName = fullfile(startingFolder, '*.*');
 [pgmFileName, pathname] = uigetfile(defaultFileName, 'Select a file');

 
 %pgmFileName = uigetfile({'*.png';'*.tiff';'*.jpeg'});
 if isequal(pgmFileName,0)
     disp('User pressed cancel')
 else
 
     imageData = (imread(fullfile(pathname,pgmFileName)));
     if length(size(imageData)) == 3
        imageData = rgb2gray(imageData);
     end
     imageData = double(imageData);

     message = sprintf('Choose image type (closest match):');
     button = questdlg(message,'Background color', 'Fluorescent/SHG image', 'Staining on light bakground', 'Fluorescent/SHG image');
     drawnow;  % Refresh screen to get rid of dialog box remnants.
     if strcmpi(button, 'Staining on light bakground')
      imageData = imcomplement(imageData);
      bGround = 0;
     end

     %axes(handles.axes1);
     if bGround 
        figure,imagesc(imageData),colormap gray, axis 'square', title('Sample Data'); 
        set(gcf,'color','w');
     else
        figure,imagesc(imcomplement(imageData)),colormap gray, axis 'square', title('Sample Data');
        set(gcf,'color','w');
     end
     
     

     
  
 end


% --- Executes on button press in fiberDetect.
function fiberDetect_Callback(hObject, eventdata, handles)
% hObject    handle to fiberDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageData
global MaxGabor
global bGround
global ThetaMaxGabor
global LambdaMaxGabor
global pgmFileName

if sum(sum(imageData)) == 0 
    f = msgbox('Please select an image file','Attention');
else

        %set(gcbo,'Backgroundcolor',[24/255 90/255 55/255]);
    wb = waitbar(0, 'Enhancing fibers with Gabor filters ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);
    [ MaxGabor, ThetaMaxGabor,LambdaMaxGabor ] = MaxGaborComputation( imageData);
    MaxGabor = (MaxGabor-min(MaxGabor(:)))/(max(MaxGabor(:))-min(MaxGabor(:)));
    %axes(handles.axes2);
    save_dir = './stats/img/'; 
    mkdir(save_dir,pgmFileName);
    if bGround
        figure,imagesc (MaxGabor), colormap gray, axis 'square', title('Gabor-enhanced fibers');
        set(gcf,'color','w');
        save_namefile = [fullfile(save_dir, pgmFileName, 'Gabor.png')];
        imwrite((MaxGabor), save_namefile, 'png');
    else
        figure,imagesc (imcomplement(MaxGabor)), colormap gray, axis 'square', title('Gabor-enhanced fibers');  
        set(gcf,'color','w'); 
        save_namefile = [fullfile(save_dir, pgmFileName, 'Gabor.png')];
        imwrite(imcomplement(MaxGabor), save_namefile, 'png');
    end
    set(gcf,'color','w');
close (wb)
end

% --- Executes on button press in morphSkel.
function morphSkel_Callback(hObject, eventdata, handles)
% hObject    handle to morphSkel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(gcbo,'Backgroundcolor',[24/255 90/255 55/255]);
global MaxGabor
global SkeletonMaxGabor
global ExtremNode
global pgmFileName


if sum(sum(MaxGabor)) == 0 
    f = msgbox('Please perform fiber detection first','Attention');
else

threshMin = 0.15;
threshMax = 0.2;
wb = waitbar(0, 'Extracting the skeleton ...','WindowStyle', 'modal');
    wbch = allchild(wb);
    jp = wbch(1).JavaPeer;
    jp.setIndeterminate(1);
BinaryImage = hysthresh (MaxGabor, threshMin, threshMax);
struct_elem = strel('disk',5);
BinaryImage = imclose(BinaryImage, struct_elem);
draw_graph = 1;
ThreshOnSkeletonLengthBranch = 5;
Radius                       = 30;

[ExtremNode, SkeletonMaxGabor,~,~,~] = DetectionExtremNodeWithGraph(pgmFileName,draw_graph, ThreshOnSkeletonLengthBranch, BinaryImage);   
figure, colormap gray, imagesc (imcomplement(SkeletonMaxGabor)), axis 'square', axis off, title('Morphological Skeleton');
set(gcf,'color','w');
save_dir = './stats/img/'; 
save_namefile = [fullfile(save_dir, pgmFileName, 'MorphologicalSkeleton.png')];
imwrite((imcomplement(SkeletonMaxGabor)), save_namefile, 'png');

close(wb);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gcbo,'Backgroundcolor',[24/255 90/255 55/255]);
% --- Executes on button press in skelReconnect.
function skelReconnect_Callback(hObject, eventdata, handles)
% hObject    handle to skelReconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MaxGabor
global SkeletonMaxGabor
global ThetaMaxGabor;
global imageData;
global ExtremNode;
global pgmFileName;

if sum(sum(MaxGabor)) == 0 
    f = msgbox('Please perform fiber detection first','Attention');
else
    wb = waitbar(0, 'Extracting the skeleton ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);

    draw_graph = 1;
    ThreshOnSkeletonLengthBranch = 5;
    Radius                       = 30;
    [ ~,FinalSkeleton ] = ConnectMissingFibers(pgmFileName, MaxGabor, imageData, SkeletonMaxGabor,...
        ExtremNode,ThetaMaxGabor, Radius, draw_graph, ThreshOnSkeletonLengthBranch );
    SkeletonMaxGabor = FinalSkeleton;
    close(wb);
end



% --- Executes on button press in batchProc.
function batchProc_Callback(hObject, eventdata, handles)
% hObject    handle to batchProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir;
% get what is inside the folder
Infolder = dir(folder_name);
MyListOfFiles = {Infolder(~[Infolder.isdir]).name};
%set(handles.listbox1,'String', MyListOfFiles);
threshMin = 0.15;
threshMax = 0.2;
draw_graph = 0;
ThreshOnSkeletonLengthBranch = 5;
Radius                       = 30;

message = sprintf('Choose image type (closest match):');
button = questdlg(message,'Background color', 'Fluorescent/SHG image', 'Staining on light bakground', 'Fluorescent/SHG image');
drawnow;  % Refresh screen to get rid of dialog box remnants.
if strcmpi(button, 'Staining on light bakground')
    bGround = 0;
else
    bGround = 1;
end

parfor nb_img = 1: length(MyListOfFiles)
    nb_img
    
    imageSample = imread(fullfile(folder_name, MyListOfFiles{nb_img}));

    if length(size(imageSample)) == 3
        imageSample = rgb2gray(imageSample);
    end
    imageSample = double(imageSample);
    if bGround == 0
        imageSample = imcomplement(imageSample);
    end
    [MaxGabor, ThetaMaxGabor,LambdaMaxGabor ] = MaxGaborComputation(imageSample);
    MaxGabor = (MaxGabor-min(MaxGabor(:)))/(max(MaxGabor(:))-min(MaxGabor(:))); 
    BinaryImage = hysthresh (MaxGabor, threshMin, threshMax);
    struct_elem = strel('disk',5);
    BinaryImage = imclose(BinaryImage, struct_elem);
    [~, SkeletonMaxGabor,~,~,~] = DetectionExtremNodeWithGraph('batch.png',draw_graph, ThreshOnSkeletonLengthBranch, BinaryImage); 
    [rows, cols] = size(imageSample);
    [G,x] = getgraph(rows,cols,SkeletonMaxGabor);
    [G,x] = removeNodesdeg2(G,x);
    [ ~,G,x ] = SortIndex( x,G ); y = x;
    distanceGraph = DistanceLength(G,y,'INT',1);     
    [DeformMap, stats_edges] = plotHspace(G,distanceGraph,y,rows,cols,LambdaMaxGabor, ThetaMaxGabor);
    DeformMap = inpaint_nans(DeformMap,4);
    DeformMap = imgaussfilt(DeformMap,7,'Padding','replicate');
    
    DeformMap  = deformHspacepores(SkeletonMaxGabor, rows,cols);
    DeformMap = inpaint_nans(DeformMap,4);
    DeformMap = imgaussfilt(DeformMap,7,'Padding','replicate');
    
    save_dir = './stats/graph/';  
    save_namefile = [save_dir [MyListOfFiles{nb_img} '.csv']];
    writetable(stats_edges, save_namefile);
    
    statsPores = getStatpores( SkeletonMaxGabor, rows,cols);
    save_dir = './stats/pores/';  
    save_namefile = [save_dir [MyListOfFiles{nb_img} '.csv']];
    writetable(statsPores, save_namefile);
end

% --- Executes on button press in reset_b.
function reset_b_Callback(hObject, eventdata, handles)
% hObject    handle to reset_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clc;
close(gcbf);
%clear global;
%clear;
close all;
OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH);
bioFiberApp_POC;


% --- Executes on button press in graphGen.
function graphGen_Callback(hObject, eventdata, handles)
% hObject    handle to graphGen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SkeletonMaxGabor
global imageData
global G
global y
global pgmFileName
% set(gcbo,'Backgroundcolor',[24/255 90/255 55/255]);
if sum(sum(SkeletonMaxGabor)) == 0 
    f = msgbox('Please extract skeleton first','Attention');
else
    wb = waitbar(0, 'Generating the fiber network ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);
    [rows, cols] = size(imageData);
    [G,x] = getgraph(rows,cols,SkeletonMaxGabor);
    [G,x] = removeNodesdeg2(G,x);
    [ ~,G,x ] = SortIndex( x,G ); y = x;
    %fig = figure,hold on, plotGraph(G,x,rows, cols);
    %set(gcf, 'unit', 'norm',  'position', [0 0 1 1]);
    x(3,:) = x(1,:); x(1,:) = x(2,:); x(2,:) = x(3,:);
    x(3,:) = [];
    x(2,:) = cols - x(2,:) +1;
    [X, Y] = gplot(G,x');
    fig = figure; plot(X, Y, '-ko', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', [1 0 0], 'LineWidth', 1);
    %title('Fiber graph');
    axis([1 cols 1 cols]); 
    axis square, axis off
    set(gcf,'color','w');
    save_dir = './stats/img/';  
    save_namefile = [fullfile(save_dir, pgmFileName, 'Fiber_graph.png')];
    export_fig(fig,save_namefile);
    hold off;
    close(wb);
end

% --- Executes on button press in fiberLength.
function fiberLength_Callback(hObject, eventdata, handles)
global G
global y
global imageData
global ThetaMaxGabor
global LambdaMaxGabor
global pgmFileName

if sum(sum(G)) == 0 
    f = msgbox('Please generate graph first','Attention');
else

    wb = waitbar(0, 'Generating the parametric length map ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);
    [rows, cols] = size(imageData);
    distanceGraph = DistanceLength(G,y,'INT',1);     
    [DeformMap, ~] = plotHspace(G,distanceGraph,y,rows,cols,LambdaMaxGabor, ThetaMaxGabor);
    DeformMap = inpaint_nans(DeformMap,4);
    DeformMap = imgaussfilt(DeformMap,7,'Padding','replicate');
    cmp = getPyPlot_cMap('Spectral');
    fig = figure; colormap(flipud(cmp)), imagesc (DeformMap),colorbar, axis square, axis off, title('Parametric fiber length map');
    set(gcf,'color','w');
    save_dir = './stats/img/';  
    save_namefile = [fullfile(save_dir, pgmFileName, 'FiberLengthMap.png')];
    export_fig(fig,save_namefile);
    close(wb)
    
     message = sprintf('Do you wish to visualize the map within a different range of values?:');
     button = questdlg(message,'Different range?', 'No, the current one is fine', 'Yes, select a different range', 'No, the current one is fine');
     drawnow;  % Refresh screen to get rid of dialog box remnants.
     if strcmpi(button, 'Yes, select a different range')
         prompt = {'Enter lowest value:','Enter highest value:'};
         dlgtitle = 'Input';
         dims = [1 35];
         definput = {num2str(min(min(DeformMap))),num2str(max(max(DeformMap)))};
         answer_map = inputdlg(prompt,dlgtitle,dims,definput);
         figure, colormap(flipud(cmp)), imagesc (DeformMap, [str2num(answer_map{1}), str2num(answer_map{2})]),colorbar, axis square, axis off, title('Parametric fiber length map');
         set(gcf,'color','w');
     end
      
end




% --- Executes on button press in fiberOrientationMap.
function fiberOrientationMap_Callback(hObject, eventdata, handles)
% hObject    handle to fiberOrientationMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageData
global SkeletonMaxGabor
global pgmFileName

if sum(sum(SkeletonMaxGabor)) == 0 
    f = msgbox('Please extract fiber skeleton first','Attention');
else
    wb = waitbar(0, 'Generating the pore isotropy map ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);
    [rows, cols] = size(imageData);
    DeformMap  = deformHspacepores(SkeletonMaxGabor, rows,cols);
    DeformMap = inpaint_nans(DeformMap,4);
    DeformMap = imgaussfilt(DeformMap,7,'Padding','replicate');
    cmp = getPyPlot_cMap('Spectral');
    fig = figure; colormap(flipud(cmp)), imagesc (DeformMap),colorbar, axis square, axis off, title('Parametric pore isotropy map');    
    set(gcf,'color','w'); 
    save_dir = './stats/img/'; 
    save_namefile = [fullfile(save_dir, pgmFileName, 'PoreIsotropyMap.png')];
    export_fig(fig,save_namefile);
    close(wb)
    
    message = sprintf('Do you wish to visualize the map within a different range of values?:');
     button = questdlg(message,'Different range?', 'No, the current one is fine', 'Yes, select a different range', 'No, the current one is fine');
     drawnow;  % Refresh screen to get rid of dialog box remnants.
     if strcmpi(button, 'Yes, select a different range')
         prompt = {'Enter lowest value:','Enter highest value:'};
         dlgtitle = 'Input';
         dims = [1 35];
         definput = {num2str(min(min(DeformMap))),num2str(max(max(DeformMap)))};
         answer_map = inputdlg(prompt,dlgtitle,dims,definput);
         figure, colormap(flipud(cmp)), imagesc (DeformMap, [str2num(answer_map{1}), str2num(answer_map{2})]),colorbar, axis square, axis off, title('Parametric fiber length map');
         set(gcf,'color','w');
     end
end

% --- Executes on button press in graphFeat.
function graphFeat_Callback(hObject, eventdata, handles)
% hObject    handle to graphFeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% UpperHalf = triu(distanceGraph,1);
% Pos = UpperHalf(UpperHalf>0);
global G
global y
global imageData
global LambdaMaxGabor
global ThetaMaxGabor
global stats_edges
global pgmFileName

if sum(sum(G)) == 0 
    f = msgbox('Please generate fiber graph first','Attention');
else
    wb = waitbar(0, 'Generating and saving the graph based features ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);

    [rows, cols] = size(imageData);
    distanceGraph = DistanceLength(G,y,'INT',1);  
    [DeformMap_1, stats_edges] = plotHspace(G,distanceGraph,y,rows,cols,LambdaMaxGabor, ThetaMaxGabor);

    DeformMap_1(DeformMap_1>0) = 1;
    DeformMap_1(DeformMap_1 ~= 1) = 0;
    LambdaGabor_Graph = DeformMap_1.*LambdaMaxGabor; 
    ThetaGabor_Graph = DeformMap_1.*ThetaMaxGabor; 
    cmp = getPyPlot_cMap('Spectral');
    fig = figure; colormap(flipud(cmp)),imagesc(ThetaGabor_Graph), colorbar, axis square, axis off, title('Local Gabor-measured angle map');
    save_dir = './stats/img/'; 
    save_namefile = [fullfile(save_dir, pgmFileName, 'ThetaGabor_Graph.png')];
    export_fig(fig,save_namefile);
   
    

    
    cmapi = [0.95    0.95  0.95
            0.5804    0.4039    0.7412;
            1.0000    0.4980    0.0549;
            0.8392    0.1529    0.1569;
            ];
    fig = figure; colormap(cmapi), imagesc(LambdaGabor_Graph, [4 10]), colorbar, axis square, title('Local Gabor-measured fiber thickness map');
    cbh = colorbar;
    caxis([4 10]);
    set(cbh,'Ticks',[4 6 8 10 12],'TickLabels',num2str([0; 6; 8; 10]))
    set(gcf,'color','w'); 
    
    save_dir = './stats/img/';  
    save_namefile = [fullfile(save_dir, pgmFileName, 'LambdaGabor_Graph.png')];
    export_fig(fig,save_namefile);

    save_dir = './stats/graph/';  
    save_namefile = [save_dir [pgmFileName '.csv']];
    writetable(stats_edges, save_namefile);

    close (wb)
end
% --- Executes on button press in poreFeat.
function poreFeat_Callback(hObject, eventdata, handles)
% hObject    handle to poreFeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SkeletonMaxGabor;
global pgmFileName;
if sum(sum(SkeletonMaxGabor)) == 0 
    f = msgbox('Please extract skeleton first','Attention');
else

    wb = waitbar(0, 'Saving pore stats ...','WindowStyle', 'modal');
        wbch = allchild(wb);
        jp = wbch(1).JavaPeer;
        jp.setIndeterminate(1);

    [rows,cols] = size(SkeletonMaxGabor);
    statsPores = getStatpores( SkeletonMaxGabor, rows,cols);
    save_dir = './stats/pores/'; 
    save_namefile = [save_dir [pgmFileName '.csv']];
    writetable(statsPores, save_namefile);
    close(wb)

end

% --- Executes when uipanel1 is resized.
function uipanel1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
% function saveImgFiles_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton18 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [filename, foldername] = uiputfile('Where do you want the file saved?');
% complete_name = fullfile(foldername, filename);
% imwrite(TheArray, complete_name);


% --- Executes on button press in gaborFeat.
function gaborFeat_Callback(hObject, eventdata, handles)
% hObject    handle to gaborFeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SkeletonMaxGabor
global ThetaMaxGabor
global LambdaMaxGabor
global pgmFileName

wb = waitbar(0, 'Generating the Gabor/morphological skeleton features ...','WindowStyle', 'modal');
    wbch = allchild(wb);
    jp = wbch(1).JavaPeer;
    jp.setIndeterminate(1);

LambdaMap = SkeletonMaxGabor.*LambdaMaxGabor;
ThetaMap = SkeletonMaxGabor.*ThetaMaxGabor;

cmp = getPyPlot_cMap('Spectral');
fig = figure; colormap(flipud(cmp)), imagesc (ThetaMap),colorbar, axis square, axis off, title('Local Gabor orientation of fiber skeleton');  
save_dir = './stats/img/';  
save_namefile = [fullfile(save_dir, pgmFileName, 'ThetaMap.png')];
export_fig(fig,save_namefile);

cmapi = [0.95    0.95  0.95
        0.5804    0.4039    0.7412;
        1.0000    0.4980    0.0549;
        0.8392    0.1529    0.1569;
        ];
fig = figure; colormap(cmapi), imagesc(LambdaMap, [4 10]), colorbar, axis square, title('Local Gabor fiber thickness of fiber skeleton');
cbh = colorbar;
caxis([4 10])
set(cbh,'Ticks',[4 6 8 10 12],'TickLabels',num2str([0; 6; 8; 10]))
set(gcf,'color','w'); 

save_dir = './stats/img/';  
save_namefile = [fullfile(save_dir, pgmFileName, 'LambdaMap.png')];
export_fig(fig,save_namefile);

close (wb);
