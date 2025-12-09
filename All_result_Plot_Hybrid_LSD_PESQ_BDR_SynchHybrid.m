%Plot all the result together Hybrid (LSD PESQ BDR)
clear all 
clc
%close all
% Sound quality%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_Folder='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\';
LSD_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\LSD_Results\';
BDR_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\NoAttack_BDR\';
PESQ_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\PESQ_Results\';

Bit_List = [1;2;4;8;16;32;64;128;256];
Re_Bit_List = log2(Bit_List);
speech_track=12;
%%%%%%%%%%%LSD
cd(LSD_Hybrid_QIM_FE);
Hybrid_LSD_results=load('Hybrid_QIM_FE_LSD');
Hybrid_LSD_results_data=Hybrid_LSD_results.LSD_results;
Avg_Hybrid_LSD=mean(Hybrid_LSD_results_data);
Std_Hybrid_LSD=std(Hybrid_LSD_results_data);

Single_QIM_LSD_results=load('Single_QIM_LSD');
Single_QIM_LSD_results_data=Single_QIM_LSD_results.LSD_results;
Avg_Single_QIM_LSD=mean(Single_QIM_LSD_results_data);
Std_Single_QIM_LSD=std(Single_QIM_LSD_results_data);

Single_FE_LSD_results=load('Single_FE_LSD');
Single_FE_LSD_results_data=Single_FE_LSD_results.LSD_results;
Avg_Single_FE_LSD=mean(Single_FE_LSD_results_data);
Std_Single_FE_LSD=std(Single_FE_LSD_results_data);

figure(18),subplot(321)

plot(Re_Bit_List,Avg_Hybrid_LSD,'o-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_QIM_LSD,'o--k','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_FE_LSD,'o--b','LineWidth',1);hold on

errorbar(Re_Bit_List,Avg_Hybrid_LSD,Std_Hybrid_LSD, 'or') 
errorbar(Re_Bit_List,Avg_Single_QIM_LSD,Std_Single_QIM_LSD, 'ok') 
errorbar(Re_Bit_List,Avg_Single_FE_LSD,Std_Single_FE_LSD, 'ob')   

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[1 1],'k--');
set(gca,'Fontname','Arial','Fontsize',7)  
axis([-0.5 8.5 0 2.5]);
text (0,2.1,'(a) ','fontsize',7)
grid on
ylabel('LSD (dB)','fontsize',7)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);

%%%%%%%%%%%PESQ
cd(PESQ_Hybrid_QIM_FE);
Hybrid_PESQ_results=load('Hybrid_QIM_FE_PESQ');
Hybrid_PESQ_results_data=Hybrid_PESQ_results.PESQ_results;
Avg_Hybrid_PESQ=mean(Hybrid_PESQ_results_data);
Std_Hybrid_PESQ=std(Hybrid_PESQ_results_data);

Single_QIM_PESQ_results=load('Single_QIM_PESQ');
Single_QIM_PESQ_results_data=Single_QIM_PESQ_results.PESQ_results;
Avg_Single_QIM_PESQ=mean(Single_QIM_PESQ_results_data);
Std_Single_QIM_PESQ=std(Single_QIM_PESQ_results_data);

Single_FE_PESQ_results=load('Single_FE_PESQ');
Single_FE_PESQ_results_data=Single_FE_PESQ_results.PESQ_results;
Avg_Single_FE_PESQ=mean(Single_FE_PESQ_results_data);
Std_Single_FE_PESQ=std(Single_FE_PESQ_results_data);

subplot(323)

plot(Re_Bit_List,Avg_Hybrid_PESQ,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Single_QIM_PESQ,'o--k','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_FE_PESQ,'o--b','LineWidth',1);hold on

errorbar(Re_Bit_List,Avg_Hybrid_PESQ,Std_Hybrid_PESQ, 'or') 
errorbar(Re_Bit_List,Avg_Single_QIM_PESQ,Std_Single_QIM_PESQ, 'ok') 
errorbar(Re_Bit_List,Avg_Single_FE_PESQ,Std_Single_FE_PESQ, 'ob')   


plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[3 3],'k--');
set(gca,'Fontname','Arial','Fontsize',7)  
axis([-0.5 8.5 0 4.5]);
text (0,0.6,'(b) ','fontsize',7)
grid on
ylabel('PESQ (ODG)','fontsize',7)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);



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

subplot(325)
plot(Re_Bit_List,Avg_Hybrid_BDR,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Single_QIM_BDR,'o--k','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_FE_BDR,'o--b','LineWidth',1);hold on

errorbar(Re_Bit_List,Avg_Hybrid_BDR,Std_Hybrid_BDR, 'or') 
errorbar(Re_Bit_List,Avg_Single_QIM_BDR,Std_Single_QIM_BDR, 'ok') 
errorbar(Re_Bit_List,Avg_Single_FE_BDR,Std_Single_FE_BDR, 'ob')   
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',7)  
axis([-0.5 8.5 40 105]);
text (0,50,'(c) ','fontsize',7)
grid on
ylabel('BDR (%)','fontsize',7)
xlabel('Bit rate (bps)','fontsize',7)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Hybrid (QIM-FE)', 'QIM', 'FE','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',7,'Position',[p1(1),p1(2),p1(3)-0.1,p1(4)])






Plot_Folder='E:/ALL_Research_WANG/IEEE_trans_Hybrid_final_revised/Hybrid_Watermarking_QIM_FE/';
LSD_Hybrid_QIM_FE='E:/ALL_Research_WANG/IEEE_trans_Hybrid_final_revised/Hybrid_Watermarking_QIM_FE/ALL_Results/LSD_Results/';
BDR_Hybrid_QIM_FE='E:/ALL_Research_WANG/IEEE_trans_Hybrid_final_revised/Hybrid_Watermarking_QIM_FE/ALL_Results/NoAttack_BDR/';
PESQ_Hybrid_QIM_FE='E:/ALL_Research_WANG/IEEE_trans_Hybrid_final_revised/Hybrid_Watermarking_QIM_FE/ALL_Results/PESQ_Results/';
Synch_Hybrid='E:/ALL_Research_WANG/IEEE_trans_Hybrid_final_revised/Hybrid_Watermarking_QIM_FE/Hybrid_WM_QIM_FE_8.1_sec_speech_Synchronized/';
Bit_List = [1;2;4;8;16;32;64;128;256];
Re_Bit_List = log2(Bit_List);
speech_track=12;
%%%%%%%%%%%Hybrid LSD
cd(LSD_Hybrid_QIM_FE);
Hybrid_LSD_results=load('Hybrid_QIM_FE_LSD');
Hybrid_LSD_results_data=Hybrid_LSD_results.LSD_results;
Avg_Hybrid_LSD=mean(Hybrid_LSD_results_data);
Std_Hybrid_LSD=std(Hybrid_LSD_results_data);

%%%%%%%%%%%Hybrid PESQ
cd(PESQ_Hybrid_QIM_FE);
Hybrid_PESQ_results=load('Hybrid_QIM_FE_PESQ');
Hybrid_PESQ_results_data=Hybrid_PESQ_results.PESQ_results;
Avg_Hybrid_PESQ=mean(Hybrid_PESQ_results_data);
Std_Hybrid_PESQ=std(Hybrid_PESQ_results_data);

%%%%%%%%%%%Hybrid BDR
cd(BDR_Hybrid_QIM_FE);
Hybrid_BDR_results=load('Hybrid_QIM_FE_BDR');
Hybrid_BDR_results_data=Hybrid_BDR_results.Bit_detection_rate_QIM_FE;
Avg_Hybrid_BDR=mean(Hybrid_BDR_results_data);
Std_Hybrid_BDR=std(Hybrid_BDR_results_data);


%%%%%%%%%%%Synchro-Hybrid LSD
cd(Synch_Hybrid);
Synch_Hybrid_LSD_results=load('Synch_Hybrid_QIM_FE_LSD');
Synch_Hybrid_LSD_results_data=Synch_Hybrid_LSD_results.LSD_results;
Avg_Synch_Hybrid_LSD=mean(Synch_Hybrid_LSD_results_data);
Std_Synch_Hybrid_LSD=std(Synch_Hybrid_LSD_results_data);

%%%%%%%%%%%Synchro-Hybrid PESQ

Synch_Hybrid_PESQ_results=load('Synch_Hybrid_QIM_FE_PESQ');
Synch_Hybrid_PESQ_results_data=Synch_Hybrid_PESQ_results.PESQ_results;
Avg_Synch_Hybrid_PESQ=mean(Synch_Hybrid_PESQ_results_data);
Std_Synch_Hybrid_PESQ=std(Synch_Hybrid_PESQ_results_data);

%%%%%%%%%%%Synchro-Hybrid BDR

Synch_Hybrid_BDR_results=load('Synch_Hybrid_QIM_FE_BDR');
Synch_Hybrid_BDR_results_data=Synch_Hybrid_BDR_results.Bit_detection_rate_QIM_FE;
Avg_Synch_Hybrid_BDR=mean(Synch_Hybrid_BDR_results_data);
Std_Synch_Hybrid_BDR=std(Synch_Hybrid_BDR_results_data);

subplot(322)

plot(Re_Bit_List,Avg_Hybrid_LSD,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_LSD,'o--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_LSD,Std_Hybrid_LSD, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_LSD,Std_Synch_Hybrid_LSD, 'ok') 
 

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[1 1],'k--');
set(gca,'Fontname','Arial','Fontsize',7)  
axis([-0.5 8.5 0 2.5]);
text (0,2.1,'(d) ','fontsize',7)
grid on
ylabel('LSD (dB)','fontsize',7)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);


%%%%%%%%%%%PESQ


subplot(324)

plot(Re_Bit_List,Avg_Hybrid_PESQ,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_PESQ,'o--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_PESQ,Std_Hybrid_PESQ, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_PESQ,Std_Synch_Hybrid_PESQ, 'ok')  

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[3 3],'k--');
set(gca,'Fontname','Arial','Fontsize',7)  
axis([-0.5 8.5 0 4.5]);
text (0,0.6,'(e) ','fontsize',7)
grid on
ylabel('PESQ (ODG)','fontsize',7)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);




subplot(326)

plot(Re_Bit_List,Avg_Hybrid_BDR,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_BDR,'o--k','LineWidth',0.5);hold on
errorbar(Re_Bit_List,Avg_Hybrid_BDR,Std_Hybrid_BDR, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_BDR,Std_Synch_Hybrid_BDR, 'ok')   
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',7)  
axis([-0.5 8.5 40 105]);
text (0,50,'(f) ','fontsize',7)
grid on
ylabel('BDR (%)','fontsize',7)
xlabel('Bit rate (bps)','fontsize',7)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Hybrid (QIM-FE)', 'Syn-Hybrid (QIM-FE)','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',7,'Position',[p1(1),p1(2),p1(3),p1(4)])


for nf=1:2:5
    subplot(3,2,nf)
            psf=get(gca,'Position');
              if nf==1
                 set(gca,'Position',[0.07,0.72,0.41,0.265]);
                 else if nf==3
                         set(gca,'Position',[0.07,0.397,0.41,0.265]);
                               else set(gca,'Position',[0.07,0.08,0.41,0.265]);
                      end

               end
                     
end  
    
for nf=2:2:6
    subplot(3,2,nf)
            psf=get(gca,'Position');
              if nf==2
                 set(gca,'Position',[0.57,0.72,0.41,0.265]);
                 else if nf==4
                         set(gca,'Position',[0.57,0.397,0.41,0.265]);
                               else set(gca,'Position',[0.57,0.08,0.41,0.265]);
                      end

               end
                     
    end  


cd(Plot_Folder)
% for nf=1:1:3
%    subplot(3,1,nf)
%    psf=get(gca,'Position');
%    if nf==1
%     set(gca,'Position',[0.11,0.7,0.85,0.285]);
%    else if nf==2
%     set(gca,'Position',[0.11,0.39,0.85,0.285]);
%        else 
%            set(gca,'Position',[0.11,0.083,0.85,0.285]);
%        end
%    end
% end

