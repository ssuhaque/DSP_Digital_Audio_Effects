function varargout = DAFX(varargin)
% DAFX Application M-file for DAFX.fig
%    FIG = DAFX launch DAFX GUI.
%    DAFX('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 21-Aug-2004 21:24:41

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    % warning off MATLAB:divideByZero;
    clc;
    
    global emptySignal;
           emptySignal.Name='Empty';
           emptySignal.fileName='';
           emptySignal.path='';
           emptySignal.samples=0;
           emptySignal.numberOfSamples=0;
           emptySignal.samplingFrequency=0;
           emptySignal.numberOfBits=0;
           emptySignal.firstSample=0;
           emptySignal.lastSample=0;
           emptySignal.info=0;
           emptySignal.amplifier=1; 
    
    global signalArray; signalArray=emptySignal;
    global currentSignal; currentSignal=emptySignal;
    global q;
    global w;
           
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


% wavplay  Play sound on PC-based audio output device  Amplitude values are in the range [-1,+1].
% wavread  Read Microsoft WAVE (.wav) sound file
% wavrecord  Record sound using PC-based audio input device
% wavwrite  Write Microsoft WAVE (.wav) sound file
% newfile,newpath] = uiputfile('animinit.m','Save file name');




% --------------------------------------------------------------------
function varargout = signalDirectory_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
signalDirectory;
guidata(gcbo,d);

% --------------------------------------------------------------------
function varargout = exit_Callback(h, eventdata, handles, varargin)
delete(handles.main);

% --------------------------------------------------------------------
function varargout = phaser_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
phaserWindow;
guidata(gcbo,d);

% --------------------------------------------------------------------
function varargout = wahWah_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
wahWindow;
guidata(gcbo,d);  

% --------------------------------------------------------------------
function varargout = Tremolo_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
tremoloWindow;
guidata(gcbo,d);    

% --------------------------------------------------------------------
function varargout = ringModulation_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
ringWindow;
guidata(gcbo,d);   

% --------------------------------------------------------------------
function varargout = limiter_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
limiterWindow;
guidata(gcbo,d);   

% --------------------------------------------------------------------
function varargout = noiseGating_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
noiseWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Reverberation_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
reverbWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Overdrive_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
overdriveWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Panning_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
panoramaWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Compression_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
comWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Fuzz_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
fuzzWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = distRenderingWindow_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
distRenderingWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Fading_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
fadingWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = Echo_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
delayWindow;
guidata(gcbo,d); 

% --------------------------------------------------------------------
function varargout = pitchShifting_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
pitchWindow;
guidata(gcbo,d); 