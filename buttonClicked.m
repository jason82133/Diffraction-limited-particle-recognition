% Callback function for button clicks
function buttonClicked(src, ~, x, y)

    clear position
    global selectedWell;  % Declare selectedWell as a global variable

    position = get(src, 'UserData');
    disp(['Button clicked at position: X = ', num2str(position(1)), ', Y = ', num2str(position(2))]);
    
    if ~isempty(selectedWell) == 1
        % Check if the position is already in selectedWell
        idx = find(ismember(selectedWell, position, 'rows'));
    else
        idx = [];
    end

    if isempty(idx)
        % Add the position to selectedWell
        selectedWell = [selectedWell; position];

        % Change the color of the clicked button to red
        set(src, 'BackgroundColor', 'red');

        % Display selected position
        disp(['Selected position: X = ', num2str(position(1)), ', Y = ', num2str(position(2))]);
    else
        % Remove the position from selectedWell
        selectedWell(idx, :) = [];

        % Change the color of the clicked button back to blue
        set(src, 'BackgroundColor', [1, 1, 1]);

        % Display unselected position
        disp(['Unselected position: X = ', num2str(position(1)), ', Y = ', num2str(position(2))]);
    end
end