% %The main file to set the algorithms and run for CSA, PSO, and GA
format long; close all; clc

Algorithm='PSO'; 

Out = get_config(Algorithm);

switch Algorithm
    %%Crow Search Algorithm
    case 'CSA'
        [AllBestFitnesses,BestSolution]=CSA(Out);
        
    case 'PSO'
        [AllBestFitnesses,BestSolution]=PSO(Out);
        
end

disp(['run =   ',num2str(Out.NRun),'  iter =   ',num2str(Out.MaxIter)])
for i=1:Out.NRun
    plot(AllBestFitnesses(i,1:50))
    hold on
end

