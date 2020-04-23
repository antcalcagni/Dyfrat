function [KI H HR FNs] = synthesis_measures(mu,muStar,x,par)

%% Kauffman Indices for both fuzzy sets
KI.movs_fs = K_Index(mu,1);
KI.final_fs = K_Index(muStar,1);

%% Normalized Entropy Indices for both fuzzy sets
H.movs_fs = fuzzy_entropy(mu);
H.final_fs = fuzzy_entropy(muStar);

%% Normalized Entropy Ratios for both fuzzy sets
HR = (H.final_fs - H.movs_fs)/H.final_fs;


%% Fuzzy Number parameters for both fuzzy sets
a = wmean(x,abs(mu));
FNs.movs_fs = [a abs(a-par(1)) abs(par(3)-a)];
b = wmean(x,abs(muStar));
FNs.final_fs = [b abs(b-par(1)) abs(par(3)-b)];


end