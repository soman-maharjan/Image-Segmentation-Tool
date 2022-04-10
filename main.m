function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 05-Jan-2022 20:40:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.histogramButton,'visible','off')

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global Image;
global segmentedImage;
global backgroundColor;
global file;
% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)
global Image;
global segmentedImage;
global backgroundColor;

% get value from radio buttons
black = get(handles.black,'Value');
white = get(handles.white,'Value');
% assign the background color based on radio button 
if(black)
    backgroundColor = 0;
else
    backgroundColor = 255;
end

% Get Threshold slider value
val = get(hObject, 'Value')

% check if the Image has been selected by the user.
if(~isempty(Image))

%if image is 2 dimensional then convert it into black and white
if(ndims(Image) == 2)
BWImage = imbinarize(Image, val);
else
%if the image is 3 dimensional the convert it into grayscale image and then
%into black and white
BWImage = imbinarize(rgb2gray(Image), val);
end

%display image in axis
axes(handles.blackAndWhiteImage);
imshow(BWImage);
axes(handles.segmentedImage)
segmentedImage = Image;

%temporary variable to change the image
tempImage = BWImage;
if(ndims(Image) == 3)
% create 3 dimensional temp variable with black and white image
tempImage(:,:,1) = BWImage;
tempImage(:,:,2) = BWImage;
tempImage(:,:,3) = BWImage;
end

% the temporary image variable is used to segment the image and add
% background color as selected from the radio buttons
segmentedImage(~tempImage) = backgroundColor;

% display the segmented image
imshow(segmentedImage);

% display histogram button
set(handles.histogramButton,'visible','on')
end

function thresholdSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function selectImage_Callback(hObject, eventdata, handles)
global file;
% select image using GUI.
[file, path] = uigetfile({'*.png;*.jpeg;*.jpg;'},'Select an image');
% combine the path with file name
path = append(path,file);
setImage(path, handles);

% this function is used to set image in axis
function setImage(path, handles)
global Image;
Image = imread(path);
axes(handles.originalImage);
imshow(Image); 

% display image information
set(handles.imageSizeValue,'String', size(Image));
set(handles.imageDimensionsValue,'String', ndims(Image));

function histogramButton_Callback(hObject, eventdata, handles)
global Image;
global segmentedImage;

origImg = Image;

if(ndims(Image) == 3)
origImg=rgb2gray(Image);
end

% display histogram of original image and segmented image
axes(handles.axes4);
imhist(origImg)
ylim([0, 1000])

axes(handles.axes7);
imhist(segmentedImage)

ylim([0, 1000])

function black_Callback(hObject, eventdata, handles)

function white_Callback(hObject, eventdata, handles)


function background_Callback(hObject, eventdata, handles)
%call thresholdslide if the background color is changed
thresholdSlider_Callback(handles.thresholdSlider, eventdata, handles)

function saveImage_Callback(hObject, eventdata, handles)
global segmentedImage;

%save image to the drive
[file,path] = uiputfile('*.png','Save Image As');
% join file name with path
path = append(path,file);
imwrite(segmentedImage,path);


function brightnessSlider_Callback(hObject, eventdata, handles)
global Image;
%check if the Image is selected by the user
if(~isempty(Image))
% if the image is selected then change the brightness of the image using the
% slider value
Image = imlocalbrighten(Image,get(hObject,'Value'));
axes(handles.originalImage)
% display the image
imshow(Image)
end

function brightnessSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function imageInfo_Callback(hObject, eventdata, handles)
global Image;
global file;
%check if the Image is selected by the user
if(~isempty(Image))
imageinfo(file);
end
