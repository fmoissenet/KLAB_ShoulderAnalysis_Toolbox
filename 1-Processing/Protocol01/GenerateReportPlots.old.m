% Author     :   F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   June 2022
% -------------------------------------------------------------------------
% Description:   To be defined
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function [] = GenerateReportPlots(Folder,Session,Report,Normal)


% Motion amplitudes
% -------------------------------------------------------------------------
% Initialise figure
f1 = figure('color','white','Position',[311 18 734 632]); hold on; grid on; box on;
spacing = 0.08;
padding = 0;
margin = 0.07;
% ANALYTIC2
subaxis(2,2,1,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Elevation coronale');
% yyaxis left;
set(gca,'YColor','black');
xticks([1 2 3]);
xticklabels({'Gauche' 'Droite' 'Norme'});
ylabel('Angle humérothoracique max. (°deg)');
xlim([0 4.15]);
ylim([0 180]);
I = imread([Folder.dependencies,'\Images\coronalElevation.png']); 
h = image([0.2 3.9],[150 20],I); 
alpha(0.2);
value = []; imax = [];
value = abs(Report.Analytic(2).Kinematics.Joint(6).Euler);
for i = 1:size(value,3)
    imax = [imax max(value(1:end,1,i))];
end
bar(1,mean(imax),'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
errorbar(1,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
text(1,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
value = []; imax = [];
value = abs(Report.Analytic(2).Kinematics.Joint(1).Euler);
for i = 1:size(value,3)
    imax = [imax max(value(1:end,1,i))];
end
bar(2,mean(imax),'FaceColor','blue','EdgeColor','none','FaceAlpha',0.5);
errorbar(2,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
text(2,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
bar(3,Normal.Analytic(2).mean,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5);
errorbar(3,Normal.Analytic(2).mean,Normal.Analytic(2).std,Normal.Analytic(2).std,[],[],'Color','black','Linewidth',2,'Marker','none');
text(3,5,{['\bf{',num2str(round(Normal.Analytic(2).mean)),'}'],['\rm{(',num2str(round(Normal.Analytic(2).std)),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
yyaxis right;
ylim([-0.5 10.5]);
yticks([0:1:10]);
% ylabel('Douleur (EVA)');
set(gca,'YColor','black');
plot(4,Session.Pain.value(5),'Marker','>','Markersize',10,'MarkerFaceColor','black','MarkerEdgeColor','black');
% ANALYTIC1
subaxis(2,2,2,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Elevation sagittale');
yyaxis left;
set(gca,'YColor','black');
xticks([1 2 3]);
xticklabels({'Gauche' 'Droite' 'Norme'});
% ylabel('Angle humérothoracique max. (°deg)');
xlim([0 4.15]);
ylim([0 180]);
I = imread([Folder.dependencies,'\Images\sagittalElevation.png']); 
h = image([0.3 3.8],[160 20],I);  
alpha(0.2);
value = []; imax = [];
value = abs(Report.Analytic(1).Kinematics.Joint(6).Euler);
for i = 1:size(value,3)
    imax = [imax max(value(1:end,3,i))];
end
bar(1,mean(imax),'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
errorbar(1,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
text(1,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
value = []; imax = [];
value = abs(Report.Analytic(1).Kinematics.Joint(1).Euler);
for i = 1:size(value,3)
    imax = [imax max(value(1:end,3,i))];
end
bar(2,mean(imax),'FaceColor','blue','EdgeColor','none','FaceAlpha',0.5);
errorbar(2,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
text(2,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
bar(3,Normal.Analytic(1).mean,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5);
errorbar(3,Normal.Analytic(1).mean,Normal.Analytic(1).std,Normal.Analytic(1).std,[],[],'Color','black','Linewidth',2,'Marker','none');
text(3,5,{['\bf{',num2str(round(Normal.Analytic(1).mean)),'}'],['\rm{(',num2str(round(Normal.Analytic(1).std)),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
yyaxis right;
ylim([-0.5 10.5]);
yticks([0:1:10]);
ylabel('Douleur (EVA)');
set(gca,'YColor','black');
plot(4,Session.Pain.value(4),'Marker','>','Markersize',10,'MarkerFaceColor','black','MarkerEdgeColor','black');
% ANALYTIC3
subaxis(2,2,3,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Rotation externe');
yyaxis left;
set(gca,'YColor','black');
xticks([1 2 3]);
xticklabels({'Gauche' 'Droite' 'Norme'});
ylabel('Angle humérothoracique max. (°deg)');
xlim([0 4.15]);
ylim([0 100]);
I = imread([Folder.dependencies,'\Images\externalRotation.png']); 
h = image([0.65 3.35],[90 10],I); 
alpha(0.2);
value = []; imax = [];
value = abs(Report.Analytic(3).Kinematics.Joint(6).Euler);
for i = 1:size(value,3)
    imax = [imax max(value(1:end,2,i))];
end
bar(1,mean(imax),'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
errorbar(1,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
text(1,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
value = []; imax = [];
value = abs(Report.Analytic(3).Kinematics.Joint(1).Euler);
for i = 1:size(value,3)
    imax = [imax max(value(1:end,2,i))];
end
bar(2,mean(imax),'FaceColor','blue','EdgeColor','none','FaceAlpha',0.5);
errorbar(2,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
text(2,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
bar(3,Normal.Analytic(3).mean,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5);
errorbar(3,Normal.Analytic(3).mean,Normal.Analytic(3).std,Normal.Analytic(3).std,[],[],'Color','black','Linewidth',2,'Marker','none');
text(3,5,{['\bf{',num2str(round(Normal.Analytic(3).mean)),'}'],['\rm{(',num2str(round(Normal.Analytic(3).std)),')}']}, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');
yyaxis right;
ylim([-0.5 10.5]);
yticks([0:1:10]);
% ylabel('Douleur (EVA)');
set(gca,'YColor','black');
plot(4,Session.Pain.value(6),'Marker','>','Markersize',10,'MarkerFaceColor','black','MarkerEdgeColor','black');
% ANALYTIC4
if length(Report.Analytic) >= 3
    subaxis(2,2,4,'Spacing',spacing,'Padding',padding,'Margin',margin);
    hold on; grid on; box on;
    title('Rotation interne');
    yyaxis left;
    set(gca,'YColor','black');
    xticks([1 2 3]);
    xticklabels({'Gauche' 'Droite' 'Norme'});
%     ylabel('Angle humérothoracique max. (°deg)');
    xlim([0 4.15]);
    ylim([0 100]);
    I = imread([Folder.dependencies,'\Images\internalRotation.png']); 
    h = image([0.7 3.3],[90 10],I);  
    alpha(0.2);
    value = []; imax = [];
    value = abs(Report.Analytic(4).Kinematics.Joint(6).Euler);
    for i = 1:size(value,3)
        imax = [imax max(value(1:end,2,i))];
    end
    bar(1,mean(imax),'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
    errorbar(1,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
    text(1,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
        'HorizontalAlignment','center','VerticalAlignment','bottom');
    value = []; imax = [];
    value = abs(Report.Analytic(4).Kinematics.Joint(1).Euler);
    for i = 1:size(value,3)
        imax = [imax max(value(1:end,2,i))];
    end
    bar(2,mean(imax),'FaceColor','blue','EdgeColor','none','FaceAlpha',0.5);
    errorbar(2,mean(imax),std(imax),std(imax),[],[],'Color','black','Linewidth',2);
    text(2,5,{['\bf{',num2str(round(mean(imax))),'}'],['\rm{(',num2str(round(std(imax))),')}']}, ...
        'HorizontalAlignment','center','VerticalAlignment','bottom');
    bar(3,Normal.Analytic(4).mean,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5);
    errorbar(3,Normal.Analytic(4).mean,Normal.Analytic(4).std,Normal.Analytic(4).std,[],[],'Color','black','Linewidth',2,'Marker','none');
    text(3,5,{['\bf{',num2str(round(Normal.Analytic(4).mean)),'}'],['\rm{(',num2str(round(Normal.Analytic(4).std)),')}']}, ...
        'HorizontalAlignment','center','VerticalAlignment','bottom');
    yyaxis right;
    ylim([-0.5 10.5]);
    yticks([0:1:10]);
    ylabel('Douleur (EVA)');
    set(gca,'YColor','black');
    plot(4,Session.Pain.value(7),'Marker','>','Markersize',10,'MarkerFaceColor','black','MarkerEdgeColor','black');
end
% SAVE
saveas(gcf,'Figure1.png');
close(f1);

% Scapular rhythm
% -------------------------------------------------------------------------
% Initialise figure
f2 = figure('color','white','Position',[90 140 600 500]); hold on; grid on; box on;
spacing = 0.08;
padding = 0;
margin = 0.09;
% During coronal elevation
subaxis(2,2,1,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Rythme scapulaire moyen');
xticks([1 2 3])
xticklabels({'Gauche' 'Droite' 'Norme'});
xlim([0 4.15]);
ylim([0 4]);
I = imread([Folder.dependencies,'\Images\coronalElevation.png']); 
h = image([0.2 3.9],[3.3 0.5],I); 
alpha(0.2);
ylabel({'\bf{Elevation coronale}','\rm{GH:ST}'});
x = [1 2 3];
y = [mean(Report.Analytic(2).Kinematics.SHR(2).value,3);mean(Report.Analytic(2).Kinematics.SHR(1).value,3)];
bar(x(1),y(1),'Facecolor','red','Edgecolor','none','FaceAlpha',0.5);
bar(x(2),y(2),'Facecolor','blue','Edgecolor','none','FaceAlpha',0.5);
bar(x(3),Normal.Analytic(2).SHR.mean,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5);
errorbar([1 2 3],...
         [mean(Report.Analytic(2).Kinematics.SHR(2).value,3),mean(Report.Analytic(2).Kinematics.SHR(1).value,3),Normal.Analytic(2).SHR.mean],...
         [std(Report.Analytic(2).Kinematics.SHR(2).value,1,3),std(Report.Analytic(2).Kinematics.SHR(1).value,1,3),Normal.Analytic(2).SHR.std],...
         'Linestyle','none','Linewidth',2,'Color','black');
text(1,0.1,{['\bf{',num2str(round(mean(Report.Analytic(2).Kinematics.SHR(2).value,3),2)),'}'],['\rm{(',num2str(round(std(Report.Analytic(2).Kinematics.SHR(2).value,1,3),2)),')}']}, ...
     'HorizontalAlignment','center','VerticalAlignment','bottom');
text(2,0.1,{['\bf{',num2str(round(mean(Report.Analytic(2).Kinematics.SHR(1).value,3),2)),'}'],['\rm{(',num2str(round(std(Report.Analytic(2).Kinematics.SHR(1).value,1,3),2)),')}']}, ...
     'HorizontalAlignment','center','VerticalAlignment','bottom');
text(3,0.1,{['\bf{',num2str(round(Normal.Analytic(2).SHR.mean,2)),'}'],['\rm{(',num2str(round(Normal.Analytic(2).SHR.std,2)),')}']}, ...
     'HorizontalAlignment','center','VerticalAlignment','bottom'); 
subaxis(2,2,2,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Rythme scapulaire continu');
xticks(0:10:180);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlim([0,180]);
ylim([0,5]);
xlabel(['Mouvement humeral (',Report.Analytic(2).Kinematics.Joint(2).units,')']);
ylabel('GH:ST');     
line([0 180],[Normal.Analytic(2).SHR.mean Normal.Analytic(2).SHR.mean],'Color',[0.5 0.5 0.5],'Linewidth',2,'Linestyle',':');
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.SHR(2).tvalue(1:iframe,:,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.SHR(1).tvalue(1:iframe,:,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);    
end
% During sagittal elevation
subaxis(2,2,3,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xticks([1 2 3])
xticklabels({'Gauche' 'Droite' 'Norme'});
xlim([0 4.15]);
ylim([0 4]);
I = imread([Folder.dependencies,'\Images\sagittalElevation.png']); 
h = image([0.3 3.8],[3.3 0.5],I); 
alpha(0.2);
ylabel({'\bf{Elevation sagittale}','\rm{GH:ST}'});
x = [1 2 3];
y = [mean(Report.Analytic(1).Kinematics.SHR(2).value,3);mean(Report.Analytic(1).Kinematics.SHR(1).value,3)];
bar(x(1),y(1),'Facecolor','red','Edgecolor','none','FaceAlpha',0.5);
bar(x(2),y(2),'Facecolor','blue','Edgecolor','none','FaceAlpha',0.5);
bar(x(3),Normal.Analytic(1).SHR.mean,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.5);
errorbar([1 2 3], ...
         [mean(Report.Analytic(1).Kinematics.SHR(2).value,3),mean(Report.Analytic(1).Kinematics.SHR(1).value,3),Normal.Analytic(1).SHR.mean],...
         [std(Report.Analytic(1).Kinematics.SHR(2).value,1,3),std(Report.Analytic(1).Kinematics.SHR(1).value,1,3),Normal.Analytic(1).SHR.std],...
         'Linestyle','none','Linewidth',2,'Color','black');
text(1,0.1,{['\bf{',num2str(round(mean(Report.Analytic(1).Kinematics.SHR(2).value,3),2)),'}'],['\rm{(',num2str(round(std(Report.Analytic(1).Kinematics.SHR(2).value,1,3),2)),')}']}, ...
     'HorizontalAlignment','center','VerticalAlignment','bottom');
text(2,0.1,{['\bf{',num2str(round(mean(Report.Analytic(1).Kinematics.SHR(1).value,3),2)),'}'],['\rm{(',num2str(round(std(Report.Analytic(1).Kinematics.SHR(1).value,1,3),2)),')}']}, ...
     'HorizontalAlignment','center','VerticalAlignment','bottom');
text(3,0.1,{['\bf{',num2str(round(Normal.Analytic(1).SHR.mean,2)),'}'],['\rm{(',num2str(round(Normal.Analytic(1).SHR.std,2)),')}']}, ...
     'HorizontalAlignment','center','VerticalAlignment','bottom');     
subaxis(2,2,4,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xticks(0:10:180);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlim([0,180]);
ylim([0,5]);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(2).units,')']);
ylabel('GH:ST');     
line([0 180],[Normal.Analytic(1).SHR.mean Normal.Analytic(1).SHR.mean],'Color',[0.5 0.5 0.5],'Linewidth',2,'Linestyle',':');
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.SHR(2).tvalue(1:iframe,:,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.SHR(1).tvalue(1:iframe,:,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);    
end
% SAVE
saveas(gcf,'Figure2.png');
close(f2);

% Scapulothoracic kinematics
% -------------------------------------------------------------------------
% Initialise figure
f3 = figure('color','white','Position',[90 140 1100 560]); hold on; grid on; box on;
spacing = 0.08;
padding = 0;
margin = 0.08;
% During coronal elevation
subaxis(2,3,1,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title(Report.Analytic(2).Kinematics.Joint(3).legend{1});
xticks(0:10:180);
yticks(0:10:180);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
yticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlabel(['Mouvement humeral (',Report.Analytic(2).Kinematics.Joint(3).units,')']);
ylabel({'\bf{Elevation coronale}','\rm{Angle (°deg)}'});
xlim([0,180]);
ylim([0,180]);
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
plot(1:1:180,1:1:180,'Color',[0.2 0.2 0.2],'Linewidth',2,'Linestyle',':');
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.Joint(8).Euler(1:iframe,1,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.Joint(3).Euler(1:iframe,1,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,2,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title(Report.Analytic(2).Kinematics.Joint(3).legend{2});
xticks(0:10:180);
yticks(0:10:60);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
% yticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlabel(['Mouvement humeral (',Report.Analytic(2).Kinematics.Joint(3).units,')']);
ylabel(['Angle (',Report.Analytic(2).Kinematics.Joint(3).units,')']);
xlim([0,180]);
ylim([0,60]);
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.Joint(8).Euler(1:iframe,2,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.Joint(3).Euler(1:iframe,2,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,3,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title(Report.Analytic(2).Kinematics.Joint(3).legend{3});
xticks(0:10:180);
yticks(-40:10:40);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
% yticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlabel(['Mouvement humeral (',Report.Analytic(2).Kinematics.Joint(3).units,')']);
ylabel(['Angle (',Report.Analytic(2).Kinematics.Joint(3).units,')']);
xlim([0,180]);
ylim([-40,40]);
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.Joint(8).Euler(1:iframe,3,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Kinematics.Joint(3).Euler(1:iframe,3,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);
end
% During sagittal elevation
subaxis(2,3,4,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xticks(0:10:180);
yticks(0:10:180);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
yticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
ylabel({'\bf{Elevation sagittale}','\rm{Angle (°deg)}'});
xlim([0,180]);
ylim([0,180]);
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
plot(1:1:180,1:1:180,'Color',[0.2 0.2 0.2],'Linewidth',2,'Linestyle',':');
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.Joint(8).Euler(1:iframe,1,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.Joint(3).Euler(1:iframe,1,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,5,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xticks(0:10:180);
yticks(0:10:60);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
% yticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
ylabel(['Angle (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
xlim([0,180]);
ylim([0,60]);
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.Joint(8).Euler(1:iframe,2,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.Joint(3).Euler(1:iframe,2,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,6,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xticks(0:10:180);
yticks(-40:10:40);
xticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
% yticklabels({'0' '' '20' '' '40' '' '60' '' '80' '' '100' '' '120' '' '140' '' '160' '' '180'});
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
ylabel(['Angle (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
xlim([0,180]);
ylim([-40,40]);
rectangle('Position',[30 -180 90 360],'Facecolor',[0 0 0 0.08],'Edgecolor','none');
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.Joint(8).Euler(1:iframe,3,icycle);
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Kinematics.Joint(3).Euler(1:iframe,3,icycle);
    plot(ref,value,'Color','blue','Linewidth',2);
end
% SAVE
saveas(gcf,'Figure3.png');
close(f3);

% Muscular activity /humerus
% -------------------------------------------------------------------------
% Initialise figure
f4 = figure('color','white','Position',[90 40 800 400]); hold on; grid on; box on; axis off;
spacing = 0.04;
padding = 0.01;
margin = 0.09;
% During coronal elevation
subaxis(2,3,1,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Deltoide ant.');
xlim([0 180]);
xticks(0:40:180);
ylabel({'\bf{Elevation coronale}','\rm{Activité (%)}'});
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(8).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(1).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,2,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Deltoide moy.');
xlim([0 180]);
xticks(0:40:180);
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(9).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(2).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,3,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Deltoide post.');
xlim([0 180]);
xticks(0:40:180);
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(10).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(3).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
% During sagittal elevation
subaxis(2,3,4,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
ylabel({'\bf{Elevation sagittale}','\rm{Activité (%)}'});
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(8).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(1).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,5,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(9).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(2).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,3,6,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(10).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(3).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
% SAVE
saveas(gcf,'Figure4.png');
close(f4);

% Muscular activity /scapula
% -------------------------------------------------------------------------
% Initialise figure
f5 = figure('color','white','Position',[90 40 1200 400]); hold on; grid on; box on; axis off;
spacing = 0.04;
padding = 0.01;
margin = 0.09;
% During coronal elevation
subaxis(2,4,1,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Trapeze sup.');
xlim([0 180]);
xticks(0:40:180);
ylabel({'\bf{Elevation coronale}','\rm{Activité (%)}'});
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(11).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(4).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,4,2,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Trapeze moy.');
xlim([0 180]);
xticks(0:40:180);
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(12).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(5).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,4,3,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Grand dentele');
xlim([0 180]);
xticks(0:40:180);
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(13).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(6).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,4,4,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
title('Grand dorsal');
xlim([0 180]);
xticks(0:40:180);
for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(6).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(14).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(2).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(2).Kinematics.Joint(1).Euler(1:iframe,1,icycle);
    value = Report.Analytic(2).Emg.Envelop(7).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
% During sagittal elevation
subaxis(2,4,5,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
ylabel({'\bf{Elevation sagittale}','\rm{Activité (%)}'});
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(11).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(4).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,4,6,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(12).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(5).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,4,7,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(13).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(6).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
subaxis(2,4,8,'Spacing',spacing,'Padding',padding,'Margin',margin);
hold on; grid on; box on;
xlim([0 180]);
xticks(0:40:180);
xlabel(['Mouvement humeral (',Report.Analytic(1).Kinematics.Joint(3).units,')']);
for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
    % Left
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(6).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(6).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(14).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','red','Linewidth',2);
    % Right
    iframe = []; ref = []; value = [];
    iframe = find(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))==max(abs(Report.Analytic(1).Kinematics.Joint(1).Euler(:,1,icycle))));
    ref = Report.Analytic(1).Kinematics.Joint(1).Euler(1:iframe,3,icycle);
    value = Report.Analytic(1).Emg.Envelop(7).value(1:iframe,1,icycle)*100;
    plot(ref,value,'Color','blue','Linewidth',2);
end
% SAVE
saveas(gcf,'Figure5.png');
close(f5);