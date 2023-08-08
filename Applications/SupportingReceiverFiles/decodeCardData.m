function binary_sequence = decodeCardData(data)
%Starting parameters
global sampling_rate;
global sample_time;
global current_sample
current_sample = 1;
sampling_rate = 2000000;
sample_time = 1/sampling_rate;
binary_sequence = '';
EOFfound = false;
findSOF(data);
while true
    EOFfound = EOFcheck(data);
    if EOFfound == true
        return;
    end
    if logicOneCheck(data)
        binary_sequence = append(binary_sequence, '1');
        continue;
    end
    if logicZeroCheck(data)
        binary_sequence = append(binary_sequence, '0');
    end
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
    %Checks if there are 24 pulses
    if checkForPulses(data, 24) ~= 24
        continue;
    end
    %Gets the time difference between the two groups of pulses
    one_sample = findNextOne(data, current_sample);
    sample_difference = one_sample - current_sample;
    time_difference = sample_difference * sample_time;
    %Checks if the time difference is correct for the SOF
    if (.000014 > time_difference) && (time_difference > .000020)
        continue;
    end
    if checkForPulses(data, 8) == 8
        SOFfound = true;
        disp('SOF FOUND');
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
    if checkForPulses(data, 8) == 8
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

%Checks for a logic zero value
function found = logicZeroCheck(data)
global sampling_rate;
global sample_time;
global current_sample;

starting_sample = current_sample;
%Gets the time difference between previous bit and current bit
one_sample = findNextOne(data, current_sample);
sample_difference = one_sample - current_sample;
time_difference = sample_difference * sample_time;

%Checks if the gap is small enough
if time_difference < 5e-06
    %Checks for 8 pulses
    if checkForPulses(data, 8) == 8
        found = true;
        %Adds a time difference after the 8 pulses
        extra_samples = round(18.88e-06 / sample_time);
        current_sample = current_sample + extra_samples;
        return;
    else
        found = false;
    end
else
    found = false;
    %Resets the current sample to the start point
    current_sample = starting_sample;
end
end

function EOFfound = EOFcheck(data)
%Starting Parameters
global sampling_rate;
global sample_time;
global current_sample;
EOFfound = false;
starting_sample = current_sample;

%Checks for a logic zero
found = logicZeroCheck(data);
if found == true
    %Checks for 24 pulses
    if checkForPulses(data, 24) == 24
        %Gets the time difference between the end of the 24 pulses and
        %the next pulse
        one_sample = findNextOne(data, current_sample);
        sample_difference = one_sample - current_sample;
        time_difference = sample_difference * sample_time;
        %Checks if there is at least 50us
        if time_difference > 50e-06
            disp("EOF FOUND");
            disp(current_sample * sample_time);
            EOFfound = true;
        else
            current_sample = starting_sample;
        end
    else
        current_sample = starting_sample;
    end
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