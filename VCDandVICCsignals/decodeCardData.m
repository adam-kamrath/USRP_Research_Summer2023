function decodeCardData(data)
    %Starting parameters
    binary_sequence = '';
    %5753340
    current_sample = 1000;
    SOFfound = false;
    EOFfound = false;
    findSOF(data, current_sample);
end

function findSOF(data, current_sample) 
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    SOFfound = false;
    current_sample = findNextOne(data, current_sample);
    [pulses, current_sample] = getPulses(data, current_sample);
    while SOFfound == false
        disp(current_sample);
        current_sample = findNextOne(data, current_sample);
        [pulses, current_sample] = getPulses(data, current_sample);
        if pulses ~= 24
            continue;
        end
        SOFfound = true;
        disp(pulses);
        disp(current_sample * sample_time);
    end
end

function [pulses, current_sample] = getPulses(data, current_sample)
    %Starting parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    pulses = 0;
    zero_time = 0;
    %Gets the first zero after the frame starts
    current_sample = findNextZero(data, current_sample);
    zero_sample = current_sample;
    %Finds all pulses
    while zero_time < 3e-06
        current_sample = findNextOne(data, current_sample);
        one_sample = current_sample;
        zero_time = (one_sample - zero_sample) * sample_time;
        pulses = pulses + 1;
        current_sample = findNextZero(data, current_sample);
        zero_sample = current_sample;
    end
end

%This will find start of the next pulse
function sample = findNextOne(data, current_sample)
    for i = (current_sample):size(data)
        if data(i) == 1
            sample = i;
            return;
        end
    end
end

%This will find when the current pulse ends
function sample = findNextZero(data, current_sample)
    for i = (current_sample):size(data)
        if data(i) == 0
            sample = i;
            return;
        end
    end
end