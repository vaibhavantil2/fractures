function displayXrayMetrics(displayResults,dataOut);

subplot(241)
imagesc(displayResults.Xray)
title(displayResults.nameFile,'interpreter','none')
% Add the results of the finger
subplot(3,4,2)
imagesc(displayResults.displayResultsFinger.Xray2)
subplot(3,4,3)
imagesc(displayResults.displayResultsFinger.Combined)
subplot(3,4,4)
plot(displayResults.displayResultsFinger.CorticalProfile{1},'k')
hold on
plot(displayResults.displayResultsFinger.centValleyLoc,displayResults.displayResultsFinger.centValley,'ro','markersize',8)
plot(displayResults.displayResultsFinger.leftPeakLoc,displayResults.displayResultsFinger.leftPeak,'b*','markersize',8)
plot(displayResults.displayResultsFinger.rightPeakLoc,displayResults.displayResultsFinger.rightPeak,'b*','markersize',8)
plot(displayResults.displayResultsFinger.leftEdgeLoc,displayResults.displayResultsFinger.leftEdge,'md','markersize',8)
plot(displayResults.displayResultsFinger.rightEdgeLoc,displayResults.displayResultsFinger.rightEdge,'md','markersize',8)
grid on
axis tight

colormap gray

% add the LBP Results
subplot(3,4,6)
imagesc(displayResults.displayResultsLBP.Xray_out)
subplot(3,4,7)
imagesc(displayResults.displayResultsLBP.PatchExtracted)
subplot(3,4,8)
bar(dataOut.LBP_Features)
axis tight
grid on

% add the profiles
subplot(3,4,10)
imagesc(displayResults.displayResultsRadial.dataOutput)
subplot(3,4,11)
hold off
plot(displayResults.displayResultsRadial.prof_radial_new1,'r')
hold on
plot(displayResults.displayResultsRadial.prof_radial_new2,'b')
grid on
axis tight
subplot(3,4,12)
hold off
plot(displayResults.displayResultsRadial.prof2_radial_new1,'r')
hold on
plot(displayResults.displayResultsRadial.prof2_radial_new2,'b')
grid on
axis tight

% Add the lines
subplot(2,4,5)
imagesc(displayResults.displayResultsLunate)


