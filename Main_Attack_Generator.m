% 自动生成抗攻击测试音频 (Attack Simulator)
% 对应论文 Section 6.2.2 & 6.2.3
clear all; clc;

% --- 1. 设置路径 ---
BaseFolder = pwd;
% 输入：读取之前的“含水印音频”
InputFolder = fullfile(BaseFolder, 'Hybrid_WM_QIM_FE_8.1_sec_speech', filesep);
% 输出：攻击后的音频根目录
OutputRoot = fullfile(BaseFolder, 'Attacked_Audio', filesep);

if ~exist(InputFolder, 'dir')
    error('未找到含水印音频，请先运行 Main_Embed 程序！');
end

% 获取所有 wav 文件
files = dir(fullfile(InputFolder, '*.wav'));
if isempty(files)
    error('文件夹为空，没有可攻击的音频文件。');
end

fprintf('开始生成攻击样本，共 %d 个文件...\n', length(files));

for i = 1:length(files)
    filename = files(i).name;
    fullPath = fullfile(InputFolder, filename);
    
    % 读取音频
    [y, Fs] = audioread(fullPath);
    info = audioinfo(fullPath);
    nbits = info.BitsPerSample;
    
    % ==============================================
    % 攻击 1: 高斯白噪声 (Gaussian Noise)
    % 对应论文 Fig. 12 (e)
    % ==============================================
    AttackName = 'Noise_36dB';
    SavePath = fullfile(OutputRoot, AttackName, filesep);
    if ~exist(SavePath, 'dir'), mkdir(SavePath); end
    
    % 添加 SNR = 36dB 的噪声
    y_noise = awgn(y, 36, 'measured'); 
    audiowrite(fullfile(SavePath, filename), y_noise, Fs, 'BitsPerSample', nbits);
    
    % ==============================================
    % 攻击 2: 音量缩放 (Amplitude Scaling)
    % 对应论文 Fig. 11 (h)
    % ==============================================
    AttackName = 'Scaling_0.5'; % 音量减半
    SavePath = fullfile(OutputRoot, AttackName, filesep);
    if ~exist(SavePath, 'dir'), mkdir(SavePath); end
    
    y_scale = y * 0.5; 
    audiowrite(fullfile(SavePath, filename), y_scale, Fs, 'BitsPerSample', nbits);
    
    % ==============================================
    % 攻击 3: 重采样 (Resampling) 
    % 对应论文 Fig. 11 (a) - 从 44.1k -> 24k -> 44.1k
    % ==============================================
    AttackName = 'Resample_24k';
    SavePath = fullfile(OutputRoot, AttackName, filesep);
    if ~exist(SavePath, 'dir'), mkdir(SavePath); end
    
    target_fs = 24000;
    % 先降采样
    y_down = resample(y, target_fs, Fs);
    % 再升采样回原始频率 (为了让检测程序能运行，必须恢复到原采样率)
    y_up = resample(y_down, Fs, target_fs);
    
    % 截断或补零以匹配原始长度
    if length(y_up) > length(y)
        y_up = y_up(1:length(y));
    elseif length(y_up) < length(y)
        y_up = [y_up; zeros(length(y)-length(y_up), 1)];
    end
    
    audiowrite(fullfile(SavePath, filename), y_up, Fs, 'BitsPerSample', nbits);
    
    if mod(i, 10) == 0, fprintf('已处理 %d 个文件...\n', i); end
end

fprintf('攻击样本生成完毕！请查看 Attacked_Audio 文件夹。\n');
