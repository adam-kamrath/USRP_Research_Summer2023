sampling_rate = 200000;
decimation_factor = 100000000/sampling_rate;
center_frequency = 13560000;

reader = comm.BasebandFileReader('3inv.bb', SamplesPerFrame=inf);

timeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 5,SampleRate = sampling_rate, ...
                      Position=[20,200,800,500]);
timeScope.YLimits = [-.6,.6];
data = reader();
timeScope(data);

release(timeScope);
release(reader);