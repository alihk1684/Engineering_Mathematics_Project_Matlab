close all; clear all; clc;

%% Task 1
original_image = imread('my_image.PNG');

if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
end

original_image = imresize(original_image, [128, 128]);

original_image = im2double(original_image);

figure('Name', 'Task 1: Original Image', 'NumberTitle', 'off');
imshow(original_image);
title('Original 128x128 Image');

%% Task 2
% Compute 2D FFT using built-in function
F_builtin = fft2(original_image);

% Shift zero frequency to center
F_shifted = fftshift(F_builtin);

% Compute inverse FFT using built-in function
reconstructed_builtin = real(ifft2(F_shifted));

%% Task 3

% Get image dimensions
[M, N] = size(original_image);
f = original_image;

% Initialize F(u,v)
F_manual = zeros(M, N);

% Compute 2D DFT using formula: F(u,v) = sum_x=0^M-1 sum_y=0^N-1 f(x,y) * exp(-2πi*(ux/M + vy/N))
for u = 1:M
    for v = 1:N
        sum_val = 0;
        for x = 1:M
            for y = 1:N
                sum_val = sum_val + f(x,y) * exp(-2*pi*1i*((u-1)*(x-1)/M + (v-1)*(y-1)/N));
            end
        end
        F_manual(u,v) = sum_val;
    end
end

%% Task 4

% Define function to keep only center percentage of coefficients
function compressed = keep_center_percentage(spectrum, percentage)
    [M, N] = size(spectrum);
    compressed = zeros(M, N);
    
    center_x = round(M/2);
    center_y = round(N/2);
    radius = round(min(M,N) * (percentage/100) / 2);
    
    for u = 1:M
        for v = 1:N
            dist = sqrt((u - center_x)^2 + (v - center_y)^2);
            if dist <= radius
                compressed(u,v) = spectrum(u,v);
            end
        end
    end
end

% Apply compression for different percentages
percentages = [50, 10, 5];

figure('Name', 'Task 4: copression for different percentages', 'NumberTitle', 'off');
tiledlayout(1,3,'TileSpacing','compact','Padding','compact')

for i = 1:length(percentages)
    % Keep only center percentage of coefficients
    compressed_spectrum = keep_center_percentage(F_shifted, percentages(i));
    
    % Reconstruct image
    reconstructed = real(ifft2(ifftshift(compressed_spectrum)));
    
    % Display
    nexttile
    imshow(reconstructed);
    title([num2str(percentages(i)), '% of Coefficients Kept']);
end

%% Task 5

% ----- Manual Inverse FFT -----
function image = manual_2d_ifft(F_shifted)
    [M, N] = size(F_shifted);
    F = ifftshift(F_shifted);
    image = zeros(M, N);
    
    for x = 1:M
        for y = 1:N
            sum_val = 0;
            for u = 1:M
                for v = 1:N
                    sum_val = sum_val + F(u,v) * exp(2*pi*1i*((u-1)*(x-1)/M + (v-1)*(y-1)/N));
                end
            end
            image(x,y) = real(sum_val / (M*N));
        end
    end
end

% Apply manual inverse FFT
reconstructed_manual = manual_2d_ifft(F_shifted);

% Compare results
difference = reconstructed_builtin - reconstructed_manual;

%% Task 6

compression_ratios = [50, 30, 20, 10, 5, 1];
figure('Name', 'Task 6', 'NumberTitle', 'off');
tiledlayout(2,3,'TileSpacing','compact','Padding','compact')

for i = 1:length(compression_ratios)
    % Compress
    compressed_spectrum = keep_center_percentage(F_shifted, compression_ratios(i));
    
    % Reconstruct
    reconstructed = real(ifft2(ifftshift(compressed_spectrum)));
    
    % Display
    nexttile
    imshow(reconstructed);
    title([num2str(compression_ratios(i)), '% Coefficients Kept']);
end

%% Task 7

% ----- Get F(0,0) from code -----
center_x = round(size(F_shifted,1)/2);
center_y = round(size(F_shifted,2)/2);
F00_code = abs(F_shifted(center_x, center_y));

disp('F(0,0) - From code:');
disp(F00_code);
