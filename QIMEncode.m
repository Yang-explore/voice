function [YPhs, delta] = QIMEncode(XMag, XPhs, bits, steps)
% Created on Feb 04 2015
% Updated on Feb 05 2015
% Updated on 2015/07/24 by WANG Shengbei
% QIMEncode version 05
% + Linear scale magnitude
% + Linear step size.
% XPhs: value/matrix
% bits: bits to be embedded into each bin
% steps: a list of step sizes 
% delta: QIM step size

v = 10^-6;
sMag = XMag./v;
group = ceil(sMag/0.2);
group(group==0) = 1;
group(group>5) = 5;
%plot(group)
delta = steps(group);
YPhs = delta.*round(XPhs./delta - bits/2) + delta.*bits/2;
