clc;
Highpass;
% Bandpass;
sampling_rate = 2000000;
decimation_factor = 100000000/sampling_rate;

file_name = 'single_sys_info.bb';

file_path = append('C:\Users\akamrath2\Documents\USRP_Research_Summer2023\VCDandVICCsignals\Signals\', file_name);
reader = comm.BasebandFileReader(file_path, SamplesPerFrame=inf);
%Create the time scope for the unfiltered data
% dataTimeScope = timescope(TimeSpanSource = "auto",...
%                       TimeSpan = 10,SampleRate = sampling_rate, ...
%                       Position=[20,100,800,350], ...
%                       YLimits=[-.6,.6]);

%Create the time scope for the highpass filtered data
highpassTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 10,SampleRate = sampling_rate, ...
                      Position=[1000,100,800,350], ...
                      YLimits=[-.6,.6]);
%Create the time scope for the bandpass filtered data
% bandpassTimeScope = timescope(TimeSpanSource = "auto",...
%                       TimeSpan = 10,SampleRate = sampling_rate, ...
%                       Position=[1000,500,800,350], ...
%                       YLimits=[-.6,.6]);


%Create spectrum analyzer for data
% spectrum = spectrumAnalyzer(Samplerate=sampling_rate, ...
%     FrequencySpan="span-and-center-frequency", Span=1e6, ...
%     Position=[20,500,800,350]);

%Get the data from the file
data = reader();

%Put data through highpass filter
highpass_data = HighpassFilter(data);

%Get magnitude of highpass filter data
absolute_data = abs(highpass_data);

edit_data = editData(absolute_data);
% [binary_sequence, current_sample] = decodeReaderData(edit_data);
% disp(binary_sequence);
decodeCardData(edit_data);


%Put highpass data through bandpass filter
% bandpass_data = BandpassFilter(highpass_data);

%Plot data
% dataTimeScope(data);
highpassTimeScope(edit_data);
% bandpassTimeScope(bandpass_data);
% spectrum(data);

%release instances
% release(dataTimeScope);
release(highpassTimeScope);
release(HighpassFilter);
% release(bandpassTimeScope);
% release(BandpassFilter);
release(reader);
