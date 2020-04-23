function [triangPoints,FNs,H,KI,HR,rsp_disc,expans,concent,muStar] = ODA(i,j,settings_par)


%% load data from base
MOUSE_MVS_X = evalin('base','MOUSE_MVS_X');MOUSE_MVS_Y = evalin('base','MOUSE_MVS_Y');MOUSE_MVS_TIMES = evalin('base','MOUSE_MVS_TIMES');NUM_MVS = evalin('base','NUM_MVS');
POINTS_LBLS = evalin('base','POINTS_LBLS'); RTS = evalin('base','RTS_resp')/1000;
RSP_DEG = evalin('base','RSP_DEG');RSP_DISC = evalin('base','RSP_DISC');
rsp_disc = RSP_DISC(i,j);
%% data analysis procedure
[i j]
if RSP_DISC(i,j) ~= 0
    [xx,yy,relF,xHist,pps_rad,muTriang,triangPoints] = analysis_movements(MOUSE_MVS_X(i,j,1:NUM_MVS(i,j)),MOUSE_MVS_Y(i,j,1:NUM_MVS(i,j)),POINTS_LBLS(i,j,:),settings_par.t0,settings_par.t1,settings_par.binHist,settings_par.parsPSO,'Triangular');
    [y Fy csi] = analysis_time(settings_par.cumModel,settings_par.cumModel_par,settings_par.cumModel_ecf,RTS(:,j),RTS(i,j));
    [muStar,g,h] = integratation_time_movs(muTriang,csi,max(Fy(y<=mean(RTS(:,j)))));
    [KI H HR FNs] = synthesis_measures(muTriang,muStar,xHist,triangPoints);

else
    triangPoints=0;FNs=0;H=0;KI=0;HR=0;muStar=0;
end
%muStar
expans=0;
concent=0;

end