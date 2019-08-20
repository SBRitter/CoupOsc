% Simple demonstration for two coupled oscillator 
%
% For more information on the theory, see among others:
% (a) Tilsen, S. 2017. Exertive modulation of speech and articulatory phasing.
%   Journal of Phonetics. dx.doi.org/10.1016/j.wocn.2017.03.001.
% (b) Saltzman, E. & D. Byrd. 2000. Task-dynamics of gestural timing: 
%   Phase windows and multifrequency rhythms. Human Movement Science, 19:499-526.
%
% Author: Simon Roessig, Date: 2019-08-19

%% Define and solve the oscillator model
% The initial phase of the two oscillators
initial_phi1 = 90; % osc1
initial_phi2 = 10; % osc2

% The coupling mode: in vs. anti-phase
mode = "anti"; % alternatives "in" or "anti"

if mode == "in"
    mode_sign = +1;
elseif mode == "anti"
    mode_sign = -1;
end

% Frequency of the oscillators
omega = 15;

% Time span for the integration
tBegin = 0;
tEnd = 30;

% Time step for the Euler method
dt = 0.03; 
tp = tBegin:dt:tEnd;

% Now solve the oscillators
phi1 = zeros(1, length(tp));
phi1(1) = initial_phi1;
phi2 = zeros(1, length(tp));
phi2(1) = initial_phi2;
rel_phase = zeros(1, length(tp));
rel_phase(1) = phi2(1) - phi1(1);
for i = 2:1:length(tp)
    phase_diff = phi2(i-1) - phi1(i-1);
    rel_phase(i) = phase_diff;
    phi1(i) = phi1(i-1) + dt * (2*pi*omega + mode_sign * 5 * sin(deg2rad(phase_diff)));
    phi2(i) = phi2(i-1) + dt * (2*pi*omega - mode_sign * 5 * sin(deg2rad(phase_diff)));
end

%% Visualise it in an animated plot
subplot(1,2,1);
set(gcf, 'Position',  [200, 200, 1050, 450])

% Cycle
y = sin(2*pi*tp); 
x = cos(2*pi*tp);
plot(x,y,':','Color','black','LineWidth',1);
hold on;

% Prepare elements for phase angles of the two oscillators
osc1_point = plot(0,0,'o','MarkerSize',10,'Color','#00ab6b','MarkerFaceColor','#00ab6b');
osc2_point = plot(0,0,'o','MarkerSize',10,'Color','#c95650','MarkerFaceColor','#c95650');
osc1_line = line([0 1],[0 1],'Color','#00ab6b','LineWidth',2);
osc2_line = line([0 1],[0 1],'Color','#c95650','LineWidth',2);
hold on;

% Prepare elements for position of the two oscillators
subplot(1,2,2);
plot(0,0);
pos_osc1 = animatedline('Color','#00ab6b','LineWidth',2);
pos_osc2 = animatedline('Color','#c95650','LineWidth',2);
xlim([-6 6]);
ylim([-1 1]);
hold on;

% Now animate
for i = 1:length(phi1)-1
    
    % Update phase angle cycle plot
    set(osc1_point,'XData', cos(deg2rad(phi1(i))));
    set(osc1_point,'YData', sin(deg2rad(phi1(i))));
    set(osc1_line,'XData', [0 cos(deg2rad(phi1(i)))]);
    set(osc1_line,'YData', [0 sin(deg2rad(phi1(i)))]);
    set(osc2_point,'XData', cos(deg2rad(phi2(i))));
    set(osc2_point,'YData', sin(deg2rad(phi2(i))));
    set(osc2_line,'XData', [0 cos(deg2rad(phi2(i)))]);
    set(osc2_line,'YData', [0 sin(deg2rad(phi2(i)))]);
    drawnow;
    
    % Update position plot
    addpoints(pos_osc1,tp(i),cos(deg2rad(phi1(i))));
    addpoints(pos_osc2,tp(i),cos(deg2rad(phi2(i))));
    xlim([i*dt-6 i*dt+5]);
    
    pause(0.00001);
end
