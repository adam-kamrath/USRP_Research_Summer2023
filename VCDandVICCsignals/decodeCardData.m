function decodeCardData(data)
    %Starting parameters
    binary_sequence = '';
    %5753340
    current_sample = 5752497;
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
    while SOFfound == false
        current_sample = findNextOne(data, current_sample);
        [pulses, current_sample] = getPulses(data, current_sample);
        if pulses ~= 24
            continue;
        end
        one_sample = findNextOne(data, current_sample);
        zero_time = (one_sample - current_sample) * sample_time;
        current_sample = one_sample;
        if (16e-06 < zero_time) && (zero_time < 20e-06)
            continue;
        end
        [pulses, current_sample] = getPulses(data, current_sample);
        if pulses == 8
            continue;
        end
        SOFfound = true;
    end
end

function [pulses, current_sample] = getPulses(data, current_sample)
    %Starting parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;  
    pulses = 1;
    zero_time = 0;
    %Gets the first zero after the frame starts
    current_sample = findNextZero(data, current_sample);
    zero_sample = current_sample;
    %Finds all pulses
    while true
        one_sample = findNextOne(data, current_sample);
        current_sample = one_sample;
        zero_time = (one_sample - zero_sample) * sample_time;
        if zero_time < 3e-06
            pulses = pulses + 1;
            current_sample = findNextZero(data, current_sample);
            zero_sample = current_sample;
            continue;
        end
        disp(pulses);
        disp(current_sample * sample_time);
        return;
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