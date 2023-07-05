sampling_rate = 200000;
decimation_factor = 100000000/sampling_rate;


reader = comm.BasebandFileReader('card.bb', SamplesPerFrame=inf);
%Create the time scope for the unfiltered data
dataTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 5,SampleRate = sampling_rate, ...
                      Position=[20,100,800,500], ...
                      YLimits=[-.6,.6]);
%Create the time scope for the highpass filtered data
highpassTimeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 5,SampleRate = sampling_rate, ...
                      Position=[1000,100,800,500], ...
                      YLimits=[-.6,.6]);

%Get the data from the file
data = reader();
%Create the highpass filter
highpass = dsp.HighpassFilter(StopbandFrequency=500, ...
    SampleRate=sampling_rate, ...
    PassbandFrequency= 1000);
%Put data through highpass filter
highpass_data = highpass(data);

%Plot data
dataTimeScope(data);
highpassTimeScope(highpass_data);
fvtool(highpass,Analysis='freq')

%release instances
release(dataTimeScope);
release(highpassTimeScope);
release(highpass);
release(reader);