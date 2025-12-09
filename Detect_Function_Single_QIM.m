%%% Function of Detect watermarks with QIM to residue
%%% By WANG Shengbei
%%% 2015 7/24

function  [Real_WM_Res ]=Detect_Function_Single_QIM(WM_speech, p)

Detected_WMs_Res=[];

Yt_Length = length(WM_speech);
FrameLeng=p.FrameLeng;
Frame_Num=floor(Yt_Length/FrameLeng);


for k=1:Frame_Num
    WM_speech_frame=WM_speech((k-1)*FrameLeng+1:k*FrameLeng);
    [WM_LP_coef,g]=lpc(WM_speech_frame,p.LPorder);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%% Detection watermarks from Residue (QIM)%%%%%%%%%%%%%%%%%%%%%%%
    WM_Residue=filter([1 WM_LP_coef(2:end)],1,WM_speech_frame);
    Residue_WM_fft = fft(WM_Residue);
 
    WM_Residue_Mag = (2/FrameLeng)*abs(Residue_WM_fft);
    WM_Residue_Phs = angle(Residue_WM_fft);
    Embedded_bins = (2:p.Freqbin+1)';%pos_bins = (2:p.Freqbin+1)'; % positive frequency bins for embedding
    [WM_Res]= QIMDecode(WM_Residue_Mag(Embedded_bins),WM_Residue_Phs(Embedded_bins),p.QIMsteps);
    Detected_WMs_Res=[Detected_WMs_Res;WM_Res]; 

end



WMs_Res_length=floor(length(Detected_WMs_Res)/p.Dup);
Detected_WMs_Res=Detected_WMs_Res(1:WMs_Res_length*p.Dup);
Reshp_WMs_Res=reshape(Detected_WMs_Res',p.Dup,WMs_Res_length);

% Watermarks from Res
Mean_WMs_Res=mean(Reshp_WMs_Res);
for kkk=1:length(Reshp_WMs_Res)
    if Mean_WMs_Res(kkk)>=0.5
       Real_WM_Res(kkk)=1;
    else
       Real_WM_Res(kkk)=0;
    end
end

