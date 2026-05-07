% Author     :   H. Francalanci
%                Biomechanics and Translational Research in Surgery Group
%                University of Geneva
%                https://www.unige.ch/medecine/chiru/en/research-groups/nicolas-holzer-et-florent-moissenet
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   May 2026
% -------------------------------------------------------------------------
% Description:   Plot absolute thoracic postural profile.
%                Two panels :
%
%                Left panel : Spinal silhouette (sagittal view)
%                  Real positions of markers CV7, TV5, TV8, S1
%                  projected onto the sagittal plane (X-Z Qualisys).
%                  Vectors v_sup, v_mid, v_inf drawn with angles.
%                  Arc indicating the approximated Cobb angle.
%
%                Right panel : Postural classification
%                  Colour-coded vertical gauge with 4 Cobb zones
%                  (Flat / Moderate / High / Very high) and marker
%                  positioned at the patient value.
%                  Segmental angles displayed as text.
%
% Inputs  : Trial      (struct)  with Joint(11).PostureSummary populated
%                                and Trial.Marker for marker positions
%           taskName   (char)    e.g. 'ANALYTIC1'
%           outputDir  (char)    PNG output folder ('' = no save)
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution -
% NonCommercial 4.0 International License. To view a copy of this license,
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function PlotCobbPosture(Trial, taskName, outputDir)

if nargin < 3, outputDir = ''; end

if length(Trial.Joint) < 11 || ...
   ~isfield(Trial.Joint(11),'PostureSummary') || ...
   ~isfield(Trial.Joint(11).PostureSummary,'thoracic_curvature_angle')
    warning('PostureSummary non disponible pour %s.', taskName);
    return;
end

ps = Trial.Joint(11).PostureSummary;
nRef = min(100, Trial.n1);


CV7 = getPos(Trial.Marker, 'CV7', nRef);
TV5 = getPos(Trial.Marker, 'TV5', nRef);
TV8 = getPos(Trial.Marker, 'TV8', nRef);
S1  = getPos(Trial.Marker, 'S1',  nRef);


pts_sag = [CV7([1,3]), TV5([1,3]), TV8([1,3]), S1([1,3])];
mnames  = {'CV7','TV5','TV8','S1'};


fig = figure('Color','w','Units','centimeters', ...
             'Position',[2 2 28 18],'Name','Thorax Posture Profile');

tl = tiledlayout(fig, 1, 2, 'TileSpacing','loose','Padding','compact');
title(tl, sprintf('Thorax Posture Profile — %s', taskName), ...
    'FontSize', 13, 'FontWeight','bold', 'Interpreter','none');

ax1 = nexttile(tl, 1);
hold(ax1, 'on');
ax1.Color = [0.97 0.98 1.0];
grid(ax1, 'on'); ax1.GridAlpha = 0.2;
ax1.Box = 'off'; ax1.FontSize = 9;
axis(ax1, 'equal');

c_spine  = [0.25 0.25 0.25];
c_vsup   = [0.18 0.42 0.78];
c_vmid   = [0.55 0.35 0.75];
c_vinf   = [0.82 0.35 0.18];
c_cobb   = [0.85 0.18 0.18];
c_marker = [0.92 0.46 0.13];

x = pts_sag(1,:);
z = pts_sag(2,:);


xf = linspace(1,4,100);
xs = spline(1:4, x, xf);
zs = spline(1:4, z, xf);
plot(ax1, xs, zs, '-', 'Color',[c_spine, 0.4], 'LineWidth', 1.5);


scatter(ax1, x, z, 80, c_marker, 'filled', 'MarkerEdgeColor','w', 'LineWidth',1.5);
labels_offset = [0.008 0; 0.008 0; 0.008 0; 0.008 0];
for i = 1:4
    text(ax1, x(i)+labels_offset(i,1), z(i)+labels_offset(i,2), ...
        mnames{i}, 'FontSize', 9, 'FontWeight','bold', ...
        'Color', c_spine, 'VerticalAlignment','middle');
end


scale = 0.8;
tv8x = x(3); tv8z = z(3);
cv7x = x(1); cv7z = z(1);
tv5x = x(2); tv5z = z(2);
s1x  = x(4); s1z  = z(4);


quiver(ax1, tv8x, tv8z, (cv7x-tv8x)*scale, (cv7z-tv8z)*scale, 0, ...
    'Color',c_vsup,'LineWidth',2,'MaxHeadSize',0.4);
text(ax1, tv8x+(cv7x-tv8x)*0.5-0.015, tv8z+(cv7z-tv8z)*0.5, ...
    'v_{sup}','FontSize',8,'Color',c_vsup,'HorizontalAlignment','right');


quiver(ax1, tv8x, tv8z, (tv5x-tv8x)*scale, (tv5z-tv8z)*scale, 0, ...
    'Color',c_vmid,'LineWidth',1.5,'MaxHeadSize',0.4,'LineStyle','--');
text(ax1, tv8x+(tv5x-tv8x)*0.5+0.01, tv8z+(tv5z-tv8z)*0.5, ...
    'v_{mid}','FontSize',8,'Color',c_vmid);


quiver(ax1, s1x, s1z, (tv8x-s1x)*scale, (tv8z-s1z)*scale, 0, ...
    'Color',c_vinf,'LineWidth',2,'MaxHeadSize',0.4);
text(ax1, s1x+(tv8x-s1x)*0.5+0.01, s1z+(tv8z-s1z)*0.5, ...
    'v_{inf}','FontSize',8,'Color',c_vinf);

r = 0.05;
ang1 = atan2(cv7z-tv8z, cv7x-tv8x);
ang2 = atan2(s1z-tv8z,  s1x-tv8x);
angs = linspace(ang1, ang2, 60);
plot(ax1, tv8x + r*cos(angs), tv8z + r*sin(angs), ...
    '-', 'Color',c_cobb, 'LineWidth',2);
mid_ang = (ang1+ang2)/2;
text(ax1, tv8x + (r+0.02)*cos(mid_ang), tv8z + (r+0.02)*sin(mid_ang), ...
    sprintf('%.1f°', ps.thoracic_curvature_angle), ...
    'FontSize',10,'FontWeight','bold','Color',c_cobb, ...
    'HorizontalAlignment','center');

xlabel(ax1, 'X — Antérieur (m)', 'FontSize', 9);
ylabel(ax1, 'Z — Supérieur (m)', 'FontSize', 9);
title(ax1, 'Spinal markers — Sagittal plane', 'FontSize',10,'FontWeight','bold');


legend(ax1, {'Spinal curve','v_{sup} (TV8→CV7)','v_{mid} (TV8→TV5)','v_{inf} (S1→TV8)'}, ...
    'Location','southeast','FontSize',8,'Box','off');

hold(ax1, 'off');

ax2 = nexttile(tl, 2);
hold(ax2, 'on');
ax2.Color = [0.98 0.98 0.98];
ax2.Box = 'off'; ax2.FontSize = 9;
ax2.XTick = []; ax2.YTick = [];
xlim(ax2, [0 3]); ylim(ax2, [0 75]);


zones = [0 20; 20 40; 40 55; 55 75];
colors = {[0.30 0.75 0.45],  
          [0.25 0.55 0.85],   
          [0.95 0.72 0.20],  
          [0.88 0.22 0.22]};  
zlabels = {'Flat trunk','Moderate','High','Very high'};
zranges = {'<20°','20-40°','40-55°','>55°'};

for iz = 1:4
    y0 = zones(iz,1); y1 = zones(iz,2);
    patch(ax2, [0.3 1.2 1.2 0.3], [y0 y0 y1 y1], colors{iz}, ...
        'FaceAlpha',0.75,'EdgeColor','w','LineWidth',0.5);
    ymid = (y0+y1)/2;
    text(ax2, 1.35, ymid, zlabels{iz}, 'FontSize',9,'FontWeight','bold', ...
        'Color',colors{iz}*0.6,'VerticalAlignment','middle');
    text(ax2, 1.35, ymid-3.5, zranges{iz}, 'FontSize',8, ...
        'Color',[0.5 0.5 0.5],'VerticalAlignment','middle');
end


cobb = min(ps.thoracic_curvature_angle, 74);
scatter(ax2, 0.75, cobb, 200, [0.1 0.1 0.1], 'filled', ...
    'MarkerEdgeColor','w','LineWidth',2);
plot(ax2, [0.3 1.2], [cobb cobb], '--', 'Color',[0.1 0.1 0.1], ...
    'LineWidth',1.2);
text(ax2, 0.05, cobb, sprintf('%.1f°', ps.thoracic_curvature_angle), ...
    'FontSize',11,'FontWeight','bold','Color',[0.1 0.1 0.1], ...
    'VerticalAlignment','middle','HorizontalAlignment','left');


ax2.YTick = [0 20 40 55 75];
ax2.YTickLabel = {'0°','20°','40°','55°','75°'};
ax2.YAxis.Visible = 'on';
ylabel(ax2, 'Thoracic Cobb angle (°)', 'FontSize',9);
title(ax2, 'Postural classification', 'FontSize',10,'FontWeight','bold');

text(ax2, 1.7, 58, sprintf('Upper (CV7-TV5-TV8) : %.1f°', ps.thoracic_upper_curvature), ...
    'FontSize',8,'Color',[0.3 0.3 0.3]);
text(ax2, 1.7, 51, sprintf('Lower (TV5-TV8-S1)  : %.1f°', ps.thoracic_lower_curvature), ...
    'FontSize',8,'Color',[0.3 0.3 0.3]);
text(ax2, 1.7, 40, ps.thorax_posture_type, 'FontSize',8,'FontWeight','bold', ...
    'Color',[0.2 0.2 0.2],'Interpreter','none');

hold(ax2, 'off');


if ~isempty(outputDir)
    fname = fullfile(outputDir, [taskName, '_Posture.png']);
    exportgraphics(fig, fname, 'BackgroundColor','white','Resolution',150);
end
end


function pos = getPos(MarkerArray, label, nRef)
pos = zeros(3,1);
for i = 1:length(MarkerArray)
    if strcmp(MarkerArray(i).label, label)
        traj = MarkerArray(i).Trajectory.full;
        pos  = mean(traj(:,1,1:min(nRef,size(traj,3))), 3);
        return;
    end
end
end