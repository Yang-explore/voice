% Function of Embed watermarks with FE to formant
%%% By WANG Shengbei
%%% 2015 7/24

function [out_speech WMs_embed] = Embed_Function_Single_FE(xt, WMs, p)
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
%%%%%%%%%%%%Embedding watermarks into formants (FE)%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%% lpc to lsf %%%%%%%%%%%%%%
    LSPs=poly2lsf_my(LP_coef); %lpc to lsp in Pi
    LSFs=LSPs*180/pi;%  LSF in angle
  
  %%%%%%the first formant and last formants are not involved in modification
    Modified_LSPs=LSPs;
    LSPs_m=LSPs(3:8);
  %%%%%%calculate distance between two LSFs
    ds=zeros(5,1);
    for j=1:5 
        ds(j)=abs(LSPs_m(j+1)-LSPs_m(j));
    end
  %%%%%% save the distance for modifying LSP
    Ds=ds;
  %%%%%%find p.Num minimum distances  
    posit=zeros(p.Num,1);
    for jj=1:p.Num
        t=find((ds-min(ds))==0);
        posit(jj)=t(1);% in case of there are same distance, then t is not a signal value
        ds(t(1))=3.14;
    end
  %%%%%%%make two shortest diatances equal each other, the longer one equals to the shorter one
     if WMs_embed(k)==1 
        pp_1=posit(1);
        Min_dis=Ds(pp_1);
        pp_2=posit(p.Num); %posit(st_num=2) is the second shorter distance
        Sec_Min_dis=Ds(pp_2);
      
        if abs(pp_1-pp_2)==1% two minmum distances are next to each other
           if pp_2==1 % if 1 and 2 are two shortest and 1 is the second shortest
              LSPs_m(pp_1)=(LSPs_m(pp_1-1)+LSPs_m(pp_1+1))/2; % control the middle LSP    
           else
            LSPs_m(pp_2)=(LSPs_m(pp_2-1)+LSPs_m(pp_2+1))/2; % control the middle LSP
           end
        else
        Det_dis=Sec_Min_dis-Min_dis;
        LSPs_m(pp_2)=LSPs_m(pp_2)+Det_dis/2;
        LSPs_m(pp_2+1)=LSPs_m(pp_2+1)-Det_dis/2;
        end
  
        else if WMs_embed(k)==0 % make the shorter one become much shorter
                pp_1=posit(1);
                Min_dis=Ds(pp_1);
      
                LSPs_m(pp_1)=LSPs_m(pp_1)+Min_dis/p.FEstep;% distance smaller
                LSPs_m(pp_1+1)=LSPs_m(pp_1+1)-Min_dis/p.FEstep;
      
            end
     end
  
    Modified_LSPs(3:8)=LSPs_m;
    LP_modify_back=lsf2poly(Modified_LSPs);  
    
    Residue=filter([1 LP_coef(2:end)],1,cur_speech);
    


    cur_speech_recons=filter(1,[1,LP_modify_back(2:end)],Residue);
    out_speech=[out_speech;cur_speech_recons];
end

if length(out_speech) < length(xt)
   out_speech=[out_speech;xt(length(WMs_embed)*FrameLeng+1:end)];
end