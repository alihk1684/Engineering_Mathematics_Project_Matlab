close all; clear all; clc;

% Parameters
T = 2*pi;
dt = 1e-3;
var_noise1 = 200;
sigma1 = sqrt(var_noise1);
var_noise2 = 0.02;
sigma2 = sqrt(var_noise2);

t = -2*T:dt:2*T;

%% Task 1
square_wave = sign(sin(2*pi*t/T));

%% Task 2
function xN = fourier_series_square_wave(t, T, N)
    w0 = 2*pi/T;
    xN = zeros(size(t));
    
    for k = 1:N
        n = 2*k -1;
        xN = xN + (1/n) * sin(n*w0*t);
    end

    xN = (4/pi) * xN;
end

%% Task 3
figure('Name', 'Task 3: Fourier Series Approximation', 'NumberTitle', 'off');

tiledlayout(3,2,'TileSpacing','compact','Padding','compact')
Nlist = [1, 3, 5, 10, 25, 50];

for i = 1:length(Nlist)
    N = Nlist(i);
    xN = fourier_series_square_wave(t, T, N);
    
    nexttile
    plot(t, square_wave, 'b', 'LineWidth', 2);
    hold on;
    plot(t, xN, 'r', 'LineWidth', 1);
    
    axis([-2*T, 2*T, -1.3, 1.3]);
    grid on;
    title(['N = ', num2str(N)]);
end

%% Task 4

noise1 = sigma1 * randn(size(t));
noisy_square1 = square_wave + noise1;

noise2 = sigma2 * randn(size(t));
noisy_square2 = square_wave + noise2;

figure('Name', 'Task 4: Original Wave vs Noisy Wave', 'NumberTitle', 'off');

subplot(2,1,1);
plot(t, noisy_square1, 'g', 'LineWidth', 1);
hold on; grid on;
plot(t, square_wave, 'b', 'LineWidth', 3);

ymax = max(abs(noisy_square1));
axis([-2*T, 2*T, -1.01*ymax, 1.01*ymax]);
title('var = 200');
xlabel('t'); ylabel('Amplitude');
legend('Noisy Signal', 'Original Signal', 'Location','best');

subplot(2,1,2);
plot(t, noisy_square2, 'g', 'LineWidth', 1);
hold on; grid on;
plot(t, square_wave, 'b', 'LineWidth', 3);

ymax = max(abs(noisy_square2));
axis([-2*T, 2*T, -1.01*ymax, 1.01*ymax]);
title('var = 0.02');
xlabel('t'); ylabel('Amplitude');
legend('Noisy Signal', 'Original Signal', 'Location','best');

%% Task 5

% Function to compute Fourier series approximation using BOTH sine and cosine
function xN_approx = fourier_series_approx_full(signal, t, T, N)
    w0 = 2*pi/T;
    xN_approx = zeros(size(t));
    
    % DC component (a0)
    a0 = (2/T) * trapz(t(1:round(end/2)), signal(1:round(end/2)));
    xN_approx = xN_approx + a0/2;
    
    for n = 1:N
        % Cosine coefficient
        an = (2/T) * trapz(t(1:round(end/2)), signal(1:round(end/2)) .* cos(n*w0*t(1:round(end/2))));
        
        % Sine coefficient
        bn = (2/T) * trapz(t(1:round(end/2)), signal(1:round(end/2)) .* sin(n*w0*t(1:round(end/2))));
        
        % Add contribution
        xN_approx = xN_approx + an * cos(n*w0*t) + bn * sin(n*w0*t);
    end
end

% var = 200
figure('Name', 'Task 5: Fourier Approx OF Noisy Signal (var = 200)', 'NumberTitle', 'off');
Nlist = [1, 3, 5, 10, 25, 50];
tiledlayout(3,2,'TileSpacing','compact','Padding','compact');

for i = 1:length(Nlist)
    N = Nlist(i);
    xN_noisy = fourier_series_approx_full(noisy_square1, t, T, N);
    
    nexttile
    plot(t, noisy_square1, 'g', 'LineWidth', 0.2);
    hold on;
    plot(t, xN_noisy/2, 'r', 'LineWidth', 1.5);
    plot(t, square_wave, 'b--', 'LineWidth', 2);
    
    axis([-T, T, -1.4*sigma1, 1.4*sigma1]);
    grid on;
    title(['N = ', num2str(N), ' (var = 200)']);
    xlabel('t'); ylabel('Amplitude');
end
legend('Noisy Signal', 'Fourier Approx', 'Original Square');

% var = 0.02
figure('Name', 'Task 5: Fourier Approx OF Noisy Signal (var = 0.02)', 'NumberTitle', 'off');
tiledlayout(3,2,'TileSpacing','compact','Padding','compact');

for i = 1:length(Nlist)
    N = Nlist(i);
    xN_noisy = fourier_series_approx_full(noisy_square2, t, T, N);
    
    nexttile
    plot(t, noisy_square2, 'g', 'LineWidth', 0.6);
    hold on;
    plot(t, xN_noisy/2, 'r', 'LineWidth', 1.5);
    plot(t, square_wave, 'b--', 'LineWidth', 2);
    
    ymax = max(abs(noisy_square2));
    axis([-2*T, 2*T, -1.05*ymax, 1.05*ymax]);
    grid on;
    title(['N = ', num2str(N), ' (var = 0.02)']);
    xlabel('t'); ylabel('Amplitude');
end
legend('Noisy Signal', 'Fourier Approx', 'Original Square');