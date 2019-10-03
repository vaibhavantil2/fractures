function [LBP_features, PatchExtracted] = ComputeLBPInPatch(Xray,Xray_info,x, y, sizeInMM,displayData)

% % Load the image and get header
% I = dicomread(filename);
% info = dicominfo(filename);

% Flip image intensities if needed
% if (strcmp(Xray_info.PhotometricInterpretation, 'MONOCHROME1'))
%     Xray = max(Xray(:)) - Xray;
% end



% Get a patch (in pixels) based on the size in mm
spacing             = Xray_info.ImagerPixelSpacing;
sizeInPixels        = round(sizeInMM ./ spacing');
Wx                  = sizeInPixels(1);
Wy                  = sizeInPixels(2);
PatchExtracted      = Xray(y-Wy:y+Wy, x-Wx:x+Wx);


% Get LBP features on patch
LBP_features        = extractLBPFeatures(uint16(PatchExtracted), 'Upright', false);


% Show image
if (displayData)
    figure;
    subplot(121)
    imagesc(double(Xray) / double(max(Xray(:))));
    colormap gray
    title(Xray_info.PatientID);
    hold on;
    %    scatter (x, y);
    plot(x,y,'ro','markersize',9,'linewidth',2)
    plot(x,y,'rx','markersize',9,'linewidth',2)
    % Show patch
    subplot(222)
    imshow(double(PatchExtracted) / double(max(Xray(:))));
    title('Extracted patch');
    subplot(224)
    bar(LBP_features)
    axis tight
    grid on
end


end

