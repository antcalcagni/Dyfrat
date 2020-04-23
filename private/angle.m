function [a] = angle(x,y)

deg = -((atan2(y,x))*360)/((pi)*2); 

if deg > 0 && deg < 180
    a = deg;

elseif deg == -180 
    a = deg*-1;
    
elseif deg == 0.0 
    a = 360.00;   

elseif deg < 0.0 && deg > -180 
    a = 360.00-(deg*-1);        

end

end