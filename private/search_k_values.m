function [best_k] = search_k_values(mu)

%% search best value for k conditioned to the choice of fuzzy set
fo_old = 0;
thr = 1e-4;
j=0; k=1;stop=0;
fo=0; fo_dif=0;
while stop~=1
    j=j+1; k=k+0.01;
    g=k;h=1/g;
    % compute modified mu
    for i=1:length(mu)
        if mu(i) <= 0.5        
            muStar(i) = 0.5-(2^((2*g)-1))*(0.5-mu(i))^(2*g);
        else
            muStar(i) = 1-(2^(0.5*h-1))*(1-mu(i))^(0.5*h);
        end
    end
    % compute fuzziness index
    muNear = zeros(length(muStar),1);
    for i=1:length(muStar)
        if muStar(i) > 0.5
            muNear(i) = 1;    
        end    
    end
    d = sum(abs(muStar(:)-muNear(:)))^(1/1);
    K_Index = (2/(length(mu)^(1/1))) * d;
    % compute objective function value
    fo(j) = K_Index;
    fo_dif(j) = abs(fo_old - fo(j));
    fo_old = fo(j);
    % evaluate decreasing of objective function values - stopping criteria
    if fo_dif(j) <= thr
        best_k = k;
        stop=1;
    end
end

end