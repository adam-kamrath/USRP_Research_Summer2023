function decodeReaderData(data)
    current_sample = 1;
    [SOFfound, current_sample] = findSOF(data, current_sample);
    [SOFfound, current_sample] = findSOF(data, current_sample);
    [SOFfound, current_sample] = findSOF(data, current_sample);
    [SOFfound, current_sample] = findSOF(data, current_sample);
end

function [SOFfound, current_sample] = findSOF(data, current_sample)
    %Sets parameters for data
    sampling_rate = 2000000;
    
    %Starting parameters
    SOFfound = false;
    
    %Gets the end of the first pulse
    while SOFfound == false
        current_sample = findNextOne(data, current_sample);
        one_start_sample = current_sample;
        current_sample = findNextZero(data, current_sample);
        one_end_sample = current_sample;
        
        %Get the time of break
        current_sample = findNextOne(data, current_sample);
        zero_samples = current_sample - one_end_sample;
        zero_time = zero_samples * 1/sampling_rate;
        
        %Checks if the break complies to the SOF
        if (32e-06 < zero_time) && (zero_time < 40e-06)
           disp('START OF FRAME FOUND');
           SOFfound = true;
           
           %Find end of pulse then adds 18.88 us for end of SOF
           current_sample = findNextZero(data, current_sample);
           start_time = one_start_sample * 1/sampling_rate;
           end_time = (current_sample * 1/sampling_rate) + 18.88e-06;
           disp(start_time);
           disp(end_time);
           return;
        end
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


%This gets the number of samples expected for each break between pulses
function samples = getSamplesPerBreak(sampling_rate, breaktime)
    sampling_time = 1/sampling_rate;
    breaktime = breaktime * (10^-6);
    samples = round(breaktime/sampling_time) + 1;
end