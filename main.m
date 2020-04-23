function varargout = main(varargin)

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

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%%PREDEFINED VALUES FOR THE SETTINGS
settings_par.t0 = 125;
settings_par.t1 = 300;
settings_par.binHist = 50;
settings_par.fuzzySet = '';
settings_par.cumModel = '';
settings_par.cumModel_par = [0 0 0];
settings_par.cumModel_ecf = 1;
settings_par.parsPSO = [1.05 1.05 0.5 400 3 50];

%%save predefined settings values 
assignin('base','settings_par',settings_par)

%%check if load_data was already called
try
    sbj = evalin('base','numSbj');
    if sbj > 0
        set(handles.cover,'Visible','Off'); 
        set(handles.load_data,'Enable','Off');
        set(handles.txtSBJ, 'String', num2str(evalin('base','numSbj'))); 
        set(handles.txtVAR, 'String', num2str(evalin('base','numItems'))); 
        set(handles.checkODA,'Value',0); 
        set(handles.checkPSO_default,'Value',1);
        set(handles.cumModel_ecdf,'Value',1);
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function load_data_Callback(hObject, eventdata, handles)
%sb = statusbar('STATUS: Load Data...please wait');
%set(sb.TextPanel, 'Foreground',[0,0,0], 'Background','white', 'ToolTipText','tool tip...')
%set(sb, 'Background',java.awt.Color.white);

[numSbj, numItems, numLabels, ONSETS_text, OFFSETS_text, RTS_text, ONSETS_resp, OFFSETS_resp, RTS_resp, MX, MY, RSP_DEG, RSP_DISC, NUM_MVS, POINTS_LBLS, MOUSE_MVS_X, MOUSE_MVS_Y, MOUSE_MVS_TIMES] = readValues();
assignin('base','numSbj',numSbj) 
assignin('base','numItems',numItems) 
assignin('base','numLabels',numLabels)
assignin('base','ONSETS_text',ONSETS_text)
assignin('base','OFFSETS_text',OFFSETS_text)
assignin('base','RTS_text',RTS_text)
assignin('base','ONSETS_resp',ONSETS_resp)
assignin('base','OFFSETS_resp',OFFSETS_resp)
assignin('base','RTS_resp',RTS_resp)
assignin('base','MX',MX)
assignin('base','MY',MY)
assignin('base','RSP_DEG',RSP_DEG)
assignin('base','RSP_DISC',RSP_DISC)
assignin('base','NUM_MVS',NUM_MVS)
assignin('base','POINTS_LBLS',POINTS_LBLS)
assignin('base','MOUSE_MVS_X',MOUSE_MVS_X)
assignin('base','MOUSE_MVS_Y',MOUSE_MVS_Y)
assignin('base','MOUSE_MVS_TIMES',MOUSE_MVS_TIMES)

%sb = statusbar('STATUS: Load Data...complete');
%set(sb.TextPanel, 'Foreground',[0,0,0], 'Background','white', 'ToolTipText','tool tip...')
%set(sb, 'Background',java.awt.Color.white);

set(handles.cover,'Visible','Off'); 
set(handles.load_data,'Enable','Off');
set(handles.checkODA,'Value',0); 
set(handles.checkPSO_default,'Value',1);
set(handles.cumModel_ecdf,'Value',1);

set(handles.txtSBJ, 'String', num2str(evalin('base','numSbj'))); 
set(handles.txtVAR, 'String', num2str(evalin('base','numItems'))); 

%sb = statusbar('STATUS: Ready');
%set(sb.TextPanel, 'Foreground',[0,0,0], 'Background','white', 'ToolTipText','tool tip...')
%set(sb, 'Background',java.awt.Color.white);


% --- Executes on button press in CheckGraph.
function CheckGraph_Callback(hObject, eventdata, handles)


% --- Executes on button press in Run_button.
function Run_button_Callback(hObject, eventdata, handles)

%%% get values from parameters panel %%%%%%%
settings_par.t0 = str2num(get(handles.t0,'String'));
settings_par.t1 = str2num(get(handles.t1,'String'));
settings_par.binHist = str2num(get(handles.histB,'String'));

val = get(handles.fuzzySet,'Value'); strModels = get(handles.fuzzySet,'String'); settings_par.fuzzySet = strModels{val};
val = get(handles.cumModels,'Value'); strModels = get(handles.cumModels,'String'); settings_par.cumModel = strModels{val};
settings_par.cumModel_par = [str2num(get(handles.cumModel_parA,'String')) str2num(get(handles.cumModel_parB,'String')) str2num(get(handles.cumModel_parC,'String'))];
settings_par.cumModel_ecf = get(handles.cumModel_ecdf,'Value');
TypeGraph = get(handles.CheckGraph, 'Value');

num_partic = str2num(get(handles.PSO_partic,'String'));
c1 = str2num(get(handles.PSO_c1,'String'));
c2 = str2num(get(handles.PSO_c2,'String'));
k = str2num(get(handles.PSO_k,'String'));
iter = str2num(get(handles.PSO_iter,'String'));

if isequal(settings_par.fuzzySet,'Triangular')
    num_pars = 3;
elseif isequal(settings_par.fuzzySet,'Trapezoidal')
    num_pars = 4;
end

settings_par.parsPSO = [c1 c2 k iter num_pars num_partic];
assignin('base','settings_par',settings_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.results,'String','');
sbj=[];sbj = str2num(get(handles.sbj,'String'));
var=[];var = str2num(get(handles.var,'String'));
if isempty(sbj)
    sbj=0;
end
if isempty(var)
    var=0;
end

%sb = statusbar('STATUS: Ready');
%set(sb.TextPanel, 'Foreground',[0,0,0], 'Background','white', 'ToolTipText','tool tip...')
%set(sb, 'Background',java.awt.Color.white);

%% First case: known subject / known variable
if sbj~=0 & var~=0
    i=sbj;j=var;
    if sbj > evalin('base','numSbj') | var > evalin('base','numItems')
        msgbox('Subject or Variable out of range','Warning','warn') 
    else
        [triangPoints,FNs,H,KI,HR,rsp_disc] = data_analysis_main(i,j,handles,settings_par,TypeGraph);
        if rsp_disc ~= 0
            results.OptParameters = triangPoints;
            results.FuzzyNumber.movements = FNs.movs_fs;
            results.FuzzyNumber.final = FNs.final_fs;
            results.FuzzyEntropy.movsFS = H.movs_fs;
            results.FuzzyEntropy.finalFS = H.final_fs;
            results.FuzzIndex.movsFS = KI.movs_fs;
            results.FuzzIndex.finalFS = KI.final_fs;
            results.EntropyRatio = HR;
            results.logText = get(handles.results,'string');
        elseif rsp_disc == 0
            results.OptParameters = 0;
            results.FuzzyNumber.movements = 0;
            results.FuzzyNumber.final = 0;
            results.FuzzyEntropy.movsFS = 0;
            results.FuzzyEntropy.finalFS = 0;
            results.FuzzIndex.movsFS = 0;
            results.FuzzIndex.finalFS = 0;
            results.EntropyRatio = 0;
            results.logText = get(handles.results,'string');
        end
        assignin('base','results',results)
    end
end
%% Second case: known subject / all variables    
if sbj~=0 & var==0
    i=sbj;
    if sbj > evalin('base','numSbj') | var > evalin('base','numItems')
        msgbox('Subject or Variable out of range','Warning','warn') 
    else
        for j=1:evalin('base','numItems')
            [triangPoints,FNs,H,KI,HR,rsp_disc,~,~] = data_analysis_main(i,j,handles,settings_par,TypeGraph);
            if rsp_disc ~= 0
                results.OptParameters(1,j,:) = triangPoints;
                results.FuzzyNumber.movements(1,j,:) = FNs.movs_fs;
                results.FuzzyNumber.final(1,j,:) = FNs.final_fs;
                results.FuzzyEntropy.movsFS(1,j,:) = H.movs_fs;
                results.FuzzyEntropy.finalFS(1,j,:) = H.final_fs;
                results.FuzzIndex.movsFS(1,j,:) = KI.movs_fs;
                results.FuzzIndex.finalFS(1,j,:) = KI.final_fs;
                results.EntropyRatio(1,j,:) = HR;
                results.logText = get(handles.results,'string');
            elseif rsp_disc == 0
                results.OptParameters(1,j,:) = 0;
                results.FuzzyNumber.movements(1,j,:) = 0;
                results.FuzzyNumber.final(1,j,:) = 0;
                results.FuzzyEntropy.movsFS(1,j,:) = 0;
                results.FuzzyEntropy.finalFS(1,j,:) = 0;
                results.FuzzIndex.movsFS(1,j,:) = 0;
                results.FuzzIndex.finalFS(1,j,:) = 0;
                results.EntropyRatio(1,j,:) = 0;
                results.logText = get(handles.results,'string');
            end
            choice = questdlg('Do you want continue to the next variable?', 'Status message','Yes','No','No');
            switch choice
            case 'Yes'
                nextItem = 1;
            case 'No'
                nextItem = 2;
            end
            if nextItem == 2
                break
            end
        end
        assignin('base','results',results)
    end  
end
%% third case: all subjects / all variables
if sbj==0 & var==0
    for i=1:evalin('base','numSbj')
        for j=1:(evalin('base','numItems'))
            [triangPoints,FNs,H,KI,HR,rsp_disc,~,~,~] = data_analysis_main(i,j,handles,settings_par,TypeGraph);
            if rsp_disc ~= 0
                results.OptParameters(i,j,:) = triangPoints;
                results.FuzzyNumber.movements(i,j,:) = FNs.movs_fs;
                results.FuzzyNumber.final(i,j,:) = FNs.final_fs;
                results.FuzzyEntropy.movsFS(i,j,:) = H.movs_fs;
                results.FuzzyEntropy.finalFS(i,j,:) = H.final_fs;
                results.FuzzIndex.movsFS(i,j,:) = KI.movs_fs;
                results.FuzzIndex.finalFS(i,j,:) = KI.final_fs;
                results.EntropyRatio(i,j,:) = HR;
                results.logText = get(handles.results,'string');    
            elseif rsp_disc == 0
                results.OptParameters(i,j,:) = 0;
                results.FuzzyNumber.movements(i,j,:) = 0;
                results.FuzzyNumber.final(i,j,:) = 0;
                results.FuzzyEntropy.movsFS(i,j,:) = 0;
                results.FuzzyEntropy.finalFS(i,j,:) = 0;
                results.FuzzIndex.movsFS(i,j,:) = 0;
                results.FuzzIndex.finalFS(i,j,:) = 0;
                results.EntropyRatio(i,j,:) = 0;
                results.logText = get(handles.results,'string');
            end
            choice1 = questdlg('Do you want continue to the next variable?', 'Status message','Yes','No','No');
            switch choice1
            case 'Yes'
                nextItem = 1;
            case 'No'
                nextItem = 2;
            end
            if nextItem == 2
                break
            end
        end
        choice2 = questdlg('Do you want continue to the next subject?', 'Status message','Yes','No','No');
        switch choice2
        case 'Yes'
            nextSbj = 1;
        case 'No'
            nextSbj = 2;
        end
        if nextSbj == 2
            break
        end
    end
    assignin('base','results',results)
end


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
close(main)

% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
helpdlg('This package is developed under Matlab language for research purposes. This version is Beta (release candidate). DISCLAIMER: The beta software licensed hereunder may contain defects and a primary purpose of this beta testing license, for which no fees have been charged or are due from licensee, is to obtain feedback on software performance and the identification of defects. licensee is advised to safeguard important data, to use caution and not to rely in any way on the correct functioning or performance of the software and/or accompanying materials. For any further question please contact: a.b@mail.it','About');

% --- Executes on selection change in results.
function results_Callback(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns results contents as cell array
%        contents{get(hObject,'Value')} returns selected item from results


% --- Executes during object creation, after setting all properties.
function results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function t1_Callback(hObject, eventdata, handles)
% hObject    handle to t1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t1 as text
%        str2double(get(hObject,'String')) returns contents of t1 as a double


% --- Executes during object creation, after setting all properties.
function t1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t0_Callback(hObject, eventdata, handles)
% hObject    handle to t0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t0 as text
%        str2double(get(hObject,'String')) returns contents of t0 as a double


% --- Executes during object creation, after setting all properties.
function t0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function histB_Callback(hObject, eventdata, handles)
% hObject    handle to histB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of histB as text
%        str2double(get(hObject,'String')) returns contents of histB as a double


% --- Executes during object creation, after setting all properties.
function histB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fuzzySet.
function fuzzySet_Callback(hObject, eventdata, handles)
% hObject    handle to fuzzySet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fuzzySet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fuzzySet


% --- Executes during object creation, after setting all properties.
function fuzzySet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fuzzySet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSO_partic_Callback(hObject, eventdata, handles)
% hObject    handle to PSO_partic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSO_partic as text
%        str2double(get(hObject,'String')) returns contents of PSO_partic as a double


% --- Executes during object creation, after setting all properties.
function PSO_partic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSO_partic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSO_c2_Callback(hObject, eventdata, handles)
% hObject    handle to PSO_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSO_c2 as text
%        str2double(get(hObject,'String')) returns contents of PSO_c2 as a double


% --- Executes during object creation, after setting all properties.
function PSO_c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSO_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSO_c1_Callback(hObject, eventdata, handles)
% hObject    handle to PSO_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSO_c1 as text
%        str2double(get(hObject,'String')) returns contents of PSO_c1 as a double


% --- Executes during object creation, after setting all properties.
function PSO_c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSO_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSO_iter_Callback(hObject, eventdata, handles)
% hObject    handle to PSO_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSO_iter as text
%        str2double(get(hObject,'String')) returns contents of PSO_iter as a double


% --- Executes during object creation, after setting all properties.
function PSO_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSO_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cumModels.
function cumModels_Callback(hObject, eventdata, handles)
% hObject    handle to cumModels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cumModels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cumModels


% --- Executes during object creation, after setting all properties.
function cumModels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cumModels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cumModel_parA_Callback(hObject, eventdata, handles)
% hObject    handle to cumModel_parA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cumModel_parA as text
%        str2double(get(hObject,'String')) returns contents of cumModel_parA as a double


% --- Executes during object creation, after setting all properties.
function cumModel_parA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cumModel_parA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cumModel_parB_Callback(hObject, eventdata, handles)
% hObject    handle to cumModel_parB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cumModel_parB as text
%        str2double(get(hObject,'String')) returns contents of cumModel_parB as a double


% --- Executes during object creation, after setting all properties.
function cumModel_parB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cumModel_parB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cumModel_parC_Callback(hObject, eventdata, handles)
% hObject    handle to cumModel_parC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cumModel_parC as text
%        str2double(get(hObject,'String')) returns contents of cumModel_parC as a double


% --- Executes during object creation, after setting all properties.
function cumModel_parC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cumModel_parC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cumModel_ecdf.
function cumModel_ecdf_Callback(hObject, eventdata, handles)
% hObject    handle to cumModel_ecdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cumModel_ecdf

if get(handles.cumModel_ecdf, 'Value') == 1
    set(handles.cumModels,'Enable','off');
    set(handles.cumModel_parA,'Enable','off');
    set(handles.cumModel_parB,'Enable','off');
    set(handles.cumModel_parC,'Enable','off');
else
    set(handles.cumModels,'Enable','on');
    set(handles.cumModel_parA,'Enable','on');
    set(handles.cumModel_parB,'Enable','on');
    set(handles.cumModel_parC,'Enable','on');
end



function PSO_k_Callback(hObject, eventdata, handles)
% hObject    handle to PSO_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSO_k as text
%        str2double(get(hObject,'String')) returns contents of PSO_k as a double


% --- Executes during object creation, after setting all properties.
function PSO_k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSO_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkPSO_default.
function checkPSO_default_Callback(hObject, eventdata, handles)
% hObject    handle to checkPSO_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkPSO_default

if get(handles.checkPSO_default, 'Value') == 1
    set(handles.PSO_iter,'Enable','off');
    set(handles.PSO_partic,'Enable','off');
    set(handles.PSO_c1,'Enable','off');
    set(handles.PSO_c2,'Enable','off');
    set(handles.PSO_k,'Enable','off');
else
    set(handles.PSO_iter,'Enable','on');
    set(handles.PSO_partic,'Enable','on');
    set(handles.PSO_c1,'Enable','on');
    set(handles.PSO_c2,'Enable','on');
    set(handles.PSO_k,'Enable','on');
end


% --- Executes on button press in checkODA.
function checkODA_Callback(hObject, eventdata, handles)
% hObject    handle to checkODA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkODA
stopP = 0;

if get(handles.checkODA,'Value') == 1
    risp=0;
    choice = questdlg('This option allow to start the data analysis procedure without graphical visualization. Are you sure you want to continue?','Only Data Analysis option','Yes','No','');
    switch choice
        case 'Yes'
            risp = 1;
        case 'No'
            risp = 0;
    end
end

if risp == 1
    %%% get values from parameters panel %%%%%%%
    settings_par.t0 = str2num(get(handles.t0,'String'));
    settings_par.t1 = str2num(get(handles.t1,'String'));
    settings_par.binHist = str2num(get(handles.histB,'String'));

    val = get(handles.fuzzySet,'Value'); strModels = get(handles.fuzzySet,'String'); settings_par.fuzzySet = strModels{val};
    val = get(handles.cumModels,'Value'); strModels = get(handles.cumModels,'String'); settings_par.cumModel = strModels{val};
    settings_par.cumModel_par = [str2num(get(handles.cumModel_parA,'String')) str2num(get(handles.cumModel_parB,'String')) str2num(get(handles.cumModel_parC,'String'))];
    settings_par.cumModel_ecf = get(handles.cumModel_ecdf,'Value');

    num_partic = str2num(get(handles.PSO_partic,'String'));
    c1 = str2num(get(handles.PSO_c1,'String'));
    c2 = str2num(get(handles.PSO_c2,'String'));
    k = str2num(get(handles.PSO_k,'String'));
    iter = str2num(get(handles.PSO_iter,'String'));
    if settings_par.fuzzySet == 'Triangular'
        num_pars = 3;
    end
    settings_par.parsPSO = [c1 c2 k iter num_pars num_partic];
    assignin('base','settings_par',settings_par)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %sb = statusbar('STATUS: ODA started');
    %set(sb.TextPanel, 'Foreground',[0,0,0], 'Background','white', 'ToolTipText','tool tip...')
    %set(sb, 'Background',java.awt.Color.white);
    
    set(handles.t0,'Enable','Off');
    set(handles.t1,'Enable','Off');
    set(handles.histB,'Enable','Off');
    set(handles.cumModel_ecdf,'Enable','Off');
    set(handles.checkPSO_default,'Enable','Off');
    set(handles.CheckGraph,'Enable','Off');
    set(handles.checkODA,'Enable','Off');
    set(handles.sbj,'Enable','Off');
    set(handles.var,'Enable','Off');
    set(handles.Run_button,'Enable','Off');
    %set(handles.Stop_button,'Enable','Off');
    set(handles.cumModels,'Enable','off');
    set(handles.fuzzySet,'Enable','off');
    
    prompt = {'Starting from subject:'};dlg_title = 'Input';num_lines = 1;def = {'1'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    sp=str2num(answer{1});
    
    n = (evalin('base','numSbj'));
    m = evalin('base','numItems');
    %stop=0;
    %while stop==0
        progressbar('subjects','variables')
        for i=sp:n
            for j=1:m
                %progressbar(char(['subject: ' num2str(i)]),char(['variable: ' num2str(j)]))
                if i==n && j~=m
                    progressbar([],j/m)
                elseif i~=n && j~=m
                    progressbar(i/n,j/m)
                elseif i~=n && j==m
                    progressbar(i/n,[])
                end
                [triangPoints,FNs,H,KI,HR,rsp_disc,expans,concent,mustar] = ODA(i,j,settings_par);
                if rsp_disc ~= 0
                    results.OptParameters(i,j,:) = triangPoints;
                    results.FuzzyNumber.movements(i,j,:) = FNs.movs_fs;
                    results.FuzzyNumber.final(i,j,:) = FNs.final_fs;
                    results.FuzzyEntropy.movsFS(i,j,:) = H.movs_fs;
                    results.FuzzyEntropy.finalFS(i,j,:) = H.final_fs;
                    results.FuzzIndex.movsFS(i,j,:) = KI.movs_fs;
                    results.FuzzIndex.finalFS(i,j,:) = KI.final_fs;
                    results.EntropyRatio(i,j,:) = HR;
                    %results.TimeFactors(i,j,:) = [expans concent];
                    %results.muStar(i,j,:) = mustar;
                end
%                 if get(handles.Stop_button,'UserData') == 1
%                     break
%                 end
%                 drawnow();
            end
            
            %stop=1;
        end
        assignin('base','results',results);
        close
        %sb = statusbar('STATUS: ODA completed');
        %set(sb.TextPanel, 'Foreground',[0,0,0], 'Background','white', 'ToolTipText','tool tip...')
        %set(sb, 'Background',java.awt.Color.white);
    %end
    set(handles.checkODA,'Value',0);
    set(handles.t0,'Enable','On');
    set(handles.t1,'Enable','On');
    set(handles.histB,'Enable','On');
    set(handles.cumModel_ecdf,'Enable','On');
    set(handles.checkPSO_default,'Enable','On');
    set(handles.CheckGraph,'Enable','On');
    set(handles.checkODA,'Enable','On');
    set(handles.sbj,'Enable','On');
    set(handles.var,'Enable','On');
    set(handles.Run_button,'Enable','On');
    %set(handles.Stop_button,'Enable','On');
    set(handles.cumModels,'Enable','On');
    set(handles.fuzzySet,'Enable','On');
end       




function sbj_Callback(hObject, eventdata, handles)
% hObject    handle to sbj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sbj as text
%        str2double(get(hObject,'String')) returns contents of sbj as a double


% --- Executes during object creation, after setting all properties.
function sbj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sbj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var_Callback(hObject, eventdata, handles)
% hObject    handle to var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var as text
%        str2double(get(hObject,'String')) returns contents of var as a double


% --- Executes during object creation, after setting all properties.
function var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Stop_button.
function Stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Stop_button,'UserData',1); 

