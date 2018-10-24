function varargout = wahWindow(varargin)
% WAHWINDOW Application M-file for wahWindow.fig
%    FIG = WAHWINDOW launch wahWindow GUI.
%    WAHWINDOW('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 28-Aug-2004 19:47:01

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
set(handles.window,'String',num2str(512));
set(handles.pass,'String',num2str(1));
set(handles.mix,'String',num2str(1));
set(handles.cFrequency,'String',num2str(0.2));
set(handles.fmax,'String',num2str(4800));
set(handles.fmin,'String',num2str(2700));

[x,map]=imread('wahwah','bmp');
image(x,'Parent',handles.axesSystem);
upDate(handles);

% --------------------------------------------------------------------
function process(handles)
global signalArray;
global outputSignal;
global inputSignal;
global currentSignal;

Fc= str2double( get(handles.cFrequency,'String') );
fmax= str2double( get(handles.fmax,'String') );
fmin= str2double( get(handles.fmin,'String') );
pass= str2double( get(handles.pass,'String') );
window=str2double( get(handles.window,'String') );
mix=str2double( get(handles.mix,'String') );

val1=get(handles.inputPop,'Value');
val2=get(handles.outputPop,'Value');
outputSignal=signalArray(val2);
inputSignal=signalArray(val1);

y=0;
x = inputSignal.samples;
Fs= inputSignal.samplingFrequency;
T=1/Fs;

y=wahwha(x, window, mix, Fc, Fs, fmax, fmin ,pass);

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
function varargout = Close_Callback(h, eventdata, handles, varargin)
delete(handles.wahWindow);

% --------------------------------------------------------------------
function varargout = inputPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = outputPop_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = upDate(handles)
global signalArray;

for i=1:length(signalArray)
    pointerCell(i)={[signalArray(i).Name]};
end

set(handles.inputPop,'String',pointerCell);
set(handles.outputPop,'String',pointerCell);

% --------------------------------------------------------------------
function varargout = window_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = pass_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = mix_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = cFrequency_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = fmax_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = fmin_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = processEffect_Callback(h, eventdata, handles, varargin)
process(handles);