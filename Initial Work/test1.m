% Load an audio signal
[audio, Fs] = audioread('piano_c_major_scale.wav');  % Replace 'example.wav' with your file name

% Generate a time vector
t = (0:length(audio)-1) / Fs;

% Define a third axis (artificial for visualization)
z = linspace(0, 1, length(audio));  % For example, a gradual change

% Create 3D plot
figure;
plot3(t, audio, z, 'b');  % 3D line plot
xlabel('Time (s)');
ylabel('Amplitude');
zlabel('Z-axis (arbitrary)');
grid on;
title('3D Plot of Audio Signal');

% Alternative: Use mesh/surf for spectrogram-based visualization
% Spectrogram
[s, f, t_s, p] = spectrogram(audio(:,1), 256, 250, 256, Fs, 'yaxis');
p_dB = 10 * log10(abs(p));  % Power in dB

% Plot spectrogram in 3D
figure;
surf(t_s, f, p_dB, 'EdgeColor', 'none');  % 3D surface plot
axis tight;
view([140 45]);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
zlabel('Power (dB)');
colorbar;
title('3D Spectrogram of Audio Signal');
