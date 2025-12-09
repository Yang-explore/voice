%%% 自动绘制抗攻击实验结果图 (Result Plotter)
%%% 对应论文 Fig. 10, 11, 12
%%% 2025 Optimized Version

clear all; clc;

% ================= 1. 基础配置 =================
BaseFolder = pwd;
Result_Root = fullfile(BaseFolder, 'ALL_Results');

% 定义三大类攻击 (对应论文的三个章节)
Categories = {
    'Robustness_against_Codecs',    'Fig. 10: Robustness against Codecs';
    'Robustness_against_Processing','Fig. 11: Robustness against Processing';
    'Robustness_against_Attacks',   'Fig. 12: Robustness against Common Attacks'
};

% 坐标轴设置
Bit_List_Raw = [4 8 16 32 64 128 256 512 1024];
Real_Bps_List = Bit_List_Raw / 4; % p.Dup=4, 实际比特率为 1, 2, 4...
X_Labels = arrayfun(@num2str, Real_Bps_List, 'UniformOutput', false);
X_Index = 1:length(Real_Bps_List);

% ================= 2. 开始遍历每一类 =================
for catIdx = 1:size(Categories, 1)
    CatName = Categories{catIdx, 1};
    FigTitle = Categories{catIdx, 2};
    CatPath = fullfile(Result_Root, CatName);
    
    if ~exist(CatPath, 'dir')
        fprintf('跳过 %s (未找到文件夹)\n', CatName);
        continue;
    end
    
    % 获取该类下的所有攻击结果文件夹
    SubDirs = dir(CatPath);
    SubDirs = SubDirs([SubDirs.isdir]);
    SubDirs = SubDirs(~ismember({SubDirs.name}, {'.', '..'}));
    
    NumAttacks = length(SubDirs);
    if NumAttacks == 0
        continue;
    end
    
    % --- 创建画布 ---
    figure('Name', FigTitle, 'Color', 'w', 'NumberTitle', 'off');
    
    % 动态计算子图布局 (例如 2列)
    nCols = 2;
    nRows = ceil(NumAttacks / nCols);
    
    % ================= 3. 遍历每一个攻击并画图 =================
    for attIdx = 1:NumAttacks
        AttackName_Raw = SubDirs(attIdx).name;
        % 去掉前缀 "BDR_" 让标题更干净
        AttackTitle = strrep(AttackName_Raw, 'BDR_', ''); 
        AttackTitle = strrep(AttackTitle, '_', ' '); % 下划线换空格
        
        DataPath = fullfile(CatPath, AttackName_Raw);
        
        % 寻找 .mat 文件
        MatFiles = dir(fullfile(DataPath, '*.mat'));
        if isempty(MatFiles)
            continue;
        end
        
        % 加载数据
        LoadPath = fullfile(DataPath, MatFiles(1).name);
        DataStruct = load(LoadPath);
        
        % 提取数据 (这里我们主要关注 Hybrid 算法的表现)
        % 如果之前只保存了 BDR_Hybrid，就只画这一条
        if isfield(DataStruct, 'BDR_Hybrid')
            Data_Matrix = DataStruct.BDR_Hybrid;
            
            % 计算平均值和标准差 (12段语音的统计结果)
            Y_Mean = mean(Data_Matrix, 1);
            Y_Std = std(Data_Matrix, 0, 1);
            
            % --- 绘制子图 ---
            subplot(nRows, nCols, attIdx);
            
            % 绘制误差棒曲线
            errorbar(X_Index, Y_Mean, Y_Std, 's-r', 'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', 'r');
            hold on;
            
            % 绘制 90% 达标线 (论文标准)
            plot([0, 10], [90 90], 'k--', 'LineWidth', 1);
            
            % --- 美化 ---
            title(AttackTitle, 'FontSize', 10, 'FontWeight', 'bold');
            axis([0.5 9.5 40 105]); % 固定 Y 轴范围方便对比
            set(gca, 'XTick', X_Index, 'XTickLabel', X_Labels);
            grid on;
            
            if attIdx == 1 % 只在第一个图显示图例，节省空间
                legend('Proposed (Hybrid)', 'Criterion (90%)', 'Location', 'SouthWest', 'FontSize', 8);
            end
            
            % 只在最左侧和最底部的图显示轴标签
            if mod(attIdx-1, nCols) == 0
                ylabel('BDR (%)', 'FontSize', 9);
            end
            if attIdx > (nRows-1)*nCols
                xlabel('Bit Rate (bps)', 'FontSize', 9);
            end
        end
    end
    
    % 给大图加个总标题 (可选)
    sgtitle(FigTitle, 'FontSize', 14, 'FontWeight', 'bold');
    
    fprintf('已生成图表: %s\n', FigTitle);
end

fprintf('所有图表绘制完成！\n');