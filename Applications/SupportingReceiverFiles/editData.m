function data = editData(data)
clc;
Highpass_Filter;
data = HighpassFilter(data);
data = abs(data);
for k=1:size(data)
    sample = data(k);
    if sample > .02
        data(k) = 1;
    else
        data(k) = 0;
    end
end
end