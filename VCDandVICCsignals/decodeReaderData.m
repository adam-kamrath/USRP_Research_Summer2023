function [binary_sequence, end_sample] = decodeReaderData(data)
    %Starting parameters
    binary_sequence = '';
    current_sample = 1;
    SOFfound = false;
    EOFfound = false;

    %Looks at pulses until it finds a Start of Frame
    while SOFfound == false
        [SOFfound, current_sample] = findSOF(data, current_sample);
    end

    %Decodes pulses until it finds a End of Frame
    while EOFfound == false
        [bit_pair, EOFfound, current_sample] = getData(data, current_sample);
        if EOFfound == false
            binary_sequence = append(binary_sequence, bit_pair);
        end
    end

    %Returns the last sample of the frame
    end_sample = current_sample;
end

function [SOFfound, current_sample] = findSOF(data, current_sample)
    %Sets parameters for data
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;
    
    %Starting parameters
    SOFfound = false;
    
    %Gets the end of the first pulse
    while SOFfound == false
        current_sample = findNextOne(data, current_sample);
        current_sample = findNextZero(data, current_sample);
        one_end_sample = current_sample;
        
        %Get the time of break
        current_sample = findNextOne(data, current_sample);
        zero_samples = current_sample - one_end_sample;
        zero_time = zero_samples * sample_time;
        
        %Checks if the break complies to the SOF
        if (32e-06 < zero_time) && (zero_time < 40e-06)
           %disp('START OF FRAME FOUND');
           SOFfound = true;
           
           %Find end of pulse then adds 18.88 us for end of SOF
           current_sample = findNextZero(data, current_sample);

           %Added 18.88us of samples to current_sample
           extra_samples = round((18.88e-06)/sample_time);
           current_sample = current_sample + extra_samples;
           return;
        end
    end
end

function [bit_pair, EOFfound, current_sample] = getData(data, current_sample)
    %Sets parameters for data
    sampling_rate = 2000000;
    sample_time = 1/sampling_rate;

    %Starting parameters
    EOFfound = false;
    
    %Finds where the pulse starts
    one_start_sample = findNextOne(data, current_sample);

    %Get the delay between pulse
    zero_samples = one_start_sample - current_sample;
    zero_time = zero_samples * sample_time;
    current_sample = one_start_sample;

    %Checks for EOF
    if (16e-06 < zero_time) && (zero_time < 22e-06)
        %disp("END OF FRAME");
        bit_pair = '';
        EOFfound = true;
        extra_samples = round((9.44e-06)/sample_time);
        current_sample = findNextZero(data, current_sample);
        current_sample = current_sample + extra_samples;
        return;
    end 
    %Decides which two binary bits are decoded
    if (9e-06 < zero_time) && (zero_time < 11e-06)
        bit_pair = '00';
        extra_samples = round((56.64e-06)/sample_time);
        current_sample = findNextZero(data, current_sample);
        current_sample = current_sample + extra_samples;
        return;
    end 

    if (24e-06 < zero_time) && (zero_time < 32e-06)
        bit_pair = '01';
        extra_samples = round((37.76e-06)/sample_time);
        current_sample = findNextZero(data, current_sample);
        current_sample = current_sample + extra_samples;
        return;
    end 

    if (43e-06 < zero_time) && (zero_time < 50e-06)
        bit_pair = '10';
        extra_samples = round((18.88e-06)/sample_time);
        current_sample = findNextZero(data, current_sample);
        current_sample = current_sample + extra_samples;
        return;
    end 

    if (60e-06 < zero_time) && (zero_time < 70e-06)
        bit_pair = '11';
        current_sample = findNextZero(data, current_sample);
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