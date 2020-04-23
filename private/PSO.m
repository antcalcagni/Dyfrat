function [Gbest_position] = PSO(x_supp,f,delta,range,parsPSO,fuzzySet)

%[c1 c2 k iter num_pars num_partic];

pars = parsPSO(5);
numPartic = parsPSO(6);
numIter = parsPSO(4);
c1 = parsPSO(1);
c2 = parsPSO(2);
w = linspace(1,0.3,numIter);

r = range(1)-range(2);
d = delta;
if delta <= 0.01
    delta = 0.01+(rand);
end

lwb = range(2);
upb = range(1);
k = parsPSO(3);

if (lwb-k)>= min(x_supp)
    lwb = lwb-k;
else
    lwb = min(x_supp);
end    

if (upb+k)<= max(x_supp)
    upb = upb+k;
else
    upb = max(x_supp);
end

lb(1:numPartic,1:pars) = lwb;
ub(1:numPartic,1:pars) = upb;


e = ub-lb;
q = (e/4);

x = sort((lwb + (upb-lwb)*rand([numPartic,pars])),2);
v = q.*rand(numPartic,pars);

obj_fun = zeros(numPartic,1);

for i=1:numPartic
    obj_fun(i) = total_fuzzy_entropy(x(i,:), x_supp,f,fuzzySet);
end

[obj_fun_Gbest index_obj_fun_Gbest] = max(obj_fun);

Gbest_position = x(index_obj_fun_Gbest,:);
Pbest_positions = x;
obj_fun_Pbests = obj_fun;

for i=1:numIter
    inertial_comp = w(i)*v;
    cognitive_comp = c1*rand*(Pbest_positions - x);
    social_comp = c2*rand*(repmat(Gbest_position,numPartic,1)-x);
    v = inertial_comp + cognitive_comp + social_comp;
    x = x+v;
    
    for j=1:numPartic
        if x(j,1) < lb | x(j,3) > lb | x(j,2) < lb | x(j,2) > lb | issorted(x(j,:)) == 0
            x(j,:) = sort((lwb + (upb-lwb)*rand([1,pars])));
        end
        
    end
 
    for k=1:numPartic
        obj_fun(k) = total_fuzzy_entropy(x(k,:), x_supp,f,fuzzySet);
    end
    
    [obj_fun_max index_obj_fun_max] = max(obj_fun);
    
    if obj_fun_max >= obj_fun_Gbest
        obj_fun_Gbest = obj_fun_max;
        Gbest_position = x(index_obj_fun_max,:);
    end
    
    index_newPbest=find(obj_fun <= obj_fun_Pbests);
    Pbest_positions(index_newPbest,:) = x(index_newPbest,:);
    obj_fun_Pbests(index_newPbest) = obj_fun(index_newPbest);
    
   
end


end

