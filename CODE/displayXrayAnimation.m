function allHandles = displayXrayAnimation(displayResults,dataOut)
% display all the metrics that have been extracted from an x-ray ANIMATION
% Check that the data is received as structs
if nargin==1
    if isa(displayResults,'char')
        [dataOut,qq2,displayResults]       = extract_measurements_xray(displayResults);
    else
        disp('Data has to be 2 structures or one file name to be processed')
        allHandles =[];
        return;
    end
elseif nargin ==2
    if ~(isa(displayResults,'struct')&&isa(dataOut,'struct'))
            disp('Data has to be 2 structures or one file name to be processed')
        allHandles =[];
        return;
    end
else
    disp('Data has to be 2 structures or one file name to be processed')
    allHandles =[];
    return;
end



% First row, the original image, plus landmarks, rotation and lines of width
set(gcf,'Position', [   1000 500 500 400])
clf
handleAx = subplot(4,4,1);
imagesc(displayResults.Xray)
handleSecAx=subplot(4,4,4);
handleSecAx.Visible='off';
handleAx.Position=[0.1 0.1 0.8 0.8];



colormap gray

Xray_gray               = repmat(displayResults.Xray./max(displayResults.Xray(:)),[1 1 3]);

sizeDilate = 55;
    Xray_mask2          = imdilate (displayResults.Xray_mask,ones(sizeDilate));   
    Xray_norm           = (Xray_mask2==0).*displayResults.Xray/max(displayResults.Xray(:));
    Xray_RGB(:,:,1)     = (Xray_mask2==1)+Xray_norm;
    Xray_RGB(:,:,2)     = (Xray_mask2==2)+Xray_norm;
    Xray_RGB(:,:,3)     = (Xray_mask2==3)+Xray_norm;
    
    Xray_maskR2          = imdilate (displayResults.Xray_maskR,ones(sizeDilate));   
    Xray_normR           = (Xray_maskR2==0).*displayResults.XrayR2/max(displayResults.XrayR(:));
    Xray_RGBR(:,:,1)     = (Xray_maskR2==1)+Xray_normR;
    Xray_RGBR(:,:,2)     = (Xray_maskR2==2)+Xray_normR;
    Xray_RGBR(:,:,3)     = (Xray_maskR2==3)+Xray_normR;
    
coords_landmarks =  regionprops(Xray_maskR2,'Centroid');    
% Number of steps
numSteps = 20;
stepAnim = 1/numSteps;

% First animation, add the manual landmarks
for k=0:stepAnim:1
    handleAx.Children.CData = (k*Xray_RGB+(1-k)*Xray_gray);
    drawnow
    pause(0.01)    
end
for k=0:stepAnim:1
     handleAx.Children.CData = ((1-k)*Xray_RGB+(k)*Xray_gray);
    drawnow
    pause(0.01)    
end

[rowsPre,colsPre,levsPre] = size(displayResults.Xray);
[rowsPos,colsPos,levsPos] = size(displayResults.XrayR);

diffRows    = floor((rowsPos-rowsPre)/2);
diffCols    = floor((colsPos-colsPre)/2);


Xray_preRot = zeros(size(displayResults.XrayR));
Xray_preRot (diffRows:diffRows+rowsPre-1,diffCols:diffCols+colsPre-1) = displayResults.Xray;


% Second animation, the rotation process
for k=0:stepAnim:1
     handleAx.Children.CData =(k*displayResults.XrayR2+(1-k)*Xray_preRot);
    drawnow
    pause(0.01)    
end

rr=displayResults.coordinatesArm(1):displayResults.coordinatesArm(2);
cc=displayResults.coordinatesArm(3):displayResults.coordinatesArm(4);

%% Zoom towards the lunate region

stepsRowsDown   = round(linspace(1,displayResults.coordinatesArm(1),numSteps));
stepsRowsUp     = round(linspace(rowsPos,displayResults.coordinatesArm(2),numSteps));
stepsColsDown   = round(linspace(1,displayResults.coordinatesArm(3),numSteps));
stepsColsUp     = round(linspace(colsPos,displayResults.coordinatesArm(4),numSteps));


 handleAx.Children.CData =(Xray_RGBR);

for k=1:numSteps   
    %axis([ stepsColsDown(k) stepsColsUp(k) stepsRowsDown(k) stepsRowsUp(k) ])  
    handleAx.YLim(1) = stepsRowsDown(k);
    handleAx.YLim(2) = stepsRowsUp(k);
    handleAx.XLim(1) = stepsColsDown(k);
    handleAx.XLim(2) = stepsColsUp(k); 
    drawnow
    pause(0.01)    
end

diffLunates =  size(displayResults.displayResultsLunate2,1)-size(displayResults.displayResultsLunate,1);

rr2=displayResults.coordinatesArm(1)-diffLunates:displayResults.coordinatesArm(2);

X_rayLunate = repmat(displayResults.XrayR2(rr2,cc)/max(max(displayResults.XrayR2(rr2,cc))),[1 1 3]);
%  animation, add lines
handleAx.YLim(1) = 1;
handleAx.XLim(1) = 1;
handleAx.XLim(2) = numel(cc);
handleAx.YLim(2) = numel(rr2);
    
for k=0:stepAnim:1
     handleAx.Children.CData =(k*displayResults.displayResultsLunate2+(1-k)*X_rayLunate);
    drawnow
    pause(0.01)    
end

%% Zoom out
 handleAx.Children.CData =(Xray_RGBR);
    handleAx.YLim(1) = stepsRowsDown(end);
    handleAx.YLim(2) = stepsRowsUp(end);
    handleAx.XLim(1) = stepsColsDown(end);
    handleAx.XLim(2) = stepsColsUp(end); 
for k=numSteps:-1:1
  %  axis([ stepsColsDown(k) stepsColsUp(k) stepsRowsDown(k) stepsRowsUp(k) ])  
        handleAx.YLim(1) = stepsRowsDown(k);
    handleAx.YLim(2) = stepsRowsUp(k);
    handleAx.XLim(1) = stepsColsDown(k);
    handleAx.XLim(2) = stepsColsUp(k); 
    drawnow
    pause(0.01)    
end



%%  Add the results of the finger
 handleAx.Children.CData =(Xray_RGBR);

stepsRowsDown   = round(linspace(1,displayResults.displayResultsFinger.rr(1),numSteps));
stepsRowsUp     = round(linspace(rowsPos,displayResults.displayResultsFinger.rr(end),numSteps));
stepsColsDown   = round(linspace(1,displayResults.displayResultsFinger.cc(1),numSteps));
stepsColsUp     = round(linspace(colsPos,displayResults.displayResultsFinger.cc(end),numSteps));

% zoom in
for k=1:numSteps
  %  axis([ stepsColsDown(k) stepsColsUp(k) stepsRowsDown(k) stepsRowsUp(k) ])  
        handleAx.YLim(1) = stepsRowsDown(k);
    handleAx.YLim(2) = stepsRowsUp(k);
    handleAx.XLim(1) = stepsColsDown(k);
    handleAx.XLim(2) = stepsColsUp(k); 
  
    drawnow
    pause(0.01)    
end

%%

[rFinger,cFinger] = size(displayResults.displayResultsFinger.Xray2);
finger2 = zeros(size(displayResults.displayResultsFinger.Combined));
finger2(5:4+rFinger,2:1+cFinger,1) = displayResults.displayResultsFinger.Xray2/max(max(displayResults.displayResultsFinger.Xray2));
finger2(5:4+rFinger,2:1+cFinger,2) = displayResults.displayResultsFinger.Xray2/max(max(displayResults.displayResultsFinger.Xray2));
finger2(5:4+rFinger,2:1+cFinger,3) = displayResults.displayResultsFinger.Xray2/max(max(displayResults.displayResultsFinger.Xray2));
[rFinger2,cFinger2,lFinger2] = size(finger2);
handleAx.XLim(1) = 1;
handleAx.YLim(1) = 1;
handleAx.XLim(2) = cFinger2;
handleAx.YLim(2) = rFinger2;
%  animation, finger
for k=0:stepAnim:1
    handleAx.Children.CData =(k*displayResults.displayResultsFinger.Combined+(1-k)*finger2);
    drawnow
    pause(0.1)    
end





handleSecAx.Visible='off';
handleSecAx.Position=[0.1 0.1 0.8 0.2];
hPlot1=plot(displayResults.displayResultsFinger.CorticalProfile{1},'g','linewidth',3);
handleSecAx.Visible='off';
handleSecAx.XTick=[];
handleSecAx.YTick=[];
axis tight
    drawnow;pause(0.1)  
%handleSecAx.
hold on
hPlot2=plot(displayResults.displayResultsFinger.centValleyLoc,displayResults.displayResultsFinger.centValley,'ro','markersize',8);
    drawnow;pause(0.1) 
hPlot3=plot(displayResults.displayResultsFinger.leftPeakLoc,displayResults.displayResultsFinger.leftPeak,'b*','markersize',8);
    drawnow;pause(0.1) 
hPlot4=plot(displayResults.displayResultsFinger.rightPeakLoc,displayResults.displayResultsFinger.rightPeak,'b*','markersize',8);
    drawnow;pause(0.1) 
hPlot5=plot(displayResults.displayResultsFinger.leftEdgeLoc,displayResults.displayResultsFinger.leftEdge,'md','markersize',8);
    drawnow;pause(0.1) 
hPlot6=plot(displayResults.displayResultsFinger.rightEdgeLoc,displayResults.displayResultsFinger.rightEdge,'md','markersize',8);
    drawnow;pause(0.1) 



hPlot2.Visible='off'; drawnow;pause(0.1) 
hPlot3.Visible='off'; drawnow;pause(0.1) 
hPlot4.Visible='off'; drawnow;pause(0.1) 
hPlot5.Visible='off'; drawnow;pause(0.1) 
hPlot6.Visible='off'; drawnow;pause(0.1) 
hPlot1.Visible='off'; drawnow;pause(0.1) 

%%
 handleAx.Children.CData =(Xray_RGBR);
% zoom out
for k=numSteps:-1:1
  %  axis([ stepsColsDown(k) stepsColsUp(k) stepsRowsDown(k) stepsRowsUp(k) ])    
    handleAx.YLim(2) = stepsRowsUp(k);
        handleAx.YLim(1) = stepsRowsDown(k);
    handleAx.XLim(2) = stepsColsUp(k); 
        handleAx.XLim(1) = stepsColsDown(k);  
    drawnow
    pause(0.01)    
end


%% zoom into styloid

stepsRowsDown   = round(linspace(1,displayResults.displayResultsFinger.rr(1),numSteps));
stepsRowsUp     = round(linspace(rowsPos,displayResults.displayResultsFinger.rr(end),numSteps));
stepsColsDown   = round(linspace(1,displayResults.displayResultsFinger.cc(1),numSteps));
stepsColsUp     = round(linspace(colsPos,displayResults.displayResultsFinger.cc(end),numSteps));


%% Third row,  add the LBP Results
hg = subplot(4,3,7)
imagesc(displayResults.displayResultsLBP.Xray_out)
% zoom in a little bit
[rows,cols,levs]=size(displayResults.displayResultsLBP.Xray_out);
 axis(round([0.2*cols 0.8*cols 0.3*rows 0.9*rows ]))
title('(g)','fontsize',12)

hh = subplot(4,3,8)
imagesc(displayResults.displayResultsLBP.PatchExtracted)
title('(h)','fontsize',12)

hi = subplot(4,3,9)
bar(dataOut.LBP_Features)
axis tight
grid on
title('(i)','fontsize',12)

%% Fourth row add the profiles
hj = subplot(4,3,10)
imagesc(displayResults.displayResultsRadial.dataOutput)
% zoom in a little bit
[rows,cols,levs]=size(displayResults.displayResultsRadial.dataOutput);
 axis(round([0.2*cols 0.8*cols 0.3*rows 0.9*rows ]))
title('(j)','fontsize',12)

hk = subplot(4,3,11)
hold off
plot(displayResults.displayResultsRadial.prof_radial_new1,'r')
hold on
plot(displayResults.displayResultsRadial.prof_radial_new2,'b')
grid on
axis tight
title('(k)','fontsize',12)

hl = subplot(4,3,12)
hold off
plot(displayResults.displayResultsRadial.prof2_radial_new1,'r')
hold on
plot(displayResults.displayResultsRadial.prof2_radial_new2,'b')
grid on
axis tight
title('(l)','fontsize',12)
% Add the lines
%h = subplot(2,4,5)
%imagesc(displayResults.displayResultsLunate)



hTit = annotation(gcf,'textbox',...
    [0.345199568500538 0.955709957258268 0.327939580623643 0.0292207786724681],...
    'String',displayResults.nameFile,'interpreter','none',...
    'FitBoxToText','on','linestyle','none');

allHandles.ha = ha;
allHandles.hb = hb;
allHandles.hc = hc;
allHandles.hd = hd;
allHandles.he = he;
allHandles.hf = hf;
allHandles.hg = hg;
allHandles.hh = hh;
allHandles.hi = hi;
allHandles.hj = hj;
allHandles.hk = hk;
allHandles.hl = hl;



%title(displayResults.nameFile,'interpreter','none')
