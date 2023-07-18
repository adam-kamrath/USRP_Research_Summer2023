function binary_sequence = decodeCardDataFast(data)
    %Starting parameters
    global sampling_rate;
    global sample_time;
    global current_sample;
    current_sample = 1;
    binary_sequence = '';

    findSOF(data);
    %This loops for the amount of bits in a system information response
    for i = 1:136
        %Checks if this bit is logic one and adds to end of binary sequence
        if logicOneCheck(data)
            binary_sequence = append(binary_sequence, '1');
            continue;
        end
        %If it is logic 0, adds to binary_sequence and skips 37.76us
        binary_sequence = append(binary_sequence, '0');
        extra_samples = round(37.76e-06 / sample_time);
        current_sample = current_sample + extra_samples;
    end
end

%Finds the SOF and places current sample after it
function findSOF(data) 
    %Starting Parameters
    global sampling_rate;
    global sample_time;
    global current_sample;
    SOFfound = false;
    
    while SOFfound == false
        %Gets the amount of consecutive pulses starting from the next one
        pulses = checkForPulses(data, 24);
        %Checks if there are 24 pulses
        if pulses ~= 24
            continue;
        end
        %Gets the time difference between the two groups of pulses
        one_sample = findNextOne(data, current_sample);
        sample_difference = one_sample - current_sample;
        time_difference = sample_difference * sample_time;
        %Checks if the time difference is correct for the SOF
        if (14e-06 > time_difference) && (time_difference > 20e-06)
            continue;
        end
        if checkForPulses(data, 8) == 8
            SOFfound = true;
        end
        
    end
end

%Checks if there are a specific number of pulses from where the current
%sample is at
function pulses = checkForPulses(data, num_pulses)
    %Starting Parameters
    global sampling_rate;
    global sample_time;
    global current_sample;
    pulses = 0;
    

    %Gets the start of pulses
    one_sample = findNextOne(data, current_sample);
    pulses = pulses + 1;
    
    while true
        %Get the samples between previous pulse and next pulse
        zero_sample = findNextZero(data, one_sample);
        one_sample = findNextOne(data, zero_sample);
        sample_difference = one_sample - zero_sample;
        time_difference = sample_difference * sample_time;

        %Checks if the gap is too big
        if (time_difference > 5e-06)
            current_sample = zero_sample;
            return;
        end
        %Increments pulses if the gap is correct
        pulses = pulses + 1;
        %Checks if there has been the desired number of pulses found
        if pulses == num_pulses
            current_sample = findNextZero(data, one_sample);
            return;
        end
    end
end

%Checks if the next 37.76us contain a logic one or not
function found = logicOneCheck(data)
    global sampling_rate;
    global sample_time;
    global current_sample;

    starting_sample = current_sample;
    %Find the gap between the previous and current bit
    one_sample = findNextOne(data, current_sample);
    sample_difference = one_sample - current_sample;
    time_difference = sample_difference * sample_time;

    %Checks if the time difference is correct for a logic one
    if time_difference > 5e-06
        %Checks if there are 8 pulses after the gap
        pulses = checkForPulses(data, 8);
        if pulses == 8
            found = true;
            return;
        else
            found = false;
        end
    else   
        found = false;
        %Resets the current sample to the start, so the logic zero can be
        %checked for
        current_sample = starting_sample;
    end
end

%Finds the index of the next one starting at a sample
function sample = findNextOne(data, start_sample)
    for i = (start_sample):size(data)
        if data(i) == 1
            sample = i;
            return;
        end
    end
end

%Finds the index of the next zero starting at a sample
function sample = findNextZero(data, start_sample)
    for i = (start_sample):size(data)
        if data(i) == 0
            sample = i;
            return;
        end
    end
end