%% --- 1. Setup ---
clear; clc; close all;
a = serialport("COM4", 115200);

% Set up the figure window
figure;
h1 = animatedline('Color', 'b', 'LineWidth', 2); % Line for LDR1
h2 = animatedline('Color', 'r', 'LineWidth', 2); % Line for LDR2
ylim([0 40]); % Arduino analog range
xlabel('Time');
ylabel('Sensor Reading');
title('Real-Time LDR Data');
legend('LDR 1', 'LDR 2');
grid on;

%% --- 2. Run the Real-Time Plot Loop ---
fprintf('Starting real-time plot... Press Ctrl+C to stop.\n');

% We'll show a "window" of the last 200 points
windowSize = 200; 
dataCount = 0;

while ishandle(h1) % Loop as long as the plot window is open
    
    % Read one line of data (e.g., "512,480")
    data_line = readline(a);
    
    % Split the string by the comma
    data = str2double(split(data_line, ','));
    
    % Sometimes a read fails, so check if we got 2 numbers
    if length(data) == 2
        % Add the new data points to the animated lines
        addpoints(h1, dataCount, data(1));
        addpoints(h2, dataCount, data(2));
        
        dataCount = dataCount + 1;
        
        % This is the magic: update the plot window
        % 'limitrate' speeds it up by not drawing every single point
        drawnow limitrate; 
        
        % This automatically slides the X-axis window
        if dataCount > windowSize
            xlim([dataCount - windowSize, dataCount]);
        end
    end
end

%% --- 3. Cleanup ---
clear a;
fprintf('Plot closed. Serial port cleared.\n');