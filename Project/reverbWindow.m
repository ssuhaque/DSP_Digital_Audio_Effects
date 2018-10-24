function varargout = reverbWindow(varargin)
% REVERBWINDOW Application M-file for reverbWindow.fig
%    FIG = REVERBWINDOW launch reverbWindow GUI.
%    REVERBWINDOW('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 10-Sep-2004 08:30:37

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
set(handles.T60,'String',num2str(1));
set(handles.k,'String',num2str(1));
set(handles.mix,'String',num2str(0.6));
set(handles.g,'String',num2str(0.8));

set(handles.offsetAP,'String',num2str(4));

set(handles.offsetComb1,'String',num2str(50));
set(handles.offsetComb2,'String',num2str(56));
set(handles.offsetComb3,'String',num2str(61));
set(handles.offsetComb4,'String',num2str(68));
set(handles.offsetComb5,'String',num2str(72));
set(handles.offsetComb6,'String',num2str(78));

set(handles.g1,'String',num2str(4));
set(handles.g2,'String',num2str(4));
set(handles.g3,'String',num2str(4));
set(handles.g4,'String',num2str(4));
set(handles.g5,'String',num2str(4));
set(handles.g6,'String',num2str(4));

set(handles.a1,'String',num2str(4));
set(handles.a2,'String',num2str(4));
set(handles.a3,'String',num2str(4));
set(handles.a4,'String',num2str(4));
set(handles.a5,'String',num2str(4));

set(handles.n1,'String',num2str(1));
set(handles.n2,'String',num2str(2));
set(handles.n3,'String',num2str(3));
set(handles.n4,'String',num2str(4));
set(handles.n5,'String',num2str(5));
upDate(handles);

[x,map]=imread('moorer','bmp');
image(x,'Parent',handles.axesReverb);

% --------------------------------------------------------------------
function process(handles)
global signalArray;
global outputSignal;
global inputSignal;
global currentSignal;


T60= str2double( get(handles.T60,'String') );
k = str2double( get(handles.k,'String') );
g = str2double( get(handles.g,'String') );
mix= str2double( get(handles.mix,'String') );

offsetAP = str2double( get(handles.offsetAP,'String') );
offsetComb(1) = str2double( get(handles.offsetComb1,'String') );
offsetComb(2) = str2double( get(handles.offsetComb2,'String') );
offsetComb(3) = str2double( get(handles.offsetComb3,'String') );
offsetComb(4) = str2double( get(handles.offsetComb4,'String') );
offsetComb(5) = str2double( get(handles.offsetComb5,'String') );
offsetComb(6) = str2double( get(handles.offsetComb6,'String') );

gL(1) = str2double( get(handles.g1,'String') );
gL(2) = str2double( get(handles.g2,'String') );
gL(3) = str2double( get(handles.g3,'String') );
gL(4) = str2double( get(handles.g4,'String') );
gL(5) = str2double( get(handles.g5,'String') );
gL(6) = str2double( get(handles.g6,'String') );

n(1) = str2double( get(handles.n1,'String') );
n(2) = str2double( get(handles.n2,'String') );
n(3) = str2double( get(handles.n3,'String') );
n(4) = str2double( get(handles.n4,'String') );
n(5) = str2double( get(handles.n5,'String') );

a(1) = str2double( get(handles.a1,'String') );
a(2) = str2double( get(handles.a2,'String') );
a(3) = str2double( get(handles.a3,'String') );
a(4) = str2double( get(handles.a4,'String') );
a(5) = str2double( get(handles.a5,'String') );

val1=get(handles.inputPop,'Value');
val2=get(handles.outputPop,'Value');
outputSignal=signalArray(val2);
inputSignal=signalArray(val1);

y=0;
x = inputSignal.samples;
Fs= inputSignal.samplingFrequency;
T=1/Fs;

y=schroder(x,Fs,T60,g,gL,k,offsetComb,offsetAP,mix,n,a);
outputSignal.samples = y;
outputSignal.samplingFrequency=inputSignal.samplingFrequency;

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
delete(handles.reverbWindow);
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
function varargout = T60_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = k_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = mix_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g3_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g4_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g5_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = g6_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetComb1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetComb2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetComb3_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetComb4_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetComb5_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetComb6_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = offsetAP_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = a1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = a2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = a3_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = a4_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = a5_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = n1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = n2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = n3_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = n4_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = n5_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = processEffect_Callback(h, eventdata, handles, varargin)
process(handles);


% --------------------------------------------------------------------
function varargout = LPF_Callback(h, eventdata, handles, varargin)
delete(figure(1));
[x,map]=imread('LPF','bmp');
image(x);


% --------------------------------------------------------------------
function varargout = combF_Callback(h, eventdata, handles, varargin)
delete(figure(1));
[x,map]=imread('comb','bmp');
image(x);

% --------------------------------------------------------------------
function varargout = APF_Callback(h, eventdata, handles, varargin)
delete(figure(1));
[x,map]=imread('APF','bmp');
image(x);