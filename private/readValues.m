function [numSbj, numItems, numLabels, ONSETS_text, OFFSETS_text, RTS_text, ONSETS_resp, OFFSETS_resp, RTS_resp, MX, MY, RSP_DEG, RSP_DISC, NUM_MVS, POINTS_LBLS, MOUSE_MVS_X, MOUSE_MVS_Y, MOUSE_MVS_TIMES] = readValues()

%%%Open text file values.txt 
fid = fopen('values.txt','r'); 
InputText=textscan(fid,'%s',(10*1e+9),'delimiter','\n');
text = InputText{1};


%%%Get number of Items and Labels
cell = (regexp(text(2),';','split'));
numItems = str2double(cell{1}(1));
numLabels = str2double(cell{1}(2));

ONSETS_text = [];OFFSETS_text = [];RTS_text = []; ONSETS_resp = [];OFFSETS_resp = [];RTS_resp = [];MX = [];MY = [];RSP_DEG = [];RSP_DISC = [];NUM_MVS = [];


%%%Get number of Subjects%%%%%%%%%%%%%%%%%%% 
q = [];j=1;numSbj = 1;
for i=1:size(text,1)
    cell = (regexp(text(j),'_','split'));
    AA(i,:) = cell{1};
    q = [q; cell{1}(4)];
    j = j+5+numLabels;
    cell = (regexp(text(j),';','split'));
    numMovs = str2double(cell{1});
    NUM_MVS = [NUM_MVS numMovs];
    j = j+numMovs+1;
    if j >= size(text,1)
        break
    end 
end   
for i=2:length(q)
    if strcmp(q(i),q(i-1)) == 0
        numSbj=numSbj+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%Get Onsets, Offsets and RTs%%%%%%%%%%%%%%%%%%%%% 
j=3;k=0;
for i=3:size(text,1)
    k=k+1;
    cell = (regexp(text(j),';','split'));
    ONSETS_text = [ONSETS_text str2double(cell{1}(1))];
    OFFSETS_text = [OFFSETS_text str2double(cell{1}(2))];
    RTS_text = [RTS_text str2double(cell{1}(3))];
    cell = (regexp(text(j+1),';','split'));
    ONSETS_resp = [ONSETS_resp str2double(cell{1}(1))];
    OFFSETS_resp = [OFFSETS_resp str2double(cell{1}(2))];
    RTS_resp = [RTS_resp str2double(cell{1}(3))];
    j = j+1 + (numLabels+NUM_MVS(k)+1+2)+2;
    if j >= size(text,1)
        break
    end   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%Get Response values: Mx, My, Degree, Discrete%%% 
j=5;k=0;
for i=1:size(text,1)
    k=k+1;
    cell = (regexp(text(j),';','split'));
    MX = [MX str2double(cell{1}(1))];
    MY = [MY str2double(cell{1}(2))];
    RSP_DEG = [RSP_DEG str2double(cell{1}(3))];
    RSP_DISC = [RSP_DISC str2double(cell{1}(4))];
    j = j+1 + numLabels+NUM_MVS(k)+1+4;
    if j >= size(text,1)
        break
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ONSETS_text = vec2mat(ONSETS_text,numItems);
OFFSETS_text = vec2mat(OFFSETS_text,numItems);
RTS_text = vec2mat(RTS_text,numItems);
ONSETS_resp = vec2mat(ONSETS_resp,numItems);
OFFSETS_resp = vec2mat(OFFSETS_resp,numItems);
RTS_resp = vec2mat(RTS_resp,numItems);
MX = vec2mat(MX,numItems);
MY = vec2mat(MY,numItems);
RSP_DEG = vec2mat(RSP_DEG,numItems);
RSP_DISC = vec2mat(RSP_DISC,numItems);
NUM_MVS = vec2mat(NUM_MVS,numItems);


%%%Get label's points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pay attention: structure POINTS_LBLS is a ipermatrix (a cube)
POINTS_LBLS = zeros(numSbj,numItems,numLabels);
j=5;
for i=1:size(text,1)
    for k=1:numSbj
        for s=1:numItems
            for w=1:numLabels
                %[i k s w]
                j=j+1;
                cell = (regexp(text(j),';','split'));
                POINTS_LBLS(k,s,w) = str2double(cell{1}(3));
            end
            j = j+1 + 1+NUM_MVS(k,s)+4;
        end
    end
    if j >= size(text,1)
       break
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%Get Mouse movementes and times %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pay attention: the matrices are cubes
MOUSE_MVS_X = zeros(numSbj,numItems,max(max(NUM_MVS)));
MOUSE_MVS_Y = zeros(numSbj,numItems,max(max(NUM_MVS)));
MOUSE_MVS_TIMES = zeros(numSbj,numItems,max(max(NUM_MVS)));
j=5+numLabels+1;
for i=1:size(text,1)
    for k=1:numSbj
        for s=1:numItems
            for w=1:NUM_MVS(k,s)
            j=j+1;
            cell = (regexp(text(j),';','split'));
            MOUSE_MVS_TIMES(k,s,w) = str2double(cell{1}(2));
            MOUSE_MVS_X(k,s,w) = str2double(cell{1}(3));
            MOUSE_MVS_Y(k,s,w) = str2double(cell{1}(4));
            end
            j = j+1 + 4+numLabels+1; 
        end
    end
    if j >= size(text,1)
       break
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end





    


