function [] = plotTime(x,y,t,r)
%%%Computing of cumulative time vector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pTimes = [];
pTimes = [pTimes;0];
cumTimes = [];
cumTimes = [cumTimes;pTimes(1)];
x_mov = [];
x_mov = [x_mov;x(1)];
y_mov = [];
y_mov = [y_mov;y(1)];
for i=2:length(t)-1
    if t(i) ~= 0
        pTimes = [pTimes;((t(i)-t(i-1))/1000)];
        cumTimes = [cumTimes;(pTimes(i)+cumTimes(i-1))];
        x_mov = [x_mov;x(i)];
        y_mov = [y_mov;y(i)];
    end
end
tCum = cumTimes;
%[(1:length(cumTimes))' cumTimes pTimes x_mov y_mov]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%Temporized graphic%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numMvs = length(cumTimes);
if r == 1
    w = 0;
elseif r == 0.1
    w = 1;
elseif r == 0.01
    w = 2;    
elseif r == 0.001
    w = 3;
end    
tCumS = [];

for i=1:numMvs-1
    if tCum(i) <=1
        tCumS = [tCumS;chop(tCum(i),w)];
    elseif tCum(i) <=10
        tCumS = [tCumS;chop(tCum(i),w+1)];
    elseif tCum(i) <=100
        tCumS = [tCumS;chop(tCum(i),w+2)];
    elseif tCum(i) <=1000
        tCumS = [tCumS;chop(tCum(i),w+3)];
    end        
end 
for i=0:r:tCumS(numMvs-1)
    index_sec = (find(tCumS==i));
    if size(index_sec) ~= 0
        W = [x(index_sec) y(index_sec)];
        scatter(W(:,1),W(:,2),'b','o')
    end
    pause(r)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end