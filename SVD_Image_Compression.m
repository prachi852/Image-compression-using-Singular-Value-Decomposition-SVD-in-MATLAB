clc;
clear;
close all;

%% Step 1: Create Landscape-like Image

[x,y] = meshgrid(1:256,1:256);

% Sky
A = 180 + 30*(y/256);

% Sun
sun = ((x-190).^2 + (y-55).^2) < 20^2;
A(sun) = 240;

% First Mountain
m1 = 100 + 25*sin(x/25);
A(y > m1) = 100;

% Second Mountain
m2 = 130 + 20*sin(x/18 + 1);
A(y > m2) = 80;

% Lake
mask = (y > 175);
A(mask) = 140 + 15*sin(x(mask)/10);

% Convert to uint8
A = uint8(max(0,min(255,A)));

%% Step 2: Display Original Image

figure(1);
imagesc(A);
colormap gray;
axis image;
title('Original Landscape Image');

%% Step 3: Convert to Double

A = double(A);

%% Step 4: Apply SVD

[U,S,V] = svd(A,'econ');

disp('SVD completed successfully');

%% Step 5: Compressed Image Reconstruction

k_values = [5,20,50,100];

figure(2);

for i = 1:length(k_values)

    k = k_values(i);

    Ak = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';

    subplot(2,2,i);

    imagesc(Ak);
    colormap gray;
    axis image;

    title(['Compressed Image - k = ',num2str(k)]);

end

%% Step 6: Calculate Error and Compression Ratio

[m,n] = size(A);

errors = zeros(1,length(k_values));
compression_ratios = zeros(1,length(k_values));

for i = 1:length(k_values)

    k = k_values(i);

    Ak = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';

    % Relative Reconstruction Error
    errors(i) = norm(A-Ak,'fro')/norm(A,'fro');

    % Storage Calculation
    original_storage = m*n;

    compressed_storage = k*(m+n+1);

    compression_ratios(i) = original_storage/compressed_storage;

    fprintf('\nFor k = %d\n',k);

    fprintf('Relative Error = %.6f\n',errors(i));

    fprintf('Compression Ratio = %.2f\n',compression_ratios(i));

end

%% Step 7: Error Graph

figure(3);

plot(k_values,errors,'-o','LineWidth',2);

xlabel('Number of Singular Values (k)');
ylabel('Relative Reconstruction Error');

title('SVD Reconstruction Error');

grid on;

%% Step 8: Compression Ratio Graph

figure(4);

bar(k_values,compression_ratios);

xlabel('Number of Singular Values (k)');
ylabel('Compression Ratio');

title('SVD Compression Ratio');

grid on;

%% Step 9: Display Completion Message

disp('Image Compression Project Completed Successfully');