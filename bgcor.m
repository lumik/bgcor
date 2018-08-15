function bgcor

hObject = figure(...
    'Visible', 'off',...
    'Position', [260 300 1000 750],...
    'toolbar', 'figure',...
    'MenuBar', 'none',...
    'NumberTitle', 'off',...
    'name', 'bgcor');
handles = guidata(hObject);
handles.main_figure = hObject;

% Choose default command line output for bgcor
handles.output = hObject;

% functional handles
h=bgcor_functions;
[handles.bgcor_load, handles.get_absolute_path, handles.find_number, handles.autoload, handles.shiftscale,...
    handles.faktorka, handles.same_scale, handles.construct_weight, handles.polybase, handles.residuum,...
    handles.lmmin] = h{:};

set(handles.main_figure, 'toolbar', 'figure');
handles.settings_figure = [];

% axes
% ----
handles.cor_axes = axes(...
    'Units', 'normalized',...
    'Position', [0.05 0.53 0.6 0.37]);
handles.orig_axes = axes(...
    'Units', 'normalized',...
    'Position', [0.05 0.05 0.6 0.37]);

% menus
% -----
handles.file_menu = uimenu(handles.main_figure, 'Label', 'File');
handles.load_menuitem = uimenu(handles.file_menu,...
    'Label', 'Load',...
    'Accelerator', 'O',...
    'Callback', @load_menuitem_Callback);
handles.save_menuitem = uimenu(handles.file_menu,...
    'Label', 'Save',...
    'Accelerator', 'S',...
    'Callback', @save_menuitem_Callback);
handles.options_menu = uimenu(handles.main_figure, 'Label', 'Options');
handles.settings_menuitem = uimenu(handles.options_menu,...
    'Label', 'Settings',...
    'Accelerator', 'T',...
    'Callback', @settings_menuitem_Callback);
handles.display_x_shift_menuitem = uimenu(handles.options_menu,...
    'Label', 'Display x shift',...
    'Accelerator', 'X',...
    'Callback', @display_x_shift_menuitem_Callback);
handles.update_menuitem = uimenu(handles.options_menu,...
    'Label', 'Update',...
    'Accelerator', 'U',...
    'Callback', @update_menuitem_Callback);
handles.load_settings_menuitem = uimenu(handles.options_menu,...
    'Label', 'Load Settings',...
    'Accelerator', 'L',...
    'Callback', @load_settings_menuitem_Callback);


% select spectrum panel
% ---------------------
handles.select_spec_panel = uipanel(...
    'Title', 'Select spectrum',...
    'Units', 'normalized',...
    'Position', [.05 .93 .4 .057]);
handles.chosen_spec_text = uicontrol(...
    'Style', 'pushbutton',...
    'Units', 'normalized',...
    'Position', [.47 .15 .5 .8],...
    'String', 'Chosen spectrum:',...
    'Parent', handles.select_spec_panel,...
    'BackgroundColor', 'green',...
    'Enable', 'inactive');
handles.choose_spec_pushbutton = uicontrol(...
    'Style', 'pushbutton',...
    'Units', 'normalized',...
    'Position', [.02 .15 .13 .8],...
    'String', '#',...
    'Parent', handles.select_spec_panel,...
    'TooltipString', 'Will choose one spectrum',...
    'Visible', 'on',...
    'Enable', 'off',...
    'FontSize', 10,...
    'Callback', @choose_spec_pushbutton_Callback);
handles.down_pushbutton = uicontrol(...
    'Style', 'pushbutton',...
    'Units', 'normalized',...
    'Position', [.17 .15 .13 .8],...
    'String', '<',...
    'Parent', handles.select_spec_panel,...
    'TooltipString', 'Select previous spectrum',...
    'FontSize', 10,...
    'Visible', 'on',...
    'Enable', 'off',...
    'Callback', @down_pushbutton_Callback);
handles.up_pushbutton = uicontrol(...
    'Style', 'pushbutton',...
    'Units', 'normalized',...
    'Position', [.32 .15 .13 .8],...
    'String', '>',...
    'Parent', handles.select_spec_panel,...
    'TooltipString', 'Select next spectrum',...
    'FontSize', 10,...
    'Visible', 'on',...
    'Enable', 'off',...
    'Callback', @up_pushbutton_Callback);

% manual adjustment panel
% -----------------------
handles.manual_adjustment_panel = uipanel(...
    'Title', 'Manual adjustment',...
    'Units', 'normalized',...
    'Position', [.47 .93 .25 .057]);
handles.bg1_manual_adjustment_checkbox = uicontrol(...
    'Style', 'checkbox',...
    'Units', 'pixels',...
    'Position', [6 5 44 23],...
    'String', 'bg1',...
    'Parent', handles.manual_adjustment_panel,...
    'Value', 0,...
    'Tooltipstring', 'Manual adjustment of background 1.',...
    'Enable', 'off',...
    'Callback', @bg1_manual_adjustment_checkbox_Callback);
handles.bg2_manual_adjustment_checkbox = uicontrol(...
    'Style', 'checkbox',...
    'Units', 'pixels',...
    'Position', [50 5 44 23],...
    'String', 'bg2',...
    'Parent', handles.manual_adjustment_panel,...
    'Value', 0,...
    'Tooltipstring', 'Manual adjustment of background 2.',...
    'Enable', 'off',...
    'Callback', @bg2_manual_adjustment_checkbox_Callback);
handles.bg3_manual_adjustment_checkbox = uicontrol(...
    'Style', 'checkbox',...
    'Units', 'pixels',...
    'Position', [100 5 44 23],...
    'String', 'bg3',...
    'Parent', handles.manual_adjustment_panel,...
    'Value', 0,...
    'Tooltipstring', 'Manual adjustment of background 1.',...
    'Enable', 'off',...
    'Callback', @bg3_manual_adjustment_checkbox_Callback);
handles.x_manual_adjustment_checkbox = uicontrol(...
    'Style', 'checkbox',...
    'Units', 'pixels',...
    'Position', [150 5 65 23],...
    'String', 'x-shift',...
    'Parent', handles.manual_adjustment_panel,...
    'Value', 0,...
    'Tooltipstring', 'Manual adjustment of background 1.',...
    'Enable', 'off',...
    'Callback', @x_manual_adjustment_checkbox_Callback);

% background and x-shift sliders initial valuse
% ---------------------------------------------
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

% background 1 slider and panel
% -----------------------------
handles.bg1_slider = uicontrol(...
    'Style', 'slider',...
    'Units', 'normalized',...
    'Position', [.77 .53 .03 .37],...
    'Min', handles.bg(1).slider_min_init,...
    'Max', handles.bg(1).slider_max_init,...
    'Value', handles.bg(1).slider_pos_init,...
    'SliderStep', [handles.bg(1).slider_step_init, 0.1],...
    'Enable', 'off',...
    'Units', 'normalized',...
    'Callback', @bg1_slider_Callback,...
    'CreateFcn', @bg1_slider_CreateFcn);
handles.bg1_slider_text = uicontrol(...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [.765 .91 .04 .03],...
    'String', 'bg1');
handles.bg1_slider_panel = uipanel(...
    'Title', 'bg1 slider settings',...
    'Units', 'normalized',...
    'Position', [.67 .25 .14 .17]);
handles.bg1_slider_pos_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg1_slider_panel,...
    'String', 'Pos',...
    'Units', 'normalized',...
    'Position', [.06 .78 .20 .14]);
handles.bg1_slider_pos_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_pos_init),...
    'Units', 'normalized',...
    'Position', [.30 .75 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg1_slider_pos_edit_Callback,...
    'CreateFcn', @bg1_slider_pos_edit_CreateFcn);
handles.bg1_slider_max_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg1_slider_panel,...
    'String', 'Max',...
    'Units', 'normalized',...
    'Position', [.06 .55 .20 .14]);
handles.bg1_slider_max_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_max_init),...
    'Units', 'normalized',...
    'Position', [.30 .52 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg1_slider_max_edit_Callback,...
    'CreateFcn', @bg1_slider_max_edit_CreateFcn);
handles.bg1_slider_min_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg1_slider_panel,...
    'String', 'Min',...
    'Units', 'normalized',...
    'Position', [.06 .32 .20 .14]);
handles.bg1_slider_min_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_min_init),...
    'Units', 'normalized',...
    'Position', [.30 .29 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg1_slider_min_edit_Callback,...
    'CreateFcn', @bg1_slider_min_edit_CreateFcn);
handles.bg1_slider_step_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg1_slider_panel,...
    'String', 'Step (%)',...
    'Units', 'normalized',...
    'Position', [.06 .09 .44 .14]);
handles.bg1_slider_step_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg1_slider_panel,...
    'String', num2str(handles.bg(1).slider_step_init),...
    'Units', 'normalized',...
    'Position', [.54 .06 .39 .20],...
    'Enable', 'off',...
    'Callback', @bg1_slider_step_edit_Callback,...
    'CreateFcn', @bg1_slider_step_edit_CreateFcn);


% background 2 slider and panel
% -----------------------------
handles.bg2_slider = uicontrol(...
    'Style', 'slider',...
    'Units', 'normalized',...
    'Position', [.82 .53 .03 .37],...
    'Min', handles.bg(2).slider_min_init,...
    'Max', handles.bg(2).slider_max_init,...
    'Value', handles.bg(2).slider_pos_init,...
    'SliderStep', [handles.bg(2).slider_step_init, 0.1],...
    'Enable', 'off',...
    'Units', 'normalized',...
    'Callback', @bg2_slider_Callback,...
    'CreateFcn', @bg2_slider_CreateFcn);
handles.bg2_slider_text = uicontrol(...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [.815 .91 .04 .03],...
    'String', 'bg2');
handles.bg2_slider_panel = uipanel(...
    'Title', 'bg2 slider settings',...
    'Units', 'normalized',...
    'Position', [.83 .25 .14 .17]);
handles.bg2_slider_pos_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg2_slider_panel,...
    'String', 'Pos',...
    'Units', 'normalized',...
    'Position', [.06 .78 .20 .14]);
handles.bg2_slider_pos_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_pos_init),...
    'Units', 'normalized',...
    'Position', [.30 .75 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg2_slider_pos_edit_Callback,...
    'CreateFcn', @bg2_slider_pos_edit_CreateFcn);
handles.bg2_slider_max_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg2_slider_panel,...
    'String', 'Max',...
    'Units', 'normalized',...
    'Position', [.06 .55 .20 .14]);
handles.bg2_slider_max_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_max_init),...
    'Units', 'normalized',...
    'Position', [.30 .52 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg2_slider_max_edit_Callback,...
    'CreateFcn', @bg2_slider_max_edit_CreateFcn);
handles.bg2_slider_min_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg2_slider_panel,...
    'String', 'Min',...
    'Units', 'normalized',...
    'Position', [.06 .32 .20 .14]);
handles.bg2_slider_min_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_min_init),...
    'Units', 'normalized',...
    'Position', [.30 .29 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg2_slider_min_edit_Callback,...
    'CreateFcn', @bg2_slider_min_edit_CreateFcn);
handles.bg2_slider_step_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg2_slider_panel,...
    'String', 'Step (%)',...
    'Units', 'normalized',...
    'Position', [.06 .09 .44 .14]);
handles.bg2_slider_step_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg2_slider_panel,...
    'String', num2str(handles.bg(2).slider_step_init),...
    'Units', 'normalized',...
    'Position', [.54 .06 .39 .20],...
    'Enable', 'off',...
    'Callback', @bg2_slider_step_edit_Callback,...
    'CreateFcn', @bg2_slider_step_edit_CreateFcn);


% background 3 slider and panel
% -----------------------------
handles.bg3_slider = uicontrol(...
    'Style', 'slider',...
    'Units', 'normalized',...
    'Position', [.87 .53 .03 .37],...
    'Min', handles.bg(1).slider_min_init,...
    'Max', handles.bg(1).slider_max_init,...
    'Value', handles.bg(1).slider_pos_init,...
    'SliderStep', [handles.bg(1).slider_step_init, 0.1],...
    'Enable', 'off',...
    'Units', 'normalized',...
    'Callback', @bg3_slider_Callback,...
    'CreateFcn', @bg3_slider_CreateFcn);
handles.bg3_slider_text = uicontrol(...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [.865 .91 .04 .03],...
    'String', 'bg3');
handles.bg3_slider_panel = uipanel(...
    'Title', 'bg3 slider settings',...
    'Units', 'normalized',...
    'Position', [.67 .05 .14 .17]);
handles.bg3_slider_pos_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg3_slider_panel,...
    'String', 'Pos',...
    'Units', 'normalized',...
    'Position', [.06 .78 .20 .14]);
handles.bg3_slider_pos_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_pos_init),...
    'Units', 'normalized',...
    'Position', [.30 .75 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg3_slider_pos_edit_Callback,...
    'CreateFcn', @bg3_slider_pos_edit_CreateFcn);
handles.bg3_slider_max_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg3_slider_panel,...
    'String', 'Max',...
    'Units', 'normalized',...
    'Position', [.06 .55 .20 .14]);
handles.bg3_slider_max_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_max_init),...
    'Units', 'normalized',...
    'Position', [.30 .52 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg3_slider_max_edit_Callback,...
    'CreateFcn', @bg3_slider_max_edit_CreateFcn);
handles.bg3_slider_min_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg3_slider_panel,...
    'String', 'Min',...
    'Units', 'normalized',...
    'Position', [.06 .32 .20 .14]);
handles.bg3_slider_min_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_min_init),...
    'Units', 'normalized',...
    'Position', [.30 .29 .63 .20],...
    'Enable', 'off',...
    'Callback', @bg3_slider_min_edit_Callback,...
    'CreateFcn', @bg3_slider_min_edit_CreateFcn);
handles.bg3_slider_step_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.bg3_slider_panel,...
    'String', 'Step (%)',...
    'Units', 'normalized',...
    'Position', [.06 .09 .44 .14]);
handles.bg3_slider_step_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.bg3_slider_panel,...
    'String', num2str(handles.bg(3).slider_step_init),...
    'Units', 'normalized',...
    'Position', [.54 .06 .39 .20],...
    'Enable', 'off',...
    'Callback', @bg3_slider_step_edit_Callback,...
    'CreateFcn', @bg3_slider_step_edit_CreateFcn);


% x-shift slider and panel
% ------------------------
handles.x_slider = uicontrol(...
    'Style', 'slider',...
    'Units', 'normalized',...
    'Position', [.05 .45 .60 .03],...
    'Min', handles.bg(1).slider_min_init,...
    'Max', handles.bg(1).slider_max_init,...
    'Value', handles.bg(1).slider_pos_init,...
    'SliderStep', [handles.bg(1).slider_step_init, 0.1],...
    'Enable', 'off',...
    'Units', 'normalized',...
    'Callback', @x_slider_Callback,...
    'CreateFcn', @x_slider_CreateFcn);
handles.x_slider_panel = uipanel(...
    'Title', 'x slider settings',...
    'Units', 'normalized',...
    'Position', [.83 .05 .14 .17]);
handles.x_slider_pos_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.x_slider_panel,...
    'String', 'Pos',...
    'Units', 'normalized',...
    'Position', [.06 .78 .20 .14]);
handles.x_slider_pos_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_pos_init),...
    'Units', 'normalized',...
    'Position', [.30 .75 .63 .20],...
    'Enable', 'off',...
    'Callback', @x_slider_pos_edit_Callback,...
    'CreateFcn', @x_slider_pos_edit_CreateFcn);
handles.x_slider_max_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.x_slider_panel,...
    'String', 'Max',...
    'Units', 'normalized',...
    'Position', [.06 .55 .20 .14]);
handles.x_slider_max_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_max_init),...
    'Units', 'normalized',...
    'Position', [.30 .52 .63 .20],...
    'Enable', 'off',...
    'Callback', @x_slider_max_edit_Callback,...
    'CreateFcn', @x_slider_max_edit_CreateFcn);
handles.x_slider_min_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.x_slider_panel,...
    'String', 'Min',...
    'Units', 'normalized',...
    'Position', [.06 .32 .20 .14]);
handles.x_slider_min_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_min_init),...
    'Units', 'normalized',...
    'Position', [.30 .29 .63 .20],...
    'Enable', 'off',...
    'Callback', @x_slider_min_edit_Callback,...
    'CreateFcn', @x_slider_min_edit_CreateFcn);
handles.x_slider_step_text = uicontrol(...
    'Style', 'text',...
    'Parent', handles.x_slider_panel,...
    'String', 'Step (%)',...
    'Units', 'normalized',...
    'Position', [.06 .09 .44 .14]);
handles.x_slider_step_edit = uicontrol(...
    'Style', 'edit',...
    'Parent', handles.x_slider_panel,...
    'String', num2str(handles.x_slider_step_init),...
    'Units', 'normalized',...
    'Position', [.54 .06 .39 .20],...
    'Enable', 'off',...
    'Callback', @x_slider_step_edit_Callback,...
    'CreateFcn', @x_slider_step_edit_CreateFcn);

set(handles.save_menuitem, 'Enable', 'off');
set(handles.display_x_shift_menuitem, 'Enable', 'off');
set(handles.update_menuitem, 'Enable', 'off');

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
handles.bg(1).fitted = 0;

handles.bg(2).use = 0;
handles.bg(2).root_name = 'background\background2';
handles.bg(2).fn_ext = '.txt';
handles.bg(2).fn_exact = 0;
handles.bg(2).fn_no_ind = 0;
handles.bg(2).manual_scale_init = 0;
handles.bg(2).loaded = 0;
handles.bg(2).fitted = 0;

handles.bg(3).use = 0;
handles.bg(3).root_name = 'background\background3';
handles.bg(3).fn_ext = '.txt';
handles.bg(3).fn_exact = 0;
handles.bg(3).fn_no_ind = 0;
handles.bg(3).manual_scale_init = 0;
handles.bg(3).loaded = 0;
handles.bg(3).fitted = 0;

handles.bg_use_loaded_flags = false(length(handles.bg), 1);
handles.bg_use_loaded = []; % numbers of backgrounds, which were loaded and set to be used
handles.bg_use_fitted_flags = false(length(handles.bg), 1);
handles.bg_use_fitted = []; % numberse of backgrounds, which were fitted

%Make the UI visible.
set(hObject, 'Visible', 'on');

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function load_menuitem_Callback(hObject, eventdata)
% hObject    handle to load_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

handles = guidata(hObject);

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

disable_UI(hObject);
handles = guidata(hObject);

handles.data_orig = data_orig;
handles.N_spectra = size(handles.data_orig,2) - 1;

skip_number = 0;
all_settings = [];
for ii = 1:length(handles.bg)
    handles.bg(ii).loaded = 0; % initialize flag, which indicates, if the background was loaded
    handles.bg(ii).fitted = 0;
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
bg_use_loaded_flags = false(length(handles.bg), 1);
for ii = 1:length(handles.bg)
    if handles.bg(ii).use && handles.bg(ii).loaded
        bg_use_loaded_flags(ii) = 1;
    else
        bg_use_loaded_flags(ii) = 0;
    end
end
bg_use_loaded = 1:length(handles.bg);
bg_use_loaded = bg_use_loaded(bg_use_loaded_flags);
handles.bg_use_loaded_flags = bg_use_loaded_flags;
handles.bg_use_loaded = bg_use_loaded;

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

handles.filepath = curr_path;
handles.current_directory = curr_path;
handles.filename = spc_fn;
guidata(hObject, handles)

enable_UI(hObject);

handles = guidata(hObject);
close(handles.treatdata_waitbar);


function disable_UI(hObject)

handles = guidata(hObject);
set(handles.choose_spec_pushbutton, 'Enable', 'off');
set(handles.up_pushbutton, 'Enable', 'off');
set(handles.down_pushbutton, 'Enable', 'off');

set(handles.bg1_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.bg1_slider, 'Enable', 'off');
set(handles.bg1_slider_pos_edit, 'Enable', 'off');
set(handles.bg1_slider_min_edit, 'Enable', 'off');
set(handles.bg1_slider_max_edit, 'Enable', 'off');
set(handles.bg1_slider_step_edit, 'Enable', 'off');
set(handles.bg2_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.bg2_slider, 'Enable', 'off');
set(handles.bg2_slider_pos_edit, 'Enable', 'off');
set(handles.bg2_slider_min_edit, 'Enable', 'off');
set(handles.bg2_slider_max_edit, 'Enable', 'off');
set(handles.bg2_slider_step_edit, 'Enable', 'off');
set(handles.bg3_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.bg3_slider, 'Enable', 'off');
set(handles.bg3_slider_pos_edit, 'Enable', 'off');
set(handles.bg3_slider_min_edit, 'Enable', 'off');
set(handles.bg3_slider_max_edit, 'Enable', 'off');
set(handles.bg3_slider_step_edit, 'Enable', 'off');
set(handles.x_manual_adjustment_checkbox, 'Enable', 'off');
set(handles.x_slider, 'Enable', 'off');
set(handles.x_slider_pos_edit, 'Enable', 'off');
set(handles.x_slider_min_edit, 'Enable', 'off');
set(handles.x_slider_max_edit, 'Enable', 'off');
set(handles.x_slider_step_edit, 'Enable', 'off');

set(handles.save_menuitem, 'Enable', 'off');
set(handles.display_x_shift_menuitem, 'Enable', 'off');
if handles.data_loaded
    set(handles.update_menuitem, 'Enable', 'on');
else
    set(handles.update_menuitem, 'Enable', 'off');
end

guidata(hObject, handles);


function enable_UI(hObject)
handles = guidata(hObject);

if handles.bg_use_loaded_flags(1)
    set(handles.bg1_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_loaded_flags(2)
    set(handles.bg2_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_loaded_flags(3)
    set(handles.bg3_manual_adjustment_checkbox, 'Enable', 'on');
end
set(handles.x_manual_adjustment_checkbox, 'Enable', 'on');

if handles.chosen_spectrum > 1
    set(handles.down_pushbutton, 'Enable', 'on');
else
    set(handles.down_pushbutton, 'Enable', 'off');
end
if handles.chosen_spectrum < handles.N_spectra
    set(handles.up_pushbutton, 'Enable', 'on');
else
    set(handles.up_pushbutton, 'Enable', 'off');
end
if(handles.N_spectra > 1)
    set(handles.choose_spec_pushbutton, 'Enable', 'on');
end
set(handles.chosen_spec_text, 'String', sprintf('Chosen spectrum: %d', handles.chosen_spectrum));

set(handles.save_menuitem, 'Enable', 'on');
set(handles.display_x_shift_menuitem, 'Enable', 'on');
set(handles.update_menuitem, 'Enable', 'on');

guidata(hObject, handles);

change_spectrum(hObject);



% --------------------------------------------------------------------
function shiftscomp(hObject)
% hObject    handle to figure

handles = guidata(hObject);

if handles.bg_shiftscale && handles.bg_use_loaded_flags(1)
    [data_orig, handles.xshifts, handles.shiftscale_polypar] = handles.shiftscale(...
        handles.data_orig, handles.bg(1).orig, handles.bg_shiftscale_polydeg, handles.bg_shiftscale_bg1int,...
        handles.bg_shiftscale_polyint);
else
    data_orig = handles.data_orig;
    handles.xshifts = zeros(handles.N_spectra, 1);
    handles.shiftscale_polypar = 0;
end
bg_use_loaded = handles.bg_use_loaded;

same_scale_spectra = cell(1, length(bg_use_loaded) + 1);
for ii = 1:length(bg_use_loaded)
    same_scale_spectra{ii} = handles.bg(bg_use_loaded(ii)).orig;
end
same_scale_spectra{end} = data_orig;
trimmed_spectra = handles.same_scale(same_scale_spectra);

for ii = 1:length(bg_use_loaded)
    handles.bg(bg_use_loaded(ii)).spc = trimmed_spectra{ii};
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
bg_use_loaded = handles.bg_use_loaded;

[Y,lind] = min(abs(handles.x_scale-handles.fitinterval(1)));
[Y,uind] = min(abs(handles.x_scale-handles.fitinterval(2)));
weight = handles.construct_weight(handles.x_scale(lind:uind), handles.important_intervals);
par_num = length(bg_use_loaded) + handles.polysize + 1;
par = zeros(par_num, handles.N_spectra);
base_poly = handles.polybase(handles.polysize,handles.x_scale);
coef = handles.coef;

base = zeros(length(handles.x_scale), par_num + 1);
base(:,1) = handles.x_scale;
for ii = 1:length(bg_use_loaded)
    base(:,ii+1) = handles.bg(bg_use_loaded(ii)).spc(:,2)/sqrt(sum(handles.bg(bg_use_loaded(ii)).spc(:,2).^2));
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
    if handles.bg_use_loaded_flags(1) % normalize intensity only, if the first background is used
        handles.spectra_corr(:,jj) = (handles.spectra_xshifted(:,jj) / sqrt(sum(y(:,jj).^2))...
                                      - base(:,2:end) * par(:,jj)) / par(1,jj);
    else
        handles.spectra_corr(:,jj) = handles.spectra_xshifted(:,jj) - base(:,2:end) * par(:,jj) * sqrt(sum(y(:,jj).^2));
    end
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

% reset flag which indicates if the particular background was fitted
for ii = 1:length(handles.bg)
    handles.bg(ii).fitted = 0;
end
% set fitted background flag and summary fitted background flags for backgrounds, which were fitted
bg_use_fitted_flags = false(length(handles.bg), 1);
for ii = bg_use_loaded
    handles.bg(ii).fitted = 1;
    bg_use_fitted_flags(ii) = 1;
end
handles.bg_use_fitted_flags = bg_use_fitted_flags;
handles.bg_use_fitted = handles.bg_use_loaded; % contains numbers of backgrounds, which were fitted

guidata(hObject, handles);


% --------------------------------------------------------------------
function treatdata_manual(hObject)
% hObject    handle to figure
  
handles = guidata(hObject);
  
bg_use_loaded = handles.bg_use_loaded;

lind = handles.fit_lind;
uind = handles.fit_uind;

jj = handles.chosen_spectrum;

y = handles.spectra_xshifted(:,jj);
par_num = handles.par_num;
par = handles.par(:, jj);
weight = handles.weight;
base = handles.base;
coef = handles.coef;

N_flags = length(bg_use_loaded);
man_treatment_flags = false(N_flags, 1);
slider_pos = ones(N_flags, 1);
for ii = 1:N_flags
    man_treatment_flags(ii) = handles.bg(bg_use_loaded(ii)).manual_scale(jj);
    if man_treatment_flags(ii)
        slider_pos(ii) = handles.bg(bg_use_loaded(ii)).slider_pos(jj);
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

handles.spectra_corr(:,jj) = handles.spectra_xshifted(:,jj) / sqrt(sum(y.^2)) - base(:,2:end) * par;
if handles.bg_use_loaded_flags(1) % normalize intensity only, if the first background is used
    handles.spectra_corr(:,jj) = (handles.spectra_xshifted(:,jj) / sqrt(sum(y.^2)) - base(:,2:end) * par) / par(1);
else
    handles.spectra_corr(:,jj) = handles.spectra_xshifted(:,jj) - base(:,2:end) * par * sqrt(sum(y.^2));    
end


handles.par(:,jj) = par;
handles.par_init(auto_treatment,jj) = par(auto_treatment);

guidata(hObject, handles);

  
% --- Executes on button press in choose_spec_pushbutton.
function choose_spec_pushbutton_Callback(hObject, eventdata)
% hObject    handle to choose_spec_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles = guidata(hObject);
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
function down_pushbutton_Callback(hObject, eventdata)
% hObject    handle to down_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles = guidata(hObject);
if handles.chosen_spectrum <= 2
    handles.chosen_spectrum = 1;
    set(handles.down_pushbutton, 'Enable', 'off');
else
    handles.chosen_spectrum = handles.chosen_spectrum - 1;
end
if handles.chosen_spectrum < handles.N_spectra
    set(handles.up_pushbutton, 'Enable', 'on');
end

set(handles.chosen_spec_text, 'String', sprintf('Chosen spectrum: %d', handles.chosen_spectrum),...
    'BackgroundColor', 'green');
guidata(hObject, handles);
change_spectrum(hObject);
  

% --- Executes on button press in up_pushbutton.
function up_pushbutton_Callback(hObject, eventdata)
% hObject    handle to up_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles = guidata(hObject);
if handles.chosen_spectrum >= handles.N_spectra - 1
    handles.chosen_spectrum = handles.N_spectra;
    set(handles.up_pushbutton, 'Enable', 'off')
else
    handles.chosen_spectrum = handles.chosen_spectrum + 1;
end
if handles.chosen_spectrum > 1
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

if handles.bg(1).manual_scale(ii) && handles.bg_use_loaded_flags(1)
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
if handles.bg(2).manual_scale(ii) && handles.bg_use_loaded_flags(2)
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
if handles.bg(3).manual_scale(ii) && handles.bg_use_loaded_flags(3)
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
plot(handles.cor_axes, handles.x_scale, handles.spectra_corr(:,ii));

hold(handles.orig_axes, 'off');
plot(handles.orig_axes, handles.x_scale, handles.spectra_xshifted(:,ii) / sqrt(sum(handles.spectra_xshifted(:,ii).^2)))
legendtext = {'orig spectrum'};
hold(handles.orig_axes, 'all');
plot(handles.orig_axes, handles.x_scale, handles.base(:,2:end) * handles.par(:,ii))
legendtext{end + 1} = 'subtracted spectrum';

N_bg = length(handles.bg_use_fitted);
for kk = 1:N_bg
    plot(handles.orig_axes, handles.x_scale, handles.base(:,kk+1) * handles.par(kk,ii), '-');
    legendtext{end + 1} = sprintf('bg%d', handles.bg_use_loaded(kk));
end

plot(handles.orig_axes, handles.x_scale,...
    handles.base(:,(N_bg + 2):end) * handles.par((N_bg + 1):end,ii))
legendtext{end + 1} = 'polynome';

legend(handles.orig_axes, legendtext, 'Location', 'Best')
guidata(hObject,handles);


% --------------------------------------------------------------------
function save_menuitem_Callback(hObject, eventdata)
% hObject    handle to save_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles = guidata(hObject);

savedata = [handles.x_scale, handles.spectra_corr];
I = find(handles.filename == '.', 1, 'last');
filename = [handles.filepath, handles.filename(1:I-1), '_kor.txt'];
fprintf('Saving file:\n%s\n', filename);
save(filename,'savedata', '-ascii');
fprintf('Done.\n');


% --------------------------------------------------------------------
function settings_menuitem_Callback(hObject, eventdata)
% hObject    handle to settings_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

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

handles = guidata(hObject);

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

settings_handles.save_pushbutton = uicontrol('Style', 'pushbutton', 'Units', 'pixels', 'Position', [600, 40, 45, 30],...
    'String', 'Save', 'Callback', @settings_save_pushbutton_Callback);
settings_handles.load_pushbutton = uicontrol('Style', 'pushbutton', 'Units', 'pixels', 'Position', [651, 40, 45, 30],...
    'String', 'Load', 'Callback', @settings_load_pushbutton_Callback);
settings_handles.ok_pushbutton = uicontrol('Style', 'pushbutton', 'Units', 'pixels', 'Position', [600, 5, 45, 30],...
    'String', 'OK', 'Callback', @settings_ok_pushbutton_Callback);
settings_handles.cancel_pushbutton = uicontrol('Style', 'pushbutton', 'Units', 'pixels',...
    'Position', [651, 5, 45, 30], 'String', 'Cancel', 'Callback', @settings_cancel_pushbutton_Callback);


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

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(1).use = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(1).fn_exact_checkbox.
function settings_bg1_fn_exact_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(1).fn_exact_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(1).fn_exact = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg_shiftscale_checkbox.
function settings_bg_shiftscale_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg_shiftscale_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg_shiftscale = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(2).use_checkbox.
function settings_bg2_use_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(2).use_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(2).use = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(2).fn_exact_checkbox.
function settings_bg2_fn_exact_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(1).fn_exact_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(2).fn_exact = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(3).use_checkbox.
function settings_bg3_use_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(3).use_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(3).use = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --- Executes on button press in bg(3).fn_exact_checkbox.
function settings_bg3_fn_exact_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg(3).fn_exact_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
settings_handles = guidata(hObject);
settings_handles.bg(3).fn_exact = get(hObject, 'Value');
guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --------------------------------------------------------------------
function settings_save_pushbutton_Callback(hObject, eventdata)

save_settings(hObject);

settings_handles = guidata(hObject);
handles = guidata(settings_handles.main_figure);

fprintf('Saving settings file...\n');
filter_spec={'*.par','Parameter files (*.par)';
             '*.*','All Files (*.*)'};
dialog_title = 'Save settings';
[filename, file_path] = uiputfile(filter_spec, dialog_title,...
    handles.current_directory);
fprintf('%s...', [file_path, filename]);
fID = fopen([file_path, filename], 'w');
fprintf(fID, '%% Parameters for bgcor program\n');
t = datestr(now, 'mmm dd, yyyy HH:MM:SS');
fprintf(fID, '%% %s\n', t);
fprintf(fID, '\n');
fprintf(fID, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fID, '%% Main background fit settings\n');
fprintf(fID, '%% ****************************\n\n');
fprintf(fID, '%% Background will be fitted only at fitinterval interval\n');
fprintf(fID, 'fitinterval = [%.2f, %.2f]\n\n', handles.fitinterval);
fprintf(fID, '%% Degree of polynomial background\n');
fprintf(fID, 'polysize = %d\n\n', handles.polysize);
fprintf(fID, '%% Penalty for negative bands\n');
fprintf(fID, 'coef = %f\n\n', handles.coef);
fprintf(fID, '%% 1 if background fit should be repeated second time, 0 otherwise\n');
fprintf(fID, 'doublefit = %d\n\n', handles.doublefit);
fprintf(fID, '%% intervals with different importance [start, end, importance; ...]\n');
if isempty(handles.important_intervals)
    fprintf(fID, 'impint = []\n\n');
elseif size(handles.important_intervals, 1) == 1
    fprintf(fID, 'impint = [%.2f, %.2f, %g]\n\n', handles.important_intervals);
else
    fprintf(fID, 'impint = [\n');
    for ii = 1:size(handles.important_intervals, 1)
        fprintf(fID, '          %.2f, %.2f, %g\n', handles.important_intervals(ii,:));
    end
    fprintf(fID, '         ]\n\n');
end

for ii = 1:length(handles.bg)
    fprintf(fID, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf(fID, '%% Background %d\n', ii);
    fprintf(fID, '%% ****************************\n\n');
    fprintf(fID, '%% 1 if background %d should be used, 0 otherwise\n', ii);
    fprintf(fID, 'bg%d.use = %d\n\n', ii, handles.bg(ii).use);
    fprintf(fID, '%% 1 if background %d filename should match exactly, 0 otherwise\n', ii);
    fprintf(fID, 'bg%d.fn_exact = %d\n\n', ii, handles.bg(ii).fn_exact);
    fprintf(fID, '%% 1 if background %d is set to manual defaultly, 0 otherwise\n', ii);
    fprintf(fID, 'bg%d.manual_scale_init = %d\n\n', ii, handles.bg(ii).manual_scale_init);
    fprintf(fID, '%% root filename of background %d\n', ii);
    fprintf(fID, 'bg%d.root_name = ''%s''\n\n', ii, handles.bg(ii).root_name);
    fprintf(fID, '%% file extension of background %d (it can contain end of filename too)\n', ii);
    fprintf(fID, 'bg%d.fn_ext = ''%s''\n\n', ii, handles.bg(ii).fn_ext);
    fprintf(fID, '%% index of number in filename, which will be used for background filename autodiscover,\n');
    fprintf(fID, '%% use 0 if no number should be used.\n');
    fprintf(fID, 'bg%d.fn_no_ind = %d\n\n', ii, handles.bg(ii).fn_no_ind);
    if ii == 1
        fprintf(fID, '%% 1 if x scale should be shifted according to a one band in background %d, 0 otherwise\n', ii);
        fprintf(fID, 'bg_shiftscale = %d\n\n', handles.bg_shiftscale);
        fprintf(fID, '%% interval used for fit of background %d and measured spectra for shift of x scale\n', ii);
        fprintf(fID, 'bg_shiftscale_bg1int = [%.2f, %.2f]\n\n', handles.bg_shiftscale_bg1int);
        fprintf(fID, '%% degree of polynomial used for fit of background %d and measured spectra\n', ii);
        fprintf(fID, '%% for shift of x scale\n');
        fprintf(fID, 'bg_shiftscale_polydeg = %d\n\n', handles.bg_shiftscale_polydeg);
        fprintf(fID, '%% intervals [start, end, start, end] of polynomial prefit used for fit of\n');
        fprintf(fID, '%% background %d and measured spectra for shift of x scale\n', ii);
        fprintf(fID, 'bg_shiftscale_polyint = [%.2f, %.2f, %.2f, %.2f]\n\n', handles.bg_shiftscale_polyint);
    end
end
fclose(fID);
fprintf('done.\n');


% --------------------------------------------------------------------
function settings_load_pushbutton_Callback(hObject, eventdata)

settings_handles = guidata(hObject);
handles = guidata(settings_handles.main_figure);
load_settings_menuitem_Callback(settings_handles.main_figure, eventdata);
handles = guidata(settings_handles.main_figure);

weights_sample_edit_string = mat2str(handles.important_intervals);
set(settings_handles.fitinterval1_edit, 'String', num2str(handles.fitinterval(1)));
set(settings_handles.fitinterval2_edit, 'String', num2str(handles.fitinterval(2)));
set(settings_handles.polydeg_edit, 'String', num2str(handles.polysize));
set(settings_handles.coef_edit, 'String', num2str(handles.coef, '%g'));
set(settings_handles.doublefit_checkbox, 'Value', handles.doublefit);
set(settings_handles.weights_sample_edit, 'String', weights_sample_edit_string);

for ii = 1:length(handles.bg)
    set(settings_handles.bg(ii).use_checkbox, 'Value', handles.bg(ii).use);
    set(settings_handles.bg(ii).fn_exact_checkbox, 'Value', handles.bg(ii).fn_exact);
    set(settings_handles.bg(ii).manual_scale_init_checkbox, 'Value', handles.bg(ii).manual_scale_init);
    set(settings_handles.bg(ii).root_name_edit, 'String', handles.bg(ii).root_name);
    set(settings_handles.bg(ii).fn_ext_edit, 'String', handles.bg(ii).fn_ext);
    set(settings_handles.bg(ii).fn_no_ind_edit, 'String', num2str(handles.bg(ii).fn_no_ind));
end

set(settings_handles.bg_shiftscale_checkbox, 'Value', handles.bg_shiftscale);
set(settings_handles.bg_shiftscale_bg1int1_edit, 'String', num2str(handles.bg_shiftscale_bg1int(1)));
set(settings_handles.bg_shiftscale_bg1int2_edit, 'String', num2str(handles.bg_shiftscale_bg1int(2)));
set(settings_handles.bg_shiftscale_polydeg_edit, 'String', num2str(handles.bg_shiftscale_polydeg));
set(settings_handles.bg_shiftscale_polyint1_edit, 'String', num2str(handles.bg_shiftscale_polyint(1)));
set(settings_handles.bg_shiftscale_polyint2_edit, 'String', num2str(handles.bg_shiftscale_polyint(2)));
set(settings_handles.bg_shiftscale_polyint3_edit, 'String', num2str(handles.bg_shiftscale_polyint(3)));
set(settings_handles.bg_shiftscale_polyint4_edit, 'String', num2str(handles.bg_shiftscale_polyint(4)));

for ii = 1:length(handles.bg)
    settings_handles.bg(ii).use = handles.bg(ii).use;
    settings_handles.bg(ii).fn_exact = handles.bg(ii).fn_exact;
    settings_handles.bg(ii).manual_scale_init = handles.bg(ii).manual_scale_init;
end
settings_handles.bg_shiftscale = handles.bg_shiftscale;

guidata(hObject, settings_handles);
set_settings_figure(hObject);


% --------------------------------------------------------------------
function load_settings_menuitem_Callback(hObject, eventdata)
% hObject    handle to load_settings_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles = guidata(hObject);

fprintf('Loading settings file...\n');
filter_spec={'*.par','Parameter files (*.par)';
             '*.*','All Files (*.*)'};
dialog_title = 'Load settings';
[filename, file_path] = uigetfile(filter_spec, dialog_title, handles.current_directory, 'Multiselect', 'off');
if (isequal(filename, 0) || isequal(file_path, 0)) % pushed cancel
    return
end

disable_UI(hObject);
handles = guidata(hObject);

try
    fprintf('%s...\n', [file_path, filename]);
    fid = fopen([file_path, filename], 'r');
    tline = fgetl(fid);
    while ischar(tline) % read line by line
        if ~isempty(tline) && tline(1) ~= '%' % skip empty lines and lines with % at the beginning
            I = find('=' == tline, 1, 'first'); % find = sign
            if ~isempty(I) && I > 1 && length(tline) > I
                par = strtrim(tline(1:I-1));
                fprintf('%s = ', par);
                if strcmp(par, 'fitinterval')
                    fitinterval = eval(tline((I + 1):end));
                    if ~isempty(fitinterval)
                        if ~isequal(size(fitinterval), [1, 2]) || ~isnumeric(fitinterval)
                            msgID = 'settings:BadInput';
                            msg = 'fitinterval must be row vector of 2 numbers.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        fprintf('[%.2f, %.2f]', fitinterval);
                        handles.fitinterval = fitinterval;
                    end
                elseif strcmp(par, 'polysize')
                    strval = strtrim(tline((I + 1):end));
                    if ~isempty(strval)
                        polysize = str2double(strval);
                        if isnan(handles.polysize) || ~isequal(fix(handles.polysize), handles.polysize) ||...
                                handles.polysize < 0
                            msgID = 'settings:BadInput';
                            msg = 'polysize polynomial degree must be a nonnegative integer.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        fprintf('%d', polysize);
                        handles.polysize = polysize;
                    end
                elseif strcmp(par, 'coef')
                    strval = strtrim(tline((I + 1):end));
                    if ~isempty(strval)
                        coef = str2double(strval);
                        if isnan(coef) || coef < 0
                            msgID = 'settings:BadInput';
                            msg = 'coef negative band penalty must be a nonnegative number.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        fprintf('%f', coef);
                        handles.coef = coef;    
                    end
                elseif strcmp(par, 'doublefit')
                    strval = strtrim(tline((I + 1):end));
                    if ~isempty(strval)
                        doublefit = str2double(strval);
                        if ~(doublefit == 0 || doublefit == 1)
                            msgID = 'settings:BadInput';
                            msg = 'doublefit must be 0 or 1.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        fprintf('%d', doublefit);
                        handles.doublefit = doublefit;    
                    end
                elseif strcmp(par, 'impint')
                    strval = strtrim(tline((I + 1):end));
                    I_bb = find('[' == strval, 1, 'first'); % beginning bracket must be at first line
                    if ~isempty(I_bb)
                        I_be = find(']' == strval, 1, 'first');
                        while isempty(I_be)
                            tline = fgetl(fid);
                            I_e = find('=' == tline, 1, 'first');
                            if ~ischar(tline) || ~isempty(I_e)
                                msgID = 'settings:BadInput';
                                msg = 'impint important intervals matrix has not got ending bracket.';
                                exception = MException(msgID, msg);
                                throw(exception)
                            end
                            if ~isempty(tline) && tline(1) ~= '%'
                                strval = sprintf('%s\n%s', strval, strtrim(tline));
                            end
                            I_be = find(']' == tline, 1, 'first');
                        end
                        impint = eval(strval);
                        if ~isempty(impint) && (~isnumeric(impint) || size(impint, 2) ~= 3)
                            msgID = 'settings:BadInput';
                            msg = 'impint important intervals for background fit has bad format.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        if isempty(impint)
                            fprintf('[]');
                        else
                            fprintf('[\n');
                            fprintf('          %.2f, %.2f, %g\n', impint');
                            fprintf('         ]');
                        end
                        handles.important_intervals = impint;
                    end
                elseif strcmp(par, 'bg_shiftscale')
                    strval = strtrim(tline((I + 1):end));
                    if ~isempty(strval)
                        bg_shiftscale = str2double(strval);
                        if ~(bg_shiftscale == 0 || bg_shiftscale == 1)
                            msgID = 'settings:BadInput';
                            msg = 'bg_shiftscale must be 0 or 1.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        fprintf('%d', bg_shiftscale);
                        handles.bg_shiftscale = bg_shiftscale;
                    end
                elseif strcmp(par, 'bg_shiftscale_bg1int')
                    bg1int = eval(tline((I + 1):end));
                    if ~isempty(bg1int)
                        if ~isequal(size(bg1int), [1, 2]) || ~isnumeric(bg1int)
                            msgID = 'settings:BadInput';
                            msg = 'fitinterval must be row vector of 2 numbers.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        if bg1int(1) > bg1int(2)
                            msgID = 'settings:BadInput';
                            msg = 'bg_shiftscale_bg1int interval limit 1 must be less than interval limit 2.';
                            exception = MException(msgID,msg);
                            throw(exception)
                        end
                        fprintf('[%.2f, %.2f]', bg1int);
                        handles.bg_shiftscale_bg1int = bg1int;
                    end    
                elseif strcmp(par, 'bg_shiftscale_polydeg')
                    sc_polydeg = eval(tline((I + 1):end));
                    if ~isempty(sc_polydeg)
                        if isnan(sc_polydeg) || ~isequal(fix(sc_polydeg), sc_polydeg) || sc_polydeg < 0
                            msgID = 'settings:BadInput';
                            msg = 'bg_shiftscale_polydeg polynomial degree must be a nonnegative integer.';
                            exception = MException(msgID,msg);
                            throw(exception)
                        end
                        fprintf('%d', sc_polydeg);
                        handles.bg_shiftscale_polydeg = sc_polydeg;
                    end
                elseif strcmp(par, 'bg_shiftscale_polyint')
                    sc_pint = eval(tline((I + 1):end));
                    if ~isempty(sc_pint)
                        if ~isequal(size(sc_pint), [1, 4]) || ~isnumeric(sc_pint)
                            msgID = 'settings:BadInput';
                            msg = 'bg_shiftscale_polyint fitinterval must be row vector of 4 numbers.';
                            exception = MException(msgID, msg);
                            throw(exception)
                        end
                        if ~isequal(sc_pint, sort(sc_pint))
                            msgID = 'settings:BadInput';
                            msg = 'Shiftscale polynomial prefit interval limits must be in ascending order.';
                            exception = MException(msgID,msg);
                            throw(exception)
                        end
                        fprintf('[%.2f, %.2f, %.2f, %.2f]', sc_pint);
                        handles.bg_shiftscale_polyint = sc_pint;
                    end    
                else
                    for ii = 1:length(handles.bg)
                        if strcmp(par, sprintf('bg%d.use', ii))
                            strval = strtrim(tline((I + 1):end));
                            if ~isempty(strval)
                                use = str2double(strval);
                                if ~(use == 0 || use == 1)
                                    msgID = 'settings:BadInput';
                                    msg = sprintf('bg%d.use must be 0 or 1.', ii);
                                    exception = MException(msgID, msg);
                                    throw(exception)
                                end
                                fprintf('%d', use);
                                handles.bg(ii).use = use;
                                if use && handles.bg(ii).loaded
                                    handles.bg_use_loaded_flags(ii) = 1;
                                else
                                    handles.bg_use_loaded_flags(ii) = 0;
                                end
                            end
                            break;
                        elseif strcmp(par, sprintf('bg%d.fn_exact', ii))
                            strval = strtrim(tline((I + 1):end));
                            if ~isempty(strval)
                                fn_exact = str2double(strval);
                                if ~(fn_exact == 0 || fn_exact == 1)
                                    msgID = 'settings:BadInput';
                                    msg = sprintf('bg%d.fn_exact must be 0 or 1.', ii);
                                    exception = MException(msgID, msg);
                                    throw(exception)
                                end
                                fprintf('%d', fn_exact);
                                handles.bg(ii).fn_exact = fn_exact;
                            end
                            break;
                        elseif strcmp(par, sprintf('bg%d.manual_scale_init', ii))
                            strval = strtrim(tline((I + 1):end));
                            if ~isempty(strval)
                                manual_scale_init = str2double(strval);
                                if ~(manual_scale_init == 0 || manual_scale_init == 1)
                                    msgID = 'settings:BadInput';
                                    msg = sprintf('bg%d.manual_scale_init must be 0 or 1.', ii);
                                    exception = MException(msgID, msg);
                                    throw(exception)
                                end
                                fprintf('%d', manual_scale_init);
                                handles.bg(ii).manual_scale_init = manual_scale_init;
                            end
                            break;
                        elseif strcmp(par, sprintf('bg%d.root_name', ii))
                            strval = tline((I + 1):end);
                            if ~isempty(strtrim(strval))
                                I_a = find('''' == strval);
                                if ~isequal(size(I_a), [1, 2])
                                    msgID = 'settings:BadInput';
                                    msg = sprintf('bg%d.root_name has not got starting or ending or has got bad number of apostrophes', ii);
                                    exception = MException(msgID, msg);
                                    throw(exception)
                                end
                                root_name = strval((I_a(1) + 1):(I_a(2) - 1));
                                if filesep == '/'
                                    root_name = strrep(root_name, '\', '/');
                                elseif filesep == '\'
                                    root_name = strrep(root_name, '/', '\');
                                end
                                fprintf('%s', root_name);
                                handles.bg(ii).root_name = root_name;
                            end
                            break;
                        elseif strcmp(par, sprintf('bg%d.fn_ext', ii))
                            strval = tline((I + 1):end);
                            if ~isempty(strtrim(strval))
                                I_a = find('''' == strval);
                                if ~isequal(size(I_a), [1, 2])
                                    msgID = 'settings:BadInput';
                                    msg = sprintf('bg%d.fn_ext has not got starting or ending or has got bad number of apostrophes', ii);
                                    exception = MException(msgID, msg);
                                    throw(exception)
                                end
                                fn_ext = strval((I_a(1) + 1):(I_a(2) - 1));
                                fprintf('%s', fn_ext);
                                handles.bg(ii).fn_ext = fn_ext;
                            end
                            break;
                        elseif strcmp(par, sprintf('bg%d.fn_no_ind', ii))
                            strval = strtrim(tline((I + 1):end));
                            if ~isempty(strval)
                                fn_no_ind = str2double(strval);
                                if isnan(fn_no_ind) || ~isequal(fix(fn_no_ind), fn_no_ind) || fn_no_ind < 0
                                    msgID = 'settings:BadInput';
                                    msg = sprintf('bg%d.fn_no_ind index of autodiscovering number must be a nonnegative integer.', ii);
                                    exception = MException(msgID, msg);
                                    throw(exception)
                                end
                                fprintf('%d', fn_no_ind);
                                handles.bg(ii).fn_no_ind = fn_no_ind;
                            end
                            break;
                        end
                    end
                end
                fprintf('\n');
            end
        end
        tline = fgetl(fid);
    end
    bg_use_loaded = 1:length(handles.bg);
    bg_use_loaded = bg_use_loaded(handles.bg_use_loaded_flags);
    handles.bg_use_loaded = bg_use_loaded;
catch ME
    getReport(ME)
    h_errordlg=errordlg(sprintf('%s', ME.message), 'Input error');
    waitfor(h_errordlg);
    fclose(fid);
    return
end

fclose(fid);
fprintf('done.\n');
guidata(hObject, handles);


% --------------------------------------------------------------------
function settings_ok_pushbutton_Callback(hObject, eventdata)

settings_handles = guidata(hObject);
disable_UI(settings_handles.main_figure);

save_settings(hObject);

settings_handles = guidata(hObject);
handles = guidata(settings_handles.main_figure);

close(handles.settings_figure);

guidata(handles.main_figure, handles);


function save_settings(hObject)

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
            handles.bg_use_loaded_flags(ii) = 1;
        else
            handles.bg_use_loaded_flags(ii) = 0;
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
    bg_use_loaded = 1:length(handles.bg);
    bg_use_loaded = bg_use_loaded(handles.bg_use_loaded_flags);
    handles.bg_use_loaded = bg_use_loaded;
    
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

guidata(handles.main_figure, handles);


function settings_cancel_pushbutton_Callback(hObject, eventdata)

settings_handles = guidata(hObject);
handles = guidata(settings_handles.main_figure);

close(handles.settings_figure);

guidata(handles.main_figure, handles);


% --------------------------------------------------------------------
function display_x_shift_menuitem_Callback(hObject, eventdata)
% hObject    handle to display_x_shift_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles = guidata(hObject);

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
function update_menuitem_Callback(hObject, eventdata)
% hObject    handle to update_menuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% shiftscomp(hObject);
% handles = guidata(hObject);
% 
% handles.spectra_xshifted = handles.spectra_orig;
% guidata(hObject, handles);
handles = guidata(hObject);

disable_UI(hObject);
handles = guidata(hObject);
handles.treatdata_waitbar = waitbar(0, 'Fitting background to spectra. Please wait...');
guidata(hObject, handles);
shiftscomp(hObject);
treatdata(hObject);
handles = guidata(hObject);

if handles.bg_use_loaded_flags(1)
    set(handles.bg1_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_loaded_flags(2)
    set(handles.bg2_manual_adjustment_checkbox, 'Enable', 'on');
end
if handles.bg_use_loaded_flags(3)
    set(handles.bg3_manual_adjustment_checkbox, 'Enable', 'on');
end
set(handles.x_manual_adjustment_checkbox, 'Enable', 'on');

guidata(hObject, handles);
enable_UI(hObject);

handles = guidata(hObject);
close(handles.treatdata_waitbar);



% --- Executes on button press in bg1_manual_adjustment_checkbox.
function bg1_manual_adjustment_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg1_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg1_manual_adjustment_checkbox
handles = guidata(hObject);
handles.bg(1).manual_scale(handles.chosen_spectrum) = get(hObject, 'Value');
guidata(hObject, handles)
set_slider_setting_panels(hObject);


% --- Executes on button press in bg2_manual_adjustment_checkbox.
function bg2_manual_adjustment_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg2_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg2_manual_adjustment_checkbox
handles = guidata(hObject);
handles.bg(2).manual_scale(handles.chosen_spectrum) = get(hObject, 'Value');
guidata(hObject, handles)
set_slider_setting_panels(hObject);


% --- Executes on button press in bg3_manual_adjustment_checkbox.
function bg3_manual_adjustment_checkbox_Callback(hObject, eventdata)
% hObject    handle to bg3_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of bg3_manual_adjustment_checkbox
handles = guidata(hObject);
handles.bg(3).manual_scale(handles.chosen_spectrum) = get(hObject, 'Value');
guidata(hObject, handles)
set_slider_setting_panels(hObject);


% --- Executes on button press in x_manual_adjustment_checkbox.
function x_manual_adjustment_checkbox_Callback(hObject, eventdata)
% hObject    handle to x_manual_adjustment_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: get(hObject,'Value') returns toggle state of x_manual_adjustment_checkbox
handles = guidata(hObject);
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
function bg1_slider_Callback(hObject, eventdata)
% hObject    handle to bg1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(1).slider_pos(ii) = get(hObject, 'Value');

set(handles.bg1_slider_pos_edit, 'String', num2str(handles.bg(1).slider_pos(ii)));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg1_slider_CreateFcn(hObject, eventdata)
% hObject    handle to bg1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end


% --- Executes on slider movement.
function bg2_slider_Callback(hObject, eventdata)
% hObject    handle to bg2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(2).slider_pos(ii) = get(hObject, 'Value');

set(handles.bg2_slider_pos_edit, 'String', num2str(handles.bg(2).slider_pos(ii)));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg2_slider_CreateFcn(hObject, eventdata)
% hObject    handle to bg2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end



% --- Executes on slider movement.
function bg3_slider_Callback(hObject, eventdata)
% hObject    handle to bg3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(3).slider_pos(ii) = get(hObject, 'Value');

set(handles.bg3_slider_pos_edit, 'String', num2str(handles.bg(3).slider_pos(ii)));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg3_slider_CreateFcn(hObject, eventdata)
% hObject    handle to bg3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end


% --- Executes on slider movement.
function x_slider_Callback(hObject, eventdata)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.x_slider_pos(ii) = get(hObject, 'Value');

set(handles.x_slider_pos_edit, 'String', num2str(handles.x_slider_pos(ii)));

handles.spectra_xshifted(:,ii) =...
    spline(handles.x_scale + handles.x_slider_pos(ii), handles.spectra_orig(:,ii), handles.x_scale);


guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function x_slider_CreateFcn(hObject, eventdata)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end



function bg1_slider_pos_edit_Callback(hObject, eventdata)
% hObject    handle to bg1_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg1_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_pos_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(1).slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'Value', handles.bg(1).slider_pos(ii));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg1_slider_pos_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg1_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg1_slider_max_edit_Callback(hObject, eventdata)
% hObject    handle to bg1_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg1_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_max_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(1).slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'Max',handles.bg(1).slider_max(ii));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function bg1_slider_max_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg1_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg1_slider_min_edit_Callback(hObject, eventdata)
% hObject    handle to bg1_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg1_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_min_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(1).slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'Min', handles.bg(1).slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg1_slider_min_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg1_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg1_slider_step_edit_Callback(hObject, eventdata)
% hObject    handle to bg1_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg1_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of bg1_slider_step_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(1).slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.bg1_slider, 'SliderStep', [handles.bg(1).slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg1_slider_step_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg1_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg2_slider_pos_edit_Callback(hObject, eventdata)
% hObject    handle to bg2_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg2_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_pos_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(2).slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'Value', handles.bg(2).slider_pos(ii));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg2_slider_pos_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg2_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg2_slider_max_edit_Callback(hObject, eventdata)
% hObject    handle to bg2_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg2_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_max_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(2).slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'Max', handles.bg(2).slider_max(ii));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function bg2_slider_max_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg2_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg2_slider_min_edit_Callback(hObject, eventdata)
% hObject    handle to bg2_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg2_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_min_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(2).slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'Min', handles.bg(2).slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg2_slider_min_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg2_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function bg2_slider_step_edit_Callback(hObject, eventdata)
% hObject    handle to bg2_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg2_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of bg2_slider_step_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(2).slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.bg2_slider, 'SliderStep', [handles.bg(2).slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg2_slider_step_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg2_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor', 'white');
end


function bg3_slider_pos_edit_Callback(hObject, eventdata)
% hObject    handle to bg3_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg3_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_pos_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(3).slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'Value', handles.bg(3).slider_pos(ii));

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function bg3_slider_pos_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg3_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg3_slider_max_edit_Callback(hObject, eventdata)
% hObject    handle to bg3_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg3_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_max_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(3).slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'Max', handles.bg(3).slider_max(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg3_slider_max_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg3_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg3_slider_min_edit_Callback(hObject, eventdata)
% hObject    handle to bg3_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg3_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_min_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(3).slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'Min', handles.bg(3).slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg3_slider_min_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg3_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function bg3_slider_step_edit_Callback(hObject, eventdata)
% hObject    handle to bg3_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of bg3_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of bg3_slider_step_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.bg(3).slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.bg3_slider, 'SliderStep', [handles.bg(3).slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bg3_slider_step_edit_CreateFcn(hObject, eventdata)
% hObject    handle to bg3_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function x_slider_pos_edit_Callback(hObject, eventdata)
% hObject    handle to x_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of x_slider_pos_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_pos_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.x_slider_pos(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'Value', handles.x_slider_pos(ii));

handles.spectra_xshifted(:,ii) =...
    spline(handles.x_scale + handles.x_slider_pos(ii), handles.spectra_orig(:,ii), handles.x_scale);

guidata(hObject, handles);
treatdata_manual(hObject);
plot_function(hObject);


% --- Executes during object creation, after setting all properties.
function x_slider_pos_edit_CreateFcn(hObject, eventdata)
% hObject    handle to x_slider_pos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function x_slider_max_edit_Callback(hObject, eventdata)
% hObject    handle to x_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of x_slider_max_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_max_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.x_slider_max(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'Max', handles.x_slider_max(ii));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function x_slider_max_edit_CreateFcn(hObject, eventdata)
% hObject    handle to x_slider_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function x_slider_min_edit_Callback(hObject, eventdata)
% hObject    handle to x_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of x_slider_min_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_min_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.x_slider_min(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'Min', handles.x_slider_min(ii));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_slider_min_edit_CreateFcn(hObject, eventdata)
% hObject    handle to x_slider_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function x_slider_step_edit_Callback(hObject, eventdata)
% hObject    handle to x_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hints: get(hObject,'String') returns contents of x_slider_step_edit as text
%        str2double(get(hObject,'String')) returns contents of x_slider_step_edit as a double
handles = guidata(hObject);
ii = handles.chosen_spectrum;

handles.x_slider_step(ii) = str2double(get(hObject, 'String'));

set(handles.x_slider, 'SliderStep', [handles.x_slider_step(ii), 0.1]);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_slider_step_edit_CreateFcn(hObject, eventdata)
% hObject    handle to x_slider_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end
