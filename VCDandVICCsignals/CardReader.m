sampling_rate = 10000000;
decimation_factor = 100000000/sampling_rate;


reader = comm.BasebandFileReader('higher_sample_card.bb', SamplesPerFrame=inf);
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

%Put data through highpass filter
highpass_data = FIRHPF(data);

%Plot data
dataTimeScope(data);
highpassTimeScope(highpass_data);

%release instances
release(dataTimeScope);
release(highpassTimeScope);
release(FIRHPF);
release(reader);