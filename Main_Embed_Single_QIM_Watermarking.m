% Main entrance of Single Watermarking embedding with QIM(Ngo) to Residue  
%%% By WANG Shengbei
%%% 2015 7/24
%%% Shengbei Wang
%%% Update  16th, Nov. 2016 

clear all
clc

%%%%%%%%%%%%%%%%% I/O setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%

InFolder = 'E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\Original_8.1_sec_speech\';
OutFolder = 'E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\Single_WM_QIM_8.1_sec_speech\';
Function_Folder = 'E:\ALL_Program_WANG\Hybrid_Watermarking_QIM_FE\Proposed_QIM_FE\';

% WM_seq_name=[Function_Folder 'WM_sequency.txt'];
% fid = fopen(WM_seq_name,'r');
% WM_sequency=fscanf(fid,'%f');
% fclose(fid);

Bit_List = [4;8;16;32;64;128;256;512;1024];
Bit_list_length=length(Bit_List);
WM_sequence='peogFcia';%(random sequence)
WM_sequence_Dec = double(WM_sequence); % convert charcter to binary
WM_sequence_Bin = dec2bin(WM_sequence_Dec); % convert int()|10 to int()|2
WM_sequence_size=size(WM_sequence_Bin);
WM_sequence_data= reshape(WM_sequence_Bin',WM_sequence_size(1)*WM_sequence_size(2),1); % size(data) = 1 numel(data_0)
WM_sequence_data=str2num(WM_sequence_data);


for k = 1:12 % for speech 
      cur_speech=[InFolder 'orgsound_8.1sec_00' num2str(k) '.wav'];
      [xt Fs nbits] = wavread(cur_speech);	
      xt=xt+0.001; 
      
      
   for kk=1:Bit_list_length
         Bps=Bit_List(kk);
         
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
         [out_speech WMs_embed] = Embed_Function_Single_QIM(xt, WM_sequence_data,p);
         Real_Bps=Bps/p.Dup;
         cd(OutFolder)
         Output_name=['WM_QIM_Bps' num2str(Real_Bps) '_00' num2str(k) '.wav'];
         wavwrite(out_speech,Fs,nbits,Output_name)

         cd(Function_Folder);
    end 
end 