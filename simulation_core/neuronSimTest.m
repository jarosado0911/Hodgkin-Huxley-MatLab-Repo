function neuronSimTest(geomFolder,refinements,outputFolder,mysave)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is for running the simulation
% geomFolder: this the folder with the .swc refinement geometries
% the geomFolder would be something like: 
% 'D:\path_to_geometry_folder\geometryfolder
% refinements: enter as an array [0] or can be like [0,1,2,3] for refines
% 0 through 3
% mysave = 0 means do not save every time step data
% mysave = 1 means save every time step == using lots of memory!!
% outputFolder = name of folder where you want output to go, i.e.
% 'runCell228-13MG
%
%   Written by James Rosado 09/20/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this gets the names of the geometry files in .swc format
% it is an array of strings for each refinement level
geomFiles = getGeomFilePrefix(geomFolder);

for i=refinements
    mydt = 2^(-1*(i+1))*0.004*1e-3;

    tic    
    % i = the refinement level
    % mydt = time step size
    % pass all goemetry files will be chosen in neuronSim
    % tell neuronSim the outputfolder name
    [~,~,~,~,~,~]=neuronSim(i,mydt,mysave,geomFiles,outputFolder);
    toc
end

end