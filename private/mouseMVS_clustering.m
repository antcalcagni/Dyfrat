function [MVS MVSt] = mouseMVS_clustering(MVSX,MVSY,MVSTms, NUMmvs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function groups mouse movements based on the quadrants criterion%
%The output are: MVS (matrix: numSbj x numItems x NUMmvs) grouping the%
%movements and MVSt (matrix: numSbj x numItems x NUMmvs) for the time%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numSbj = size(MVSX,1);
numItems = size(MVSX,2);

%%%Clustering for mouse movements%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MVS = zeros(numSbj,numItems,size(MVSX,3));
MVSt = zeros(numSbj,numItems,size(MVSX,3));
for i=1:numSbj
    for j=1:numItems
        mvs = []; tms = [];
        for k=1:NUMmvs(i,j)    
            %Check if the movement is in the first quadrant 
            if MVSX(i,j,k) > 0 && MVSY(i,j,k) >= 0    
                mvs = [mvs;1];
                tms = [tms;MVSTms(i,j,k)];
            end
            %Check if the movement is in the second quadrant 
            if MVSX(i,j,k) <= 0 && MVSY(i,j,k) > 0    
                mvs = [mvs;2];
                tms = [tms;MVSTms(i,j,k)];
            end
            %Check if the movement is in the thirdth quadrant 
            if MVSX(i,j,k) <= 0 && MVSY(i,j,k) < 0    
                mvs = [mvs;3];
                tms = [tms;MVSTms(i,j,k)];
            end
            %Check if the movement is in the fourth quadrant 
            if MVSX(i,j,k) > 0 && MVSY(i,j,k) <= 0    
                mvs = [mvs;4];
                tms = [tms;MVSTms(i,j,k)];
            end             
        end
        MVS(i,j,1:size(mvs)) = mvs;
        MVSt(i,j,1:size(tms)) = tms;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%