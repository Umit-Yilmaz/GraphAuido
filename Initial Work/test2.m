% Load the audio file
[audio, Fs] = audioread('piano_c_major_scale.wav');  % Replace 'example.wav' with your file
audio = mean(audio, 2);  % Convert to mono if stereo
audio = audio / max(abs(audio));  % Normalize

% Parameters for analysis
winLength = 2048;  % Window size for FFT
hopLength = 512;   % Hop size between windows
numWindows = floor((length(audio) - winLength) / hopLength) + 1;
time = (0:numWindows-1) * hopLength / Fs;  % Time vector

% Initialize results
frequencies = zeros(1, numWindows);
amplitudes = zeros(1, numWindows);

% Analyze each window
for i = 1:numWindows
    % Extract the windowed segment
    startIdx = (i-1)*hopLength + 1;
    endIdx = startIdx + winLength - 1;
    segment = audio(startIdx:endIdx) .* hamming(winLength);
    
    % Perform FFT
    fftResult = fft(segment);
    mag = abs(fftResult(1:floor(winLength/2)));  % Magnitude spectrum
    freqs = (0:floor(winLength/2)-1) * Fs / winLength;  % Frequency vector
    
    % Find the fundamental frequency (pitch)
    [~, idx] = max(mag);  % Index of the peak
    frequencies(i) = freqs(idx);  % Frequency of the peak
    amplitudes(i) = mag(idx);  % Corresponding amplitude
end

% Map frequencies to MIDI notes
notes = round(12 * log2(frequencies / 440) + 69);  % MIDI note numbers
notes(frequencies == 0) = NaN;  % Handle zero frequencies (silence)

% Map MIDI numbers to note names
noteNames = arrayfun(@(x) midiNoteToName(x), notes, 'UniformOutput', false);

% Display some notes
disp('Notes and their Names:');
disp(table(frequencies', notes', noteNames', 'VariableNames', {'Frequency (Hz)', 'MIDI Note', 'Note Name'}));

% 3D Plot
figure;
stem3(time, frequencies, amplitudes, 'filled');  % 3D stem plot
xlabel('Time (s)');
ylabel('Frequency (Hz)');
zlabel('Amplitude');
title('3D Plot of Detected Notes');
grid on;

% Helper Function: Map MIDI number to note name
function noteName = midiNoteToName(midiNumber)
    if isnan(midiNumber)
        noteName = 'Silence';  % Handle silence
    else
        noteNames = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};
        octave = floor((midiNumber - 12) / 12);
        noteIdx = mod(midiNumber, 12) + 1;
        noteName = sprintf('%s%d', noteNames{noteIdx}, octave);
    end
end
