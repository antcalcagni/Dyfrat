function [x,y,relF,xHist,pps_rad,muFS,FSPoints] = analysis_movements(xx,yy,coordPol,t0,t1,binHist,parsPSO,fuzzySet)

x = zeros(size(xx,3),1);
y = zeros(size(yy,3),1);
for i=1:size(xx,3)
    x(i) = xx(:,:,i);
    y(i) = yy(:,:,i);
end

%Get distance from the center of the circle for each points 
ds=[];
X = [x y];
for i=1:size(X,1)
    ds = [ds;pdist([0,0; X(i,1),X(i,2)],'euclidean')]; 
end
D = [X ds];

%Get the points within the fixed bounds t0 and t1 
W = [];
for i=1:size(D,1)
    if D(i,3) > t0 && D(i,3) < t1
        W = [W;D(i,1:2)];
    end    
end

%Get polar coordinates from cartesian coordinates of the W points 
pols = [];
for i=1:size(W,1)
    if W(i,1) && W(i,2) ~=0
        pols=[pols;angle(W(i,1),W(i,2))];
    end    
end

%Get polar coordinates from cartesian coordinates of the labels points 
pps = [];
delta = 360-coordPol(1);
for i=1:length(coordPol)
    p = coordPol(i)+delta+((360/5)/2);
    if p > 360
        p = abs(360-p);
    elseif p == 360
        p = 0;
    end    
    pps = [pps;p];
end

%Rescaled the polar coordinates within a scale with a common origin 
rescaled_pols = [];
for i=1:length(pols)
    p = pols(i)+delta+((360/5)/2);
    if p > 360
        p = abs(360-p);
    elseif p == 360
        p = 0;
    end    
    rescaled_pols = [rescaled_pols;p];
end

%Transform polar coordinates into radians
pps_rad = degtorad(pps);
pols_rad = degtorad(rescaled_pols);
%Delete values between first and last label 
pols_rad(pols_rad > (pps_rad(length(pps_rad))+0.1)) = 0;
pols_rad(pols_rad < (pps_rad(1))-0.06) = 0;
pols_rad = pols_rad(pols_rad~=0);
if sum(pols_rad) == 0 % too few values in filtered pols_rad: no filter
    pols_rad = degtorad(rescaled_pols);
end
    
%Compute values for PSO
intWidth = (6.28-0)/binHist;
xHist = (0:intWidth:6.28)';
n = histc(pols_rad,xHist);
relF = n/length(pols_rad);

%Compute fuzzy set for movements

FSPoints = PSO(xHist,relF,var(pols_rad),[max(pols_rad) min(pols_rad)],parsPSO,fuzzySet);
muFS = mu_function(FSPoints,xHist,1,1,fuzzySet);
    




end