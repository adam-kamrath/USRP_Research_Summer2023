bandpassSpecs = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,2e5,4e5,5e5,7e5,10e6);
bandpassSpecs.Stopband1Constrained = true;
bandpassSpecs.Astop1 = 60;
bandpassSpecs.Stopband2Constrained = true;
bandpassSpecs.Astop2 = 60;

bandpassFilter = design(bandpassSpecs, 'Systemobject', true);
fvtool(bandpassFilter)
measure(bandpassFilter)