

% -------------------------------------------------
% Citation details:
% Alireza Askarzadeh, Anovel metaheuristic method for solving constrained
% engineering optimization problems: Crow search algorithm, Computers &
% Structures, Vol. 169, 1-12, 2016.

% Programmed by Alireza Askarzadeh at Kerman Graduate %
% University of Advanced Technology (KGUT) %
% Date of programming: September 2015 %
% -------------------------------------------------
% This demo only implements a standard version of CSA for minimization of
% a standard test function (Sphere) on MATLAB 7.6.0 (R2008a).
% -------------------------------------------------
% Note:
% Due to the stochastic nature of meta-heuristc algorithms, different runs
% may lead to slightly different results.
% -------------------------------------------------

format long; close all; clear all; clc
tic;
Global=zeros(1,1000);
mem_best=zeros(1000,2);
for run=1:1
pd=2; % Problem dimension (number of decision variables)
N=20; % Flock (population) size
AP=0.35; % Awareness probability
fl=2; % Flight length (fl)
FuncNum=5; %Number of Function

[x l u]=init(N,pd); % Function for initialization

xn=x;
ft=fitness(xn,N,pd,FuncNum); % Function for fitness evaluation

mem=x; % Memory initialization
fit_mem=ft; % Fitness of memory positions

tmax=1000; % Maximum number of iterations (itermax)
for t=1:tmax
    
xnew=Move(x,mem,fit_mem,N,pd,fl,AP,l,u,t,tmax);

    xn=xnew;
    ft=fitness(xn,N,pd,FuncNum); % Function for fitness evaluation of new solutions

    for i=1:N % Update position and memory
        for j=1:pd
        if xnew(i,j)>=l(j) & xnew(i,j)<=u(j)
            x(i,j)=xnew(i,j); % Update position
        end
            if ft(i)<fit_mem(i)
                mem(i,:)=xnew(i,:); % Update memory
                fit_mem(i)=ft(i);
            end
        end
    end

    ffit(t)=min(fit_mem); % Best found value until iteration t
    best_=min(fit_mem);
    
    mem_gbest=find(fit_mem== min(fit_mem));
    mem_best(t,:)=mem(mem_gbest(1),:);

    disp([ 'run =   ' num2str(run)     '  iter =   '  num2str(t)   ' BEST = '  num2str(best_)])
    
    %if t==1|| t==100 || t==200 || t==300 || t==400 || t==500 || t==600 || t== 700 || t== 1000
      %  figure(t);
     %   plotmatrix(mem(1:20,1:2));figure(gcf);
    %end
end
ngbest=find(fit_mem== min(fit_mem));
g_best=mem(ngbest(1),:); % Solutin of the problem
Global(run,:)=ffit;
Graph=[mem_best ffit'];
end
toc
