function [y,Fs,genOut] = basicSignals(varargin)
% BASICSIGNALS Application M-file for basicSignals.fig
%    FIG = BASICSIGNALS launch basicSignals GUI.
%    BASICSIGNALS('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 21-Aug-2004 03:36:14

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    global y;
    global Fs;
    global genOut;
    
    loadData(handles);

	% Wait for callbacks to run and window to be dismissed:
	uiwait(fig);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
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


% 1:Sine  2:Cosine  3:Square  4:Triangular  5:Pulse  6:Step function 
% 7:Unit impulse   8:Ramp function    9:Exponential function

% --------------------------------------------------------------------
function loadData(handles)

set(handles.frequency,'String',num2str(1000));
set(handles.duration,'String',num2str(0.1));
set(handles.amplitude,'String',num2str(1));
set(handles.sFrequency,'String',num2str(44100));

% --------------------------------------------------------------------
function varargout = sineFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.rampFunction,handles.exponentialFunction,handles.cosineFunction,handles.squareFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = cosineFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.rampFunction,handles.exponentialFunction,handles.sineFunction,handles.squareFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = squareFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.rampFunction,handles.sineFunction,handles.cosineFunction,handles.exponentialFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = triangleFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.rampFunction,handles.sineFunction,handles.cosineFunction,handles.squareFunction,handles.exponentialFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = pulseFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.rampFunction,handles.sineFunction,handles.cosineFunction,handles.squareFunction,handles.triangleFunction,handles.exponentialFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = stepFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.rampFunction,handles.exponentialFunction,handles.sineFunction,handles.cosineFunction,handles.squareFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = impulseFunction_Callback(h, eventdata, handles, varargin)
off = [handles.stepFunction,handles.rampFunction,handles.exponentialFunction,handles.sineFunction,handles.cosineFunction,handles.squareFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = rampFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.exponentialFunction,handles.sineFunction,handles.cosineFunction,handles.squareFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function varargout = exponentialFunction_Callback(h, eventdata, handles, varargin)
off = [handles.impulseFunction,handles.stepFunction,handles.rampFunction,handles.sineFunction,handles.cosineFunction,handles.squareFunction,handles.triangleFunction,handles.pulseFunction];
mutual_exclude(off);
gen(handles);

% --------------------------------------------------------------------
function mutual_exclude(off)
set(off,'Value',0)

% --------------------------------------------------------------------
function gen(handles)
global y;
global Fs;
global genOut;

y=0;
Fs=0;
type=10;
genOut=0;

if (get(handles.sineFunction,       'Value') == 1) type=1; end;
if (get(handles.cosineFunction,     'Value') == 1) type=2; end;
if (get(handles.squareFunction,     'Value') == 1) type=3; end;
if (get(handles.triangleFunction,   'Value') == 1) type=4; end;
if (get(handles.pulseFunction,      'Value') == 1) type=5; end;
if (get(handles.stepFunction,       'Value') == 1) type=6; end;
if (get(handles.impulseFunction,    'Value') == 1) type=7; end;
if (get(handles.rampFunction,       'Value') == 1) type=8; end;
if (get(handles.exponentialFunction,'Value') == 1) type=9; end;

if type~=10
    
if strncmpi(handles.frequency,'Empty',2)==0 & strncmpi(handles.sFrequency,'Empty',2)==0 & strncmpi(handles.duration,'Empty',2)==0 & strncmpi(handles.amplitude,'Empty',2)==0
    
    y = generator(type,str2double( get(handles.frequency,'String') ),str2double( get(handles.duration,'String') ),str2double( get(handles.amplitude,'String') ),str2double( get(handles.sFrequency,'String') ) );
    Fs= str2double( get(handles.sFrequency,'String') );
    set(handles.noSamples,'String',num2str(length(y)));
    genOut=1;
    
else    
    errordlg('Information Incomplete: Frequency/Duration/Amplitude/sFrequency','Signal Name Error'); 
end;

end;

% --------------------------------------------------------------------
function varargout = frequency_Callback(h, eventdata, handles, varargin)
gen(handles);

% --------------------------------------------------------------------
function varargout = duration_Callback(h, eventdata, handles, varargin)
gen(handles);

% --------------------------------------------------------------------
function varargout = amplitude_Callback(h, eventdata, handles, varargin)
gen(handles);

% --------------------------------------------------------------------
function varargout = sFrequency_Callback(h, eventdata, handles, varargin)
gen(handles);

% --------------------------------------------------------------------
function varargout = noSamples_Callback(h, eventdata, handles, varargin)
gen(handles);

% --------------------------------------------------------------------
function varargout = close_Callback(h, eventdata, handles, varargin)
global y;
global Fs;
global genOut;

y=0;
Fs=0;
genOut=0;

delete(handles.basicSignals);

% --------------------------------------------------------------------
function varargout = ok_Callback(h, eventdata, handles, varargin)
if (str2double( get(handles.frequency,'String') )*2) > str2double( get(handles.sFrequency,'String') )
    errordlg('Sampling Frequency should be at least f*2','Frequency Error');  
else
    gen(handles);
    delete(handles.basicSignals);
end;