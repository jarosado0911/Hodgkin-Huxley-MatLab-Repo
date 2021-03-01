function fullpath=pathAtoB(startNode,endNode,filename,plotsON)

[~,~,~,coord,~,~]=readSWC(filename);

outpath1=get_path(1, startNode,filename);
outpath2=get_path(1, endNode,filename);
fullpath = [];
if (intersect(outpath1,outpath2)==[1])
    fullpath = [outpath1,outpath2];
    fullpath = unique(fullpath);
    fprintf("only one intersection\n")
end

if (length((intersect(outpath1,outpath2))) > 1)
    fprintf("overlapping paths\n")
    intersectionPath = intersect(outpath1,outpath2);
    unionPath = [outpath1,outpath2];
    fullpath = setdiff(unionPath,intersectionPath);
    fullpath = [intersectionPath(end),startNode,endNode,fullpath]; fullpath = unique(fullpath);
end

if (plotsON ==1)
    figure
    subplot(1,3,1)
    hold on
    scatter3(coord(:,1), coord(:,2),coord(:,3),4,'b')
    scatter3(coord(outpath1',1),coord(outpath1',2),coord(outpath1',3),'r');
    subplot(1,3,2)
    hold on
    scatter3(coord(:,1), coord(:,2),coord(:,3),4,'b')
    scatter3(coord(outpath2',1),coord(outpath2',2),coord(outpath2',3),'r');
    subplot(1,3,3)
    hold on
    scatter3(coord(:,1), coord(:,2),coord(:,3),4,'b')
    scatter3(coord(fullpath',1),coord(fullpath',2),coord(fullpath',3),'r');
end

