function H = total_fuzzy_entropy(par,x,f,fuzzySet)

mu = mu_function(par,x,1,1,fuzzySet);
mu = mu/(max(mu));
mu_c = 1-mu;

H = 0;
for i=1:length(mu)
    
    h=0;
    s=0;
    if mu(i) > 0
        if f(i) > 0
            s = -f(i)*log(f(i));
        end
        A = mu(i)*(log(mu(i)+1e-19)); 
        B = mu_c(i)*(log(mu_c(i)+1e-19));
        h = -f(i)*(A+B);
        H = H+(s+h);
    end
end

end