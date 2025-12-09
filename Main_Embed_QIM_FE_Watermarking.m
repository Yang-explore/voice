% Main entrance of Hybrid Watermarking embedding with QIM(Ngo) and FE(Wang)
%%% By WANG Shengbei
%%% Fixed for newer MATLAB versions (wavread -> audioread)

clear all
clc

%%%%%%%%%%%%%%%%% I/O setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 【修改1】使用相对路径，自动识别当前文件夹，避免路径报错
% 假设你的代码就在 'Proposed_QIM_FE' 文件夹根目录下
BaseFolder = pwd; 
InFolder = fullfile(BaseFolder, 'Original_8.1_sec_speech', filesep);
OutFolder = fullfile(BaseFolder, 'Hybrid_WM_QIM_FE_8.1_sec_speech', filesep);
Function_Folder = BaseFolder;

% 如果输出文件夹不存在，自动创建一个，防止报错
if ~exist(OutFolder, 'dir')
    mkdir(OutFolder);
end

% 生成水印序列
Bit_List = [4;8;16;32;64;128;256;512;1024];
Bit_list_length=length(Bit_List);
WM_sequence='peogFcia';%(random sequence)
WM_sequence_Dec = double(WM_sequence); % convert charcter to binary
WM_sequence_Bin = dec2bin(WM_sequence_Dec); % convert int()|10 to int()|2
WM_sequence_size=size(WM_sequence_Bin);
WM_sequence_data= reshape(WM_sequence_Bin',WM_sequence_size(1)*WM_sequence_size(2),1); 
WM_sequence_data=str2num(WM_sequence_data);

% 开始处理
for k = 1:12 % for speech 
      % 读取文件名，注意格式是 orgsound_8.1sec_001.wav 等
      if k < 10
          file_idx = ['00' num2str(k)];
      else
          file_idx = ['0' num2str(k)];
      end
      cur_speech=[InFolder 'orgsound_8.1sec_' file_idx '.wav'];
      
      % 【修改2】wavread 替换为 audioread
      % 旧代码: [xt Fs nbits] = wavread(cur_speech);
      if exist(cur_speech, 'file')
          [xt, Fs] = audioread(cur_speech);
          info = audioinfo(cur_speech);
          nbits = info.BitsPerSample; % 获取位深
          
          xt=xt+0.001; % 加微量噪声防止除零错误
          
          fprintf('正在处理音频: %s ...\n', cur_speech);

          for kk=1:Bit_list_length % 注意：这里建议从1开始遍历，除非你有意跳过前几个
             Bps=Bit_List(kk);
             
             % Set the embedding parameters
             p.FEstep=4;
p.LPorder=10;

% --- 修复开始 ---
raw_len = floor(Fs/Bps);
% 如果是奇数，就减 1 变成偶数；如果是偶数保持不变
if mod(raw_len, 2) == 1
    p.FrameLeng = raw_len - 1;
else
    p.FrameLeng = raw_len;
end
% --- 修复结束 ---

p.Fs=Fs;
p.Bps=Bps;
p.Num=2;
p.Dup=4;
p.Freqbin = p.FrameLeng/2; % 现在这里肯定能除尽了，结果是整数
             p.QIMsteps = [pi/2 pi/4 pi/6 pi/8 pi/10]';
             
             % 调用核心嵌入函数
             [out_speech, WMs_embed] = Embed_Function_QIM_FE(xt, WM_sequence_data, p);
             
             Real_Bps=Bps/p.Dup;
             
             % 构建输出文件名
             Output_name = fullfile(OutFolder, ['WM_QIM_FE_Bps' num2str(Real_Bps) '_' file_idx '.wav']);
             
             % 【修改3】wavwrite 替换为 audiowrite
             % 旧代码: wavwrite(out_speech,Fs,nbits,Output_name)
             % audiowrite 的参数顺序是：文件名, 数据, 采样率
             audiowrite(Output_name, out_speech, Fs, 'BitsPerSample', nbits);
             
             % cd(Function_Folder); % 不需要频繁切换目录
          end 
      else
          fprintf('警告: 找不到文件 %s，跳过。\n', cur_speech);
      end
end

fprintf('所有处理完成！\n'); 