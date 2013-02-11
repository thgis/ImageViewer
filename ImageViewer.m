function varargout = ImageViewer(varargin)
% IMAGEVIEWER MATLAB code for ImageViewer.fig
%      IMAGEVIEWER, by itself, creates a new IMAGEVIEWER or raises the existing
%      singleton*.
%
%      H = IMAGEVIEWER returns the handle to a new IMAGEVIEWER or the handle to
%      the existing singleton*.
%
%      IMAGEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEVIEWER.M with the given input arguments.
%
%      IMAGEVIEWER('Property','Value',...) creates a new IMAGEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageViewer

% Last Modified by GUIDE v2.5 07-Feb-2013 11:39:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageViewer_OutputFcn, ...
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


% --- Executes just before ImageViewer is made visible.
function ImageViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageViewer (see VARARGIN)

% Choose default command line output for ImageViewer
handles.output = hObject;

%handles.images = varargin{1};

% TODO the following is an annoing workaround... find better solution
handles.images = {}; 
handles.images{1}=zeros(256);
handles.images{2}=zeros(256);
%handles.titles = varargin{2};
handles.titles= {};
handles.titles{1} = 'blank stage - workaround';
handles.titles{2} = 'blank stage - workaround';
% TODO END

handles.initialImage=1;
%set(handles.slImageChooser,'Min',1,'Max',length(handles.images),'SliderStep',1.0/length(handles.images),'Value',1);
setupSlider(handles);
set(handles.slImageChooser,'Value',1);
slImageChooser_Callback(hObject,eventdata,handles)
handles.addImageFunc=@addImage;
handles.getImageFunc=@getImage;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function setupSlider(handles)
    set(handles.slImageChooser,'Min',1);
    set(handles.slImageChooser,'Max',length(handles.images));
    set(handles.slImageChooser,'SliderStep',[1.0/(length(handles.images)-1) 1.0/(length(handles.images)-1)]);
   


% --- Outputs from this function are returned to the command line.
function varargout = ImageViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
varargout{1} = handles;


% --- Executes on slider movement.
function slImageChooser_Callback(hObject, eventdata, handles)
% hObject    handle to slImageChooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% When this function is called read the current placement of the slider and
% update the image in axesImage
handles.currentSliderIndex = round(get(handles.slImageChooser,'Value'));
%guidata(handles)
updateTitle(handles);
updateIndex(handles);
updateImage(handles);
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function slImageChooser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slImageChooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in btnDetach.
function btnDetach_Callback(hObject, eventdata, handles)
% hObject    handle to btnDetach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figh=figure();
imshow(handles.images{handles.currentSliderIndex});
title(handles.titles{handles.currentSliderIndex});


function updateTitle(handles)
    %data = guidata(handles);
    set(handles.lblTitle,'String',handles.titles{handles.currentSliderIndex});
    %guidata(handles,data);

    
function updateImage(handles)
    %data = guidata(handles);
    imageAxes = handles.axesImage;
    
    axes(imageAxes);
    imshow(handles.images{handles.currentSliderIndex});    
    %guidata(handles,data);

function updateIndex(handles)
    set(handles.lblIndex,'String',handles.currentSliderIndex);


function addImage(handles, image, title)
    data=guidata(handles);
    data.images{end+1}=image;
    data.titles{end +1}=title;
    setupSlider(data);
    guidata(handles,data);
    drawnow;


function output=getImage(handles,index)
    data = guidata(handles);
    output.image=data.images{index};
    output.title=data.titles{index};


    


% --- Executes on button press in btnSaveImage.
function btnSaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    imageToSave = handles.images{handles.currentSliderIndex};
    titleOfImage = handles.titles{handles.currentSliderIndex};
    is = ImageSaver.instance();
    is.saveImage(imageToSave,titleOfImage);
