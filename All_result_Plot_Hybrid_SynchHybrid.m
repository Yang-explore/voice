%Plot all the result together (Hybrid-Synchronized Hybrid)
clear all 
clc
%close all
% Sound quality%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_Folder='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\';
LSD_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\LSD_Results\';
BDR_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\NoAttack_BDR\';
PESQ_Hybrid_QIM_FE='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\PESQ_Results\';
%Synch_Hybrid='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\Hybrid_WM_QIM_FE_8.1_sec_speech_Synchronized\';
Bit_List = [1;2;4;8;16;32;64;128;256];
Re_Bit_List = log2(Bit_List);
speech_track=12;
%%%%%%%%%%%Hybrid LSD
cd(LSD_Hybrid_QIM_FE);
Hybrid_LSD_results=load('Hybrid_QIM_FE_LSD');
Hybrid_LSD_results_data=Hybrid_LSD_results.LSD_results;
Avg_Hybrid_LSD=mean(Hybrid_LSD_results_data);
Std_Hybrid_LSD=std(Hybrid_LSD_results_data);

Synch_Hybrid_LSD_results=load('Synch_Hybrid_QIM_FE_LSD');
Synch_Hybrid_LSD_results_data=Synch_Hybrid_LSD_results.LSD_results;
Avg_Synch_Hybrid_LSD=mean(Synch_Hybrid_LSD_results_data);
Std_Synch_Hybrid_LSD=std(Synch_Hybrid_LSD_results_data);
%%%%%%%%%%%Hybrid PESQ
cd(PESQ_Hybrid_QIM_FE);
Hybrid_PESQ_results=load('Hybrid_QIM_FE_PESQ');
Hybrid_PESQ_results_data=Hybrid_PESQ_results.PESQ_results;
Avg_Hybrid_PESQ=mean(Hybrid_PESQ_results_data);
Std_Hybrid_PESQ=std(Hybrid_PESQ_results_data);

%%%%%%%%%%%Synchro-Hybrid PESQ

Synch_Hybrid_PESQ_results=load('Synch_Hybrid_QIM_FE_PESQ');
Synch_Hybrid_PESQ_results_data=Synch_Hybrid_PESQ_results.PESQ_results;
Avg_Synch_Hybrid_PESQ=mean(Synch_Hybrid_PESQ_results_data);
Std_Synch_Hybrid_PESQ=std(Synch_Hybrid_PESQ_results_data);

%%%%%%%%%%%Hybrid BDR
cd(BDR_Hybrid_QIM_FE);
Hybrid_BDR_results=load('Hybrid_QIM_FE_BDR');
Hybrid_BDR_results_data=Hybrid_BDR_results.Bit_detection_rate_QIM_FE;
Avg_Hybrid_BDR=mean(Hybrid_BDR_results_data);
Std_Hybrid_BDR=std(Hybrid_BDR_results_data);


%%%%%%%%%%%Synchro-Hybrid BDR

Synch_Hybrid_BDR_results=load('Synch_Hybrid_QIM_FE_BDR');
Synch_Hybrid_BDR_results_data=Synch_Hybrid_BDR_results.Bit_detection_rate_QIM_FE;
Avg_Synch_Hybrid_BDR=mean(Synch_Hybrid_BDR_results_data);
Std_Synch_Hybrid_BDR=std(Synch_Hybrid_BDR_results_data);

figure(19),subplot(121)

plot(Re_Bit_List,Avg_Hybrid_LSD,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_LSD,'*--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_LSD,Std_Hybrid_LSD, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_LSD,Std_Synch_Hybrid_LSD, 'ok') 
 

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[1 1],'k--');
set(gca,'Fontname','Arial','Fontsize',15)  
axis([-0.5 8.5 0 2.5]);
text (0,2.1,'(a) LSD','fontsize',15)
grid on
ylabel('LSD (dB)','fontsize',15)
set(gca,'xtick',1:1:length(Bit_List),'xticklabel',[]);

%%%%%%%%%%%PESQ


subplot(122)

plot(Re_Bit_List,Avg_Hybrid_PESQ,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_PESQ,'*--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_PESQ,Std_Hybrid_PESQ, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_PESQ,Std_Synch_Hybrid_PESQ, 'ok')  

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[3 3],'k--');
set(gca,'Fontname','Arial','Fontsize',15)  
axis([-0.5 8.5 0 4.5]);
text (0,0.6,'(b) PESQ','fontsize',15)
grid on
ylabel('PESQ (ODG)','fontsize',15)
set(gca,'xtick',1:1:length(Bit_List),'xticklabel',[]);



subplot(632)

plot(Re_Bit_List,Avg_Hybrid_BDR,'o-r','LineWidth',2);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_BDR,'o--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_BDR,Std_Hybrid_BDR, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_BDR,Std_Synch_Hybrid_BDR, 'ok')   
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',15)  
axis([-0.5 8.5 40 105]);
text (0,50,'(c) BDR','fontsize',15)
grid on
ylabel('BDR (%)','fontsize',15)
xlabel('Bit rate (bps)','fontsize',15)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Hybrid (QIM-FE)', 'Syn-Hybrid (QIM-FE)','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',14,'Position',[p1(1),p1(2),p1(3)+0.14,p1(4)])


cd(Plot_Folder)
for nf=1:1:3
   subplot(3,1,nf)
   psf=get(gca,'Position');
   if nf==1
    set(gca,'Position',[0.11,0.7,0.85,0.285]);
   else if nf==2
    set(gca,'Position',[0.11,0.39,0.85,0.285]);
       else 
           set(gca,'Position',[0.11,0.083,0.85,0.285]);
       end
   end
end
