function [dat] = DPC_dec(yfile, p, steps)
% Nhut M. Ngo @AIS-JAIST
% Created on 04-Feb-2015
% Updated on 05-June-2015
% Updated on 17-Jun-2015
% DPC_dec version 1
% + Bit rate is adjusted by assigning number of frequency bins for each bit
% + Band for embedding: bins 2:800 with frame size = 22050 (0.5s)
% + Non-meaningful bins are excluded to avoid errors
% Note: first frequency bin is excluded because it is usually meaningless

nbin = 600; % Total number of embedding bins
thres = p.thres; % magnitude threshold. components have magnitude less than thres is skipped
[yt, fs] = audioread(yfile);
[l,c] = size(yt);
frlen = fs/2;
bpf = ceil(p.bps/2);
bpb = ceil(nbin/bpf); % number of bins for each bit
nbin = bpb*bpf; % rounded total number of embedding bins.

nfr = floor(size(yt,1)/frlen);
dat = zeros(nfr*bpf,1);
for ic = 1%:c % only need to detect from one channel
    for i = 1:nfr
        idx = (i-1)*frlen+1:i*frlen;
        Y = fft(yt(idx,ic));
        YPhs = angle(Y);
        YMag = (2/frlen)*abs(Y);
        embed_bins = (2:nbin+1)';
        [bits] = QIMDecode(YMag(embed_bins),YPhs(embed_bins),steps);
        bits = deinterleave(bits,bpb);
        bits = reshape(bits, bpb, bpf);
        detect_bins = getdetectbins(YMag,bpb,bpf,thres);
        n1 = zeros(1,bpf);
        n0 = zeros(1,bpf);
        for j = 1:bpf
            tmp = bits(:,j);
            n1(:,j) = sum(tmp(detect_bins(:,j)));
            n0(:,j) = sum(detect_bins(:,j)) - n1(:,j);
        end
        dat((i-1)*bpf+1:i*bpf) = n1 > n0;
    end
end
end