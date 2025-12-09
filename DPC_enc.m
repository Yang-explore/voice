function [yt,enc_dat] = DPC_enc(xfile, p, dat, steps)
% Nhut M. Ngo @AIS-JAIST
% Created on 04-Feb-2015
% DPC_enc version 01
% Version 02: Adding a dummy piece of signal to silence periods to combat
% the dull IHC database.
% Updated on 22-Mar-2015
% Updated on 17-Jun-2015
% + Bit rate is adjusted by assigning number of frequency bins for each bit
% + Band for embedding: bins 2:800 with frame size = 22050 (0.5s)
% Note: first frequency bin is excluded because it is usually meaningless

nbin = 600; % Total number of embedding bins
[xt, fs] = audioread(xfile);
[l,c] = size(xt);
frlen = fs/2; % 0.5 s
bpf = ceil(p.bps/2); % bit per frame
bpb = ceil(nbin/bpf); % number of bins for each bit
nbin = bpb*bpf; % rounded total number of embedding bins.
pos_bins = (2:nbin+1)'; % positive frequency bins
neg_bins = (frlen:-1:frlen-nbin+1)'; % negative frequency bins

nfr = floor(size(xt,1)/frlen);
yt = zeros(size(xt));
enc_dat = dat(1:nfr*bpf);
for ic = 1:c
    for i = 1:nfr
        idx = (i-1)*frlen+1:i*frlen;
        temp = xt(idx,ic);
        bits = enc_dat((i-1)*bpf+1:i*bpf);
        bits = bits*ones(1,bpb);
        bits = reshape(bits',bpf*bpb,1);
        bits = interleave(bits, bpb);
        if(abs(temp(1:500)) < 10^-5)
            DMag = zeros(frlen,1); DPhs = zeros(frlen,1);
            t = (log(1):log(0.5)/2000:1999*log(0.5)/2000)';
            scl = exp(5*t); scl = scl(1:600,:);
            DMag(pos_bins) = (2*10^-5)*scl.*ones(nbin,1);
            DMag(neg_bins) = DMag(pos_bins);
            DPhs(pos_bins) = 2*pi*rand(nbin,1) - pi;
            v = 5*10^-3;
            sMag = DMag(pos_bins)./v;
            group = ceil(sMag/0.2);
            group(group==0) = 1;
            group(group>5) = 5;
            delta = steps(group);
            DPhs(pos_bins) = delta.*round(DPhs(pos_bins)./delta-bits/2) + delta.*bits/2;
            DPhs(neg_bins) = -DPhs(pos_bins);
            Dummy = (frlen/2)*DMag.*exp(1j*DPhs);
            dummy = real(ifft(Dummy));
            yt(idx,ic) = dummy;
        else
            X = fft(temp);
            XMag = (2/frlen)*abs(X);
            XPhs = angle(X);
            YPhs = XPhs;
            [YPhs(pos_bins)] = QIMEncode(XMag(pos_bins),XPhs(pos_bins),bits,steps);
            % Nagative frequencies
            YPhs(neg_bins) = -YPhs(pos_bins);
            Y = (frlen/2)*XMag.*exp(1j*YPhs);
            yt(idx,ic) = real(ifft(Y,frlen));
        end
    end
    if nfr*frlen < size(xt,1)
        yt(nfr*frlen+1:end,ic) = xt(nfr*frlen+1:end,ic);
    end
end