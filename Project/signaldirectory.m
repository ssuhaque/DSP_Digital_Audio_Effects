function varargout = signalDirectory(varargin)
% SIGNALDIRECTORY Application M-file for signalDirectory.fig
%    FIG = SIGNALDIRECTORY launch signalDirectory GUI.
%    SIGNALDIRECTORY('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 10-Sep-2004 11:28:17

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    upDate(handles);

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
function varargout = pointerPopUpMenu_Callback(h, eventdata, handles, varargin)
global currentSignal;
global signalArray;

val=get(handles.pointerPopUpMenu,'Value');
currentSignal=signalArray(val);

% --------------------------------------------------------------------
function varargout = signalProperty_Callback(h, eventdata, handles, varargin)

global currentSignal;
global signalArray;

val=get(handles.pointerPopUpMenu,'Value');
currentSignal=signalArray(val);

d=guidata(gcbo);

if length(currentSignal.samples)==1 & currentSignal.samples(1)==0
           errordlg('Please Select a signal / Length of current Signal is zero','Signal Error');  
else
   if currentSignal.samplingFrequency==0
           errordlg('Please Select any other signal / S-Frequency of Signal is zero','Signal Error');  
   else signalProperty;
   end;
end;

% --------------------------------------------------------------------
function varargout = newSignal_Callback(h, eventdata, handles, varargin)
global currentSignal;
global signalArray;

d=guidata(gcbo);
newSignal;
guidata(gcbo,d);

val=get(handles.pointerPopUpMenu,'Value');
signalArray(val)=currentSignal;
upDate(handles);

% --------------------------------------------------------------------
function varargout = numberOfPointer_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = addPointer_Callback(h, eventdata, handles, varargin)
global signalArray;
global emptySignal;

oldSize=length(signalArray);
signalArray(oldSize+1)=emptySignal;
upDate(handles);

% --------------------------------------------------------------------
function varargout = deletePointer_Callback(h, eventdata, handles, varargin)
global signalArray;
global emptySignal;

val=get(handles.pointerPopUpMenu,'Value');
str=get(handles.pointerPopUpMenu,'String');

if length(str)==1
    signalArray(val) = emptySignal;
else
    signalArray(val) = [];    
end
upDate(handles);

% --------------------------------------------------------------------
function varargout = close_Callback(h, eventdata, handles, varargin)
delete(handles.signalDirectory);

% --------------------------------------------------------------------
function varargout = upDate(handles)
global signalArray;

for i=1:length(signalArray)
    pointerCell(i)={[signalArray(i).Name]};
end

set(handles.pointerPopUpMenu,'String',pointerCell);
set(handles.numberOfPointer,'String',num2str(length(pointerCell)));


% --------------------------------------------------------------------
function varargout = save_Callback(h, eventdata, handles, varargin)
d=guidata(gcbo);
fileName;
guidata(gcbo,d);
