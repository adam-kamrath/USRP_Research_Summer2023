clc;
Highpass;
% Bandpass;
global sampling_rate;
global sample_time;
sampling_rate = 2000000;
sample_time = 1/sampling_rate;
decimation_factor = 100000000/sampling_rate;

file_name = 'fifth_test.bb';

file_path = append('C:\Users\akamrath2\Documents\USRP_Research_Summer2023\VCDandVICCsignals\Signals\', file_name);
reader = comm.BasebandFileReader(file_path, SamplesPerFrame=inf);
%Create the time scope for the unfiltered data
dataTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 10,SampleRate = sampling_rate, ...
                      Position=[1000,100,800,350], ...
                      YLimits=[-.6,.6]);

%Create spectrum analyzer for data
% spectrum = spectrumAnalyzer(Samplerate=sampling_rate, ...
%     FrequencySpan="span-and-center-frequency", Span=1e6, ...
%     Position=[20,500,800,350]);

%Get the data from the file
data = reader();



%Put data through highpass filter
% highpass_data = HighpassFilter(data);


% %Put data through bandpass filter
% bandpass_data = BandpassFilter(highpass_data);


%Gets the magnitude of the data
magnitude_data = abs(data);

%Makes the data digital signals
edit_data = editData(magnitude_data);

%Plot data
dataTimeScope(magnitude_data);
release(dataTimeScope);
% spectrum(data);
% 
% binary_sequence = decodeCardData(edit_data);
% disp(binary_sequence);
% [flags, info_flags, uid, dsfid, afi, memory, ic_reference, crc] = sortBinarySequence(binary_sequence);
% disp(flags);
% disp(info_flags);
% disp(uid);
% disp(dsfid);
% disp(afi);
% disp(memory);
% disp(ic_reference);
% disp(crc);

%release instances
release(HighpassFilter);
% release(BandpassFilter);
release(reader);
