function d=getGeomFilePrefix(geomFolder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is for getting all of the geometry .swc files in an array
% the geomFolder would be something like: D:\FinalHHSimulator\ReferenceGeometry\cell228-13MG
%   Written by James Rosado 09/20/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s\n',geomFolder)
d = dir([geomFolder, '/*.swc']);
end