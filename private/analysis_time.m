function [y Fy csi] = analysis_time(cumModel,parsModel,check_ECM,RTS,RTS_sbj)

%%compute function PHI
if check_ECM == 0
    if parsModel(1) ~= 0  
        csi = cdf(cumModel,RTS_sbj,parsModel(1),parsModel(2),parsModel(3));
    elseif parsModel(1) == 0;
        csi = cdf(cumModel,RTS_sbj,mean(RTS),std(RTS));
    end
    y = linspace(0,max(RTS),length(RTS));
    for e=1:length(y)
        Fy(e) = cdf(cumModel,y(e),mean(RTS),std(RTS));
    end
else 
    y = linspace(0,max(RTS),3000);
    Fy = ksdensity(RTS, y, 'function','cdf');
    y = [
        y(1)-Fy(1)*(y(2)-y(1))/((Fy(2)-Fy(1)));
        y';
        y(end)+(1-Fy(end))*((y(end)-y(end-1))/(Fy(end)-Fy(end-1)))
        ];
    Fy = [0; Fy'; 1];
    
    csi = max(Fy(y<=RTS_sbj));
end
