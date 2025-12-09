%%% Main entrance of Single Watermarking embedding with FE(Wang)
%%% By WANG Shengbei
%%% 2015 7/24
%%% Shengbei Wang
%%% Update  16th, Nov. 2016 

clear all
clc

%%%%%%%%%%%%%%%%% I/O setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Function_Folder = 'E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\';
Result_Folder= 'E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\ALL_Results\NoAttack_BDR\';
WM_InFolder  = 'E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\Single_WM_FE_8.1_sec_speech\';

% Set the parameters
Bit_List = [4;8;16;32;64;128;256;512;1024];
Bit_list_length=length(Bit_List);
WM_sequence='peogFcia';%(random sequence)

Bit_detection_rate_FE=zeros(12,Bit_list_length);

for k = 1:12 
     for kk=1:Bit_list_length
           Bps=Bit_List(kk);
           Real_Bps=Bps/4;
           WM_speech=[WM_InFolder 'WM_FE_Bps' num2str(Real_Bps) '_00' num2str(k) '.wav'];
           [yt Fs nbits] = wavread(WM_speech);	
           % Set the embedding parameters
           p.FEstep=4;%  when embed 0, we make the shortest distance much shorter, step is used control this. 
           p.LPorder=10;
           p.FrameLeng=floor(Fs/Bps);
           p.Fs=Fs;
           p.Bps=Bps;
           p.Num=2;
           p.Dup=4;
           p.Freqbin = p.FrameLeng/2;
           p.QIMsteps = [pi/2 pi/4 pi/6 pi/8 pi/10]';

           [Real_WM_LSFs]=Detect_Function_Single_FE(yt, p);
         
           Embed_WM_Dec = double(WM_sequence);
           Embed_WM_Bin = dec2bin(Embed_WM_Dec); 
           [Embed_WM_row,Embed_WM_col]=size(Embed_WM_Bin);
           Embed_WM_unit=reshape(Embed_WM_Bin',Embed_WM_row*Embed_WM_col,1);
           Embed_WM_Leng = length(Embed_WM_unit);
             
           Detect_WM_Leng = length(Real_WM_LSFs);
           RNum =  ceil(Detect_WM_Leng/Embed_WM_Leng);
           Embed_data= Embed_WM_unit;
            for kkk = 1:RNum
                Embed_data= [Embed_data; Embed_WM_unit]; 
            end

           WMs_Embedded=Embed_data(1:Detect_WM_Leng);
           WMs_Embedded=str2num(WMs_Embedded); 
           Detect_error=xor(Real_WM_LSFs',WMs_Embedded);
           Error_sum=sum(Detect_error);

           clear correct_rate;
           Correct_rate_FE=100 * (Detect_WM_Leng- Error_sum) / Detect_WM_Leng; 
           Bit_detection_rate_FE(k,kk) = Correct_rate_FE;    
           
      end; 
 end;    


cd(Result_Folder);
save Single_FE_BDR Bit_detection_rate_FE
result_text=['Single_FE_BDR.txt'];
fid = fopen(result_text,'w+');
fprintf(fid, '     bps |  1     2      4     8      16      32      64      128      256 \n')
for m= 1:12 
text_head =['speech_00' num2str(m) '   '];
fprintf(fid, text_head);
       
for mm=1:length(Bit_List)
    fprintf(fid,'%3.2f   ', Bit_detection_rate_FE(m,mm));
end; 
   fprintf(fid, '\n');
end; %m
fclose(fid);
     

cd(Function_Folder);

