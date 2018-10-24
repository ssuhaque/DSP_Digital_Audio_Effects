function varargout = delayWindow(varargin)
% DELAYWINDOW Application M-file for delayWindow.fig
%    FIG = DELAYWINDOW launch delayWindow GUI.
%    DELAYWINDOW('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 10-Sep-2004 10:03:02

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

	% Wait for callbacks to run and window to be dismissed:
	uiwait(fig);

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
set(handles.f,'String',num2str(10));
set(handles.tau,'String',num2str(15));

set(handles.Width,'String',num2str(1));
set(handles.Depth,'String',num2str(1));
set(handles.Delay,'String',num2str(25));
set(handles.vType,'Value',1);
set(handles.FB,'String',num2str(1));
set(handles.FF,'String',num2str(0.5));
set(handles.BL,'String',num2str(0.5));

upDate(handles);

[x,map]=imread('multiDelay','bmp');
image(x,'Parent',handles.systemAxes);

% --------------------------------------------------------------------
function process(handles)
global signalArray;
global outputSignal;
global inputSignal;
global currentSignal;

f = str2double( get(handles.f,'String') );
v = get(handles.vType,'Value');
tau = str2double( get(handles.tau,'String') );

Delay= str2double( get(handles.Delay,'String') );
Width= str2double( get(handles.Width,'String') );
Depth = str2double( get(handles.Depth,'String') );
FB =str2double( get(handles.FB,'String') );
FF =str2double( get(handles.FF,'String') );
BL =str2double( get(handles.BL,'String') );

val1=get(handles.inputPop,'Value');
val2=get(handles.outputPop,'Value');
outputSignal=signalArray(val2);
inputSignal=signalArray(val1);

y=0;
x = inputSignal.samples;
Fs= inputSignal.samplingFrequency;

y=delayEffect(x,Fs, tau, Delay, FB, Width, Depth, f,v,FF,BL);
outputSignal.samples = y;
outputSignal.samplingFrequency=inputSignal.samplingFrequency;
outputSignal.numberOfBits=inputSignal.numberOfBits;
currentSignal=outputSignal;
fileproperty; % Setting Name of Signal
outputSignal=currentSignal;
signalArray(val2)=outputSignal;
upDate(handles);

% --------------------------------------------------------------------

function varargout = SDirectory_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
signalDirectory;
guidata(gcbo,d);
upDate(handles);

% --------------------------------------------------------------------
function varargout = upDate(handles)
global signalArray;

for i=1:length(signalArray)
    pointerCell(i)={[signalArray(i).Name]};
end

set(handles.inputPop,'String',pointerCell);
set(handles.outputPop,'String',pointerCell);

% --------------------------------------------------------------------
function varargout = f_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = Delay_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = Width_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = vType_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = tau_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = Depth_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = FB_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = FF_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = BL_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = inputPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = outputPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = Close_Callback(h, eventdata, handles, varargin)
delete(handles.delayWindow);


% --------------------------------------------------------------------
function varargout = processEffect_Callback(h, eventdata, handles, varargin)
process(handles);


% --------------------------------------------------------------------
function varargout = setting_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
settingWindow;
guidata(gcbo,d);
upDate(handles);