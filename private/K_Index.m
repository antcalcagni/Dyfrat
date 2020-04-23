function [KI] = K_Index(mu,k)

muNear = zeros(length(mu),1);
for i=1:length(mu)
    if mu(i) > 0.5
        muNear(i) = 1;    
    end    
end

d = sum(abs(mu(:)-muNear(:)))^(1/k);
KI = (2/(length(mu)^(1/k))) * d;


end