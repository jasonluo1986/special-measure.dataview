function data = imfCombFun(data, pulses)    data =  permute(mean(data(1:2:end, :, :), 1), [3 2 1]);
