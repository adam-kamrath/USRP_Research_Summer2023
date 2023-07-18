function decodeCardData(data)
    %Starting parameters
    binary_sequence = '';
    %samples before SOF = 5753340
    %sample before EOF = 5763822
    current_sample = 1;
    SOFfound = false;
    EOFfound = false;
    [SOFfound, current_sample] = findSOF(data, current_sample);
    while true
        [EOFfound, current_sample] = EOFcheck(data, current_sample);
        if EOFfound == true
            disp(binary_sequence);
            return;
        end
        [found, current_sample] = logicOneCheck(data, current_sample);
        if found
            binary_sequence = append(binary_sequence, '1');
            continue;
        end
        % [found, current_sample] = logicZeroCheck(data, current_sample);
        % if found
        %     binary_sequence = append(binary_sequence, '0');
        % end
    end 
end

function [SOFfound, current_sample] = findSOF(data, current_sample) 
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    SOFfound = false;

    while SOFfound == false
        %Gets the amount of consecutive pulses starting from the next one
        [pulses, current_sample] = checkForPulses(data, current_sample, 24);
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
        [pulses, current_sample] = checkForPulses(data, current_sample, 8);
        if pulses ~= 8
            continue;
        end
        disp("SOF FOUND");
        SOFfound = true;
    end
end

function [pulses, ending_sample] = checkForPulses(data, starting_sample, num_pulses)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    pulses = 0;

    %Gets the start of pulses
    one_sample = findNextOne(data, starting_sample);
    pulses = pulses + 1;
    
    while true
        %Get the samples between previous pulse and next pulse
        zero_sample = findNextZero(data, one_sample);
        one_sample = findNextOne(data, zero_sample);
        sample_difference = one_sample - zero_sample;
        time_difference = sample_difference * sample_time;

        %Checks if the gap is too big
        if (time_difference > 5e-06)
            ending_sample = zero_sample;
            return;
        end
        %Increments pulses if the gap is correct
        pulses = pulses + 1;
        %Checks if there has been the desired number of pulses found
        if pulses == num_pulses
            ending_sample = findNextZero(data, one_sample);
            return;
        end
    end
end

%Checks for a logic one value
function [found, ending_sample] = logicOneCheck(data, starting_sample)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    
    %Find the gap between the previous and current bit
    one_sample = findNextOne(data, starting_sample);
    sample_difference = one_sample - starting_sample;
    time_difference = sample_difference * sample_time;

    %Checks if the time difference is correct for a logic one
    if time_difference > 5e-06
        %Checks if there are 8 pulses after the gap
        [pulses, ending_sample] = checkForPulses(data, starting_sample, 8);
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
        ending_sample = starting_sample;
    end
end

%Checks for a logic zero value
function [found, ending_sample] = logicZeroCheck(data, starting_sample)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    
    %Gets the time difference between previous bit and current bit
    one_sample = findNextOne(data, starting_sample);
    sample_difference = one_sample - starting_sample;
    time_difference = sample_difference * sample_time;

    %Checks if the gap is small enough
    if time_difference < 5e-06
        %Checks for 8 pulses
        [pulses, ending_sample] = checkForPulses(data, starting_sample, 8);
        if pulses == 8
            found = true;
            %Adds a time difference after the 8 pulses
            extra_samples = round(18.88e-06 / sample_time);
            ending_sample = ending_sample + extra_samples;
            return;
        else
            found = false;
        end
    else 
        found = false;
        %Resets the current sample to the start point
        ending_sample = starting_sample;
    end
end

function [EOFfound, ending_sample] = EOFcheck(data, starting_sample)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    ending_sample = starting_sample;
    EOFfound = false;
    
    %Checks for a logic zero
    [found, current_sample] = logicZeroCheck(data, starting_sample);
    if found == true
        %Checks for 24 pulses
        [pulses, current_sample] = checkForPulses(data, current_sample, 24);
        if pulses == 24
            %Gets the time difference between the end of the 24 pulses and
            %the next pulse
            one_sample = findNextOne(data, current_sample);
            sample_difference = one_sample - current_sample;
            time_difference = sample_difference * sample_time;
            %Checks if there is at least 50us
            if time_difference > 50e-06
                disp("EOF FOUND");
                ending_sample = current_sample;
                EOFfound = true;
            end
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