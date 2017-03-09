function varargout = trichroma(varargin)
% TRICHROMA MATLAB code for trichroma.fig
%      TRICHROMA, by itself, creates a new TRICHROMA or raises the existing
%      singleton*.
%
%      H = TRICHROMA returns the handle to a new TRICHROMA or the handle to
%      the existing singleton*.
%
%      TRICHROMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRICHROMA.M with the given input arguments.
%
%      TRICHROMA('Property','Value',...) creates a new TRICHROMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trichroma_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trichroma_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trichroma

% Last Modified by GUIDE v2.5 16-Dec-2016 17:06:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trichroma_OpeningFcn, ...
                   'gui_OutputFcn',  @trichroma_OutputFcn, ...
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

% --- Executes just before trichroma is made visible.
function trichroma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trichroma (see VARARGIN)

% Choose default command line output for trichroma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using trichroma.
if strcmp(get(hObject,'Visible'),'off')
%    plot(rand(5));
end
% UIWAIT makes trichroma wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% now reading default config, which should be always in application folder
file = 'default_config.prm';
if ~isequal(file, 0)
    [keys,sections,subsections] = inifile(file,'readall');
    for jj=1:size(keys,1)
        if (~isempty(keys{jj,1}))
            handles.ini.(keys{jj,1}).(keys{jj,3}) = keys{jj,4};
        end
    end
    handles = Update_GUI_after_input_INI_file(handles);
    guidata(hObject, handles);
end

function handles = Update_GUI_after_input_INI_file(handles)
handles = getGMC_values( handles);
if isfield(handles,'ini') &&  isfield(handles.ini,'main')
    
    try
        % colortargetPopup
        hObject = handles.colortargetPopup;  
        cArr = []; nselect = 0;
        if isfield(handles.ini.main,'colorchoices')
            cstr = handles.ini.main.colorchoices;
            cArr = strread(cstr,'%s','delimiter',',');
            set(hObject,'String',cArr);
        end
        if isfield(handles.ini.main,'colorselect')
            nselect = uint8(str2num(handles.ini.main.colorselect));
            set(hObject,'Value',nselect);
        end

        % colortargetTable
        if ~isempty(cstr) && nselect ~= 0
            sColorSet = cArr{nselect};
            hObject = handles.colortargetTable;
            set(hObject,'Data',handles.gmc.(sColorSet));
        end
    catch ME
        error('MATLAB:INI_input', 'can"t set color target');
    end
    
    try % weightsTable
        colorweights = handles.ini.main.colorweights;
        grayweights = handles.ini.main.grayweights;
        ncw = cell2mat(textscan(colorweights,'%f','delimiter',','));
        ngw = cell2mat(textscan(grayweights,'%f','delimiter',','));
%        ncw = str2double(strread(colorweights,'%s','delimiter',','));
%        ngw = str2double(strread(grayweights,'%s','delimiter',','));
        weights = [ncw;ngw];
        assert(length(weights)==24);
        gmc = handles.gmc;  
        set(handles.weightsTable,'Data',weights,'RowName',gmc.chipNames);
    catch ME
        error('MATLAB:INI_input', 'can"t set weightsTable data');
    end
end

if isfield(handles,'ini') &&  isfield(handles.ini,'files')
    try % select files
        hObject = handles.editFN;  % GMC image file
        if isfield(handles.ini.files,'gmcimg_fn')
            set(hObject,'String',handles.ini.files.gmcimg_fn);
        end
        hObject = handles.editFN2;  % dark image file
        if isfield(handles.ini.files,'darkimg_fn')
            set(hObject,'String',handles.ini.files.darkimg_fn);
        end
        hObject = handles.editINI;  % config ini file name
        if isfield(handles.ini.files,'configini_fn')
            set(hObject,'String',handles.ini.files.configini_fn);
        end
    catch ME
        error('MATLAB:INI_input', 'error in select files panel');
    end    
end


% --- Outputs from this function are returned to the command line.
function varargout = trichroma_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenConfigFile_Callback(hObject, eventdata, handles)
% hObject    handle to OpenConfigFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.ini');
if ~isequal(file, 0)
    [keys,sections,subsections] = inifile(file,'readall');
%    open(file);
    
    for jj=1:size(keys,1)
        if (~isempty(keys{jj,1}))
            handles.ini.(keys{jj,1}).(keys{jj,3}) = keys{jj,4};
    %       handles.ini.sections = sections;
        end
    end
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function editFN_Callback(hObject, eventdata, handles)
% hObject    handle to editFN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFN as text
%        str2double(get(hObject,'String')) returns contents of editFN as a double


% --- Executes during object creation, after setting all properties.
function editFN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsePB.
function browsePB_Callback(hObject, eventdata, handles)
% hObject    handle to browsePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fName,pathName,filterIndex]  = uigetfile('*.*');
if ~isequal(fName, 0)
    set(handles.editFN,'String',[pathName,fName]);
%    open([pathName,fName]);
end


function editFN2_Callback(hObject, eventdata, handles)
% hObject    handle to editFN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFN2 as text
%        str2double(get(hObject,'String')) returns contents of editFN2 as a double


% --- Executes during object creation, after setting all properties.
function editFN2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsePB2.
function browsePB2_Callback(hObject, eventdata, handles)
% hObject    handle to browsePB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fName,pathName,filterIndex]  = uigetfile('*.*');
if ~isequal(fName, 0)
    set(handles.editFN2,'String',[pathName,fName]);
end

% --- Fuction loads Gretag Macbeth Checker values.
function handles = getGMC_values( handles)
if ~isfield(handles,'gmc')
    gmc = getGMC_color();
handles.gmc = gmc;
end

% --- Executes on button press in calibratePB.
function calibratePB_Callback(hObject, eventdata, handles)
% hObject    handle to calibratePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected = '';  % refreshing structure
selected.sf_img  = get(handles.editFN, 'String');
selected.sf_dark = get(handles.editFN2, 'String');

try % read files
    B=imread(selected.sf_img);
    B_dark=imread(selected.sf_dark);
    C=double(B) - double(B_dark);
catch ME
    error('MATLAB:calibratePB_Callback', 'can"t read image files');
end

% update gamma
try selected.gamma = str2double(handles.ini.main.gamma);
catch ME
    error('MATLAB:calibratePB_Callback', 'gamma is not set correctly');
end

    % update colortargetTable
    handles = getGMC_values( handles); 
    gmc = handles.gmc;
    selected.graySet = gmc.gray_Values /256;
    selected.labCIE = gmc.Lab_CIE_D50;
    selected.chipNames = gmc.chipNames;
    
try % select target weights
    weights = get(handles.weightsTable,'Data');
    assert(length(weights)==24);
    assert(min(weights)>=0);
    selected.weights = weights;
catch ME
    error('MATLAB:calibratePB_Callback', 'error in target weights selection');
end

try % select other settings
    pedestal = str2double(get(handles.pedestalEdit,'String'));
    assert(isnumeric(pedestal));
    selected.pedestal = pedestal;
catch ME
    selected.pedestal = 0;
    error('MATLAB:calibratePB_Callback', 'error in target weights selection');
end

try % calibrate image
    cArr = get(handles.colortargetPopup,'String');
    nselect = uint8(get(handles.colortargetPopup,'Value'));
    if ~isempty(cArr) && nselect ~= 0
        sColorSet = cArr{nselect};
        selected.colorSet = handles.gmc.(sColorSet);
    else error('MATLAB:colorTarget', 'colortable is not set correctly');    
    end
    calib = gmc_calibrate( C, selected);
    selected.calib = calib;
    
    % update WB and CCM tables in calibPanel
    set(handles.wbTable,'Data', calib.wb );
    set(handles.ccmTable,'Data', calib.ccm );
catch ME
        error('MATLAB:calibratePB_Callback', 'error in gmc_calibrate');
end

handles.selected = selected;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function weightsTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightsTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function OptionsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OptionsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ColorWeightsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ColorWeightsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.filePanel,'Visible', 'off' )
set(handles.calibPanel,'Visible', 'off' )
set(handles.targetPanel,'Visible', 'off' )
set(handles.otherPanel,'Visible', 'off' )
set(handles.weightsPanel,'Visible', 'on' )

% --------------------------------------------------------------------
function TargetColorsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to TargetColorsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.weightsPanel,'Visible', 'off' )
set(handles.filePanel,'Visible', 'off' )
set(handles.calibPanel,'Visible', 'off' )
set(handles.otherPanel,'Visible', 'off' )
set(handles.targetPanel,'Visible', 'on' )

% --------------------------------------------------------------------
function CalibrateMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrateMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.weightsPanel,'Visible', 'off' )
set(handles.filePanel,'Visible', 'off' )
set(handles.targetPanel,'Visible', 'off' )
set(handles.otherPanel,'Visible', 'off' )
set(handles.calibPanel,'Visible', 'on' )

% --------------------------------------------------------------------
function FilesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FilesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.weightsPanel,'Visible', 'off' )
set(handles.calibPanel,'Visible', 'off' )
set(handles.targetPanel,'Visible', 'off' )
set(handles.otherPanel,'Visible', 'off' )
set(handles.filePanel,'Visible', 'on' )


% --------------------------------------------------------------------
function OtherOptionsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OtherOptionsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.weightsPanel,'Visible', 'off' )
set(handles.calibPanel,'Visible', 'off' )
set(handles.targetPanel,'Visible', 'off' )
set(handles.filePanel,'Visible', 'off' )
set(handles.otherPanel,'Visible', 'on' )

% --------------------------------------------------------------------
function SaveConfigFile_Callback(hObject, eventdata, handles)
% hObject    handle to SaveConfigFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editINI_Callback(hObject, eventdata, handles)
% hObject    handle to editINI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editINI as text
%        str2double(get(hObject,'String')) returns contents of editINI as a double


% --- Executes during object creation, after setting all properties.
function editINI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editINI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseiniPB.
function browseiniPB_Callback(hObject, eventdata, handles)
% hObject    handle to browseiniPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fName,pathName,filterIndex]  = uigetfile('*.ini');
if ~isequal(fName, 0)
    set(handles.editINI,'String',[pathName,fName]);
%    open([pathName,fName]);
end


% --- Executes on selection change in colortargetPopup.
function colortargetPopup_Callback(hObject, eventdata, handles)
% hObject    handle to colortargetPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colortargetPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colortargetPopup

handles = getGMC_values( handles);
cArr = get(hObject,'String');
nselect = get(hObject,'Value');
    
% colortargetTable
if ~isempty(cArr) && nselect ~= 0
    sColorSet = cArr{nselect};
    set(handles.colortargetTable,'Data',handles.gmc.(sColorSet));
end


% --- Executes during object creation, after setting all properties.
function colortargetPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colortargetPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in graytargetPopup.
function graytargetPopup_Callback(hObject, eventdata, handles)
% hObject    handle to graytargetPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns graytargetPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from graytargetPopup


% --- Executes during object creation, after setting all properties.
function graytargetPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graytargetPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function graytargetTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graytargetTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles = getGMC_values( handles); gmc = handles.gmc;
gray_Values = gmc.gray_Values /256; % sRGB gray with gamma correction
set(hObject,'Data',gray_Values);


% --------------------------------------------------------------------
function ablout_menu_Callback(hObject, eventdata, handles)
% hObject    handle to ablout_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trichroma_about;


% --- Executes during object creation, after setting all properties.
function cmAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
h= imread('ccm_formula.PNG');
imshow(h);


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pedestalEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pedestalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pedestalEdit as text
%        str2double(get(hObject,'String')) returns contents of pedestalEdit as a double
    pedestal = str2double(get(hObject,'String'));
    if ~(isnumeric(pedestal) && ~isnan(pedestal))
        errordlg('Please enter numeric value')
    end


% --- Executes during object creation, after setting all properties.
function pedestalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pedestalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
