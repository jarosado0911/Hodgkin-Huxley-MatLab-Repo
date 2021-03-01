function outpath=get_path(indexFrom, indexTo,filename)
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

global G;
G.vertices = id;
G.edges = [pid(2:end),id(2:end)];
G.adjacencyMat = adjMat;
G.adjacencyLst = adjLst;
G.color = ones(length(id),1);
G.discovered = 0;
G.found = 0;
G.pid = pid;

visited = zeros(length(G.vertices),1);
s=indexFrom; d = indexTo;
pathLst=[]; pathLst = [pathLst, s];
outpath=printAllPathsUtil(s,d, visited,pathLst);

end

function outPath =printAllPathsUtil(u,d,visited,localPath)
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
        outPath=[outPath, printAllPathsUtil(G.adjacencyLst{u}(i),d,visited,localPath)];
        localPath = localPath(1:end-1);
    end
end
visited(u)=0;
end
