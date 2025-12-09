%%% 终极通用检测脚本 (Universal Detector - Fixed Watermark Source)
%%% 1. 优先读取 WM_sequency.txt (解决 BDR 低的问题)
%%% 2. 包含强力同步搜索
%%% 2025 Corrected Version

clear all; clc;

% ================= 1. 基础配置 =================
BaseFolder = pwd;
CategoryFolders = {
    'Robustness_against_Attacks', ...
    'Robustness_against_Codecs', ...
    'Robustness_against_Processing'
};
Global_Result_Root = fullfile(BaseFolder, 'ALL_Results');

% ================= 2. 关键修复：正确加载水印 =================
% 尝试寻找老师留下的水印文件
WM_File_Path = fullfile(BaseFolder, 'WM_sequency.txt');

if exist(WM_File_Path, 'file')
    fprintf('>>> 发现原始水印文件: WM_sequency.txt，正在加载...\n');
    fid = fopen(WM_File_Path, 'r');
    % 读取浮点数 (通常是 0 或 1)
    WM_Raw = fscanf(fid, '%f'); 
    fclose(fid);
    
    % 处理数据格式：如果是 0/1 序列
    WM_sequence_data = WM_Raw(:); 
    
    % 如果文件里存的是十进制数(如 0~255)，可能需要转换，但通常是二进制流
    % 这里假设它是直接的二进制序列
else
    fprintf('>>> 警告：未找到 WM_sequency.txt，使用默认字符串 peogFcia (可能导致 BDR 偏低)\n');
    WM_sequence = 'peogFcia'; 
    WM_sequence_Dec = double(WM_sequence); 
    WM_sequence_Bin = dec2bin(WM_sequence_Dec); 
    [WM_row, WM_col] = size(WM_sequence_Bin);
    WM_sequence_data = reshape(WM_sequence_Bin', WM_row*WM_col, 1); 
    WM_sequence_data = str2num(WM_sequence_data);
end

WM_Unit_Length = length(WM_sequence_data);
fprintf('>>> 水印序列长度: %d bits\n', WM_Unit_Length);

Bit_List = [4;8;16;32;64;128;256;512;1024];

% ================= 3. 开始遍历 =================
for catIdx = 1:length(CategoryFolders)
    CurrentCategory = CategoryFolders{catIdx};
    CategoryPath = fullfile(BaseFolder, CurrentCategory);
    
    if ~exist(CategoryPath, 'dir'), continue; end
    
    fprintf('==============================================\n');
    fprintf('正在处理大类: %s\n', CurrentCategory);
    
    SubDirs = dir(CategoryPath);
    SubDirs = SubDirs([SubDirs.isdir]);
    SubDirs = SubDirs(~ismember({SubDirs.name}, {'.', '..'}));
    
    ValidSubDirs = {};
    for i = 1:length(SubDirs)
        if ~strcmpi(SubDirs(i).name, 'ALL_Results') && ~strcmpi(SubDirs(i).name, 'codec_methods')
            ValidSubDirs{end+1} = SubDirs(i).name;
        end
    end
    
    for attIdx = 1:length(ValidSubDirs)
        AttackName = ValidSubDirs{attIdx};
        AttackFolderPath = fullfile(CategoryPath, AttackName, filesep);
        SaveResultPath = fullfile(Global_Result_Root, CurrentCategory, ['BDR_' AttackName], filesep);
        if ~exist(SaveResultPath, 'dir'), mkdir(SaveResultPath); end
        
        fprintf('  >>> 检测攻击: %s ... ', AttackName);
        BDR_Hybrid = zeros(12, length(Bit_List));
        
        for k = 1:12
            if k < 10, idx_str = ['00' num2str(k)]; else, idx_str = ['0' num2str(k)]; end
            
            for kk = 1:length(Bit_List)
                Bps = Bit_List(kk);
                Real_Bps = Bps/4;
                
                Pattern = ['*Bps' num2str(Real_Bps) '_' idx_str '.wav'];
                DirData = dir(fullfile(AttackFolderPath, Pattern));
                if isempty(DirData), continue; end
                
                FilePath = fullfile(AttackFolderPath, DirData(1).name);
                
                try
                    [yt_raw, Fs] = audioread(FilePath);
                    
                    % 参数设置
                    p.FEstep = 4; p.LPorder = 10;
                    p.FrameLeng = floor(Fs/Bps); % 保持原始逻辑
                    p.Fs = Fs; p.Bps = Bps; p.Num = 2; p.Dup = 4;
                    p.Freqbin = floor(p.FrameLeng / 2);
                    p.QIMsteps = [pi/2 pi/4 pi/6 pi/8 pi/10]';
                    
                    % --- 同步搜索 (Sync Search) ---
                    % 增加搜索范围以应对 Jitter 等强攻击
                    Max_Offset = 300; 
                    Best_BDR = 0;
                    Step = 2;
                    
                    for offset = 0:Step:Max_Offset
                        if length(yt_raw) <= offset, break; end
                        yt_curr = yt_raw(1+offset:end);
                        
                        [~, ~, Raw_Hybrid] = Detect_Function_QIM_FE(yt_curr, p);
                        
                        % 多数投票
                        L = length(Raw_Hybrid);
                        Valid_L = floor(L / p.Dup) * p.Dup;
                        if Valid_L > 0
                            Raw_Trunc = Raw_Hybrid(1:Valid_L);
                            Matrix = reshape(Raw_Trunc, p.Dup, []);
                            Sum_Votes = sum(Matrix, 1)';
                            Final_Bits = (Sum_Votes >= (p.Dup / 2));
                            
                            % 比对
                            Final_Len = length(Final_Bits);
                            RNum = ceil(Final_Len / WM_Unit_Length);
                            Full_WM_Ref = repmat(WM_sequence_data, RNum, 1);
                            WM_Ref = Full_WM_Ref(1:Final_Len);
                            
                            Err = sum(xor(Final_Bits, WM_Ref));
                            Curr_BDR = 100 * (Final_Len - Err) / Final_Len;
                            
                            if Curr_BDR > Best_BDR
                                Best_BDR = Curr_BDR;
                            end
                            if Best_BDR == 100, break; end
                        end
                    end
                    
                    BDR_Hybrid(k, kk) = Best_BDR;
                    
                catch
                end
            end
        end
        fprintf('完成. Avg BDR: %.2f%%\n', mean(mean(BDR_Hybrid)));
        
        cd(SaveResultPath);
        save(['BDR_Hybrid_' AttackName '.mat'], 'BDR_Hybrid');
        cd(BaseFolder);
    end
end
fprintf('\n全部完成！请重新运行绘图脚本。\n');