%%% Plot the result together Hybrid (LSD PESQ )  Synch (LSD PESQ )
%%% Created by WANG Shengbei

clc
clear all 
%close all

% Sound quality%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_Folder='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\';
LSD_Results='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\LSD_Results\';
PESQ_Results='E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\PESQ_Results\';

Bit_List = [1;2;4;8;16;32;64;128;256];
Re_Bit_List = log2(Bit_List);
speech_track=12;

%%%%%%%%%%%LSD
cd(LSD_Results);
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

figure(18),subplot(221)

plot(Re_Bit_List,Avg_Hybrid_LSD,'s-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_QIM_LSD,'o--k','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_FE_LSD,'*--b','LineWidth',1);hold on

errorbar(Re_Bit_List,Avg_Hybrid_LSD,Std_Hybrid_LSD, 'or') 
errorbar(Re_Bit_List,Avg_Single_QIM_LSD,Std_Single_QIM_LSD, 'ok') 
errorbar(Re_Bit_List,Avg_Single_FE_LSD,Std_Single_FE_LSD, 'ob')   

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[1 1],'k--');
set(gca,'Fontname','Arial','Fontsize',9)  
axis([-0.5 8.5 0 2.5]);
text (0,2.1,'(a) ','fontsize',9)
grid on
ylabel('LSD (dB)','fontsize',9)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);

%%%%%%%%%%%PESQ
cd(PESQ_Results);
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

subplot(223)

plot(Re_Bit_List,Avg_Hybrid_PESQ,'s-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_QIM_PESQ,'o--k','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Single_FE_PESQ,'*--b','LineWidth',1);hold on

errorbar(Re_Bit_List,Avg_Hybrid_PESQ,Std_Hybrid_PESQ, 'or') 
errorbar(Re_Bit_List,Avg_Single_QIM_PESQ,Std_Single_QIM_PESQ, 'ok') 
errorbar(Re_Bit_List,Avg_Single_FE_PESQ,Std_Single_FE_PESQ, 'ob')   


plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[3 3],'k--');
set(gca,'Fontname','Arial','Fontsize',9)  
axis([-0.5 8.5 0 4.5]);
text (0,3.6,'(b) ','fontsize',9)
grid on
ylabel('PESQ (ODG)','fontsize',9)
xlabel('Bit rate (bps)','fontsize',9)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Prop. (QIM-FE)', 'QIM', 'FE','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',9,'Position',[p1(1),p1(2),p1(3)-0.1,p1(4)])


%%%%%%%%%%%Hybrid LSD
cd(LSD_Results);
Hybrid_LSD_results=load('Hybrid_QIM_FE_LSD');
Hybrid_LSD_results_data=Hybrid_LSD_results.LSD_results;
Avg_Hybrid_LSD=mean(Hybrid_LSD_results_data);
Std_Hybrid_LSD=std(Hybrid_LSD_results_data);

%%%%%%%%%%%Hybrid PESQ
cd(PESQ_Results);
Hybrid_PESQ_results=load('Hybrid_QIM_FE_PESQ');
Hybrid_PESQ_results_data=Hybrid_PESQ_results.PESQ_results;
Avg_Hybrid_PESQ=mean(Hybrid_PESQ_results_data);
Std_Hybrid_PESQ=std(Hybrid_PESQ_results_data);

%%%%%%%%%%%Synchro-Hybrid LSD
cd(LSD_Results);
Synch_Hybrid_LSD_results=load('Synch_Hybrid_QIM_FE_LSD');
Synch_Hybrid_LSD_results_data=Synch_Hybrid_LSD_results.LSD_results;
Avg_Synch_Hybrid_LSD=mean(Synch_Hybrid_LSD_results_data);
Std_Synch_Hybrid_LSD=std(Synch_Hybrid_LSD_results_data);

%%%%%%%%%%%Synchro-Hybrid PESQ
cd(PESQ_Results);
Synch_Hybrid_PESQ_results=load('Synch_Hybrid_QIM_FE_PESQ');
Synch_Hybrid_PESQ_results_data=Synch_Hybrid_PESQ_results.PESQ_results;
Avg_Synch_Hybrid_PESQ=mean(Synch_Hybrid_PESQ_results_data);
Std_Synch_Hybrid_PESQ=std(Synch_Hybrid_PESQ_results_data);

subplot(222)

plot(Re_Bit_List,Avg_Hybrid_LSD,'s-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_LSD,'>--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_LSD,Std_Hybrid_LSD, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_LSD,Std_Synch_Hybrid_LSD, 'ok') 
 

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[1 1],'k--');
set(gca,'Fontname','Arial','Fontsize',9)  
axis([-0.5 8.5 0 2.5]);
text (0,2.1,'(c) ','fontsize',9)
grid on
ylabel('LSD (dB)','fontsize',9)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);


%%%%%%%%%%%PESQ


subplot(224)

plot(Re_Bit_List,Avg_Hybrid_PESQ,'s-r','LineWidth',1);hold on
plot(Re_Bit_List,Avg_Synch_Hybrid_PESQ,'>--k','LineWidth',1);hold on
errorbar(Re_Bit_List,Avg_Hybrid_PESQ,Std_Hybrid_PESQ, 'or') 
errorbar(Re_Bit_List,Avg_Synch_Hybrid_PESQ,Std_Synch_Hybrid_PESQ, 'ok')  

plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[3 3],'k--');
set(gca,'Fontname','Arial','Fontsize',9)  
axis([-0.5 8.5 0 4.5]);
text (0,3.6,'(d) ','fontsize',9)
grid on
ylabel('PESQ (ODG)','fontsize',9)
xlabel('Bit rate (bps)','fontsize',9)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend('Prop. (QIM-FE)', 'Syn-Prop. (QIM-FE)','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',9,'Position',[p1(1),p1(2),p1(3),p1(4)])


for nf=1:2:3
   subplot(2,2,nf)
   psf=get(gca,'Position');
   if nf==1
    set(gca,'Position',[0.07,0.58,0.41,0.4]);
   else 
    set(gca,'Position',[0.07,0.11,0.41,0.4]);
   end
 end

for nf=2:2:4
   subplot(2,2,nf)
   psf=get(gca,'Position');
   if nf==2
    set(gca,'Position',[0.58,0.58,0.41,0.4]);
   else 
    set(gca,'Position',[0.58,0.11,0.41,0.4]);
       
   end
end
 

cd(Plot_Folder)






