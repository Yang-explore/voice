%%% 自动读取刚才生成的实验结果并画图
%%% Fixed path and variable names matches Main_Detect output

clear all
clc

% 1. 设置路径 (自动识别)
BaseFolder = pwd;
Results_Path = fullfile(BaseFolder, 'ALL_Results', 'NoAttack_BDR');

% 检查结果文件夹是否存在
if ~exist(Results_Path, 'dir')
    error('找不到结果文件夹，请先运行检测程序 Main_Detect_QIM_FE_Watermarking.m');
end

cd(Results_Path);

% 2. 加载数据
% 注意：这里的文件名必须与检测程序保存的文件名一致
try
    % 加载混合算法数据
    load('Hybrid_QIM_FE_BDR.mat'); 
    Data_Hybrid = mean(Bit_detection_rate_QIM_FE); % 计算12段语音的平均值
    Std_Hybrid = std(Bit_detection_rate_QIM_FE);   % 计算标准差
    
    % 加载 QIM 数据
    load('Hybrid_QIM_BDR.mat');
    Data_QIM = mean(Bit_detection_rate_QIM);
    Std_QIM = std(Bit_detection_rate_QIM);
    
    % 加载 FE 数据
    load('Hybrid_FE_BDR.mat');
    Data_FE = mean(Bit_detection_rate_FE);
    Std_FE = std(Bit_detection_rate_FE);
    
    fprintf('数据加载成功！开始绘图...\n');
catch
    error('数据加载失败。请检查 ALL_Results/NoAttack_BDR 文件夹下是否有 .mat 文件。');
end

% 3. 准备绘图参数
Bit_List = [4;8;16;32;64;128;256;512;1024]; % 横坐标刻度
Re_Bit_List = 1:length(Bit_List); % 这里的 x 轴用索引 1-9 表示

% 4. 开始绘图
figure('Color','w'); % 创建白色背景窗口

% --- 绘制 BDR 曲线 ---
plot(Re_Bit_List, Data_Hybrid, 's-r', 'LineWidth', 2, 'MarkerSize', 8); hold on;
plot(Re_Bit_List, Data_QIM,    'o--k', 'LineWidth', 1.5, 'MarkerSize', 8);
plot(Re_Bit_List, Data_FE,     '*--b', 'LineWidth', 1.5, 'MarkerSize', 8);

% --- 添加误差棒 (Error Bar) ---
errorbar(Re_Bit_List, Data_Hybrid, Std_Hybrid, 'or'); 
errorbar(Re_Bit_List, Data_QIM,    Std_QIM,    'ok'); 
errorbar(Re_Bit_List, Data_FE,     Std_FE,     'ob');

% --- 添加装饰线 (90% 达标线) ---
plot([0, 10], [90 90], 'k--', 'LineWidth', 1); 

% --- 设置坐标轴美化 ---
axis([0.5 9.5 40 105]); % 设置显示范围
set(gca, 'XTick', 1:length(Bit_List), 'XTickLabel', Bit_List); % 设置横坐标标签
set(gca, 'Fontname', 'Arial', 'Fontsize', 12); % 设置字体
grid on; % 打开网格

% --- 添加文字说明 ---
xlabel('Bit Rate (bps)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Bit Detection Rate (%)', 'FontSize', 12, 'FontWeight', 'bold');
title('Robustness Comparison (No Attack)', 'FontSize', 14);
legend('Proposed (QIM-FE)', 'QIM', 'FE', 'Location', 'SouthWest');

% 切回主目录
cd(BaseFolder);
fprintf('绘图完成！\n');