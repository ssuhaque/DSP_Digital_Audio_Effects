function [start,steps,N,clippingpoint,baseplane,EL,AZ] = waterWindow(varargin)
% WATERWINDOW Application M-file for waterWindow.fig
%    FIG = WATERWINDOW launch waterWindow GUI.
%    WATERWINDOW('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 28-Aug-2004 05:25:43

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    loadData(handles)

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
global water;
set(handles.start,'String',num2str(water.start));
set(handles.steps,'String',num2str(water.steps));
set(handles.N,'String',num2str(water.N));
set(handles.clippingpoint,'String',num2str(water.clippingpoint));
set(handles.baseplane,'String',num2str(water.baseplane));
set(handles.EL,'String',num2str(water.EL));
set(handles.AZ,'String',num2str(water.AZ));

% --------------------------------------------------------------------
function process(handles)
global water;

water.start  = str2double( get(handles.start,'String') );
water.steps  = str2double( get(handles.steps,'String') );
water.N  = str2double( get(handles.N,'String') );
water.clippingpoint  = str2double( get(handles.clippingpoint,'String') );
water.baseplane = str2double( get(handles.baseplane,'String') ); 
water.EL = str2double( get(handles.EL,'String') );
water.AZ  = str2double( get(handles.AZ,'String') );

% --------------------------------------------------------------------
function varargout = Close_Callback(h, eventdata, handles, varargin)
process(handles);
delete(handles.waterWindow);

% --------------------------------------------------------------------
function varargout = start_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = steps_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = N_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = clippingpoint_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = baseplane_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = EL_Callback(h, eventdata, handles, varargin)
process(handles);

% --------------------------------------------------------------------
function varargout = AZ_Callback(h, eventdata, handles, varargin)
process(handles);