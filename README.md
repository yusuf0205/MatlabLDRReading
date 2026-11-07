# MATLAB and Arduino Dual-LDR Signal Processing

Dual-channel Light Dependent Resistor (LDR) data acquisition, DC offset removal, cross-correlation, FIR moving-average filtering, and real-time serial plotting implemented in MATLAB with an Arduino Uno for the EC1110 Digital Signal Processing course.

## Overview

This project interfaces an Arduino Uno with MATLAB to sample two analog photoresistor channels (`A0` and `A1`) and apply time-domain digital signal processing techniques:

1. **Batch Acquisition and DSP (`BasicAnalogReading.m`)**
   - Connects to the Arduino Uno over `COM4` using the MATLAB Support Package for Arduino Hardware (`arduino('COM4', 'Uno')`).
   - Collects $N = 512$ voltage samples per channel at 10 ms intervals (`readVoltage`).
   - Extracts AC signal components by subtracting the sample mean (DC component) from each channel:
     $$x_{\text{AC}}[n] = x[n] - \frac{1}{N}\sum_{k=0}^{N-1} x[k]$$
   - Computes the cross-correlation sequence $R_{x_1 x_2}[m]$ between the two AC-coupled LDR channels using `xcorr`.
   - Applies a 5-point causal moving-average FIR low-pass filter (`filter(b, a, data1_ac)` with $b_k = 0.2$) to suppress high-frequency sensor and quantization noise.
   - Exports raw AC signals, filtered output, and cross-correlation sequences to `LDRSenorData.xlsx` (`Signals` and `Correlation` sheets).

2. **Real-Time Sliding-Window Visualizer (`RealTimeRunning.m`)**
   - Streams comma-separated dual-LDR readings from the Arduino over UART at `115200` baud (`serialport("COM4", 115200)`).
   - Updates a dual-trace `animatedline` figure with `drawnow limitrate` and a 200-sample sliding time window.

## Repository Contents

| File | Description |
| :--- | :--- |
| `BasicAnalogReading.m` | 512-sample acquisition, AC coupling, cross-correlation, 5-point moving average filter, and Excel export |
| `RealTimeRunning.m` | Real-time 115200-baud serial stream plotter with a 200-sample sliding window |
| `LDRSenorData.xlsx` | Logged experimental dataset containing raw AC signals, filtered output, and cross-correlation values |
| `Raw Data Plot.png` | Plot of raw analog voltage readings from the LDR channels |
| `AC Component Plot.png` | Zero-mean AC components of LDR1 and LDR2 |
| `Filtered Plot.png` | Output of the 5-point moving-average FIR filter |
| `Comparision of unfiltered and filtered Plot.png` | Overlay comparison of noisy AC input versus moving-average filtered signal |
| `Correlation Plot.png` | Cross-correlation sequence between LDR1 and LDR2 AC signals |
| `Data Log File.png` | Screenshot of the exported Excel workbook (`LDRSenorData.xlsx`) |

## Signal Processing Results

### Unfiltered vs. 5-Point Moving-Average Filtered Signal
![Comparison of Unfiltered and Filtered Plot](Comparision%20of%20unfiltered%20and%20filtered%20Plot.png)

### AC Components and Cross-Correlation
| AC Component Signals | Cross-Correlation Sequence |
| :---: | :---: |
| ![AC Component Plot](AC%20Component%20Plot.png) | ![Correlation Plot](Correlation%20Plot.png) |

## Requirements and Usage

- **Hardware**: Arduino Uno with two LDR voltage-divider circuits connected to analog pins `A0` and `A1`.
- **Software**: MATLAB (R2021a or newer) with the **MATLAB Support Package for Arduino Hardware** installed.

To run the batch DSP pipeline:
1. Update the serial port in `BasicAnalogReading.m` (default `'COM4'`) to match your system.
2. Execute `BasicAnalogReading` in the MATLAB Command Window.

To run the real-time serial plotter:
1. Flash your Arduino Uno with a sketch that prints `analogRead(A0),analogRead(A1)` at `115200` baud.
2. Execute `RealTimeRunning` in MATLAB.

## License

MIT License. See [LICENSE](LICENSE) for details.
