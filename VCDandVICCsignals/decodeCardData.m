function decodeCardData(data)
    %Starting parameters
    binary_sequence = '';
    %5753340
    current_sample = 1;
    SOFfound = false;
    EOFfound = false;
    [SOFfound, current_sample] = findSOF(data, current_sample);
    for i = 1:117
        [found, current_sample] = logicOneCheck(data, current_sample);
        [found, current_sample] = logicZeroCheck(data, current_sample);
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
        disp("24 PULSES");
        %Gets the time difference between the two groups of pulses
        one_sample = findNextOne(data, current_sample);
        sample_difference = one_sample - current_sample;
        time_difference = sample_difference * sample_time;
        %Checks if the time difference is correct for the SOF
        if (14e-06 > time_difference) && (time_difference > 20e-06)
            continue;
        end
        disp("CORRECT GAP");
        [pulses, current_sample] = checkForPulses(data, current_sample, 8);
        if pulses ~= 8
            continue;
        end
        disp("8 PULSES");
        disp("SOF FOUND");
        disp(current_sample* sample_time);
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
        pulses = pulses + 1;
        if pulses == num_pulses
            ending_sample = findNextZero(data, one_sample);
            return;
        end
    end
end

function [found, ending_sample] = logicOneCheck(data, starting_sample)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    
    one_sample = findNextOne(data, starting_sample);
    sample_difference = one_sample - starting_sample;
    time_difference = sample_difference * sample_time;
    if time_difference > 5e-06
        [pulses, ending_sample] = checkForPulses(data, starting_sample, 8);
        if pulses == 8
            disp("LOGIC ONE FOUND");
            found = true;
            return;
        else
            found = false;
        end
    else
        % disp("LOGIC ONE NOT FOUND");    
        found = false;
        ending_sample = starting_sample;
    end
end

function [found, ending_sample] = logicZeroCheck(data, starting_sample)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    
    one_sample = findNextOne(data, starting_sample);
    sample_difference = one_sample - starting_sample;
    time_difference = sample_difference * sample_time;
    if time_difference < 5e-06
        [pulses, ending_sample] = checkForPulses(data, starting_sample, 8);
        if pulses == 8
            disp("LOGIC ZERO FOUND");
            found = true;
            extra_samples = round(18.88e-06 / sample_time);
            ending_sample = ending_sample + extra_samples;
            return;
        else
            found = false;
        end
    else
        % disp("LOGIC ZERO NOT FOUND");    
        found = false;
        ending_sample = starting_sample;
    end
end

function [EOFfound, ending_sample] = EOFcheck(data, starting_sample)
    %Starting Parameters
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    ending_sample = starting_sample;
    EOFfound = false;

    [found, current_sample] = logicZeroCheck(data, starting_sample);
    if found == true
        [pulses, current_sample] = checkForPulses(data, current_sample, 24);
        if pulses == 24
            one_sample = findNextOne(data, current_sample);
            sample_difference = one_sample - current_sample;
            time_difference = sample_difference / sample_time;
            if time_difference > 50e-06
                disp("EOF FOUND");
                disp(current_sample);
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