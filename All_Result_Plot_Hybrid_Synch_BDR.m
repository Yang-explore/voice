%%% Plot the result together Hybrid (BDR ) Synch (BDR)
%%% Created by WANG Shengbei

clc
%clear all 

% BDR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_Folder='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\';
BDR_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\NoAttack_BDR\';

Bit_List = [1;2;4;8;16;32;64;128;256];
Re_Bit_List = log2(Bit_List);
speech_track=12;


%%%%%%%%%%%BDR
cd(BDR_Hybrid_QIM_FE);
Hybrid_BDR_results=load('Hybrid_QIM_FE_BDR');
Hybrid_BDR_results_data=Hybrid_BDR_results.Bit_detection_rate_QIM_FE;
Avg_Hybrid_BDR=mean(Hybrid_BDR_results_data);
Std_Hybrid_BDR=std(Hybrid_BDR_results_data);

Single_QIM_BDR_results=load('Single_QIM_BDR');
Single_QIM_BDR_results_data=Single_QIM_BDR_results.Bit_detection_rate_QIM;
Avg_Single_QIM_BDR=mean(Single_QIM_BDR_results_data);
Std_Single_QIM_BDR=std(Single_QIM_BDR_results_data);

Single_FE_BDR_results=load('Single_FE_BDR');
Single_FE_BDR_results_data=Single_FE_BDR_results.Bit_detection_rate_FE;
Avg_Single_FE_BDR=mean(Single_FE_BDR_results_data);
Std_Single_FE_BDR=std(Single_FE_BDR_results_data);

figure(6)
subplot(121)
plot(Re_Bit_List,Avg_Hybrid_BDR,'s-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_QIM_BDR,'o--k','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_FE_BDR,'*--b','LineWidth',1);hold on

errorbar(Re_Bit_List,Avg_Hybrid_BDR,Std_Hybrid_BDR, 'or') 
errorbar(Re_Bit_List,Avg_Single_QIM_BDR,Std_Single_QIM_BDR, 'ok') 
errorbar(Re_Bit_List,Avg_Single_FE_BDR,Std_Single_FE_BDR, 'ob')   
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',9)  
axis([-0.5 8.5 40 105]);
text (0,45,'(a) ','fontsize',9)
grid on
ylabel('BDR (%)','fontsize',9)
xlabel('Bit rate (bps)','fontsize',9)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Prop. (QIM-FE)', 'QIM', 'FE','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',9,'Position',[p1(1),p1(2),p1(3)-0.1,p1(4)])


%%%%%%%%%%%Synchro-Hybrid BDR

cd(BDR_Hybrid_QIM_FE);
Synch_Hybrid_BDR_results=load('Synch_Hybrid_QIM_FE_BDR');
Synch_Hybrid_BDR_results_data=Synch_Hybrid_BDR_results.Bit_detection_rate_QIM_FE;
Avg_Synch_Hybrid_BDR=mean(Synch_Hybrid_BDR_results_data);
Std_Synch_Hybrid_BDR=std(Synch_Hybrid_BDR_results_data);



subplot(122)

plot(Re_Bit_List,Avg_Hybrid_BDR,'o-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_BDR,'>--k','LineWidth',0.5);hold on
errorbar(Re_Bit_List,Avg_Hybrid_BDR,Std_Hybrid_BDR, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_BDR,Std_Synch_Hybrid_BDR, 'ok')   
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',9)  
axis([-0.5 8.5 40 105]);
text (0,45,'(b) ','fontsize',9)
grid on
ylabel('BDR (%)','fontsize',9)
xlabel('Bit rate (bps)','fontsize',9)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Prop. (QIM-FE)', 'Syn-Prop. (QIM-FE)','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',9,'Position',[p1(1),p1(2),p1(3),p1(4)])

% for sub-figures  1 row * 2 column
subplot(1,2,1)
psf=get(gca,'Position');
set(gca,'Position',[0.07,0.19,0.41,0.78]);

subplot(1,2,2)
psf=get(gca,'Position');
set(gca,'Position',[0.58,0.19,0.41,0.78]);    

cd(Plot_Folder)
