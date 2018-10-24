function varargout = comWindow(varargin)
% COMWINDOW Application M-file for comWindow.fig
%    FIG = COMWINDOW launch comWindow GUI.
%    COMWINDOW('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 28-Aug-2004 19:43:23

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

set(handles.CT,'String',num2str(1));
set(handles.CS,'String',num2str(1));
set(handles.tRT,'String',num2str(1));
set(handles.tAT,'String',num2str(0.001));
set(handles.tTAV,'String',num2str(1));
set(handles.tH,'String',num2str(1));
set(handles.UTH,'String',num2str(0.15));
set(handles.LTH,'String',num2str(0.1));
set(handles.pole,'String',num2str(0.997));
set(handles.comp,'String',num2str(-0.9));
upDate(handles);

[x,map]=imread('compressor','bmp');
image(x,'Parent',handles.axesSystem);

[x,map]=imread('compEXP','bmp');
image(x,'Parent',handles.axesComp);

% --------------------------------------------------------------------
function process(handles)
global signalArray;
global outputSignal;
global inputSignal;
global currentSignal;

CT= str2double( get(handles.CT,'String') );
CS= str2double( get(handles.CS,'String') );
tRT= str2double( get(handles.tRT,'String') );
tAT= str2double( get(handles.tAT,'String') );
tTAV= str2double( get(handles.tTAV,'String') );
tH = str2double( get(handles.tH,'String') );
UTH=str2double( get(handles.UTH,'String') );
LTH=str2double( get(handles.LTH,'String') );
Hoption=get(handles.Hoption,'Value');
pole=str2double( get(handles.pole,'String') );

env=get(handles.envPop,'Value');
comp=get(handles.comp,'Value');

val1=get(handles.inputPop,'Value');
val2=get(handles.outputPop,'Value');
outputSignal=signalArray(val2);
inputSignal=signalArray(val1);

y=0;
x = inputSignal.samples;
Fs= inputSignal.samplingFrequency;
T=1/Fs;

y = Compressor(x,T,CT,CS,tRT,tAT,tTAV,tH,UTH,LTH,Fs,Hoption,env,pole,comp);

outputSignal.samples = y;
outputSignal.samplingFrequency=inputSignal.samplingFrequency;
outputSignal.numberOfBits=inputSignal.numberOfBits;
currentSignal=outputSignal;
fileproperty; % Setting Name of Signal
outputSignal=currentSignal;
signalArray(val2)=outputSignal;
upDate(handles);

% x - Input Signal 
% T - Sampling period

% CT - Compressor Threshold 
% CS - Compressor Slope factor 

% tRT - Release Time 
% tAT - Attack Time 
% tTAV - Averaging Time 

% tH - Hold Time (for hysterisis function) 
% UTH - Upper Threshold (for hysterisis function) 
% LTH - Lower THreshold (for hysterisis function) 

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
function varargout = processEffect_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = T_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = LT_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = LS_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = tRT_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = tAT_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = tTAV_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = tH_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = UTH_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = LTH_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = envPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = pole_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = comp_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = inputPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = outputPop_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = Hoption_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = Close_Callback(h, eventdata, handles, varargin)
delete(handles.comWindow);