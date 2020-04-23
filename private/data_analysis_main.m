function [FSPoints,FNs,H,KI,HR,rsp_disc] = data_analysis_main(i,j,handles,settings_par,TypeGraph)

%% load data from base
MOUSE_MVS_X = evalin('base','MOUSE_MVS_X');MOUSE_MVS_Y = evalin('base','MOUSE_MVS_Y');MOUSE_MVS_TIMES = evalin('base','MOUSE_MVS_TIMES');NUM_MVS = evalin('base','NUM_MVS');
POINTS_LBLS = evalin('base','POINTS_LBLS'); RTS = evalin('base','RTS_resp')/1000;
RSP_DEG = evalin('base','RSP_DEG');RSP_DISC = evalin('base','RSP_DISC');
rsp_disc = RSP_DISC(i,j);
%% data analysis procedure
if RSP_DISC(i,j) ~= 0
    id=0;
    old_str = get(handles.results, 'String' );
    str0a = '';
    str = ['*** SUBJECT: ' num2str(i) ' | VARIABLE: ' num2str(j) '***'];
    str0 = ['___________________________________________________________'];
    set(handles.results, 'String', char(old_str,str0, str0a,str));    
    
    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Analysis of Movements started',100*id/4);
    [xx,yy,relF,xHist,pps_rad,muFS,FSPoints] = analysis_movements(MOUSE_MVS_X(i,j,1:NUM_MVS(i,j)),MOUSE_MVS_Y(i,j,1:NUM_MVS(i,j)),POINTS_LBLS(i,j,:),settings_par.t0,settings_par.t1,settings_par.binHist,settings_par.parsPSO,settings_par.fuzzySet);
    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Analysis of Movements finished',100*id/4);

    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Analysis of Times started',100*id/4);
    [y Fy csi] = analysis_time(settings_par.cumModel,settings_par.cumModel_par,settings_par.cumModel_ecf,RTS(:,j),RTS(i,j));
    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Analysis of Times finished',100*id/4);

    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Integration started',100*id/4);
    [muStar,g,h] = integratation_time_movs(muFS,csi,max(Fy(y<=mean(RTS(:,j)))));
    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Integration finished',100*id/4);
    
    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Computing measure of synthesis started',100*id/4);
    [KI H HR FNs] = synthesis_measures(muFS,muStar,xHist,FSPoints);
    %id=id+0.5;statusbar('STATUS: Processing %.1f%% \t - \t Computing measure of synthesis finished',100*id/4);
    
    expans=g;
    concent=h;
    
    %%%    PRINT RESULTS IN LISTBOX    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    old_str = get(handles.results, 'string' ); 
    str0 = [''];
    str1 = ['== OPTIMIZED FUZZY SET: ' num2str(FSPoints)];
    str2 = ['== FUZZY NUMBER: '];
    str2a = ['=== fuzzy set movements: ' num2str(FNs.movs_fs)];
    str2b = ['=== final fuzzy set: ' num2str(FNs.final_fs)];
    str5 = ['== NORMALIZED FUZZY ENTROPY:'];
    str5a = ['=== fuzzy set movements: ' num2str(H.movs_fs)];
    str5b = ['=== final fuzzy set: ' num2str(H.final_fs)];
    str4 = ['== FUZZINESS INDEX:'];
    str4a = ['=== fuzzy set movements: ' num2str(KI.movs_fs)];
    str4b = ['=== final fuzzy set ' num2str(KI.final_fs)];
    str6 = ['== ENTROPY RATIO: ' num2str(HR)];
    str8 = ['== SAMPLE TIME :'];
    str8a = ['=== mean: ' num2str(mean(RTS(:,j)))];
    str8b = ['=== std: ' num2str(std(RTS(:,j)))];
    str8c = ['=== PHI(mean): ' num2str(max(Fy(y<=mean(RTS(:,j)))))];
    str9 = ['== SUBJECT TIME: '];
    str9a = ['=== time: ' num2str(RTS(i,j))];
    str9b = ['=== PHI(time): ' num2str(max(Fy(y<=(RTS(i,j)))))];
    str9c = ['=== expansion factor: ' num2str(g)];
    str9d = ['=== concentration factor: ' num2str(h)];
    str10 = ['== SUBJECT RESPONSE'];
    str10b = ['=== resp (degree): ' num2str(RSP_DEG(i,j))];
    str10c = ['=== resp (discrete): ' num2str(RSP_DISC(i,j))];
    str10d = ['=== resp (continuous): ' num2str(FNs.final_fs(1))];
    str10a = ['=== num mvs: ' num2str(NUM_MVS(i,j))];
    set(handles.results, 'string', char(old_str,str0, str1,str0, str2, str2a, str2b,str0, str4,str4a,str4b, str0,str5, str5a, str5b,str0, str6,str0, str8, str8a, str8b,str8c,str0, str9, str9a, str9b, str9c, str9d,str0,str10,str10b,str10c,str10d,str10a));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%    GRAPHICS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %id=0;id=id+1;statusbar('STATUS: Processing %.1f%% \t - \t Graphical elaboration',100*id/4);
    %% Movements
    %Circular configuration
    cla(handles.fig1)
    axes(handles.fig1);hold on
    plot(0,linspace(-300,300,600),'k')
    plot(linspace(-300,300,600),0,'k')
    circle([0,0],250,1000,'k');
    circle([0,0],settings_par.t0,1000,'k-.');
    circle([0,0],settings_par.t1,1000,'k-.');
    for u=1:size(POINTS_LBLS(i,j,:),3)
        rad_x = (POINTS_LBLS(i,j,u)*(3.14/180))*-1;
        [pol_x,pol_y] = pol2cart(rad_x,250)
        scatter(pol_x,pol_y,'filled','ks')
        labels = num2str(u,'%d');
        text(pol_x, pol_y, labels,'FontSize',18, 'horizontal','left', 'vertical','bottom')
    end
    
    if TypeGraph == 0 %static graph
        scatter(xx,yy,'b') 
    else %dynamic graph
        [~, MVSt] = mouseMVS_clustering(MOUSE_MVS_X,MOUSE_MVS_Y,MOUSE_MVS_TIMES, NUM_MVS);
        plotTime(xx,yy,MVSt(i,j,1:NUM_MVS(i,j)),0.1)
    end
    [xx yy]
    %id=id+1;statusbar('STATUS: Processing %.1f%% \t - \t Graphical elaboration',100*id/4);
    %% Histogram of movements
    cla(handles.fig2)
    axes(handles.fig2);hold on
    intWidth = (6.28-0)/settings_par.binHist;
    bar(xHist-intWidth/2,relF,1,'w')
    xlim([min(xHist) max(xHist)])
    g=0;
    pps_rad
    for g=1:length(pps_rad)
        scatter(pps_rad(g),0,'k','s','filled');
        %labels = num2str(g,'%d');
        %text(pps_rad(g), 0, labels,'FontSize',15, 'horizontal','left', 'vertical','top')
    end

    %id=id+1;statusbar('STATUS: Processing %.1f%% \t - \t Graphical elaboration',100*id/4);
    %% Histogram of times
    cla(handles.fig3)
    axes(handles.fig3);hold on
    % hist(RTS(:,j))
    % histT = findobj(gca,'Type','patch');
    % set(histT,'FaceColor','w')
    data=RTS(:,j);
    n = length(data);
    binwidth = range(data)/20;
    edg= min(data):binwidth:max(data);
    [count] = histc(data, edg);
    histT = bar(edg, count./(n*binwidth), 'histc');
    set(histT,'FaceColor','w')
    hold on;plot(y,Fy,'r');hold off;

    %id=id+1;statusbar('STATUS: Processing %.1f%% \t - \t Graphical elaboration',100*id/4);
    %% Integration
    cla(handles.fig4)
    axes(handles.fig4);hold on
    [muFS muStar]
    plot(xHist,muFS)
    plot(xHist,muStar,'r');
    xlim([min(xHist) max(xHist)])
    g=0;
    for g=1:length(pps_rad)
        scatter(pps_rad(g),0,'k','s','filled');
        %labels = num2str(g,'%d');
        %text(pps_rad(g), 0, labels,'FontSize',18, 'horizontal','left', 'vertical','top')
    end
    hold off; statusbar('STATUS: Done');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    FSPoints=0;FNs=0;H=0;KI=0;HR=0;
end

end