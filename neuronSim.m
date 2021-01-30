function [LHS,RHS,dx,u,t,rec_u]=neuronSim(REF,dt,mysave,geomFiles,outputFolder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% neuronSim  this runs the Hodgkin Huxley model equations on the neuron
% defined by the geometry(ies) in geomFiles
%   LHS = this is the left hand side of the stencil matrix from diffusion
%   solve
%   RHS = this is the right hand side of the stencil matrix from diffusion
%   solve
%   dx = this is the average edge length
%   t = the time vector
%   rec_u = this is the last voltage state at the end of the simulation
%
%   this code is still in development, the outputs defined above will be
%   removed, they are outputted for testing purposes
% 
%   Written by James Rosado 09/20/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this puts together the geomtry file name, I do REF+1 because you can't
% index 0!
filename = [geomFiles(REF+1).folder filesep geomFiles(REF+1).name];

global a  % define the radius variable for global usage in this file

% read radius and subset names from readSWC function
[~,~,~,~,a,subset]=readSWC(filename);

% need to scale radii to MICRO METERS
a = a*1e-6;

% for now using M adjacency matrix, neighborlist, boundarylist, branchpoint
% list, number of nodes n, set average edgelength to be dx
% [M,nLst,bLst,brchLst,numNodes,numEdges, meanEdge,maxEdge,minEdge,medEdge]
[~,nLst,blst,brchLst,n,nEdges, dx_mean,dx_max,dx_min,dx_med]=getGraphStructure(filename,false,false);

% this outputs some general information abou the cell to the console
fprintf('mean dx = %f\n', dx_mean)
fprintf('max dx = %f\n', dx_max)
fprintf('min dx = %f\n', dx_min)
fprintf('med dx = %f\n', dx_med)

% I really do not use dx because the stencil has to compute the dx for each
% edge when making the stencil entries
dx = dx_mean*1e-6; 

% this is for make the output folder
mkdir(outputFolder)

% make a subfolder for the data, I do this because if the use runs multiple
% levels of refinements they should have their own subfolder in the output
% folder
dir = sprintf('%s/%iRef%0.7f',outputFolder,REF,dt*1e6);
mkdir(dir);

% it will make a subfolder in the above subfolder folder called 'data'
% this is where the voltage data is stored if you choose to save it
mkdir(sprintf('%s/data',dir));

% this is for recording the voltages and states at branch points
record_index = cell2mat(brchLst);
%-------------------------------------------------------------------------%
%Set Biological Parameters for AP
global R C gk ek gna ena gl el

R= 250*1e-2;               % resistance                   [ohm.m]
C=1e-2;                    % capacitance                  [F/m2]
gk=5*1e1;                  % potassium ion conductance    [S/m2]
ek=-90*1e-3;               % potassium reversal potential [V]
gna=50*1e1;                % sodium ion conductance       [S/m2]
ena=50*1e-3;               % sodium reversal potential    [V]
gl=0.0*1e1;                % leak conductance             [S/m2]
el=-70*1e-3;               % leak potential               [m]

% Simulation Parameters
% n is the number of nodes in the cell already given!
vStart = 0 *1e-3;             % initial cell voltage [V]
vClamp = 50*1e-3;             % clamp voltage        [V]
endTime = 50*1e-3;           % end time in          [s]
delay = 15*1e-3;              % delay clamp by x     [s]
nT = floor(endTime/dt);       % number of Time Steps

ni=0.0376969;  % these are ion gating variables dimensionless
mi=0.0147567;  % these are ion gating variables dimensionless
hi=0.995941;  % these are ion gating variables dimensionless

%-------------------------------------------------------------------------%

%------------------------Initialize solution space------------------------%
u=ones(n,1).*vStart;  % this is our voltage solution vector
somaId=[];
% Here I find the soma for voltage clamp, it may not always be the ind = 1
% it could be multiple indices in fact, but for our VR it is usually i = 1
for i=1:n
    if strcmp(subset{i},'soma')
        somaId = [somaId,i];
        %break
    end
end
clamp = somaId;

% Here I initialize the gating variables m,n, and h
% these are our state variable solution vectors
nn=zeros(n,1); nn(:,1)=ni;
mm=zeros(n,1); mm(:,1)=mi;
hh=zeros(n,1); hh(:,1)=hi;
%-------------------------------------------------------------------------%
% Make sparse stencil matrices
[LHS, RHS] = stencilMaker(n,dt,dx,R,a,C,filename);

% initialize empty recording vectors
usoma=[];
rec_u =[];
rec_h =[];
rec_m =[];
rec_n =[];

for i=0:nT
    % set soma to clamp
    if i*dt >=delay
        u(clamp)=vClamp;
    end
    
    % if mysave is 1 then save the current voltage of entire cell to file
    if mysave == 1
        writematrix(u,sprintf('%s/data/vm_t%i.dat',dir,i))
    end
    
    % we will always record and output the data at the soma and branch
    % points, these locations are important for measuring
    usoma=[usoma;u(clamp)];
    
    tmp = u(record_index);
    rec_u=[rec_u,tmp];
    tmp = hh(record_index);
    rec_h=[rec_h, tmp];
    tmp = mm(record_index);
    rec_m=[rec_m, tmp];
    tmp=nn(record_index);
    rec_n=[rec_n, tmp];
    
    % The scheme is a Strang splitting
    % (1) Do a 1/2 time step with the ODEs and Reaction part of OP-split
    nn = RK4(u,nn,dt/2,@fn);
    mm = RK4(u,mm,dt/2,@fm);
    hh = RK4(u,hh,dt/2,@fh);

    u = RK4_react(u,mm,hh,nn,dt/2,@react);
    
    % (2) Do full step of diffusion solve, this is part of OP-split
    u = LHS\(RHS*u);
    
    % (3) Finish off with other half to time step from ODEs and Reaction
    % part
    u = RK4_react(u,mm,hh,nn,dt/2,@react);
    
    nn = RK4(u,nn,dt/2,@fn);
    mm = RK4(u,mm,dt/2,@fm);
    hh = RK4(u,hh,dt/2,@fh);
    
    % set soma to clamp
    if i*dt >=delay
        u(clamp)=vClamp;
    end   
    fprintf('t= %f [s]\n',i*dt)
end

% set time values for output
t=dt*(0:nT);

fprintf('Done!\n')

% save soma voltage and time voltage as .mat files
save(sprintf('%s/usoma.mat',dir),'usoma','-v7.3')
save(sprintf('%s/time.mat',dir),'t')

% this will save the voltage and state variables at branch points to 
%.dat files separately. This is always done the branch points are good 
% places to check and compare later on to Yale neuron
for j=1:length(record_index)
    writematrix(rec_u(j,:)',sprintf('%s/vmloc_%i.dat',dir,record_index(j)));
    writematrix(rec_h(j,:)',sprintf('%s/hloc_%i.dat',dir,record_index(j)));
    writematrix(rec_m(j,:)',sprintf('%s/mloc_%i.dat',dir,record_index(j)));
    writematrix(rec_n(j,:)',sprintf('%s/nloc_%i.dat',dir,record_index(j)));
end

% print some information abou the simulation run
fprintf('The soma ID = %i\n',somaId)
fprintf('Number of spatial steps = %i\n',nEdges);
fprintf('Number of nodes = %i\n',n);
fprintf('Spatial dx = %d [m]\n',dx);
fprintf('Number of time steps = %i\n',nT);
fprintf('Temporal dt = %d [s]\n',dt);
end

% these are the right hand side functions for the ode state equations
function out = fn(v,nn)
    out = an(v).*(1-nn)-bn(v).*nn;
    out = out*1.0;
end
function out = fm(v,mm)
    out = am(v).*(1-mm)-bm(v).*mm;
    out = out*1.0;
end
function out = fh(v,hh) 
    out =ah(v).*(1-hh)-bh(v).*hh;
    out = out*1.0;
end

% this is the RK4 time stepping scheme set LeVeque 2007 for details
function pout = RK4(v,pp,dt,fun)
    p1 = pp;
    p2 = pp + (0.5).*dt.*fun(v,p1);
    p3 = pp + (0.5).*dt.*fun(v,p2);
    p4 = pp + (1.0).*dt.*fun(v,p3);
    pout = pp + (1/6).*dt.*(fun(v,p1)+2.*fun(v,p2)+2.*fun(v,p3)+fun(v,p4));
end

% I did a separate RK4 function for the reaction term, it involves for
% inputs.
% v = input voltage vector
% mm = input state m for potassium channels
% hh = input state h for potassium channels
% n = input state n for sodium channels
function rout = RK4_react(v,mm,hh,nn,dt,fun)
    r1 = v;
    r2 = v + (0.5).*dt.*fun(r1,mm,hh,nn);
    r3 = v + (0.5).*dt.*fun(r2,mm,hh,nn);
    r4 = v + (1.0).*dt.*fun(r3,mm,hh,nn);
    rout = v+(1/6).*dt.*(fun(r1,mm,hh,nn)+2.*fun(r2,mm,hh,nn)...
                        +2.*fun(r3,mm,hh,nn)+fun(r4,mm,hh,nn));
end

% this is the reaction term in the HH model
% v = input voltage vector
% mm = input state m for potassium channels
% hh = input state h for potassium channels
% n = input state n for sodium channels
function rout = react(v,mm,hh,nn)
global C gk ek gna ena gl el  % these are the global variable defined earlier

    rout = (-1/C).*(gk.*nn.^4.*(v-ek)+gna.*mm.^3.*hh.*(v-ena)+gl.*(v-el));
end

% These functions are for the gating variables in the Hodgkin-Huxley
% formulism
% carefully notice that for this simulation I am using MKS, these gating
% function use [mV] and output [ms]^-1 so they need to be properly scaled!!
function out=an(vin)
vin = vin.*1e3;
out=(-0.032).*(vin-15)./(exp(-1.*(vin-15)./5)-1);
out = out*1e3;
end

function out=bn(vin)
vin = vin.*1e3;
out=(0.5).*exp(-1.*(vin-10)./40);
out = out*1e3;
end

function out=am(vin)
vin = vin.*1e3;
out=(-0.32).*(vin-13)./(exp(-1.*(vin-13)./4)-1);
out = out*1e3;
end

function out=bm(vin)
vin = vin.*1e3;
out=(0.28).*(vin-40)./(exp((vin-40)./5)-1);
out = out*1e3;
end

function out=ah(vin)
vin = vin.*1e3;
out=(0.128).*exp(-1.*(vin-17)./18);
out = out*1e3;
end

function out=bh(vin)
vin = vin.*1e3;
out=4./(exp((40-vin)./5)+1);
out = out*1e3;
end
