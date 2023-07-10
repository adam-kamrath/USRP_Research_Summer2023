sampling_rate = 2000000;
decimation_factor = 100000000/sampling_rate;


reader = comm.BasebandFileReader('system_information.bb', SamplesPerFrame=inf);
%Create the time scope for the unfiltered data
dataTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 10,SampleRate = sampling_rate, ...
                      Position=[20,100,800,500], ...
                      YLimits=[-.6,.6]);
%Create the time scope for the highpass filtered data
highpassTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 10,SampleRate = sampling_rate, ...
                      Position=[1000,100,800,500], ...
                      YLimits=[-.6,.6]);

bandpassTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 10,SampleRate = sampling_rate, ...
                      Position=[1000,100,800,500], ...
                      YLimits=[-.6,.6]);

spectrum = spectrumAnalyzer(Samplerate=sampling_rate, ...
    FrequencySpan="span-and-center-frequency", Span=1e6);
%Get the data from the file
data = reader();

%Put data through highpass filter
highpass_data = HighpassFilter(data);
bandpass_data = BandpassFilter(highpass_data);
spectrum(bandpass_data);

%Plot data
dataTimeScope(data);
highpassTimeScope(highpass_data);
bandpassTimeScope(bandpass_data);

%release instances
release(dataTimeScope);
release(highpassTimeScope);
release(HighpassFilter);
release(bandpassTimeScope);
release(BandpassFilter);
release(reader);
