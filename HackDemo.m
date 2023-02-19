%For Sensorineural Hearing Loss
% Load the audio signal

[x, Fs] = audioread('Sensorineural_Severe.wav');
disp(Fs);

% Applying a high-pass filter to remove low-frequency noise and compress the audio signal
[b, a] = butter(4, 1000/(Fs/2), 'high');
x = filter(b, a, x);
x = sign(x) .* log(1 + 100 * abs(x)) / log(101);

% Computing the power spectrum of the signal and identify critical speech sounds
N = length(x);
X = fft(x, N);
P = abs(X).^2 / N;
frequencies = linspace(0, Fs, N);
consonants = frequencies > 2000 & frequencies < 6000;

% Boost high-frequency sounds that are critical for speech perception and amplify the audio signal
P(consonants) = P(consonants) * 10;
x_processed = real(ifft(sqrt(P) .* exp(1i * angle(X)), N));
x_processed = 0.3 * x_processed / max(abs(x_processed));

% Applying noise reduction techniques to further improve speech perception
x_processed = wiener2(x_processed, [3, 3]);


% Compute the difference between the original and processed signals
x_diff = x - x_processed;


% Ploting the original and processed signals as waves
t = linspace(0, length(x)/Fs, length(x));
subplot(2, 1, 1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
plot(t, x_processed);
title('Processed Signal');
xlabel('Time (s)');
ylabel('Amplitude');


% Ploting the difference between the original and processed signals as a wave
t_diff = linspace(0, length(x_diff)/Fs, length(x_diff));
figure;
plot(t_diff, x_diff);
title('Difference between Original and Processed Signals');
xlabel('Time (s)');
ylabel('Amplitude');

% Play the processed audio signal
sound(x, Fs);

