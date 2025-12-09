% Function of Embed watermarks with  QIM to residue
%%% By WANG Shengbei
%%% 2015 7/24

function [out_speech WMs_Real_embed] = Embed_Function_Single_QIM(xt, WMs, p)
Xt_Length = length(xt);
FrameLeng=p.FrameLeng;
Frame_Num=floor(Xt_Length/FrameLeng);

out_speech=[];


%creat watermarks
WMs_length=length(WMs);
nRepeat = floor(Frame_Num/p.Dup/WMs_length);% repeat times for the whole wateramrk 
nBits = floor(mod(Frame_Num/p.Dup,WMs_length));% additional bits except the whole repeated time
WMs_enlarge= WMs*ones(1,nRepeat+1);% reproduce : for nRepeat+1 times 
WMs_enlarge_col=reshape(WMs_enlarge,(nRepeat+1)*WMs_length,1);

%final watermarks
WMs_Real_embed=WMs_enlarge_col(1:nRepeat*WMs_length+nBits);
WMs_embed=WMs_Real_embed*ones(1,p.Dup);
WMs_embed=reshape(WMs_embed',length(WMs_embed)*p.Dup,1);
%length(WMs_embed) actually equals p.Dup*WMs_Real_embed

for k=1:length(WMs_embed)
    cur_speech=xt((k-1)*FrameLeng+1:k*FrameLeng);
    [LP_coef,g]=lpc(cur_speech,p.LPorder);  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%Embedding watermarks into Residue (QIM)%%%%%%%%%%%%%%%%%%%%%%%%% 

    pos_bins = (2:p.Freqbin+1)'; % positive frequency bins
    neg_bins = (FrameLeng:-1:FrameLeng-p.Freqbin+1)'; % negative frequency bins
    
    Residue=filter([1 LP_coef(2:end)],1,cur_speech);
    Residue_fft = fft(Residue);
    Residue_Mag = (2/FrameLeng)*abs(Residue_fft);
    Residue_Phs = angle(Residue_fft);
    WM_Residue_Phs = Residue_Phs;
    Dup_cur_WMs=WMs_embed(k)*ones(1,p.Freqbin)';
  
    
    [WM_Residue_Phs(pos_bins)] = QIMEncode(Residue_Mag(pos_bins),Residue_Phs(pos_bins),Dup_cur_WMs,p.QIMsteps);
    % Nagative frequencies
    WM_Residue_Phs(neg_bins) = -WM_Residue_Phs(pos_bins);

    Y = (FrameLeng/2)*Residue_Mag.*exp(1j*WM_Residue_Phs);
    WM_Residue = real(ifft(Y,FrameLeng));


    cur_speech_recons=filter(1,[1,LP_coef(2:end)],WM_Residue);
    out_speech=[out_speech;cur_speech_recons];
end

if length(out_speech) < length(xt)
   out_speech=[out_speech;xt(length(WMs_embed)*FrameLeng+1:end)];
end

  

  
  
  
