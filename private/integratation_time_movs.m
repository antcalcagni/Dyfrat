function [muStar,g,h] = integratation_time_movs(mu,csi,trh)

g=0;
%% integration by concentration
if csi <= trh %if time_sbj < time_sample
    h = 1/(csi*2);    
    if csi >= 0.55
        h = 1;
    end
    muStar = mu.^h;
    
%% integration by expansion
elseif csi > trh %if time_sbj > time_sample
    k = search_k_values(mu);
    g = csi*k;
    h = 1/g;
    for i=1:length(mu)
        if mu(i) <= 0.5
            muStar(i) = 0.5-(2^((2*g)-1))*(0.5-mu(i))^(2*g);
        elseif mu(i) > 0.5
            muStar(i) = 1-(2^(0.5*h-1))*(1-mu(i))^(0.5*h);
        end
    end
    muStar=muStar';
end
