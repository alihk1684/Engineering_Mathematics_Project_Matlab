clear; close all; clc;

%% Part 1
% Parameters
R = 1;              % sphere radius
alpha = 1;       % thermal diffusivity

% Discretization
r = linspace(0, R, 50);
t = linspace(0, 0.5, 100);

ms = 2;  % spherical symmetry for pdepe

% Solve PDE
sol = pdepe(ms, @(r,t,u,DuDr)pdefun_sphere(r,t,u,DuDr,alpha), ...
               @icfun_sphere, ...
               @(rl,ul,rr,ur,t)bcfun_sphere(rl,ul,rr,ur,t), ...
               r, t);

T = sol(:,:,1);   % temperature matrix size: (length(t) x length(r))

% Plot 1: Temperature distribution vs radius and time
figure('Name','Part 1.1: Sphere Heat Diffusion: T(r,t)','NumberTitle','off');
surf(r, t, T, 'EdgeColor','none'); grid on;
xlabel('Radius r'); ylabel('Time t'); zlabel('Temperature T');
title('Temperature Distribution in Sphere (radial)');

% Plot 2: Temperature at the center vs time
figure('Name','Part 1.2: Center Temperature: T(0,t)','NumberTitle','off');
plot(t, T(:,1), 'LineWidth', 2); grid on;
xlabel('Time t'); ylabel('T(0,t)');
title('Temperature at Sphere Center vs Time');

% Sphere PDE functions
function [c,f,s] = pdefun_sphere(~,~,~,DuDr,alpha)
    c = 1;
    f = alpha * DuDr;
    s = 0;
end

function u0 = icfun_sphere(r)
    % Example IC: uniform initial temperature
    u0 = sech(r);
end

function [pl,ql,pr,qr] = bcfun_sphere(~,~,~,~,~)
    % Left boundary r=0 (symmetry): dT/dr = 0
    pl = 0;
    ql = 1;

    % Right boundary r=R:
    
    pr = 0;
    qr = 1;
end

%% Part 2
% Parameters
L = 1;              % rod length
alpha = 2;

x = linspace(0, L, 100);
t = linspace(0, 0.5, 120);

m = 0;  % 1D

sol = pdepe(m, @(x,t,u,DuDx)pdefun_1d(x,t,u,DuDx,alpha), ...
               @icfun_1d, ...
               @(xl,ul,xr,ur,t)bcfun_1d(xl,ul,xr,ur,t), ...
               x, t);

T = sol(:,:,1);

% Plot: T(x,t)
figure('Name','Part 2.1: Temperature Distribution T(x,t)','NumberTitle','off');
surf(x, t, T, 'EdgeColor','none'); grid on;
xlabel('Position x'); ylabel('Time t'); zlabel('Temperature T');
title('Temperature Distribution in 1D Rod');

% Steady-state (t -> infinity)
T_ss = T(end,:);   % last time row approximates steady-state

figure('Name','Part 2.2: Steady-State Temperature','NumberTitle','off');
plot(x, T_ss, 'LineWidth', 2); grid on;
xlabel('x'); ylabel('T_{ss}(x)');
title('Steady-State Temperature Profile (approx. t \rightarrow \infty)');

% Functions
function [c,f,s] = pdefun_1d(~,~,~,DuDx,alpha)
    c = 1;
    f = alpha * DuDx;
    s = 0;
end

function u0 = icfun_1d(x)
    u0 = -sin(3*pi*x) + (1/4)*sin(6*pi*x);
end

function [pl,ql,pr,qr] = bcfun_1d(~,ul,~,ur,~)
  
    pl = ul;
    ql = 0;
    pr = ur;
    qr = 0;
end
