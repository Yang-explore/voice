function [WM_Res] = QIMDecode(YMag, YPhs, steps)
% Created on Feb 04 2015
% Updated on 2015/07/24 by WANG Shengbei
% QIMDecode version 02
% + Log scale magnitude. Magnitude = 1 turns to 140dB, magnitude = 10^-7
% turns to 0dB. Magnitude is categorized into 7 groups,
% i.e., 0:20:140dB ~ 1:7
% + Non-linear step size.
% Groups 1:3: 4pi/10
% Group 4: 3pi/10
% Group 5: 2pi/10
% Groups 6,7: pi/10
% XPhs: value/matrix
% bits: detected bits
% delta: QIM step size
% steps: a list of 5 step size

v = 10^-6;
sMag = YMag./v;
group = ceil(sMag/0.2);
group(group==0) = 1;
group(group>5) = 5;
delta = steps(group);
d2 = delta/2;
YPhs = round(YPhs./d2).*d2;
r = (YPhs./delta) - floor(YPhs./delta);
%--------------------------------------
% r < 0.25 or r > 0.75 then bit 0
% r >= 0.25 and r <= 0.75 then bit 1
%--------------------------------------
r(r>0.75) = r(r>0.75) - 0.75; % to reduce one 'or' condition for bit 0
bits = zeros(size(YPhs));
bits = r>=0.25;

if mean(bits)>0.5
    WM_Res=1;
else
    WM_Res=0;
end




