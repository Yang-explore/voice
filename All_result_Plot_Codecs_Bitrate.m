%Plot all the result together
clear all 
clc
%close all
% Sound quality%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_Folder='/home/Wang/doctor materies/Hybrid_Watermarking_FE_CD/IIHMSP2014_Hybrid_WM_FE_Blind_CD/';
BDR_FE_Blind_CD ='/home/Wang/doctor materies/Hybrid_Watermarking_FE_CD/IIHMSP2014_Hybrid_WM_FE_Blind_CD/ALL_Results/Bit_detection_rate_result/';
G711_BDR_FE_Blind_CD ='/home/Wang/doctor materies/Hybrid_Watermarking_FE_CD/IIHMSP2014_Hybrid_WM_FE_Blind_CD/ALL_Results/G711_Bit_detection_rate_result/';
G726_BDR_FE_Blind_CD ='/home/Wang/doctor materies/Hybrid_Watermarking_FE_CD/IIHMSP2014_Hybrid_WM_FE_Blind_CD/ALL_Results/G726_Bit_detection_rate_result/';
G729_BDR_FE_Blind_CD ='/home/Wang/doctor materies/Hybrid_Watermarking_FE_CD/IIHMSP2014_Hybrid_WM_FE_Blind_CD/ALL_Results/G729_Bit_detection_rate_result/';

Bit_List = [1;2;4;8;16;32;64;128;256];
Re_Bit_List = log2(Bit_List);
speech_track=12;

%%%%%%%%%%%LSD
cd(BDR_FE_Blind_CD);
FE_BDR_results=load('Hybrid_FE_bit_detection_rate_sp_1_4');
FE_BDR_results_data=FE_BDR_results.bit_detection_rate_FE;
Avg_FE_BDR=mean(FE_BDR_results_data);
Std_FE_BDR=std(FE_BDR_results_data);


CD_BDR_results=load('Hybrid_CD_bit_detection_rate_sp_1_4');
CD_BDR_results_data=CD_BDR_results.bit_detection_rate_CD;
Avg_CD_BDR=mean(CD_BDR_results_data);
Std_CD_BDR=std(CD_BDR_results_data);

FE_CD_BDR_results=load('Hybrid_FE_CD_bit_detection_rate_sp_1_4');
FE_CD_BDR_results_data=FE_CD_BDR_results.bit_detection_rate_CD_FE;
Avg_FE_CD_BDR=mean(FE_CD_BDR_results_data);
Std_FE_CD_BDR=std(FE_CD_BDR_results_data);


cd(G711_BDR_FE_Blind_CD);
G711_FE_BDR_results=load('Hybrid_FE_bit_detection_rate_sp_1_4');
G711_FE_BDR_results_data=G711_FE_BDR_results.bit_detection_rate_FE;
G711_Avg_FE_BDR=mean(G711_FE_BDR_results_data);
G711_Std_FE_BDR=std(G711_FE_BDR_results_data);


G711_CD_BDR_results=load('Hybrid_CD_bit_detection_rate_sp_1_4');
G711_CD_BDR_results_data=G711_CD_BDR_results.bit_detection_rate_CD;
G711_Avg_CD_BDR=mean(G711_CD_BDR_results_data);
G711_Std_CD_BDR=std(G711_CD_BDR_results_data);

G711_FE_CD_BDR_results=load('Hybrid_FE_CD_bit_detection_rate_sp_1_4');
G711_FE_CD_BDR_results_data=G711_FE_CD_BDR_results.bit_detection_rate_CD_FE;
G711_Avg_FE_CD_BDR=mean(G711_FE_CD_BDR_results_data);
G711_Std_FE_CD_BDR=std(G711_FE_CD_BDR_results_data);



cd(G726_BDR_FE_Blind_CD);
G726_FE_BDR_results=load('Hybrid_FE_bit_detection_rate_sp_1_4');
G726_FE_BDR_results_data=G726_FE_BDR_results.bit_detection_rate_FE;
G726_Avg_FE_BDR=mean(G726_FE_BDR_results_data);
G726_Std_FE_BDR=std(G726_FE_BDR_results_data);


G726_CD_BDR_results=load('Hybrid_CD_bit_detection_rate_sp_1_4');
G726_CD_BDR_results_data=G726_CD_BDR_results.bit_detection_rate_CD;
G726_Avg_CD_BDR=mean(G726_CD_BDR_results_data);
G726_Std_CD_BDR=std(G726_CD_BDR_results_data);

G726_FE_CD_BDR_results=load('Hybrid_FE_CD_bit_detection_rate_sp_1_4');
G726_FE_CD_BDR_results_data=G726_FE_CD_BDR_results.bit_detection_rate_CD_FE;
G726_Avg_FE_CD_BDR=mean(G726_FE_CD_BDR_results_data);
G726_Std_FE_CD_BDR=std(G726_FE_CD_BDR_results_data);

cd(G729_BDR_FE_Blind_CD);
G729_FE_BDR_results=load('Hybrid_FE_bit_detection_rate_sp_1_4');
G729_FE_BDR_results_data=G729_FE_BDR_results.bit_detection_rate_FE;
G729_Avg_FE_BDR=mean(G729_FE_BDR_results_data);
G729_Std_FE_BDR=std(G729_FE_BDR_results_data);


G729_CD_BDR_results=load('Hybrid_CD_bit_detection_rate_sp_1_4');
G729_CD_BDR_results_data=G729_CD_BDR_results.bit_detection_rate_CD;
G729_Avg_CD_BDR=mean(G729_CD_BDR_results_data);
G729_Std_CD_BDR=std(G729_CD_BDR_results_data);

G729_FE_CD_BDR_results=load('Hybrid_FE_CD_bit_detection_rate_sp_1_4');
G729_FE_CD_BDR_results_data=G729_FE_CD_BDR_results.bit_detection_rate_CD_FE;
G729_Avg_FE_CD_BDR=mean(G729_FE_CD_BDR_results_data);
G729_Std_FE_CD_BDR=std(G729_FE_CD_BDR_results_data);



figure(11),subplot(311)
plot(Re_Bit_List,G711_Avg_FE_BDR,'o--b','LineWidth',2);hold on
plot(Re_Bit_List,G711_Avg_CD_BDR,'o--k','LineWidth',2);hold on
plot(Re_Bit_List,G711_Avg_FE_CD_BDR,'o-r','LineWidth',2);hold on

errorbar(Re_Bit_List,G711_Avg_FE_BDR,G711_Std_FE_BDR, 'ob') 
errorbar(Re_Bit_List,G711_Avg_CD_BDR,G711_Std_CD_BDR, 'ok') 
errorbar(Re_Bit_List,G711_Avg_FE_CD_BDR,G711_Std_FE_CD_BDR, 'or') 
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',15)  
axis([-0.5 8.5 40 105]);
text (0,50,'(a) BDR after G.711','fontsize',15)
grid on
ylabel('BDR (%)','fontsize',15)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',[]);



subplot(312)
plot(Re_Bit_List,G726_Avg_FE_BDR,'o--b','LineWidth',2);hold on
plot(Re_Bit_List,G726_Avg_CD_BDR,'o--k','LineWidth',2);hold on
plot(Re_Bit_List,G726_Avg_FE_CD_BDR,'o-r','LineWidth',2);hold on

errorbar(Re_Bit_List,G726_Avg_FE_BDR,G726_Std_FE_BDR, 'ob') 
errorbar(Re_Bit_List,G726_Avg_CD_BDR,G726_Std_CD_BDR, 'ok') 
errorbar(Re_Bit_List,G726_Avg_FE_CD_BDR,G726_Std_FE_CD_BDR, 'or') 
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',15)  
axis([-0.5 8.5 40 105]);
text (0,50,'(b) BDR after G.726','fontsize',15)
grid on
ylabel('BDR (%)','fontsize',15)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',[]);



subplot(313)
plot(Re_Bit_List,G729_Avg_FE_BDR,'o--b','LineWidth',2);hold on
plot(Re_Bit_List,G729_Avg_CD_BDR,'o--k','LineWidth',2);hold on
plot(Re_Bit_List,G729_Avg_FE_CD_BDR,'o-r','LineWidth',2);hold on

errorbar(Re_Bit_List,G729_Avg_FE_BDR,G729_Std_FE_BDR, 'ob') 
errorbar(Re_Bit_List,G729_Avg_CD_BDR,G729_Std_CD_BDR, 'ok') 
errorbar(Re_Bit_List,G729_Avg_FE_CD_BDR,G729_Std_FE_CD_BDR, 'or') 
            
plot([log2(Bit_List(1))-1 log2(Bit_List(end))+1],[90 90],'k--');
set(gca,'Fontname','Arial','Fontsize',15)  
axis([-0.5 8.5 40 105]);
text (0,60,'(c) BDR after G.729','fontsize',15)
grid on
ylabel('BDR (%)','fontsize',15)
set(gca,'xtick',0:1:length(Bit_List),'xticklabel',Bit_List);
h1=legend( 'FE', 'CD','Hybrid (FE-CD)','location','SouthEast');
p1=get(h1, 'Position');
set(h1,'Fontsize',14,'Position',[p1(1),p1(2),p1(3)+0.11,p1(4)])

cd(Plot_Folder)
for nf=1:1:3
   subplot(3,1,nf)
   psf=get(gca,'Position');
   if nf==1
    set(gca,'Position',[0.11,0.685,0.85,0.285]);
   else if nf==2
    set(gca,'Position',[0.11,0.37,0.85,0.285]);
       else 
           set(gca,'Position',[0.11,0.055,0.85,0.285]);
       end
   end
end



