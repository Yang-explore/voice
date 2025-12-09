%%% Function of Detect watermarks with FE to Formants
%%% By WANG Shengbei
%%% 2015 7/24

function  [Real_WM_LSFs]=Detect_Function_Single_FE(WM_speech, p)

Detected_WMs_LSFs=[];


Yt_Length = length(WM_speech);
FrameLeng=p.FrameLeng;
Frame_Num=floor(Yt_Length/FrameLeng);


for k=1:Frame_Num
    WM_speech_frame=WM_speech((k-1)*FrameLeng+1:k*FrameLeng);
    [WM_LP_coef,g]=lpc(WM_speech_frame,p.LPorder);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%Detecting watermarks from formants (FE)%%%%%%%%%%%%%%%%%%%%%%%%%

    WM_LSPs=poly2lsf_my(WM_LP_coef); %lpc to lsp in Pi
    WM_LSPs_m=WM_LSPs(3:8);

    WM_ds=zeros(5,1);
       for j=1:5 
           WM_ds(j)=abs(WM_LSPs_m(j+1)-WM_LSPs_m(j));
       end
    WM_Ds=WM_ds; 
  
%%%%%%%%find st_num minimum distances  %%%%%%%%%
    posit=zeros(p.Num,1);
       for jj=1:p.Num
           t=find((WM_ds-min(WM_ds))==0);
           posit(jj)=t(1);% in case of there are same distance, then t is not a single value
           WM_ds(t(1))=3.14;
       end  
  
%%%%%%%%% calculation of watermarks %%%%%%%%%%%%%%%%%%%%%%%
    pp_1=posit(1);
    pp_2=posit(2);
  
    D=abs(WM_Ds(pp_1)-WM_Ds(pp_2));
   if D<WM_Ds(pp_1)*(p.FEstep/2-1)/(p.FEstep/2)
      Detected_WMs_LSFs=[Detected_WMs_LSFs;1]; 
   else 
      Detected_WMs_LSFs=[Detected_WMs_LSFs;0];
   end   


end

% get the correct watermark length
WMs_LSFs_length=floor(length(Detected_WMs_LSFs)/p.Dup);
Detected_WMs_LSFs=Detected_WMs_LSFs(1:WMs_LSFs_length*p.Dup);
Reshp_WMs_LSFs=reshape(Detected_WMs_LSFs',p.Dup,WMs_LSFs_length);

% Watermarks from LSFs
Mean_WMs_LSFs=mean(Reshp_WMs_LSFs);
for kkk=1:length(Reshp_WMs_LSFs)
    if Mean_WMs_LSFs(kkk)>=0.5
       Real_WM_LSFs(kkk)=1;
    else
       Real_WM_LSFs(kkk)=0;
    end
end

