%%% Main entrance of Hybrid Watermarking Detection
%%% Fixed for newer MATLAB versions (wavread -> audioread)
%%% Fixed parameter logic to match Embedding step

clear all
clc

%%%%%%%%%%%%%%%%% I/O setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 【修改1】使用相对路径
BaseFolder = pwd; 
Function_Folder = BaseFolder;
% 输入：读取刚才生成的含水印音频
WM_InFolder = fullfile(BaseFolder, 'Hybrid_WM_QIM_FE_8.1_sec_speech', filesep);
% 输出：结果保存路径
Result_Folder = fullfile(BaseFolder, 'ALL_Results', 'NoAttack_BDR', filesep);

% 如果结果文件夹不存在，自动创建
if ~exist(Result_Folder, 'dir')
    mkdir(Result_Folder);
end

% Set the parameters
Bit_List = [4;8;16;32;64;128;256;512;1024];
Bit_list_length = length(Bit_List);
WM_sequence = 'peogFcia'; %(random sequence)

% 初始化结果矩阵
Bit_detection_rate_FE = zeros(12, Bit_list_length);
Bit_detection_rate_QIM = zeros(12, Bit_list_length);
Bit_detection_rate_QIM_FE = zeros(12, Bit_list_length);

fprintf('开始检测...\n');

for k = 1:12 
    % 构造文件名编号
    if k < 10
        file_idx = ['00' num2str(k)];
    else
        file_idx = ['0' num2str(k)];
    end
    
    for kk = 1:Bit_list_length
           Bps = Bit_List(kk);
           Real_Bps = Bps/4; % Dup=4
           
           % 构造文件名
           WM_speech = fullfile(WM_InFolder, ['WM_QIM_FE_Bps' num2str(Real_Bps) '_' file_idx '.wav']);
           
           if exist(WM_speech, 'file')
               % 【修改2】wavread -> audioread
               [yt, Fs] = audioread(WM_speech);	
               
               % Set the embedding parameters
               p.FEstep = 4; 
               p.LPorder = 10;
               
               % 【修改3】关键修复！保持与嵌入端完全一致的帧长计算逻辑
               % 强制帧长为偶数，防止 p.Freqbin 出现小数导致的 ones 报错
               raw_len = floor(Fs/Bps);
               if mod(raw_len, 2) == 1
                   p.FrameLeng = raw_len - 1;
               else
                   p.FrameLeng = raw_len;
               end
               
               p.Fs = Fs;
               p.Bps = Bps;
               p.Num = 2;
               p.Dup = 4;
               p.Freqbin = p.FrameLeng/2; % 现在这里肯定是整数了
               p.QIMsteps = [pi/2 pi/4 pi/6 pi/8 pi/10]';
               
               % 调用核心检测函数
               [Real_WM_LSFs, Real_WM_Res, Real_WM_LSFs_Res] = Detect_Function_QIM_FE(yt, p);
             
               % 准备原始水印数据用于比对
               Embed_WM_Dec = double(WM_sequence);
               Embed_WM_Bin = dec2bin(Embed_WM_Dec); 
               [Embed_WM_row, Embed_WM_col] = size(Embed_WM_Bin);
               Embed_WM_unit = reshape(Embed_WM_Bin', Embed_WM_row*Embed_WM_col, 1);
               Embed_WM_Leng = length(Embed_WM_unit);
                 
               Detect_WM_Leng = length(Real_WM_LSFs);
               
               % 循环填充原始水印，使其长度与检测出的长度一致
               RNum = ceil(Detect_WM_Leng/Embed_WM_Leng);
               Embed_data = Embed_WM_unit;
               for kkk = 1:RNum
                    Embed_data = [Embed_data; Embed_WM_unit]; 
               end
               WMs_Embedded = Embed_data(1:Detect_WM_Leng);
               WMs_Embedded = str2num(WMs_Embedded);
               
               % --- 计算 BDR (Bit Detection Rate) ---
               
               % 1. BDR for FE (Formant Enhancement)
               Detect_error_FE = xor(Real_WM_LSFs', WMs_Embedded);
               Error_sum_FE = sum(Detect_error_FE);
               Correct_rate_FE = 100 * (Detect_WM_Leng - Error_sum_FE) / Detect_WM_Leng; 
               Bit_detection_rate_FE(k,kk) = Correct_rate_FE;
               
               % 2. BDR for QIM (Quantization Index Modulation)
               Detect_error_QIM = xor(Real_WM_Res', WMs_Embedded);
               Error_sum_QIM = sum(Detect_error_QIM);
               Correct_rate_QIM = 100 * (Detect_WM_Leng - Error_sum_QIM) / Detect_WM_Leng; 
               Bit_detection_rate_QIM(k,kk) = Correct_rate_QIM;           
     
               % 3. BDR for Hybrid QIM and FE (The Proposed Method)
               Detect_error_QIM_FE = xor(Real_WM_LSFs_Res', WMs_Embedded);
               Error_sum_QIM_FE = sum(Detect_error_QIM_FE);
               Correct_rate_QIM_FE = 100 * (Detect_WM_Leng - Error_sum_QIM_FE) / Detect_WM_Leng; 
               Bit_detection_rate_QIM_FE(k,kk) = Correct_rate_QIM_FE; 
               
               fprintf('文件: %s | 码率: %d | Hybrid BDR: %.2f%%\n', file_idx, Bps, Correct_rate_QIM_FE);
           else
               if k <= 9 % 忽略不存在的文件
                   fprintf('跳过文件: %s (未找到)\n', WM_speech);
               end
           end
     end 
 end    

% 保存结果
fprintf('保存结果到: %s ...\n', Result_Folder);
cd(Result_Folder);

% 保存 .mat 数据
save Hybrid_FE_BDR Bit_detection_rate_FE
save Hybrid_QIM_BDR Bit_detection_rate_QIM
save Hybrid_QIM_FE_BDR Bit_detection_rate_QIM_FE

% 保存 .txt 文本报告
% 1. FE 结果
fid = fopen('Hybrid_FE_BDR.txt','w+');
fprintf(fid, '     bps |  4     8      16     32      64      128      256      512      1024 \n');
for m= 1:12 
    fprintf(fid, 'speech_0%02d   ', m);
    for mm=1:length(Bit_List)
        fprintf(fid,'%3.2f   ', Bit_detection_rate_FE(m,mm));
    end 
    fprintf(fid, '\n');
end
fclose(fid);
     
% 2. QIM 结果
fid = fopen('Hybrid_QIM_BDR.txt','w+');
fprintf(fid, '     bps |  4     8      16     32      64      128      256      512      1024 \n');
for m= 1:12 
    fprintf(fid, 'speech_0%02d   ', m);
    for mm=1:length(Bit_List) 
        fprintf(fid,'%3.2f   ', Bit_detection_rate_QIM(m,mm));
    end 
    fprintf(fid, '\n');
end
fclose(fid);

% 3. Hybrid 结果
fid = fopen('Hybrid_QIM_FE_BDR.txt','w+');
fprintf(fid, '     bps |  4     8      16     32      64      128      256      512      1024 \n');
for m= 1:12 
    fprintf(fid, 'speech_0%02d   ', m);
    for mm=1:length(Bit_List) 
        fprintf(fid,'%3.2f   ', Bit_detection_rate_QIM_FE(m,mm));
    end 
    fprintf(fid, '\n');
end 
fclose(fid);

% 切回原目录
cd(Function_Folder);
fprintf('所有检测完成！结果已保存。\n');