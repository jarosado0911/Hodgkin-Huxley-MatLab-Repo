function outpath=get_path(indexFrom, indexTo,filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will output the path of a graph between two index nodes it
% is used as an  internal function for the pathAtoB.m function
%-------------------------------------------------------------------------%
% Input: filename of SWC file, indexFrom is the starting node, and indexTo
% is the end node
%
% Output: outpath is an array of indices which correspond to the indices in
% the .swc for the nodes
%-------------------------------------------------------------------------%
%   Written by James Rosado 02/19/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get id and pid lists
[~,id,pid,~,~,~]=readSWC(filename);

% this makes the adjacency matrix
adjMat = zeros(length(id),length(id));
for i=2:length(id)
    adjMat(id(i),pid(i))=1;
    adjMat(pid(i),id(i))=1;
end

% this makes the adjacency list
adjLst = {};
for i =1:length(id)
    tmpArray = [];
    for j=1:length(pid)
        if pid(j)==i
            tmpArray = [tmpArray, j];
        end
    end
    adjLst{i}=tmpArray;
end

% this makes a structure for the graph geometry, I really don't use all of
% this but I need to exploit this later on as I develop my scripts
global G;
G.vertices = id;
G.edges = [pid(2:end),id(2:end)];
G.adjacencyMat = adjMat;
G.adjacencyLst = adjLst;
G.color = ones(length(id),1);   % i don't really use this
G.discovered = 0;               % i don't really use this
G.found = 0;                    % i don't really use this
G.pid = pid;

visited = zeros(length(G.vertices),1);
s=indexFrom; d = indexTo;
pathLst=[]; pathLst = [pathLst, s];
outpath=printAllPathsUtil(s,d, visited,pathLst);

end

function outPath =printAllPathsUtil(u,d,visited,localPath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is a recursive algorithm for finding the path from u to d
% it uses a visisted array which is 1 for visisted and 0 not visitived
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global G;
outPath =[];
if (u==d)
    outPath=localPath;
    return;
end

visited(u)=1;

for i=1:length(G.adjacencyLst{u})
    if (visited(G.adjacencyLst{u}(i)) == 0)
        localPath=[localPath, G.adjacencyLst{u}(i)];
        % make the recursive call here
        outPath=[outPath, printAllPathsUtil(G.adjacencyLst{u}(i),d,visited,localPath)];
        localPath = localPath(1:end-1);
    end
end
visited(u)=0;
end
