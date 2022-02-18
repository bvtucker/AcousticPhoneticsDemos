# aliasDemo.praat
# Step sinusoids to illustrate aliasing
# name numChan startTime endTime sF formula
# Version 1.0 TM Nearey March 1 2011
# Version 1.1 March 1 2012  adjusts spectrogram range
# Version 1.1.1 Sept 18 2013. 
# Try different sampling rates with default steps 
# Should be packaged (in same directory as) with AliasDemo2013Description.txt
show_instructions=1
repeat 
beginPause("Information")
comment(" With default values, all is well.")
comment(" (Series of sine pips 100 ms long increasing in frequency from 1000 ")
comment(" to 9000 Hz).")
comment(" Spectrogram controls set to show 0:10000 Hz")
comment(" Change sampling rate to 10000 Hz")
comment("What happens?")
boolean( "Show instructions", show_instructions)
clicked = endPause ("Continue", 1)
if show_instructions
	txt$ < ./AliasDemoDescription.txt
printline --------------------------------------------
printline --------------------------------------------
printline INSTRUCTIONS
print 'txt$'
printline
printline --------------------------------------------
printline --------------------------------------------
endif


stepHz=1000;
stepMs=100
sampleFreq=20000
durSec=1
# while 1==1
beginPause("Input information")
real( "StepHz",stepHz)
real("StepMs",stepMs);
real("durSec", durSec);
real("SampleFreq", sampleFreq)
    clicked = endPause ("Continue", 1)
soundName$="sig_"+fixed$(stepHz,0)+"Hz_"+fixed$(stepMs,0)+"_msSteps_Fs"+fixed$(sampleFreq,0)
stepSec=stepMs/1000;

Create Sound from formula... "'soundName$'"  1 0 'durSec'  'sampleFreq'  0.5 * sin(2*pi*ceiling(x/stepSec)*1000*x) 
Play
Edit
editor Sound 'soundName$'
Spectrogram settings... 0 10000 0.02 30
endeditor

#beginPause("View last signal")
#    clicked = endPause ("Continue", 1)
#endwhile

beginPause("Examine last signal")
clickedMore=endPause("More", "Enough",1)
more=clickedMore==1
until more==0

