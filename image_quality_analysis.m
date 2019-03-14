% Codes are used for image quality analysis of CRISM and CTX
% SuperGLT and HyBER(MLM) should be well registrated or almost registrated
% CTX is auto self-adjust the brigntness based on the HyBER(MLM) image.
% Linyun He
% 03/14/19
function res = image_quality_analysis()
    [mlm_filename,mlm_path] = uigetfile({'*.*'},'MLM file');
    [superglt_filename,superglt_path] = uigetfile({'*.*'},'SuperGLT file');
    operate = inputdlg('Pixel size for MLM and SuperGLT (in meter)');
    mlm_size = str2double(cell2mat(operate));
    
    [ctx_filename,ctx_path] = uigetfile({'*.*'},'CTX file');
    operate = inputdlg('Pixel size for CTX (in meter)');
    ctx_size = str2double(cell2mat(operate));
    band = 32;
    
    MLM = read_envi_data(fullfile(mlm_path,mlm_filename));
    SGLT = read_envi_data(fullfile(superglt_path,superglt_filename));
    CTX = read_envi_data(fullfile(ctx_path,ctx_filename));
    CTX = CTX/(2^8-1);
    
    
    [num_rows,num_cols,num_bands] = size(MLM);
    [num_rows2,num_cols2,num_bands2] = size(SGLT);
    if num_rows == num_rows2+1
        MLM = MLM(1:end-1,:,:);
    elseif num_cols == num_cols2+1
        MLM = MLM(:,1:end-1,:);
    end
    [num_rows,num_cols,num_bands] = size(MLM);
    if num_rows ~= num_rows2 || num_cols ~= num_cols2 || num_bands ~= num_bands2
        error("SuperGLT and MLM should have the same bands and almost the same rows and cols!");
    end
    
    waitfor(msgbox("Starting to self-adjust the brightness of MLM and CTX..."));
    CTX_sub = choosesubfig(1,1,CTX);
    MLM_sub = choosesubfig(1,1,MLM(:,:,band));
    scalar = mean(MLM_sub(:))/mean(CTX_sub(:));
    CTX_new = CTX * scalar;
    
    waitfor(msgbox("Starting to select the rock on MLM and CTX to compute the PSF..."));
    draw_PSF(MLM,SGLT,band,mlm_size,CTX_new,ctx_size,1);
    
    waitfor(msgbox("Starting to select the area on SuperGLT and CTX to compute the MTF..."));
    draw_MTF(SGLT(:,:,band),MLM(:,:,band),mlm_size,CTX,ctx_size);
    
    res = true;
    
end