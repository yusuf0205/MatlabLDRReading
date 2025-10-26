clc; clear; close all;
a = arduino('COM4', 'Uno'); % Connects to the board
N=512;
x = 0:1:N-1;
fprintf('Collecting %d samples...\n', N);
for i = 1:N
   data2(i) = readVoltage(a, 'A1'); 
   data1(i) = readVoltage(a, 'A0'); % Directly reads the pin
   pause(0.01); % Manages timing from MATLAB
end
disp('Samples Collected ')

% Creating AC Components:
data1_ac = data1 - mean(data1);                                            % mean(data1) is the DC components
data2_ac = data2 - mean(data2);

% Plots:
subplot(3,1,1);
plot(x,data1_ac)
title('LDR01')
subplot(3,1,2)
plot(x,data2_ac)
title('LDR02')

% Correlation:
correlatedValues = xcorr(data1_ac,data2_ac);
subplot(3,1,3);
plot(0: length(correlatedValues)-1,correlatedValues);
title('Correlated Value')

% Filtering (A 5-point moving average filter)
windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
filtered_data = filter(b, a, data1_ac);
figure;
plot(data1_ac, 'b-');  % Original
hold on;
plot(filtered_data, 'r-', 'LineWidth', 2); % Filtered
title('Original vs. Moving Average Filter');
legend('Original Noisy Signal', 'Filtered Smooth Signal');

% Logging
signals_data = [data1_ac'  filtered_data'  data2_ac'];
filename = 'LDRSenorData.xlsx';
headers = {'Original_LDR1_AC', 'Filtered_LDR1', 'Original_LDR2_AC'};
writecell(headers, filename, 'Sheet', 'Signals', 'Range', 'A1');
writematrix(signals_data, filename, 'Sheet', 'Signals', 'Range', 'A2');
writematrix(correlatedValues', filename, 'Sheet', 'Correlation');

fprintf('Successfully saved all data to %s\n', filename);