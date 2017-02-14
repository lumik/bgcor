function varargout = bgcor(varargin)
% BGCOR M-file for bgcor.fig
%      BGCOR, by itself, creates a new BGCOR or raises the existing
%      singleton*.
%
%      H = BGCOR returns the handle to a new BGCOR or the handle to
%      the existing singleton*.
%
%      BGCOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BGCOR.M with the given input arguments.
%
%      BGCOR('Property','Value',...) creates a new BGCOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bgcor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bgcor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bgcor

% Last Modified by GUIDE v2.5 25-Jan-2017 15:08:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bgcor_OpeningFcn, ...
                   'gui_OutputFcn',  @bgcor_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bgcor is made visible.
function bgcor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bgcor (see VARARGIN)

% Choose default command line output for bgcor
handles.output = hObject;

% functional handles
h=bgcor_functions;
[handles.bgcor_load, handles.get_absolute_path, handles.find_number, handles.autoload, handles.shiftscale,...
    handles.faktorka, handles.same_scale, handles.construct_weight, handles.polybase, handles.residuum,...
    handles.lmmin] = h{:};

set(handles.main_figure, 'toolbar', 'figure');
handles.settings_figure = [];

set(handles.select_spec_panel, 'Title', 'Select spectrum', 'Units', 'normalized', 'Position', [.05 .93 .4 .057]);
set(handles.chosen_spec_text, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [.47 .15 .5 .8],...
    'String', 'Chosen spectrum:', 'Parent', handles.select_spec_panel, 'BackgroundColor', 'green',...
    'Enable', 'inactive');
set(handles.choose_spec_pushbutton, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [.02 .15 .13 .8],...
    'String' , '#', 'Parent', handles.select_spec_panel, 'TooltipString', 'Will chose one spectrum',...
    'FontSize', 10, 'Enable', 'off');
set(handles.down_pushbutton, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [.17 .15 .13 .8],...
    'String', '<', 'Parent', handles.select_spec_panel, 'TooltipString', 'Will chose one spectrum',...
    'FontSize', 10, 'Enable', 'off');
set(handles.up_pushbutton, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [.32 .15 .13 .8],...
    'String', '>', 'Parent', handles.select_spec_panel, 'TooltipString', 'Will chose one spectrum',...
    'FontSize', 10, 'Enable', 'off');

handles.bg(1).slider_min_init = 0.5;
handles.bg(1).slider_max_init = 1.5;
handles.bg(1).slider_step_init = 0.01;
handles.bg(1).slider_pos_init = 1;
handles.bg(2).slider_min_init = 0.5;
handles.bg(2).slider_max_init = 1.5;
handles.bg(2).slider_step_init = 0.01;
handles.bg(2).slider_pos_init = 1;
handles.bg(3).slider_min_init = 0.5;
handles.bg(3).slider_max_init = 1.5;
handles.bg(3).slider_step_init = 0.01;
handles.bg(3).slider_pos_init = 1;
handles.x_slider_min_init = -1;
handles.x_slider_max_init = 1;
handles.x_slider_step_init = 0.01;
handles.x_slider_pos_init = 0;

set(handles.manual_adjustment_panel, 'Title', 'Manual adjustment',...
    'Units', 'normalized', 'Position',[.47,.93,.25,.057]);
set(handles.bg1_manual_adjustment_checkbox, 'String', 'bg1', 'Units', 'pixels', 'Position', [6 5 44 23],...
    'Parent', handles.manual_adjustment_panel, 'Value', 0, 'Enable', 'off');
set(handles.bg2_manual_adjustment_checkbox, 'String', 'bg2', 'Units', 'pixels', 'Position', [50 5 44 23],...
    'Parent', handles.manual_adjustment_panel, 'Value', 0, 'Enable', 'off');
set(handles.bg3_manual_adjustment_checkbox, 'String', 'bg3', 'Units', 'pixels', 'Position', [100 5 44 23],...
    'Parent', handles.manual_adjustment_panel, 'Value', 0, 'Enable', 'off');
set(handles.x_manual_adjustment_checkbox, 'String', 'x-shift', 'Units', 'pixels', 'Position', [150 5 65 23],...
    'Parent', handles.manual_adjustment_panel, 'Value', 0, 'Enable', 'off');

set(handles.bg1_slider, 'Min', handles.bg(1).slider_min_init, 'Max', handles.bg(1).slider_max_init,...
    'Value', handles.bg(1).slider_pos_init, 'SliderStep', [handles.bg(1).slider_step_init, 0.1], 'Enable', 'off',...
    'Units', 'normalized');
set(handles.bg1_slider_text, 'String', 'bg1');
set(handles.bg1_slider_panel, 'Title', 'bg1 slider settings', 'Units', 'normalized')
set(handles.bg1_slider_pos_text, 'Parent', handles.bg1_slider_panel, 'String', 'Pos')
set(handles.bg1_slider_pos_edit, 'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_pos_init), 'Enable', 'off')
set(handles.bg1_slider_min_text, 'Parent', handles.bg1_slider_panel, 'String', 'Min')
set(handles.bg1_slider_min_edit, 'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_min_init), 'Enable', 'off')
set(handles.bg1_slider_max_text, 'Parent', handles.bg1_slider_panel, 'String', 'Max')
set(handles.bg1_slider_max_edit, 'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_max_init), 'Enable', 'off')
set(handles.bg1_slider_step_text, 'Parent', handles.bg1_slider_panel, 'String', 'Step (%)')
set(handles.bg1_slider_step_edit, 'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_step_init), 'Enable', 'off')

set(handles.bg2_slider, 'Min', handles.bg(2).slider_min_init, 'Max', handles.bg(2).slider_max_init,...
    'Value', handles.bg(2).slider_pos_init, 'SliderStep', [handles.bg(2).slider_step_init, 0.1], 'Enable', 'off',...
    'Units', 'normalized');
set(handles.bg2_slider_text, 'String', 'bg2');
set(handles.bg2_slider_panel, 'Title', 'bg2 slider settings', 'Units', 'normalized')
set(handles.bg2_slider_pos_text, 'Parent', handles.bg2_slider_panel, 'String', 'Pos')
set(handles.bg2_slider_pos_edit, 'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_pos_init), 'Enable', 'off')
set(handles.bg2_slider_min_text, 'Parent', handles.bg2_slider_panel, 'String', 'Min')
set(handles.bg2_slider_min_edit, 'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_min_init), 'Enable', 'off')
set(handles.bg2_slider_max_text, 'Parent', handles.bg2_slider_panel, 'String', 'Max')
set(handles.bg2_slider_max_edit, 'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_max_init), 'Enable', 'off')
set(handles.bg2_slider_step_text, 'Parent', handles.bg2_slider_panel, 'String', 'Step (%)')
set(handles.bg2_slider_step_edit, 'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_step_init), 'Enable', 'off')

set(handles.bg3_slider, 'Min', handles.bg(3).slider_min_init, 'Max', handles.bg(3).slider_max_init,...
    'Value', handles.bg(3).slider_pos_init, 'SliderStep', [handles.bg(3).slider_step_init, 0.1], 'Enable', 'off',...
    'Units', 'normalized');
set(handles.bg3_slider_text, 'String', 'bg3');
set(handles.bg3_slider_panel, 'Title', 'bg3 slider settings', 'Units', 'normalized')
set(handles.bg3_slider_pos_text, 'Parent', handles.bg3_slider_panel, 'String', 'Pos')
set(handles.bg3_slider_pos_edit, 'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_pos_init), 'Enable', 'off')
set(handles.bg3_slider_min_text, 'Parent', handles.bg3_slider_panel, 'String', 'Min')
set(handles.bg3_slider_min_edit, 'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_min_init), 'Enable', 'off')
set(handles.bg3_slider_max_text, 'Parent', handles.bg3_slider_panel, 'String', 'Max')
set(handles.bg3_slider_max_edit, 'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_max_init), 'Enable', 'off')
set(handles.bg3_slider_step_text, 'Parent', handles.bg3_slider_panel, 'String', 'Step (%)')
set(handles.bg3_slider_step_edit, 'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_step_init), 'Enable', 'off')

set(handles.x_slider, 'Min', handles.x_slider_min_init, 'Max', handles.x_slider_max_init,...
    'Value', handles.x_slider_pos_init, 'SliderStep', [handles.x_slider_step_init, 0.1], 'Enable', 'off',...
    'Units', 'normalized');
set(handles.x_slider_panel, 'Title', 'x slider settings', 'Units', 'normalized')
set(handles.x_slider_pos_text, 'Parent', handles.x_slider_panel, 'String', 'Pos')
set(handles.x_slider_pos_edit, 'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_pos_init), 'Enable', 'off')
set(handles.x_slider_min_text, 'Parent', handles.x_slider_panel, 'String', 'Min')
set(handles.x_slider_min_edit, 'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_min_init), 'Enable', 'off')
set(handles.x_slider_max_text, 'Parent', handles.x_slider_panel, 'String', 'Max')
set(handles.x_slider_max_edit, 'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_max_init), 'Enable', 'off')
set(handles.x_slider_step_text, 'Parent', handles.x_slider_panel, 'String', 'Step (%)')
set(handles.x_slider_step_edit, 'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_step_init), 'Enable', 'off')

set(handles.cor_axes, 'Units', 'normalized');
set(handles.orig_axes, 'Units', 'normalized');
set(handles.main_figure, 'Resize', 'on');
set(handles.bg1_slider_text, 'Units', 'normalized');
set(handles.bg2_slider_text, 'Units', 'normalized');
set(handles.bg3_slider_text, 'Units', 'normalized');

handles.data_loaded = 0;

handles.current_directory = pwd; % nastaveni aktualniho adresare
handles.filepath = handles.current_directory;
handles.filename = '';

handles.spectra_orig = zeros(2,2);
handles.spectra_xshifted = handles.spectra_orig;
handles.N_spectra = 1;
handles.chosen_spectrum = 1;

% handles.important_intervals = [400, 2000, 1e1];
% handles.important_intervals = ...
%                       [1200, 1750    1e-3
% %                        2800, 2900    1e-3
%                        2100, 2300    1e1
% %                        2890, 2910    1e-2
%                        2932, 2940    3e-3
% %                        2920, 3025    1e3
% %                        2950, 2970    1e1
% %                        3010, 3030    2e-2
%                        ];
                   
handles.bg_shiftscale_polydeg = 3;
handles.bg_shiftscale_bg1int = [2900, 2950];
handles.bg_shiftscale_polyint = [2900, 2910, 2960, 2970];
handles.bg_shiftscale = 0;
                  
handles.sumfunc = @(vector) sum(vector.^2);

handles.doublefit = 0;
handles.fitinterval = [0, 1e4];
handles.important_intervals = [];
handles.polysize = 0;
handles.coef = 1e2;

handles.bg(1).use = 0;
handles.bg(1).root_name = 'background\background1';
handles.bg(1).fn_ext = '.txt';
handles.bg(1).fn_exact = 0;
handles.bg(1).fn_no_ind = 0;
handles.bg(1).manual_scale_init = 0;
handles.bg(1).loaded = 0;

handles.bg(2).use = 0;
handles.bg(2).root_name = 'background\background2';
handles.bg(2).fn_ext = '.txt';
handles.bg(2).fn_exact = 0;
handles.bg(2).fn_no_ind = 0;
handles.bg(2).manual_scale_init = 0;
handles.bg(2).loaded = 0;

handles.bg(3).use = 0;
handles.bg(3).root_name = 'background\background3';
handles.bg(3).fn_ext = '.txt';
handles.bg(3).fn_exact = 0;
handles.bg(3).fn_no_ind = 0;
handles.bg(3).manual_scale_init = 0;
handles.bg(3).loaded = 0;

handles.bg_use_flags = false(length(handles.bg), 1);
handles.bg_use = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bgcor wait for user response (see UIRESUME)
% uiwait(handles.main_figure);


% --- Outputs from this function are returned to the command line.
function varargout = bgcor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_menuitem_Callback(hObject, eventdata, handles)
% hObject    handle to load_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\nLoading new file...\n');
filter_spec={'*.*','All Files (*.*)';
             '*.mat','MAT-files (*.mat)';
             '*.txt;*.dat','text files (*.txt,*.dat)'}; 
[status, spc_fn, curr_path, data_orig] = handles.bgcor_load(0, handles.current_directory, filter_spec,...
    'Load Data', 'Off');
if status==0 % error during data load   
    h_errordlg=errordlg('No data loaded or invalid format of data !', 'loading data');
    waitfor(h_errordlg);
    return
end

set(handles.bg1_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.bg1_slider, 'Enable', 'off');
set(handles.bg1_slider_pos_text, 'Enable', 'off')
set(handles.bg1_slider_min_edit, 'Enable', 'off')
set(handles.bg1_slider_max_edit, 'Enable', 'off')
set(handles.bg1_slider_step_edit, 'Enable', 'off')
set(handles.bg2_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.bg2_slider, 'Enable', 'off');
set(handles.bg2_slider_pos_text, 'Enable', 'off')
set(handles.bg2_slider_min_edit, 'Enable', 'off')
set(handles.bg2_slider_max_edit, 'Enable', 'off')
set(handles.bg2_slider_step_edit, 'Enable', 'off')
set(handles.bg3_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.bg3_slider, 'Enable', 'off');
set(handles.bg3_slider_pos_text, 'Enable', 'off')
set(handles.bg3_slider_min_edit, 'Enable', 'off')
set(handles.bg3_slider_max_edit, 'Enable', 'off')
set(handles.bg3_slider_step_edit, 'Enable', 'off')
set(handles.x_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.x_slider, 'Enable', 'off');
set(handles.x_slider_pos_text, 'Enable', 'off')
set(handles.x_slider_min_edit, 'Enable', 'off')
set(handles.x_slider_max_edit, 'Enable', 'off')
set(handles.x_slider_step_edit, 'Enable', 'off')

handles.data_orig = data_orig;
handles.N_spectra = size(handles.data_orig,2) - 1;

skip_number = 0;
all_settings = [];
for ii = 1:length(handles.bg)
    handles.bg(ii).loaded = 0; % initialize flag, which indicates, if the background was loaded
    all_settings(ii).use = handles.bg(ii).use;
    if all_settings(end).use
        handles.bg(ii).abs_root_name = handles.get_absolute_path(...
            handles.bg(ii).root_name, curr_path);
        all_settings(ii).root_name = handles.bg(ii).abs_root_name;
        all_settings(ii).exact = handles.bg(ii).fn_exact;
        if handles.bg(ii).fn_no_ind
            all_settings(ii).number = handles.find_number(spc_fn, handles.bg(ii).fn_no_ind);
            if isempty(all_settings(ii).number)
                if ~skip_number
                    h_warndlg=warndlg(...
                        sprintf(['A number with index %d was not found in the file:\n%s\n',...
                                 'Skipping. For more inforamtion see settings menu.\n'],...
                                handles.bg(ii).fn_no_ind, spc_fn));
                    waitfor(h_warndlg);
                    skip_number = 1;
                end
                all_settings(ii).number = [];
            end
        else
            all_settings(ii).number = [];
        end
        all_settings(ii).extension = handles.bg(ii).fn_ext;
    end
end

[statuses, spectra] = handles.autoload(all_settings);

for ii = 1:length(handles.bg)
    if statuses(ii) == 4
        handles.bg(ii).loaded = 0;
    elseif statuses(ii) > 0
        [status, bg_fn, bg_path, data_bg] = handles.bgcor_load(0, curr_path, filter_spec,...
            sprintf('Load Background no. %d', ii), 'Off');
        if status==0 % error during data load
            h_errordlg=errordlg(sprintf('No data loaded or invalid format of data! Skipping background no. %d.', ii),...
                sprintf('loading bacground %d', ii));
            waitfor(h_errordlg);
            handles.bg(ii).loaded = 0;
        else
            handles.bg(ii).loaded = 1;    
            handles.bg(ii).orig = data_bg;
        end
    elseif statuses(ii) == 0
        handles.bg(ii).orig = spectra{ii};
        handles.bg(ii).loaded = 1;
    end
end


% flags for using background
bg_use_flags = false(length(handles.bg), 1);
for ii = 1:length(handles.bg)
    if handles.bg(ii).use && handles.bg(ii).loaded
        bg_use_flags(ii) = 1;
    else
        bg_use_flags(ii) = 0;
    end
end
bg_use = 1:length(handles.bg);
bg_use = bg_use(bg_use_flags);
handles.bg_use_flags = bg_use_flags;
handles.bg_use = bg_use;

handles.data_loaded = 1;

handles.chosen_spectrum = 1;

for ii = 1:length(handles.bg)
    handles.bg(ii).manual_scale = ones(handles.N_spectra, 1) * handles.bg(ii).manual_scale_init;
    handles.bg(ii).slider_pos = ones(handles.N_spectra, 1) * handles.bg(ii).slider_pos_init;
    handles.bg(ii).slider_min = ones(handles.N_spectra, 1) * handles.bg(ii).slider_min_init;
    handles.bg(ii).slider_max = ones(handles.N_spectra, 1) * handles.bg(ii).slider_max_init;
    handles.bg(ii).slider_step = ones(handles.N_spectra, 1) * handles.bg(ii).slider_step_init;
end
handles.x_scale_manual = zeros(handles.N_spectra, 1);
handles.x_slider_pos = ones(handles.N_spectra, 1) * handles.x_slider_pos_init;
handles.x_slider_min = ones(handles.N_spectra, 1) * handles.x_slider_min_init;
handles.x_slider_max = ones(handles.N_spectra, 1) * handles.x_slider_max_init;
handles.x_slider_step = ones(handles.N_spectra, 1) * handles.x_slider_step_init;

handles.treatdata_waitbar = waitbar(0, 'Fitting background to spectra. Please wait...');
guidata(hObject, handles);
shiftscomp(hObject);
treatdata(hObject);
handles = guidata(hObject);

if handles.bg_use_flags(1)
    set(handles.bg1_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_flags(2)
    set(handles.bg2_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_flags(3)
    set(handles.bg3_manual_adjustment_checkbox, 'Enable', 'on');
end
set(handles.x_manual_adjustment_checkbox, 'Enable', 'on');

set(handles.down_pushbutton,'Enable','off');
if(handles.N_spectra == 1)
    set(handles.up_pushbutton,'Enable','off');
else
    set(handles.up_pushbutton,'Enable','on');
end
set(handles.chosen_spec_text, 'String', sprintf('Chosen spectrum: %d', handles.chosen_spectrum));

handles.filepath = curr_path;
handles.current_directory = curr_path;
handles.filename = spc_fn;
close(handles.treatdata_waitbar);
guidata(hObject, handles)

change_spectrum(hObject);


% --------------------------------------------------------------------
function shiftscomp(hObject)
% hObject    handle to figure

handles = guidata(hObject);

if handles.bg_shiftscale && handles.bg_use_flags(1)
    [data_orig, handles.xshifts, handles.shiftscale_polypar] = handles.shiftscale(...
        handles.data_orig, handles.bg(1).orig, handles.bg_shiftscale_polydeg, handles.bg_shiftscale_bg1int,...
        handles.bg_shiftscale_polyint);
else
    data_orig = handles.data_orig;
    handles.xshifts = zeros(handles.N_spectra, 1);
    handles.shiftscale_polypar = 0;
end
bg_use = handles.bg_use;

same_scale_spectra = cell(1, length(bg_use) + 1);
for ii = 1:length(bg_use)
    same_scale_spectra{ii} = handles.bg(bg_use(ii)).orig;
end
same_scale_spectra{end} = data_orig;
trimmed_spectra = handles.same_scale(same_scale_spectra);

for ii = 1:length(bg_use)
    handles.bg(bg_use(ii)).spc = trimmed_spectra{ii};
end
data_orig = trimmed_spectra{end};

handles.x_scale = data_orig(:,1);
handles.spectra_orig = data_orig(:,2:end);
handles.spectra_xshifted = handles.spectra_orig;

guidata(hObject, handles);

% --------------------------------------------------------------------
function treatdata(hObject)
% hObject    handle to figure
  
handles = guidata(hObject);
bg_use = handles.bg_use;

[Y,lind] = min(abs(handles.x_scale-handles.fitinterval(1)));
[Y,uind] = min(abs(handles.x_scale-handles.fitinterval(2)));
weight = handles.construct_weight(handles.x_scale(lind:uind), handles.important_intervals);
par_num = length(bg_use) + handles.polysize + 1;
par = zeros(par_num, handles.N_spectra);
base_poly = handles.polybase(handles.polysize,handles.x_scale);
coef = handles.coef;

base = zeros(length(handles.x_scale), par_num + 1);
base(:,1) = handles.x_scale;
for ii = 1:length(bg_use)
    base(:,ii+1) = handles.bg(bg_use(ii)).spc(:,2)/sqrt(sum(handles.bg(bg_use(ii)).spc(:,2).^2));
end
base(:,(end - handles.polysize):end) = base_poly(:,2:end);

handles.spectra_corr = handles.spectra_xshifted;

y = handles.spectra_xshifted;

fprintf('processing spectrum no ');
for jj = 1:handles.N_spectra;
    fprintf('%d...', jj);
    sample_fit = y(lind:uind,jj)/sqrt(sum(y(:,jj).^2));
    [par(:,jj), sigma, iter] = handles.lmmin(...
        @(x, a) handles.residuum(a, base(lind:uind,:), sample_fit, weight, coef),...
        [], handles.sumfunc, handles.x_scale(lind:uind), par(:,jj), 1e2);
    if handles.doublefit
        [par(:,jj), sigma, iter] = handles.lmmin(...
            @(x, a) handles.residuum(a, base(lind:uind,:), sample_fit, weight, coef),...
            [], handles.sumfunc, handles.x_scale(lind:uind), par(:,jj), 1e2);
    end
    handles.spectra_corr(:,jj) = (handles.spectra_xshifted(:,jj) / sqrt(sum(y(:,jj).^2)) - (base(:,2:end) * ...
        par(:,jj))) / par(1,jj);
    fprintf('\b\b\b, ')
    waitbar(handles.N_spectra / jj);
end
fprintf('\b\b.\nDone.\n')

handles.par_init = par;
handles.par = par;
handles.base = base;
handles.par_num = par_num;
handles.weight = weight;
handles.fit_lind = lind;
handles.fit_uind = uind;

guidata(hObject, handles);


% --------------------------------------------------------------------
function treatdata_manual(hObject)
% hObject    handle to figure
  
handles = guidata(hObject);
  
bg_use = handles.bg_use;

lind = handles.fit_lind;
uind = handles.fit_uind;

jj = handles.chosen_spectrum;

y = handles.spectra_xshifted(:,jj);
par_num = handles.par_num;
par = handles.par(:, jj);
weight = handles.weight;
base = handles.base;
coef = handles.coef;

N_flags = length(bg_use);
man_treatment_flags = false(N_flags, 1);
slider_pos = ones(N_flags, 1);
for ii = 1:N_flags
    man_treatment_flags(ii) = handles.bg(bg_use(ii)).manual_scale(jj);
    if man_treatment_flags(ii)
        slider_pos(ii) = handles.bg(bg_use(ii)).slider_pos(jj);
    end
end

indices = 1:N_flags;
man_treatment = indices(man_treatment_flags);
auto_treatment = indices(~man_treatment_flags);

par(man_treatment) = handles.par_init(man_treatment, jj) .* ...
    slider_pos(man_treatment);

sample_fit = y(lind:uind) / sqrt(sum(y.^2));
for ii = man_treatment
    sample_fit = sample_fit - par(ii) * base(lind:uind,ii+1);
end

[par([auto_treatment, (N_flags + 1):end]), sigma, iter] = handles.lmmin(...
    @(x, a) handles.residuum(...
        a, base(lind:uind,[1, auto_treatment + 1, (N_flags + 2):end]), sample_fit, weight, coef),...
    [], handles.sumfunc, handles.x_scale(lind:uind), par([auto_treatment, (N_flags + 1):end]), 1e2);

handles.spectra_corr(:,jj) = (handles.spectra_xshifted(:,jj) / sqrt(sum(y.^2)) - (base(:,2:end) * ...
    par)) / par(1);

handles.par(:,jj) = par;
handles.par_init(auto_treatment,jj) = par(auto_treatment);

guidata(hObject, handles);

  
% --- Executes on button press in choose_spec_pushbutton.
function choose_spec_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to choose_spec_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {sprintf('Select one spectrum\n(integer from 1 to %d)',...
    handles.N_spectra)}; 
dlg_title_matrix = 'Selection of spectrum';
num_lines = 1;
options.Resize='on';
response_num_of_spec=inputdlg(prompt, dlg_title_matrix, num_lines, {'',''},...
    options);
%--------------------------------------------------------------------------
% Test for cancel button
%--------------------------------------------------------------------------
if ~isequal(response_num_of_spec,{})
   [num_chos_spec, status] = str2num(response_num_of_spec{1});
  
   % improper values check
   if num_chos_spec < 1 || num_chos_spec > handles.N_spectra || status==0 ||...
           ~isequal(floor(num_chos_spec),num_chos_spec) || size(num_chos_spec,2)~=1
        % improper value is indicated by red background
        set(handles.chosen_spec_text, 'String', 'Incorrect number', 'BackgroundColor', 'red');
   else % correct values are saved to global variables
       if num_chos_spec > 1
           set(handles.down_pushbutton, 'Enable', 'on');
       else
           set(handles.down_pushbutton, 'Enable', 'off');
       end
       if num_chos_spec < handles.N_spectra
           set(handles.up_pushbutton, 'Enable', 'on');
       else
           set(handles.up_pushbutton, 'Enable', 'off');
       end
       set(handles.chosen_spec_text, 'String', sprintf('Chosen spectrum: %d', num_chos_spec),...
           'BackgroundColor', 'green');
       handles.chosen_spectrum = num_chos_spec;
       guidata(hObject, handles);
       change_spectrum(hObject);
       handles = guidata(hObject);
   end
end
guidata(hObject, handles);


% --- Executes on button press in down_pushbutton.
function down_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to down_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.chosen_spectrum <= 2
    handles.chosen_spectrum = 1;
    set(handles.down_pushbutton, 'Enable', 'off');
else
    handles.chosen_spectrum = handles.chosen_spectrum - 1;
end
if handles.chosen_spectrum < handles.N_spectra;
    set(handles.up_pushbutton, 'Enable', 'on');
end

set(handles.chosen_spec_text, 'String', sprintf('Chosen spectrum: %d', handles.chosen_spectrum),...
    'BackgroundColor', 'green');
guidata(hObject, handles);
change_spectrum(hObject);
  

% --- Executes on button press in up_pushbutton.
function up_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to up_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.chosen_spectrum >= handles.N_spectra - 1
    handles.chosen_spectrum = handles.N_spectra;
    set(handles.up_pushbutton, 'Enable', 'off')
else
    handles.chosen_spectrum = handles.chosen_spectrum + 1;
end
if handles.chosen_spectrum > 1;
    set(handles.down_pushbutton, 'Enable', 'on');
end

set(handles.chosen_spec_text, 'String', sprintf('Chosen spectrum: %d', handles.chosen_spectrum),...
    'BackgroundColor', 'green');
guidata(hObject, handles)
change_spectrum(hObject);


% --------------------------------------------------------------------
function change_spectrum(hObject)

set_slider_setting_panels(hObject);
plot_function(hObject);

% --------------------------------------------------------------------
function set_slider_setting_panels(hObject)

handles = guidata(hObject);
ii = handles.chosen_spectrum;

if handles.bg(1).manual_scale(ii) && handles.bg_use_flags(1)
    set(handles.bg1_manual_adjustment_checkbox, 'Value', 1);
    set(handles.bg1_slider_pos_edit, 'Enable', 'on', 'String', num2str(handles.bg(1).slider_pos(ii)));
    set(handles.bg1_slider_min_edit, 'Enable', 'on', 'String', num2str(handles.bg(1).slider_min(ii)));
    set(handles.bg1_slider_max_edit, 'Enable', 'on', 'String', num2str(handles.bg(1).slider_max(ii)));
    set(handles.bg1_slider_step_edit, 'Enable', 'on', 'String', num2str(handles.bg(1).slider_step(ii)));
    set(handles.bg1_slider,...
        'Min', handles.bg(1).slider_min(ii),...
        'Max', handles.bg(1).slider_max(ii),...
        'Value', handles.bg(1).slider_pos(ii),...
        'SliderStep', [handles.bg(1).slider_step(ii), 0.1],...
        'Enable', 'on');
else
    set(handles.bg1_manual_adjustment_checkbox, 'Value', 0);    
    set(handles.bg1_slider_pos_edit, 'Enable', 'off', 'String', num2str(handles.bg(1).slider_pos(ii)));
    set(handles.bg1_slider_min_edit, 'Enable', 'off', 'String', num2str(handles.bg(1).slider_min(ii)));
    set(handles.bg1_slider_max_edit, 'Enable', 'off', 'String', num2str(handles.bg(1).slider_max(ii)));
    set(handles.bg1_slider_step_edit, 'Enable', 'off', 'String', num2str(handles.bg(1).slider_step(ii)));
    set(handles.bg1_slider,...
        'Min', handles.bg(1).slider_min(ii),...
        'Max', handles.bg(1).slider_max(ii),...
        'Value', handles.bg(1).slider_pos(ii),...
        'SliderStep', [handles.bg(1).slider_step(ii), 0.1],...
        'Enable', 'off');
end
if handles.bg(2).manual_scale(ii) && handles.bg_use_flags(2)
    set(handles.bg2_manual_adjustment_checkbox, 'Value', 1);
    set(handles.bg2_slider_pos_edit, 'Enable', 'on', 'String', num2str(handles.bg(2).slider_pos(ii)));
    set(handles.bg2_slider_min_edit, 'Enable', 'on', 'String', num2str(handles.bg(2).slider_min(ii)));
    set(handles.bg2_slider_max_edit, 'Enable', 'on', 'String', num2str(handles.bg(2).slider_max(ii)));
    set(handles.bg2_slider_step_edit, 'Enable', 'on', 'String', num2str(handles.bg(2).slider_step(ii)));
    set(handles.bg2_slider,...
        'Min', handles.bg(2).slider_min(ii),...
        'Max', handles.bg(2).slider_max(ii),...
        'Value', handles.bg(2).slider_pos(ii),...
        'SliderStep', [handles.bg(2).slider_step(ii), 0.1],...
        'Enable', 'on');
else
    set(handles.bg2_manual_adjustment_checkbox, 'Value', 0);    
    set(handles.bg2_slider_pos_edit, 'Enable', 'off', 'String', num2str(handles.bg(2).slider_pos(ii)));
    set(handles.bg2_slider_min_edit, 'Enable', 'off', 'String', num2str(handles.bg(2).slider_min(ii)));
    set(handles.bg2_slider_max_edit, 'Enable', 'off', 'String', num2str(handles.bg(2).slider_max(ii)));
    set(handles.bg2_slider_step_edit, 'Enable', 'off', 'String', num2str(handles.bg(2).slider_step(ii)));
    set(handles.bg2_slider,...
        'Min', handles.bg(2).slider_min(ii),...
        'Max', handles.bg(2).slider_max(ii),...
        'Value', handles.bg(2).slider_pos(ii),...
        'SliderStep', [handles.bg(2).slider_step(ii), 0.1],...
        'Enable', 'off');
end
if handles.bg(3).manual_scale(ii) && handles.bg_use_flags(3)
    set(handles.bg3_manual_adjustment_checkbox, 'Value', 1);
    set(handles.bg3_slider_pos_edit, 'Enable', 'on', 'String', num2str(handles.bg(3).slider_pos(ii)));
    set(handles.bg3_slider_min_edit, 'Enable', 'on', 'String', num2str(handles.bg(3).slider_min(ii)));
    set(handles.bg3_slider_max_edit, 'Enable', 'on', 'String', num2str(handles.bg(3).slider_max(ii)));
    set(handles.bg3_slider_step_edit, 'Enable', 'on', 'String', num2str(handles.bg(3).slider_step(ii)));
    set(handles.bg3_slider,...
        'Min', handles.bg(3).slider_min(ii),...
        'Max', handles.bg(3).slider_max(ii),...
        'Value', handles.bg(3).slider_pos(ii),...
        'SliderStep', [handles.bg(3).slider_step(ii), 0.1],...
        'Enable', 'on');
else
    set(handles.bg3_manual_adjustment_checkbox, 'Value', 0);    
    set(handles.bg3_slider_pos_edit, 'Enable', 'off', 'String', num2str(handles.bg(3).slider_pos(ii)));
    set(handles.bg3_slider_min_edit, 'Enable', 'off', 'String', num2str(handles.bg(3).slider_min(ii)));
    set(handles.bg3_slider_max_edit, 'Enable', 'off', 'String', num2str(handles.bg(3).slider_max(ii)));
    set(handles.bg3_slider_step_edit, 'Enable', 'off', 'String', num2str(handles.bg(3).slider_step(ii)));
    set(handles.bg3_slider,...
        'Min', handles.bg(3).slider_min(ii),...
        'Max', handles.bg(3).slider_max(ii),...
        'Value', handles.bg(3).slider_pos(ii),...
        'SliderStep', [handles.bg(3).slider_step(ii), 0.1],...
        'Enable', 'off');
end
if handles.x_scale_manual(ii)
    set(handles.x_manual_adjustment_checkbox, 'Value', 1);
    set(handles.x_slider_pos_edit, 'Enable', 'on', 'String', num2str(handles.x_slider_pos(ii)));
    set(handles.x_slider_min_edit, 'Enable', 'on', 'String', num2str(handles.x_slider_min(ii)));
    set(handles.x_slider_max_edit, 'Enable', 'on', 'String', num2str(handles.x_slider_max(ii)));
    set(handles.x_slider_step_edit, 'Enable', 'on', 'String', num2str(handles.bg(1).slider_step(ii)));
    set(handles.x_slider,...
        'Min', handles.x_slider_min(ii),...
        'Max', handles.x_slider_max(ii),...
        'Value', handles.x_slider_pos(ii),...
        'SliderStep', [handles.x_slider_step(ii), 0.1],...
        'Enable', 'on');
else
    set(handles.x_manual_adjustment_checkbox, 'Value', 0);
    set(handles.x_slider_pos_edit, 'Enable', 'off', 'String', num2str(handles.x_slider_pos(ii)));
    set(handles.x_slider_min_edit, 'Enable', 'off', 'String', num2str(handles.x_slider_min(ii)));
    set(handles.x_slider_max_edit, 'Enable', 'off', 'String', num2str(handles.x_slider_max(ii)));
    set(handles.x_slider_step_edit, 'Enable', 'off', 'String', num2str(handles.x_slider_step(ii)));
    set(handles.x_slider,...
        'Min', handles.x_slider_min(ii),...
        'Max', handles.x_slider_max(ii),...
        'Value', handles.x_slider_pos(ii),...
        'SliderStep', [handles.x_slider_step(ii), 0.1],...
        'Enable', 'off');
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function plot_function(hObject)
handles = guidata(hObject);
cla(handles.cor_axes);
cla(handles.orig_axes);  

ii = handles.chosen_spectrum;

hold(handles.cor_axes, 'off');
plot(handles.cor_axes,handles.x_scale, handles.spectra_corr(:,ii));

hold(handles.orig_axes, 'off');
plot(handles.orig_axes,handles.x_scale, handles.spectra_xshifted(:,ii) / sqrt(sum(handles.spectra_xshifted(:,ii).^2)))
legendtext = {'orig spectrum'};
hold(handles.orig_axes, 'all');
plot(handles.orig_axes, handles.x_scale, handles.base(:,2:end) * handles.par(:,ii))
legendtext{end + 1} = 'subtracted spectrum';

for kk = 1:3
    plot(handles.orig_axes,handles.x_scale,handles.base(:,kk+1) * handles.par(kk,ii),'-');
    legendtext{end + 1} = sprintf('bg%d', kk);
end

plot(handles.orig_axes,handles.x_scale,handles.base(:,5:end) * handles.par(4:end,ii))
legendtext{end + 1} = 'polynome';

legend(handles.orig_axes, legendtext, 'Location', 'Best')
guidata(hObject,handles);


% --------------------------------------------------------------------
function save_menuitem_Callback(hObject, eventdata, handles)
% hObject    handle to save_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savedata = [handles.x_scale, handles.spectra_corr];
I = find(handles.filename == '.', 1, 'last');
filename = [handles.filepath, handles.filename(1:I-1), '_kor.txt'];
fprintf('Saving file:\n%s\n', filename);
save(filename,'savedata', '-ascii');
fprintf('Done.\n');


% --------------------------------------------------------------------
function options_menu_Callback(hObject, eventdata, handles)
% hObject    handle to options_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function settings_menuitem_Callback(hObject, eventdata, handles)
% hObject    handle to settings_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% sample_edit_string = '';
% for ii = 1:size(handles.important_intervals,1)-1
%     sample_edit_string = ...
%         [sample_edit_string, num2str(handles.important_intervals(ii,:)),';  '];
% end
% sample_edit_string = ...
%     [sample_edit_string, num2str(handles.important_intervals(end,:))];
% buffer_edit_string = '';
% for ii = 1:size(handles.important_intervals_kakwat,1)-1
%     buffer_edit_string = ...
%         [buffer_edit_string, num2str(handles.important_intervals_kakwat(ii,:)),';  '];
% end
% buffer_edit_string = ...
%     [buffer_edit_string, num2str(handles.important_intervals_kakwat(end,:))];


if ishandle(handles.settings_figure)
    figure(handles.settings_figure);
else
    handles.settings_figure = figure('Position', [560, 300, 700, 400], 'Toolbar', 'none', 'Resize', 'off',...
        'Name', 'Settings', 'Color', get(handles.main_figure,'Color'), 'MenuBar', 'None');
end
settings_handles = guidata(handles.settings_figure);

% background fit settings
weights_sample_edit_string = mat2str(handles.important_intervals);
settings_handles.fit_panel = uipanel('Title', 'Background fit settings', 'Units', 'pixels',...
    'Position', [20, 270, 660, 120]);
settings_handles.fitinterval_panel = uipanel('Title', 'Fit interval (cm-1)', 'Units', 'pixels',...
    'Parent', settings_handles.fit_panel, 'Position', [10, 65, 106, 40]);
settings_handles.fitinterval_text = uicontrol('Style', 'text',...
    'Parent', settings_handles.fitinterval_panel,...
    'Units', 'pixels', 'Position', [46, 4, 10, 20], 'String', ':', 'HorizontalAlignment', 'center');
settings_handles.fitinterval1_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.fitinterval_panel,...
    'Units', 'pixels', 'Position', [6, 6, 40, 20], 'String', num2str(handles.fitinterval(1)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.fitinterval2_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.fitinterval_panel,...
    'Units', 'pixels', 'Position', [56, 6, 40, 20], 'String', num2str(handles.fitinterval(2)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.polydeg_text = uicontrol('Style', 'text',...
    'Parent', settings_handles.fit_panel,...
    'Units', 'pixels', 'Position', [122, 70, 90, 20], 'String', 'Polynomial degree:',...
    'HorizontalAlignment', 'left');
settings_handles.polydeg_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.fit_panel,...
    'Units', 'pixels', 'Position', [218, 72, 20, 20], 'String', num2str(handles.polysize),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.coef_text = uicontrol('Style', 'text',...
    'Parent', settings_handles.fit_panel,...
    'Units', 'pixels', 'Position', [244, 70, 90, 20], 'String', 'Neg. band penalty:',...
    'HorizontalAlignment', 'left');
settings_handles.coef_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.fit_panel,...
    'Units', 'pixels', 'Position', [340, 72, 40, 20], 'String', num2str(handles.coef, '%g'),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.doublefit_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'repetitive fit', 'Units', 'pixels', 'Position', [390 72 80 20],...
    'Parent', settings_handles.fit_panel, 'Value', handles.doublefit);
settings_handles.weights_panel = uipanel('Title', 'Set important intervals for background fit',...
    'Parent', settings_handles.fit_panel, 'Units', 'pixels', 'Position', [10, 6, 640, 60]);
settings_handles.weights_sample_text = uicontrol('Style', 'text', 'Parent', settings_handles.weights_panel,...
    'Units', 'pixels', 'Position', [10, 26, 620, 15], 'String',...
    ['[{start}, {end}, {importance}; {start}, {end}, {importance}; ...], ',...
        'example: [1200, 1750, 1e-3; 2100, 2300, 1e1]'],...
    'HorizontalAlignment', 'left');
settings_handles.weights_sample_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.weights_panel,...
    'Units', 'pixels', 'Position', [10, 6, 620, 20], 'String', weights_sample_edit_string,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1,1,1]);

settings_handles.bg(1).panel = uipanel('Title', 'Background 1', 'Units', 'pixels',...
    'Position', [20, 135, 660, 130]);
settings_handles.bg(1).use_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'use', 'Units', 'pixels', 'Position', [6 98 40 20],...
    'Parent', settings_handles.bg(1).panel, 'Value', handles.bg(1).use,...
    'Callback', @settings_bg1_use_checkbox_Callback);
settings_handles.bg(1).fn_exact_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'exact filename', 'Units', 'pixels', 'Position', [56 98 100 20],...
    'Parent', settings_handles.bg(1).panel, 'Value', handles.bg(1).fn_exact,...
    'Callback', @settings_bg1_fn_exact_checkbox_Callback);
settings_handles.bg(1).manual_scale_init_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'manual scale', 'Units', 'pixels', 'Position', [156 98 100 20],...
    'Parent', settings_handles.bg(1).panel, 'Value', handles.bg(1).manual_scale_init);
settings_handles.bg(1).root_name_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(1).panel,...
    'Units', 'pixels', 'Position', [6, 74, 273, 20], 'String', 'root name (rel. or abs.):',...
    'HorizontalAlignment', 'left');
settings_handles.bg(1).root_name_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(1).panel,...
    'Units', 'pixels', 'Position', [6, 56, 273, 20], 'String', handles.bg(1).root_name,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg(1).fn_ext_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(1).panel,...
    'Units', 'pixels', 'Position', [6, 30, 55, 20], 'String', 'extension:',...
    'HorizontalAlignment', 'left');
settings_handles.bg(1).fn_ext_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(1).panel,...
    'Units', 'pixels', 'Position', [61, 32, 218, 20], 'String', handles.bg(1).fn_ext,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg(1).fn_no_ind_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(1).panel,...
    'Units', 'pixels', 'Position', [6, 6, 166, 20], 'String', 'index of autodiscovering number:',...
    'HorizontalAlignment', 'left');
settings_handles.bg(1).fn_no_ind_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(1).panel,...
    'Units', 'pixels', 'Position', [172, 8, 20, 20], 'String', num2str(handles.bg(1).fn_no_ind),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1],...
    'TooltipString', sprintf(['Autodiscover method finds all numbers in the filename and selects the one\n',... 
                              'according to the provided index. For example, if the spectrum has filename\n',... 
                              '''123spc345_6_78.txt'', 123 has index 1, 345 index 2, ... Then it tries to find\n',... 
                              'background files with name beginning with base, ending with extension and\n',... 
                              'containing the number. This result cannot be ambiguous.']));

settings_handles.bg_shiftscale_panel = uipanel('Title', 'Shift x scale:', 'Units', 'pixels',...
    'Position', [291, 6, 353, 110], 'Parent', settings_handles.bg(1).panel);
settings_handles.bg_shiftscale_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'shift scale', 'Units', 'pixels', 'Position', [6 78 80 20],...
    'Parent', settings_handles.bg_shiftscale_panel, 'Value', handles.bg_shiftscale,...
    'Callback', @settings_bg_shiftscale_checkbox_Callback);
settings_handles.bg_shiftscale_bg1int_text = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [6, 54, 120, 20], 'String', 'Shiftscale band interval:',...
    'HorizontalAlignment', 'left');
settings_handles.bg_shiftscale_bg1int_text2 = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [166, 54, 10, 20], 'String', ':',...
    'HorizontalAlignment', 'center');
settings_handles.bg_shiftscale_bg1int1_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [127, 56, 40, 20], 'String', num2str(handles.bg_shiftscale_bg1int(1)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg_shiftscale_bg1int2_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [176, 56, 40, 20], 'String', num2str(handles.bg_shiftscale_bg1int(2)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg_shiftscale_polydeg_text = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [6, 30, 135, 20], 'String', 'Baseline polynomial degree:',...
    'HorizontalAlignment', 'left');
settings_handles.bg_shiftscale_polydeg_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [145, 32, 20, 20], 'String', num2str(handles.bg_shiftscale_polydeg),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg_shiftscale_polyint_text = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [6, 6, 120, 20], 'String', 'Polynomial prefit interval:',...
    'HorizontalAlignment', 'left');
settings_handles.bg_shiftscale_polyint_text2 = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [168, 6, 10, 20], 'String', ':',...
    'HorizontalAlignment', 'center');
settings_handles.bg_shiftscale_polyint_text2 = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [217, 6, 10, 20], 'String', ',',...
    'HorizontalAlignment', 'center');
settings_handles.bg_shiftscale_polyint_text2 = uicontrol('Style', 'text',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [266, 6, 10, 20], 'String', ':',...
    'HorizontalAlignment', 'center');
settings_handles.bg_shiftscale_polyint1_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [129, 8, 40, 20], 'String', num2str(handles.bg_shiftscale_polyint(1)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg_shiftscale_polyint2_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [178, 8, 40, 20], 'String', num2str(handles.bg_shiftscale_polyint(2)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg_shiftscale_polyint3_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [227, 8, 40, 20], 'String', num2str(handles.bg_shiftscale_polyint(3)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg_shiftscale_polyint4_edit = uicontrol('Style', 'edit',...
    'Parent', settings_handles.bg_shiftscale_panel,...
    'Units', 'pixels', 'Position', [276, 8, 40, 20], 'String', num2str(handles.bg_shiftscale_polyint(4)),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);

settings_handles.bg(2).panel = uipanel('Title', 'Background 2', 'Units', 'pixels',...
    'Position', [20, 5, 285, 130]);
settings_handles.bg(2).use_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'use', 'Units', 'pixels', 'Position', [6 98 40 20],...
    'Parent', settings_handles.bg(2).panel, 'Value', handles.bg(2).use,...
    'Callback', @settings_bg2_use_checkbox_Callback);
settings_handles.bg(2).fn_exact_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'exact filename', 'Units', 'pixels', 'Position', [56 98 100 20],...
    'Parent', settings_handles.bg(2).panel, 'Value', handles.bg(2).fn_exact,...
    'Callback', @settings_bg2_fn_exact_checkbox_Callback);
settings_handles.bg(2).manual_scale_init_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'manual scale', 'Units', 'pixels', 'Position', [156 98 100 20],...
    'Parent', settings_handles.bg(2).panel, 'Value', handles.bg(2).manual_scale_init);
settings_handles.bg(2).root_name_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(2).panel,...
    'Units', 'pixels', 'Position', [6, 74, 273, 20], 'String', 'root name (rel. or abs.):',...
    'HorizontalAlignment', 'left');
settings_handles.bg(2).root_name_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(2).panel,...
    'Units', 'pixels', 'Position', [6, 56, 273, 20], 'String', handles.bg(2).root_name,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg(2).fn_ext_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(2).panel,...
    'Units', 'pixels', 'Position', [6, 30, 55, 20], 'String', 'extension:',...
    'HorizontalAlignment', 'left');
settings_handles.bg(2).fn_ext_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(2).panel,...
    'Units', 'pixels', 'Position', [61, 32, 218, 20], 'String', handles.bg(2).fn_ext,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg(2).fn_no_ind_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(2).panel,...
    'Units', 'pixels', 'Position', [6, 6, 166, 20], 'String', 'index of autodiscovering number:',...
    'HorizontalAlignment', 'left');
settings_handles.bg(2).fn_no_ind_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(2).panel,...
    'Units', 'pixels', 'Position', [172, 8, 20, 20], 'String', num2str(handles.bg(2).fn_no_ind),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1],...
    'TooltipString', sprintf(['Autodiscover method finds all numbers in the filename and selects the one\n',... 
                              'according to the provided index. For example, if the spectrum has filename\n',... 
                              '''123spc345_6_78.txt'', 123 has index 1, 345 index 2, ... Then it tries to find\n',... 
                              'background files with name beginning with base, ending with extension and\n',... 
                              'containing the number. This result cannot be ambiguous.']));

settings_handles.bg(3).panel = uipanel('Title', 'Background 3', 'Units', 'pixels',...
    'Position', [310, 5, 285, 130]);
settings_handles.bg(3).use_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'use', 'Units', 'pixels', 'Position', [6 98 40 20],...
    'Parent', settings_handles.bg(3).panel, 'Value', handles.bg(3).use,...
    'Callback', @settings_bg3_use_checkbox_Callback);
settings_handles.bg(3).fn_exact_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'exact filename', 'Units', 'pixels', 'Position', [56 98 100 20],...
    'Parent', settings_handles.bg(3).panel, 'Value', handles.bg(3).fn_exact,...
    'Callback', @settings_bg3_fn_exact_checkbox_Callback);
settings_handles.bg(3).manual_scale_init_checkbox = uicontrol('Style', 'checkbox',...
    'String', 'manual scale', 'Units', 'pixels', 'Position', [156 98 100 20],...
    'Parent', settings_handles.bg(3).panel, 'Value', handles.bg(3).manual_scale_init);
settings_handles.bg(3).root_name_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(3).panel,...
    'Units', 'pixels', 'Position', [6, 74, 273, 20], 'String', 'root name (rel. or abs.):',...
    'HorizontalAlignment', 'left');
settings_handles.bg(3).root_name_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(3).panel,...
    'Units', 'pixels', 'Position', [6, 56, 273, 20], 'String', handles.bg(3).root_name,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg(3).fn_ext_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(3).panel,...
    'Units', 'pixels', 'Position', [6, 30, 55, 20], 'String', 'extension:',...
    'HorizontalAlignment', 'left');
settings_handles.bg(3).fn_ext_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(3).panel,...
    'Units', 'pixels', 'Position', [61, 32, 218, 20], 'String', handles.bg(3).fn_ext,...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);
settings_handles.bg(3).fn_no_ind_text = uicontrol('Style', 'text', 'Parent', settings_handles.bg(3).panel,...
    'Units', 'pixels', 'Position', [6, 6, 166, 20], 'String', 'index of autodiscovering number:',...
    'HorizontalAlignment', 'left');
settings_handles.bg(3).fn_no_ind_edit = uicontrol('Style', 'edit', 'Parent', settings_handles.bg(3).panel,...
    'Units', 'pixels', 'Position', [172, 8, 20, 20], 'String', num2str(handles.bg(3).fn_no_ind),...
    'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1],...
    'TooltipString', sprintf(['Autodiscover method finds all numbers in the filename and selects the one\n',... 
                              'according to the provided index. For example, if the spectrum has filename\n',... 
                              '''123spc345_6_78.txt'', 123 has index 1, 345 index 2, ... Then it tries to find\n',... 
                              'background files with name beginning with base, ending with extension and\n',... 
                              'containing the number. This result cannot be ambiguous.']));
settings_handles.ok_pushbutton = uicontrol('Style', 'pushbutton',...
    'Units', 'pixels', 'Position', [600, 5, 45, 30], 'String', 'OK',...
    'Callback', @settings_ok_pushbutton_Callback);
settings_handles.cancel_pushbutton = uicontrol('Style', 'pushbutton',...
    'Units', 'pixels', 'Position', [651, 5, 45, 30], 'String', 'Cancel',...
    'Callback', @settings_cancel_pushbutton_Callback);


settings_handles.main_figure = handles.main_figure;
for ii = 1:length(handles.bg)
    settings_handles.bg(ii).use = handles.bg(ii).use;
    settings_handles.bg(ii).fn_exact = handles.bg(ii).fn_exact;
    settings_handles.bg(ii).manual_scale_init = handles.bg(ii).manual_scale_init;
end
settings_handles.bg_shiftscale = handles.bg_shiftscale;

guidata(handles.settings_figure, settings_handles);
guidata(hObject, handles);
set_settings_figure(handles.settings_figure);


function set_settings_figure(hObject)
settings_handles = guidata(hObject);
for ii = 1:length(settings_handles.bg)
    if settings_handles.bg(ii).use
        set(settings_handles.bg(ii).fn_exact_checkbox, 'Enable', 'on');
        set(settings_handles.bg(ii).manual_scale_init_checkbox, 'Enable', 'on');
        set(settings_handles.bg(ii).root_name_edit, 'Enable', 'on');
        set(settings_handles.bg(ii).fn_ext_edit, 'Enable', 'on');
        if settings_handles.bg(ii).fn_exact
            set(settings_handles.bg(ii).fn_no_ind_edit, 'Enable', 'off');
        else
            set(settings_handles.bg(ii).fn_no_ind_edit, 'Enable', 'on');
        end
    else
        set(settings_handles.bg(ii).fn_exact_checkbox, 'Enable', 'off');
        set(settings_handles.bg(ii).manual_scale_init_checkbox, 'Enable', 'off');
        set(settings_handles.bg(ii).root_name_edit, 'Enable', 'off');
        set(settings_handles.bg(ii).fn_ext_edit, 'Enable', 'off');
        set(settings_handles.bg(ii).fn_no_ind_edit, 'Enable', 'off');
    end
end
if settings_handles.bg(1).use
    set(settings_handles.bg_shiftscale_checkbox, 'Enable', 'on');
    if settings_handles.bg_shiftscale
        set(settings_handles.bg_shiftscale_bg1int1_edit, 'Enable', 'on');
        set(settings_handles.bg_shiftscale_bg1int2_edit, 'Enable', 'on');
        set(settings_handles.bg_shiftscale_polydeg_edit, 'Enable', 'on');
        set(settings_handles.bg_shiftscale_polyint1_edit, 'Enable', 'on');
        set(settings_handles.bg_shiftscale_polyint2_edit, 'Enable', 'on');
        set(settings_handles.bg_shiftscale_polyint3_edit, 'Enable', 'on');
        set(settings_handles.bg_shiftscale_polyint4_edit, 'Enable', 'on');
    else
        set(settings_handles.bg_shiftscale_bg1int1_edit, 'Enable', 'off');
        set(settings_handles.bg_shiftscale_bg1int2_edit, 'Enable', 'off');
        set(settings_handles.bg_shiftscale_polydeg_edit, 'Enable', 'off');
        set(settings_handles.bg_shiftscale_polyint1_edit, 'Enable', 'off');
        set(settings_handles.bg_shiftscale_polyint2_edit, 'Enable', 'off');
        set(settings_handles.bg_shiftscale_polyint3_edit, 'Enable', 'off');
        set(settings_handles.bg_shiftscale_polyint4_edit, 'Enable', 'off');
    end
else
    set(settings_handles.bg_shiftscale_checkbox, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_bg1int1_edit, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_bg1int2_edit, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_polydeg_edit, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_polyint1_edit, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_polyint2_edit, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_polyint3_edit, 'Enable', 'off');
    set(settings_handles.bg_shiftscale_polyint4_edit, 'Enable', 'off');
end
guidata(hObject, settings_handles);


% --- Executes on button press in bg(1).use_checkbox.
function settings_bg1_use_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(1).use_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(1).use = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(1).fn_exact_checkbox.
function settings_bg1_fn_exact_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(1).fn_exact_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(1).fn_exact = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg_shiftscale_checkbox.
function settings_bg_shiftscale_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg_shiftscale_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg_shiftscale = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(2).use_checkbox.
function settings_bg2_use_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(2).use_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(2).use = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(2).fn_exact_checkbox.
function settings_bg2_fn_exact_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(1).fn_exact_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(2).fn_exact = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(3).use_checkbox.
function settings_bg3_use_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(3).use_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(3).use = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(3).fn_exact_checkbox.
function settings_bg3_fn_exact_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(3).fn_exact_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(3).fn_exact = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --------------------------------------------------------------------
function settings_ok_pushbutton_Callback(hObject, eventdata)

settings_handles = guidata(hObject);
handles = guidata(settings_handles.main_figure);

try
    fitinterval1 = str2double(get(settings_handles.fitinterval1_edit, 'String'));
    fitinterval2 = str2double(get(settings_handles.fitinterval2_edit, 'String'));
    if isnan(fitinterval1)
        msgID = 'settings:BadInput';
        msg = 'Fit interval limit 1 must be a number.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    if isnan(fitinterval2)
        msgID = 'settings:BadInput';
        msg = 'Fit interval limit 2 must be a number.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    if fitinterval1 > fitinterval2
        msgID = 'settings:BadInput';
        msg = 'Fit interval limit 1 must be less than fit interval limit 2.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.fitinterval = [fitinterval1, fitinterval2];
    handles.polysize = str2double(get(settings_handles.polydeg_edit, 'String'));
    if isnan(handles.polysize) || ~isequal(fix(handles.polysize), handles.polysize) || handles.polysize < 0 
        msgID = 'settings:BadInput';
        msg = 'Polynomial degree must be a nonnegative integer.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.coef = str2double(get(settings_handles.coef_edit, 'String'));
    if isnan(handles.coef) || handles.coef < 0
        msgID = 'settings:BadInput';
        msg = 'Neg. band penalty must be a nonnegative number.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.doublefit = get(settings_handles.doublefit_checkbox, 'Value');
    impint = eval(get(settings_handles.weights_sample_edit, 'String'));
    if ~isempty(impint) && (~isnumeric(impint) || size(impint, 2) ~= 3)
        msgID = 'settings:BadInput';
        msg = 'Important intervals for background fit has bad format.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.important_intervals = impint;
    
    for ii = 1:length(handles.bg)
        handles.bg(ii).use = get(settings_handles.bg(ii).use_checkbox, 'Value');
        if handles.bg(ii).use && handles.bg(ii).loaded
            handles.bg_use_flags(ii) = 1;
        else
            handles.bg_use_flags(ii) = 0;
        end
        handles.bg(ii).fn_exact = get(settings_handles.bg(ii).fn_exact_checkbox, 'Value');
        handles.bg(ii).manual_scale_init = get(settings_handles.bg(ii).manual_scale_init_checkbox, 'Value');
        handles.bg(ii).root_name = get(settings_handles.bg(ii).root_name_edit, 'String');
        handles.bg(ii).fn_ext = get(settings_handles.bg(ii).fn_ext_edit, 'String');
        fn_no_ind = str2double(get(settings_handles.bg(ii).fn_no_ind_edit, 'String'));
        if isnan(fn_no_ind) || ~isequal(fix(fn_no_ind), fn_no_ind) || fn_no_ind < 0
            msgID = 'settings:BadInput';
            msg = sprintf('Index of autodiscovering number for background %d must be a nonnegative integer.', ii);
            exception = MException(msgID,msg);
            throw(exception)
        end
        handles.bg(ii).fn_no_ind = fn_no_ind;
    end
    bg_use = 1:length(handles.bg);
    bg_use = bg_use(handles.bg_use_flags);
    handles.bg_use = bg_use;
    
    handles.bg_shiftscale = get(settings_handles.bg_shiftscale_checkbox, 'Value');
    bg1int1 = str2double(get(settings_handles.bg_shiftscale_bg1int1_edit, 'String'));
    bg1int2 = str2double(get(settings_handles.bg_shiftscale_bg1int2_edit, 'String'));
    if isnan(bg1int1)
        msgID = 'settings:BadInput';
        msg = 'Shiftscale band interval limit 1 must be a number.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    if isnan(bg1int2)
        msgID = 'settings:BadInput';
        msg = 'Shiftscale band interval limit 2 must be a number.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    if bg1int1 > bg1int2
        msgID = 'settings:BadInput';
        msg = 'Shiftscale band interval limit 1 must be less than interval limit 2.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.bg_shiftscale_bg1int = [bg1int1, bg1int2];
    sc_polydeg = str2double(get(settings_handles.bg_shiftscale_polydeg_edit, 'String'));
    if isnan(sc_polydeg) || ~isequal(fix(sc_polydeg), sc_polydeg) || sc_polydeg < 0 
        msgID = 'settings:BadInput';
        msg = 'Polynomial degree must be a nonnegative integer.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.bg_shiftscale_polydeg = sc_polydeg;
    sc_pint(1) = str2double(get(settings_handles.bg_shiftscale_polyint1_edit, 'String'));
    sc_pint(2) = str2double(get(settings_handles.bg_shiftscale_polyint2_edit, 'String'));
    sc_pint(3) = str2double(get(settings_handles.bg_shiftscale_polyint3_edit, 'String'));
    sc_pint(4) = str2double(get(settings_handles.bg_shiftscale_polyint4_edit, 'String'));
    for ii = 1:length(sc_pint)
        if isnan(sc_pint(ii))
            msgID = 'settings:BadInput';
            msg = sprintf('Polynomial prefit interval limit %d must be a number.', ii);
            exception = MException(msgID,msg);
            throw(exception)
        end
    end
    
    if ~isequal(sc_pint, sort(sc_pint))
        msgID = 'settings:BadInput';
        msg = 'Shiftscale polynomial prefit interval limits must be in ascending order.';
        exception = MException(msgID,msg);
        throw(exception)
    end
    handles.bg_shiftscale_polyint = sc_pint;
    
catch ME
    getReport(ME)
    h_errordlg=errordlg(sprintf('%s', ME.message), 'Input error');
    waitfor(h_errordlg);
    return
end

close(handles.settings_figure);

guidata(handles.main_figure, handles);


function settings_cancel_pushbutton_Callback(hObject, eventdata)

settings_handles = guidata(hObject);
handles = guidata(settings_handles.main_figure);

close(handles.settings_figure);

guidata(handles.main_figure, handles);


% --------------------------------------------------------------------
function display_x_shift_menuitem_Callback(hObject, eventdata, handles)
% hObject    handle to display_x_shift_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.shiftscale_fig = figure('Name', 'X-shifts', 'MenuBar', 'figure', 'ToolBar', 'figure');

ii = handles.chosen_spectrum;
manual_xshifts = handles.x_slider_pos;
manual_xshifts(~logical(handles.x_scale_manual)) = 0;

handles.shiftscale_axes = axes;
pH(1) = plot(handles.shiftscale_axes, 1:handles.N_spectra, handles.xshifts,'-b');
legendtext{1} = 'original possitons of caligration peak';
hold on
if handles.bg_shiftscale
    pH(end + 1) = plot(handles.shiftscale_axes,...
        1:handles.N_spectra, polyval(handles.shiftscale_polypar, 1:handles.N_spectra) + manual_xshifts', 'xr');
    legendtext{end + 1} = 'current x-shift';
    
    pH(end + 1) = plot(handles.shiftscale_axes,...
        1:handles.N_spectra, polyval(handles.shiftscale_polypar, 1:handles.N_spectra), '-g');
    legendtext{end + 1} = 'x_shift from fit';
else
    pH(end + 1) = plot(handles.shiftscale_axes,...
        1:handles.N_spectra, manual_xshifts', 'xr');
    legendtext{end + 1} = 'current x-shift';
end
xlabel(handles.shiftscale_axes, 'spectrum no.')
ylabel(handles.shiftscale_axes, 'xshift (cm^{-1})')
legend(pH, legendtext)

ti = get(handles.shiftscale_axes, 'TightInset');
set(handles.shiftscale_axes, 'Position', [ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
set(handles.shiftscale_axes, 'units', 'centimeters')

pos = get(handles.shiftscale_axes, 'Position');
ti = get(handles.shiftscale_axes, 'TightInset');

set(handles.shiftscale_fig, 'PaperUnits', 'centimeters');
set(handles.shiftscale_fig, 'PaperSize', [pos(3) + ti(1) + ti(3), pos(4) + ti(2) + ti(4)]);
set(handles.shiftscale_fig, 'PaperPositionMode', 'manual');
set(handles.shiftscale_fig, 'PaperPosition', [0, 0, pos(3) + ti(1) + ti(3), pos(4) + ti(2) + ti(4)]);
set(handles.shiftscale_fig, 'Color', 'w');

set(handles.shiftscale_axes,'units', 'normalized')
set(handles.shiftscale_fig, 'Units', 'normalized')


% --------------------------------------------------------------------
function update_menuitem_Callback(hObject, eventdata, handles)
% hObject    handle to update_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% shiftscomp(hObject);
% handles = guidata(hObject);
% 
% handles.spectra_xshifted = handles.spectra_orig;
% guidata(hObject, handles);

handles.treatdata_waitbar = waitbar(0, 'Fitting background to spectra. Please wait...');
guidata(hObject, handles);
shiftscomp(hObject);
treatdata(hObject);
handles = guidata(hObject);

if handles.bg_use_flags(1)
    set(handles.bg1_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_flags(2)
    set(handles.bg2_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_flags(3)
    set(handles.bg3_manual_adjustment_checkbox, 'Enable', 'on');
end
set(handles.x_manual_adjustment_checkbox, 'Enable', 'on');

close(handles.treatdata_waitbar);

guidata(hObject, handles);
change_spectrum(hObject);
plot_function(hObject);


% --- Executes on button press in bg1_manual_adjustment_checkbox.
function bg1_manual_adjustment_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to bg1_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
handles.bg(1).manual_scale(handles.chosen_spectrum) = get(hObject, 'Value');
guidata(hObject, handles)
set_slider_setting_panels(hObject);


% --- Executes on button press in bg2_manual_adjustment_checkbox.
function bg2_manual_adjustment_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to bg2_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg2_manual_adjustment_checkbox
handles.bg(2).manual_scale(handles.chosen_spectrum) = get(hObject, 'Value');
guidata(hObject, handles)
set_slider_setting_panels(hObject);


% --- Executes on button press in bg3_manual_adjustment_checkbox.
function bg3_manual_adjustment_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to bg3_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bg3_manual_adjustment_checkbox
handles.bg(3).manual_scale(handles.chosen_spectrum) = get(hObject, 'Value');
guidata(hObject, handles)
set_slider_setting_panels(hObject);


% --- Executes on button press in x_manual_adjustment_checkbox.
function x_manual_adjustment_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to x_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of x_manual_adjustment_checkbox
ii = handles.chosen_spectrum;

handles.x_scale_manual(ii) = get(hObject, 'Value');
guidata(hObject, handles)
if handles.x_scale_manual(ii)
    fprintf('switching on x-scale manual settings\n')
    x_slider_Callback(handles.x_slider, eventdata, handles)
else
    fprintf('switching off x-scale manual settings\n')
    handles.spectra_xshifted(:,ii) = handles.spectra_orig(:,ii);
    guidata(hObject, handles);
    treatdata_manual(hObject);
    plot_function(hObject);
end
set_slider_setting_panels(hObject);


% --- Executes on slider movement.
function bg1_slider_Callback(hObject, eventdata, handles)
% hObject    handle to bg1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ii = handles.chosen_spectrum;

handles.bg(1).slider_pos(ii) = get(hObject, 'Value');

set(handles.bg1_slider_pos_edit, 'String', num2str(handles.bg(1).slider_pos(ii)));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg1_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end


% --- Executes on slider movement.
function bg2_slider_Callback(hObject, eventdata, handles)
% hObject    handle to bg2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ii = handles.chosen_spectrum;

handles.bg(2).slider_pos(ii) = get(hObject, 'Value');

set(handles.bg2_slider_pos_edit, 'String', num2str(handles.bg(2).slider_pos(ii)));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg2_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end



% --- Executes on slider movement.
function bg3_slider_Callback(hObject, eventdata, handles)
% hObject    handle to bg3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ii = handles.chosen_spectrum;

handles.bg(3).slider_pos(ii) = get(hObject, 'Value');

set(handles.bg3_slider_pos_edit, 'String', num2str(handles.bg(3).slider_pos(ii)));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg3_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end


% --- Executes on slider movement.
function x_slider_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

ii = handles.chosen_spectrum;

handles.x_slider_pos(ii) = get(hObject, 'Value');

set(handles.x_slider_pos_edit, 'String', num2str(handles.x_slider_pos(ii)));

handles.spectra_xshifted(:,ii) =...
    spline(handles.x_scale + handles.x_slider_pos(ii), handles.spectra_orig(:,ii), handles.x_scale);


guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);

% --- Executes during object creation, after setting all properties.
function x_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end



function bg1_slider_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg1_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg1_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_max_edit as a double
ii = handles.chosen_spectrum;

handles.bg(1).slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'Max',handles.bg(1).slider_max(ii));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function bg1_slider_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg1_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg1_slider_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg1_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg1_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_min_edit as a double
ii = handles.chosen_spectrum;

handles.bg(1).slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'Min', handles.bg(1).slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg1_slider_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg1_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg1_slider_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg1_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg1_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_step_edit as a double
ii = handles.chosen_spectrum;

handles.bg(1).slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'SliderStep', [handles.bg(1).slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg1_slider_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg1_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg1_slider_pos_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg1_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg1_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_pos_edit as a double
ii = handles.chosen_spectrum;

handles.bg(1).slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'Value', handles.bg(1).slider_pos(ii));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg1_slider_pos_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg1_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg2_slider_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg2_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg2_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_max_edit as a double
ii = handles.chosen_spectrum;

handles.bg(2).slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'Max', handles.bg(2).slider_max(ii));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function bg2_slider_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg2_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg2_slider_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg2_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg2_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_min_edit as a double
ii = handles.chosen_spectrum;

handles.bg(2).slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'Min', handles.bg(2).slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg2_slider_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg2_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg2_slider_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg2_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg2_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_step_edit as a double
ii = handles.chosen_spectrum;

handles.bg(2).slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'SliderStep', [handles.bg(2).slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg2_slider_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg2_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor', 'white');
end



function bg2_slider_pos_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg2_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg2_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_pos_edit as a double
ii = handles.chosen_spectrum;

handles.bg(2).slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'Value', handles.bg(2).slider_pos(ii));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg2_slider_pos_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg2_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg3_slider_pos_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg3_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg3_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_pos_edit as a double
ii = handles.chosen_spectrum;

handles.bg(3).slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'Value', handles.bg(3).slider_pos(ii));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg3_slider_pos_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg3_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg3_slider_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg3_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg3_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_max_edit as a double
ii = handles.chosen_spectrum;

handles.bg(3).slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'Max', handles.bg(3).slider_max(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg3_slider_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg3_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg3_slider_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg3_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg3_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_min_edit as a double
ii = handles.chosen_spectrum;

handles.bg(3).slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'Min', handles.bg(3).slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg3_slider_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg3_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg3_slider_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bg3_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg3_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_step_edit as a double
ii = handles.chosen_spectrum;

handles.bg(3).slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'SliderStep', [handles.bg(3).slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg3_slider_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg3_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function x_slider_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_max_edit as a double
ii = handles.chosen_spectrum;

handles.x_slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'Max', handles.x_slider_max(ii));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function x_slider_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function x_slider_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_min_edit as a double
ii = handles.chosen_spectrum;

handles.x_slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'Min', handles.x_slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_slider_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function x_slider_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_step_edit as a double
ii = handles.chosen_spectrum;

handles.x_slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'SliderStep', [handles.x_slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_slider_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function x_slider_pos_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_pos_edit as a double
ii = handles.chosen_spectrum;

handles.x_slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'Value', handles.x_slider_pos(ii));

handles.spectra_xshifted(:,ii) =...
    spline(handles.x_scale + handles.x_slider_pos(ii), handles.spectra_orig(:,ii), handles.x_scale);

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function x_slider_pos_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end
