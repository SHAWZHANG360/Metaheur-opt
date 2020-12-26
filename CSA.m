function [AllBestFitnesses,BestSolution]=CSA(Out)
AllBestFitnesses=zeros(Out.NRun,Out.MaxIter);

Npopulation=Out.Npopulation; % Flock (population) size
NDecisionVariable=Out.NDecisionVariable; % Problem dimension (number of decision variables)
LowerBound=Out.LowerBound;
UpperBound=Out.UpperBound;
AP=Out.AP;
fl=Out.fl;
%%Define structure for the array of solutions
XExisting.Position=zeros(Npopulation,NDecisionVariable);
XExisting.Memory=zeros(Npopulation,NDecisionVariable);

for iRun=1:Out.NRun
    
    XExisting.Position=init(Out); % Function for initialization
    
    XExisting.fitness=fitness(XExisting.Position,Out); % Function for fitness evaluation
    
    XExisting.PosMemory=XExisting.Position; % initialization of Memory of each Crow
    fitnessMemory=XExisting.fitness; % Fitness of memory positions
    
    Bestfit=zeros(1,Out.MaxIter);
    
    %Main loop of iteration
    Xnew=zeros(Npopulation,NDecisionVariable);
    for iIter=1:Out.MaxIter % Maximum number of iterations (itermax)
        num=ceil(Npopulation*rand(1,Npopulation)); % Generation of random candidate crows for following (chasing)
        for i=1:Npopulation
            if rand>AP
                for j=1:NDecisionVariable
                    Xnew(i,j)= XExisting.Position(i,j)+fl*rand*(XExisting.PosMemory(num(i),j)-XExisting.Position(i,j)); % Generation of a new position for crow i (state 1)
                end
            else
                Xnew(i,:)=LowerBound+(UpperBound-LowerBound)*rand; % Generation of a new position for crow i (state 2)
            end
        end
        
        % this line may evluate the fitness of multiple infeasible
        % solution: Find a way to avoid this can definitely help the
        % algorithm works efficiently
        fitne=fitness(Xnew,Out); % Function for fitness evaluation of new solutions
        
        for i=1:Npopulation % Update position and memory
            Bool=1;
            for j=1:NDecisionVariable % Update position and memory
                if Xnew(i,j)<=LowerBound(j) || Xnew(i,j)>=UpperBound(j)
                    Bool=0;
                    break
                end
            end
            if(Bool==1)
                XExisting.Position(i,:)=Xnew(i,:); % Update position
                if fitne(i)<fitnessMemory(i)
                    XExisting.PosMemory(i,:)=Xnew(i,:); % Update memory
                    fitnessMemory(i)=fitne(i);
                end
            end
        end
        Bestfit(iIter)=min(fitnessMemory); % Best found value until iteration t
        %         disp(['run =   ',num2str(iRun),'  iter =   ',num2str(iIter),' BEST Fitness= ',num2str(Bestfitness(iIter))])
    end
    
    [~,ngbest]=min(fitnessMemory);
    BestSolution=XExisting.Memory(ngbest(1),:); % Solutin of the problem
    AllBestFitnesses(iRun,:)=Bestfit;
    
end
