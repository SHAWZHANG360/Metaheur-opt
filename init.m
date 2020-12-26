function InitArray=init(Out) % Function for initialization

LB=Out.LowerBound; UB=Out.UpperBound; % Lower and upper bounds

InitArray=zeros(Out.Npopulation,Out.NDecisionVariable);

for i=1:Out.Npopulation % Generation of initial solutions (position of crows)
    for j=1:Out.NDecisionVariable
        InitArray(i,j)=LB-(LB-UB)*rand; % Position of the crows in the space
    end
end
