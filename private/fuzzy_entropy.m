function [H] = fuzzy_entropy(mu)

muC = 1-mu;

H = -mu'*log(mu+1e-7)-...
    muC'*log(muC+1e-7);

%H = H*(1/(4*log(length(mu))));


end