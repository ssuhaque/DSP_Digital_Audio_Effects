function varargout = panoramaWindow(varargin)
% PANORAMAWINDOW Application M-file for panoramaWindow.fig
%    FIG = PANORAMAWINDOW launch panoramaWindow GUI.
%    PANORAMAWINDOW('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 28-Aug-2004 19:44:54

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    loadData(handles);
    global inputSignal;
    global outputSignal;
    
	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

% --------------------------------------------------------------------
function loadData(handles)
clc;
set(handles.seg,'String',num2str(4));
set(handles.iAngle,'String',num2str(60));
set(handles.fAngle,'String',num2str(10));
set(handles.pAngle,'String',num2str(180));
upDate(handles);

% [x,map]=imread('phaser','bmp');
% image(x,'Parent',handles.axes5);

% --------------------------------------------------------------------
function process(handles)
global signalArray;
global outputSignal;
global inputSignal;
global currentSignal;


iAngle= str2double( get(handles.iAngle,'String') );
fAngle= str2double( get(handles.fAngle,'String') );
pAngle= str2double( get(handles.pAngle,'String') );
segments=str2double( get(handles.seg,'String') );

if get(handles.rot,'Value')==1
    type=2;% rotate 
else 
    type=1;% panning
end

val1=get(handles.inputPop,'Value');
val2=get(handles.outputPop,'Value');
outputSignal=signalArray(val2);
inputSignal=signalArray(val1);

y=0;
x = inputSignal.samples;
y = pan(x,type,pAngle,iAngle,fAngle,segments);

outputSignal.samples = y;
outputSignal.samplingFrequency=inputSignal.samplingFrequency;
outputSignal.numberOfBits=inputSignal.numberOfBits;
currentSignal=outputSignal;
fileproperty; % Setting Name of Signal
outputSignal=currentSignal;
signalArray(val2)=outputSignal;
upDate(handles);

% Angles are in degrees 

% --------------------------------------------------------------------
function varargout = SDirectory_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
signalDirectory;
guidata(gcbo,d);
upDate(handles);

% --------------------------------------------------------------------
function varargout = Close_Callback(h, eventdata, handles, varargin)
delete(handles.panoramaWindow);

% --------------------------------------------------------------------
function varargout = upDate(handles)
global signalArray;

for i=1:length(signalArray)
    pointerCell(i)={[signalArray(i).Name]};
end

set(handles.inputPop,'String',pointerCell);
set(handles.outputPop,'String',pointerCell);

% --------------------------------------------------------------------
function varargout = pAngle_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = iAngle_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = fAngle_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = seg_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = inputPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = outputPop_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = rot_Callback(h, eventdata, handles, varargin)
set(handles.pan,'Value',0);
set(handles.pAngle,'Enable','off');

set(handles.rot,'Value',1);
set(handles.iAngle,'Enable','on');
set(handles.fAngle,'Enable','on');
set(handles.seg,'Enable','on');

% --------------------------------------------------------------------
function varargout = pan_Callback(h, eventdata, handles, varargin)

set(handles.pan,'Value',1);
set(handles.pAngle,'Enable','on');

set(handles.rot,'Value',0);
set(handles.iAngle,'Enable','off');
set(handles.fAngle,'Enable','off');
set(handles.seg,'Enable','off');

% --------------------------------------------------------------------
function varargout = processEffect_Callback(h, eventdata, handles, varargin)
process(handles);