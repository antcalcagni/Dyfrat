function [mu] = mu_function(par,x,w,p,fuzzySet)



switch fuzzySet
    case 'Triangular'

    %%%Triangular fuzzy set construction%%%%%%%%%%%%%%%%%%%%%%%%%
    lb = par(1);
    m = par(2);
    ub = par(3);
    mu=[];

    for i=1:length(x)
        if x(i) > lb && x(i) < m
            mu = [mu;((x(i)-lb)/(m-lb))];
        elseif x(i) > m && x(i) < ub
            mu = [mu;((x(i)-ub)/(m-ub))];
        elseif x(i) == m
            mu = [mu;1];
        elseif x(i) <= lb || x(i) >= ub    
            mu = [mu;0];
        end
    end
    mu = mu/(max(mu));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    case 'Trapezoidal'

    %%%Trapezoidal fuzzy set construction%%%%%%%%%%%%%%%%%%%%%%%%%
    lb = par(1);
    m1 = par(2);
    m2 = par(3);
    ub = par(4);
    mu=[];
    
    for i=1:length(x)
        if x(i) > lb && x(i) < m1
            mu = [mu;((x(i)-lb)/(m1-lb))];
        elseif x(i) >= m1 && x(i) <= m2
            mu = [mu;1];
        elseif x(i) > m2 && x(i) < ub
            mu = [mu;((x(i)-ub)/(m2-ub))];
        elseif x(i) <= lb || x(i) >= ub    
            mu = [mu;0];
        end
       
    end
    mu = mu/(max(mu));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end





%%%Linguistic-edges for mu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%w > 1: concentration procedure on mu
if w > 1
    mu = mu.^w;
end
%w < 1: ad-hoc uncertanty intensification procedure on mu
if w < 1
    q=1/p;
    for i=1:length(mu)
        if mu(i) <= 0.5
            mu(i) = 0.5-(2^((2*p)-1))*(0.5-mu(i))^(2*p);
        elseif mu(i) > 0.5
            mu(i) = 1-(2^(0.5*q-1))*(1-mu(i))^(0.5*q);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
end

