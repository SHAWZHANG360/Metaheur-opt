function [BestCost,BestSolution]=PSO(Out)

Global=zeros(Out.NRun,Out.MaxIter);
Npopulation=Out.Npopulation; % Flock (population) size
NDecisionVariable=Out.NDecisionVariable; % Problem dimension (number of decision variables)
LowerBound=Out.LowerBound;
UpperBound=Out.UpperBound;
MaxIter=Out.MaxIter;

% Velocity Limits
VelMax=0.1*(UpperBound-LowerBound);
VelMin=-VelMax;
XExisting=zeros(Npopulation,NDecisionVariable);

for iRun=1:Out.NRun
    %% Initialisation
    
    empty_particle.Position=[];
    empty_particle.Cost=[];
    empty_particle.Velocity=[];
    empty_particle.Best.Position=[];
    empty_particle.Best.Cost=[];
    
    particle=repmat(empty_particle,Npopulation,1);
    
    GlobalBest.Cost=inf;
    
    for i=1:Npopulation
        
        % Initialize Position
        particle(i).Position=unifrnd(LowerBound,UpperBound,[1,NDecisionVariable]);
        
        % Initialize Velocity
        particle(i).Velocity=zeros([1,NDecisionVariable]);
        
        XExisting(i,:)=particle(i).Position;
    end
    
    %% Evaluation
    ft=fitness(XExisting,Out);
    %particle(i).Cost=CostFunction(particle(i).Position);
    
    for i=1:Npopulation
        particle(i).Cost=ft(i);
    end
    
    
    for i=1:Npopulation
        % Update Personal Best
        particle(i).Best.Position=particle(i).Position;
        particle(i).Best.Cost=particle(i).Cost;
        
        % Update Global Best
        if particle(i).Best.Cost<GlobalBest.Cost
            
            GlobalBest=particle(i).Best;
            
        end
        
    end
    
    BestCost=zeros(MaxIter,1);
    
    nfe=zeros(MaxIter,1);
    
    
    %% PSO Main Loop
    
    for it=1:MaxIter
        
        for i=1:Npopulation
            
            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                +c1*rand(1,NDecisionVariable).*(particle(i).Best.Position-particle(i).Position) ...
                +c2*rand(1,NDecisionVariable).*(GlobalBest.Position-particle(i).Position);
            
            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity,VelMin);
            particle(i).Velocity = min(particle(i).Velocity,VelMax);
            
            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            % Velocity Mirror Effect
            IsOutside=(particle(i).Position<LB | particle(i).Position>UB);
            particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
            
            % Apply Position Limits
            particle(i).Position = max(particle(i).Position,LB);
            particle(i).Position = min(particle(i).Position,UB);
        end
        
        for i=1:Npopulation
            XExisting(i,:)=particle(i).Position;
        end
        
        % Evaluation
        ft=fitness(XExisting,Out);
        %particle(i).Cost=CostFunction(particle(i).Position);
        
        for i=1:Npopulation
            particle(i).Cost=ft(i);
        end
        
        % Evaluation
        %particle(i).Cost = CostFunction(particle(i).Position);
        for i=1:Npopulation
            % Update Personal Best
            if particle(i).Cost<particle(i).Best.Cost
                particle(i).Best.Position=particle(i).Position;
                particle(i).Best.Cost=particle(i).Cost;
                
                % Update Global Best
                if particle(i).Best.Cost<GlobalBest.Cost
                    GlobalBest=particle(i).Best;
                end
            end
        end
        
        BestCost(it)=GlobalBest.Cost;
        %     nfe(it)=NFE;
        %     disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
        %      disp(['Iteration ' num2str(it)  ', Best Cost = ' num2str(BestCost(it))]);
        w=w*wdamp;
        disp(['Iteration ' num2str(it) ' Best Cost = ' num2str(BestCost(it))]);
        
    end
    % hold on
    % plot(BestCost,'r','linewidth',2)
    %BestCost=GlobalBest.Cost
    %BestSolution=GlobalBest.Position
    % BestCost=GlobalBest.Cost
    BestSolution=GlobalBest.Position
    
    % disp('Particle Swarm Optimization (PSO)')
    % disp(' ')
    Global(iRun,:)=Bestfitness;
end