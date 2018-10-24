function varargout = signalProperty(varargin)
% SIGNALPROPERTY Application M-file for signalProperty.fig
%    FIG = SIGNALPROPERTY launch signalProperty GUI.
%    SIGNALPROPERTY('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 28-Aug-2004 18:55:49

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    global water;
           water.start=256;
           water.steps=256;
           water.N=512;
           water.clippingpoint=20;
           water.baseplane=-100;
           water.EL=40;
           water.AZ=20;
    global nFFT;
           nFFT=256;    
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




% --------------------------------------------------------------------
function loadData(handles)
global currentSignal;
global nFFT;

     % --------------------------------------------  
     set(handles.currentSignal,'String',currentSignal.Name);
     set(handles.tDisplay,'String',num2str(length(currentSignal.samples)/currentSignal.samplingFrequency));
     set(handles.displayMagnitudeFrequency,'String',num2str(currentSignal.samplingFrequency/2));
     set(handles.displayPhaseFrequency,'String',num2str(currentSignal.samplingFrequency/2));
     set(handles.nFFT,'String',num2str(nFFT));
     
     set(handles.signalTimePrefix,'Value',2);
     set(handles.magnitudeFrequencyPrefix,'Value',2);
     set(handles.phaseFrequencyPrefix,'Value',2);
     
     makeSignalGraph(handles);     
     makePhaseGraph(handles);
     makeMagnitudeGraph(handles);
     makeWaterGraph(handles);

     
% --------------------------------------------------------------------
function varargout = tDisplay_Callback(h, eventdata, handles, varargin)
makeSignalGraph(handles);

% --------------------------------------------------------------------
function varargout = displayMagnitudeFrequency_Callback(h, eventdata, handles, varargin)
makeMagnitudeGraph(handles);

% --------------------------------------------------------------------
function varargout = displayPhaseFrequency_Callback(h, eventdata, handles, varargin)
makePhaseGraph(handles);

% --------------------------------------------------------------------
function varargout = mDecibel_Callback(h, eventdata, handles, varargin)
makeMagnitudeGraph(handles);

% --------------------------------------------------------------------
function varargout = magnitudeSide_Callback(h, eventdata, handles, varargin)
makeMagnitudeGraph(handles);

% --------------------------------------------------------------------
function varargout = phaseSide_Callback(h, eventdata, handles, varargin)
makePhaseGraph(handles);

% --------------------------------------------------------------------
function varargout = angle_Callback(h, eventdata, handles, varargin)
makePhaseGraph(handles);

% --------------------------------------------------------------------
function varargout = signalTimePrefix_Callback(h, eventdata, handles, varargin)
makeSignalGraph(handles);

% --------------------------------------------------------------------
function varargout = magnitudeFrequencyPrefix_Callback(h, eventdata, handles, varargin)
 makeMagnitudeGraph(handles);

% --------------------------------------------------------------------
function varargout = phaseFrequencyPrefix_Callback(h, eventdata, handles, varargin)
makePhaseGraph(handles);


% --------------------------------------------------------------------
function makeSignalGraph(handles)
global currentSignal;
     Fs=currentSignal.samplingFrequency;
     y=currentSignal.samples;  

% if length(y)<str2double( get(handles.tDisplay,'String') )*Fs 
%          errordlg('Limits of signal is less then "display time set" ','Display time Error'); 
% else
     pre=getPrefix( get(handles.signalTimePrefix,'Value') );
     t=[0:1:(str2double( get(handles.tDisplay,'String') )*Fs)];
%      X=pre*t(1:length(y)) /Fs;
%      Y=y( t(1:length(y)) +1);
     X=(pre/Fs)*t;
     Y=y( t(1:length(t)) +1);
     size(X);
     size(Y);
     plot(X,Y,'Parent',handles.signalAxes);     
% end; 
     set(handles.signalAxes,'XGrid','on','YGrid','on');
     set(get(handles.signalAxes,'Title'),'String','Signal');
     set(get(handles.signalAxes,'XLabel'),'String','Time');
     set(get(handles.signalAxes,'YLabel'),'String','Amplitude');
     
% --------------------------------------------------------------------
function makeWaterGraph(handles)
global currentSignal;
global water;

     Fs=currentSignal.samplingFrequency;
     y=currentSignal.samples;
     
     set(gcf,'CurrentAxes',handles.waterAxes);

     waterfspec(y,water.start,water.steps,water.N,Fs,water.clippingpoint,water.baseplane)     
       
     view(handles.waterAxes,water.AZ,water.EL);
     set(handles.waterAxes,'DrawMode','fast');
     set(handles.waterAxes,'Ydir','reverse'); 
%    set(handles.waterAxes,'XGrid','on','YGrid','on','ZGrid','on');
     set(get(handles.waterAxes,'Title'),'String','Waterfall Representation of Short-time FFTs');
     set(get(handles.waterAxes,'XLabel'),'String','f in Hz \rightarrow');
     set(get(handles.waterAxes,'YLabel'),'String','n \rightarrow');
     set(get(handles.waterAxes,'ZLabel'),'String','Magnitude in dB \rightarrow');


% --------------------------------------------------------------------
function makeMagnitudeGraph(handles)
global currentSignal;

Fmax=str2double( get(handles.displayMagnitudeFrequency,'string') );

if Fmax > currentSignal.samplingFrequency/2
    errordlg('Limits of signal is less then "display FRequency set" ','Display Frequency Error');
else
     
     y=currentSignal.samples;
     Y= abs(fft(y));  % frequency domain 
     Nf=length(Y);    % length of frequency domain signal
        
     if get(handles.mDecibel,'Value')==1 Y=10*log(Y); end;

     % Side==1 single sided spectrum must be mult by 2 
     % side==2 double sided spectrum 
     if(get(handles.magnitudeSide,'Value')==1) 
         Y=2 * Y( 1:floor(Nf/2) );                   
         F=linspace(0,Fmax/2,floor(Nf/2))*getPrefix(get(handles.magnitudeFrequencyPrefix,'Value'));
     end; 
     
     if(get(handles.magnitudeSide,'Value')==2) 
         Y=[Y(floor(Nf/2):-1:1) Y( 1:floor(Nf/2) )]; 
         F=linspace(-Fmax/2,Fmax/2,length(Y))*getPrefix(get(handles.magnitudeFrequencyPrefix,'Value'));
     end;    
     
     plot(F,Y,'Parent',handles.magnitudeAxes);
 end
 
     set(handles.magnitudeAxes,'XGrid','on','YGrid','on');
     set(get(handles.magnitudeAxes,'Title'),'String','Magnitude Spectrum');
     set(get(handles.magnitudeAxes,'XLabel'),'String','Frequency');
     set(get(handles.magnitudeAxes,'YLabel'),'String','Magnitude |Y(f)|');

     
% --------------------------------------------------------------------
function makePhaseGraph(handles)
global currentSignal;

Fmax=str2double( get(handles.displayPhaseFrequency,'string') );

if Fmax > currentSignal.samplingFrequency/2
    errordlg('Limits of signal is less then "display FRequency set" ','Display Frequency Error');
    
else
     y=currentSignal.samples;
     if(get(handles.angle,'Value')==1)Y= angle(fft(y))*180/pi ;end; % Degree 
     if(get(handles.angle,'Value')==2)Y= angle(fft(y)); end;% Radian 
     Nf=length(Y); % length of frequency domain signal
     
     % Side==1 single sided spectrum 
     % side==2 double sided spectrum 
     
     if(get(handles.phaseSide,'Value')==1) 
         Y= Y( 1:floor(Nf/2) );                      
         F=linspace(0,Fmax/2,floor(Nf/2))*getPrefix(get(handles.phaseFrequencyPrefix,'Value'));
     end; 
     
     if(get(handles.phaseSide,'Value')==2) 
         Y=[Y(floor(Nf/2):-1:1) Y( 1:floor(Nf/2) )]; 
         F=linspace(-Fmax/2,Fmax/2,length(Y))*getPrefix(get(handles.phaseFrequencyPrefix,'Value'));
     end; 
     
     plot(F,Y,'Parent',handles.phaseAxes);
 end
 
     set(handles.phaseAxes,'XGrid','on','YGrid','on');
     set(get(handles.phaseAxes,'Title'),'String','Phase Spectrum');
     set(get(handles.phaseAxes,'XLabel'),'String','Frequency');
     set(get(handles.phaseAxes,'YLabel'),'String','Phase Shift');
     
        
% --------------------------------------------------------------------
function out = getPrefix(in)
if in==1  out=1000;      end;
if in==2  out=1;         end;
if in==3  out=1/1000;    end;

% --------------------------------------------------------------------
function varargout = spectrogram_Callback(h, eventdata, handles, varargin)
global currentSignal;
global nFFT;

figure(1);
y=currentSignal.samples;
Fs=currentSignal.samplingFrequency;
SPECGRAM(y,nFFT,Fs);

% --------------------------------------------------------------------
function varargout = playSound_Callback(h, eventdata, handles, varargin)
global currentSignal;
sound(currentSignal.samples);

% --------------------------------------------------------------------
function varargout = close_Callback(h, eventdata, handles, varargin)
delete(handles.signalProperty);


% --------------------------------------------------------------------
function varargout = wControl_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
waterWindow;
guidata(gcbo,d);
makeWaterGraph(handles);


% --------------------------------------------------------------------
function varargout = nFFT_Callback(h, eventdata, handles, varargin)
global nFFT;
nFFT=str2double( get(handles.nFFT,'string') );
delete(figure(1));