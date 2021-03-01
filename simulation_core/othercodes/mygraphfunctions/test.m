filename = 'testcell.swc';
[~,id,~,coord,~,~]=readSWC(filename);
numNodes = length(id);

myv = VideoWriter('pathAtoB.mp4','MPEG-4');
open(myv)
fig=figure('units','normalized','outerposition',[0 0 0.5 0.65]);

for i=2:5:numNodes
    for j=2:5:numNodes
        fprintf(sprintf("%i, %i\n",i,j))
        if j==i
            continue;
        end
        fullpath=pathAtoB(i,j,filename,0);
        
        hold on
        scatter3(coord(:,1), coord(:,2),coord(:,3),4,'b')
        scatter3(coord(fullpath',1),coord(fullpath',2),coord(fullpath',3),'r');
        title(sprintf("%i, %i\n",i,j))
        drawnow
        
        thisframe=getframe(fig);
        writeVideo(myv, thisframe);
        clf
    end
end
close(myv)