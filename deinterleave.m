function [deinterleaved_msg] = deinterleave(interleaved_msg, block_size)
%DEINTERLEAVE Summary of this function goes here
%   Detailed explanation goes here

msg_len = length(interleaved_msg);
num_block = floor(msg_len/block_size);
deinterleaved_msg = zeros(size(interleaved_msg));
for i = 1:num_block*block_size;
    i_block = mod((i - 1), num_block) + 1;
    i_th = floor((i - 1)/num_block) + 1;
    deinterleaved_msg((i_block-1)*block_size + i_th) = interleaved_msg(i);
end
if(num_block*block_size < msg_len)
    deinterleaved_msg(num_block*block_size+1 : end) = interleaved_msg(num_block*block_size+1 : end);
end

end

