function dialogBoxWithDropDown()
    % Create a figure
    fig = figure('Name', 'Dialog Box with Drop-Down Menu', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 300, 150], 'MenuBar', 'none', 'ToolBar', 'none');
             
    % Create a drop-down menu
    dropDownItems = {'Option 1', 'Option 2', 'Option 3'};
    dropDown = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
                         'String', dropDownItems, ...
                         'Position', [50, 70, 200, 30]);
                     
    % Create a button to trigger the dialog box
    btn = uicontrol('Parent', fig, 'Style', 'pushbutton', ...
                    'String', 'Open Dialog Box', ...
                    'Position', [100, 20, 100, 30], ...
                    'Callback', @openDialog);
    
    function openDialog(~, ~)
        selectedOptionIndex = get(dropDown, 'Value');
        selectedOption = dropDownItems{selectedOptionIndex};
        
        % Display a dialog box with the selected option
        msgbox(['You selected: ' selectedOption], 'Selected Option');
    end
end