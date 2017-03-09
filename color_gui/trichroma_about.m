function varargout = trichroma_about(varargin)
% TRICHROMA_ABOUT MATLAB code for trichroma_about.fig
%      TRICHROMA_ABOUT, by itself, creates a new TRICHROMA_ABOUT or raises the existing
%      singleton*.
%
%      H = TRICHROMA_ABOUT returns the handle to a new TRICHROMA_ABOUT or the handle to
%      the existing singleton*.
%
%      TRICHROMA_ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRICHROMA_ABOUT.M with the given input arguments.
%
%      TRICHROMA_ABOUT('Property','Value',...) creates a new TRICHROMA_ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trichroma_about_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trichroma_about_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trichroma_about

% Last Modified by GUIDE v2.5 16-Dec-2016 15:47:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trichroma_about_OpeningFcn, ...
                   'gui_OutputFcn',  @trichroma_about_OutputFcn, ...
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


% --- Executes just before trichroma_about is made visible.
function trichroma_about_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trichroma_about (see VARARGIN)

% Choose default command line output for trichroma_about
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trichroma_about wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trichroma_about_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%set(hObject,'String','Color match ');
set(hObject,'String',['All rights reserved ',char(169),'Altasens']); % 


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
h= imread('altasens.PNG');
handles.axes = axes( 'Position', [0 0 1 1],'Parent', hObject); 
imshow(h);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
