# SimpleVowelXfrFuncScriptV4.praat
# Author T.M Nearey Oct 30 2008- Feb 12 2013
# Modified and updated by B.V. Tucker 2014-2022
# Creates 5-formant vowels.
# Displays preemphasized spectrum with LPC in drawing window.
# Bandwidths set at larger of 60 Hz or 6% of formant frequency.
# Default frequencies work best with sampling rate (fs) of 10000 Hz
# Version 4.0 with extra note about 'digital version'
# Version 5.0 Updated filter was created and added plotting of the source and the filter in addition to the output

repeat
fs=10000;
vowelDuration=0.500
windowDuration=0.0500
f0=100
f1=500
f2=1500
f3=2500
f4=3500
f5=4500
# the revised form
beginPause("Input information")
	comment ("What is the sampling frequency (fs)?")
	real("fs",fs);
	comment ("This is digital synthesis. The transfer functions are a little different than analog versions.")
	comment ("Higher pole correction is implicit. Relative effects of varying formant frequencies within")
	comment ("reason are very similar to analog world.")
	comment ("Bandwiths are set at 6 percent of formant frequencies or min of 60 Hz")
	real("vowelDuration",vowelDuration);
	real("windowDuration",windowDuration);
	real("f0",f0);
	real("f1",f1);
	real("f2",f2);
	real("f3",f3);
	real("f4",f4);
	real("f5",f5);
clicked = endPause ("Continue", 1)

b1 = max(60, 0.06*f1)
b2 = max(60, 0.06*f2)
b3 = max(60, 0.06*f3)
b4 = max(60, 0.06*f4)
b5 = max(60, 0.06*f5)

printline Formant frequencies 'f1' 'f2' 'f3' 'f4' 'f5'
printline Formant bandwiths 'b1' 'b2' 'b3' 'b4'

#                    name    timeStart timeEnd
Create PitchTier... source    0        vowelDuration

#           time pitch
Add point... 0 f0

Add point... vowelDuration f0
#                 Fs   adapFac maxPer OpPhase ColisPhase Power1 Power2 'NoHum'
To Sound (phonation)... 'fs' 1 0.05 0.7 0.03 3 4 no
Play

# Plotting the source
Erase all
Select outer viewport: 0, 8, 0, 3
select Sound source
To Spectrum: "yes"
Blue
Draw: 0, 0, 0, 0, "yes"


# Note this will actually produce enough formants to fill nyquist
#                     Name   tStart tEnd
#Create FormantTier... FPattern 0 'vowelDuration'
#                   time  f1   b1   f2   b2 .....
#	Add point... 0.0 'f1' 'b1' 'f2' 'b2' 'f3' 'b3' 'f4' 'b4' 'f5' 'b5'
#	Add point... 'vowelDuration' 'f1' 'b1' 'f2' 'b2' 'f3' 'b3' 'f4' 'b4'  'f5' 'b5'

Create FormantGrid: "FPattern", 'vowelDuration', 1, 5, f1, 1000, 60, 50

Remove formant points between: 1, 0, 1
Remove bandwidth points between: 1, 0.3, 0.7
for i from 1 to 5
  Add formant point: i, 0.5, f'i'
  Add bandwidth point: i, 0.5, b'i'
endfor

select FormantGrid FPattern
Select outer viewport: 0, 8, 2.5, 5.5
To Formant: 0.01, 0.1
To LPC: 16000
To Spectrum (slice): 0, 20, 0, 50
Red
Draw: 0, 0, 0, 0, "yes"

select Sound source
#plus FormantTier FPattern
plus FormantGrid FPattern
Filter
select Sound source_filt
Rename...  source_filtVowel
sleep (1)
Play
Edit
select Sound source_filtVowel
Filter (pre-emphasis)... 50
select Sound source_filtVowel_preemp
# To Spectrum... FAST=yes
To Spectrum... yes


Select outer viewport: 0, 8, 5, 9
Black


lowFreq=0
highFreq= fs/2
# Draw... LowFreq HighFreq MinPowdB MaxPowDb Garnish
Draw... 'lowFreq'  'highFreq' 0 80 yes
#Preemph chosen for better envelope fit at high frequencies

Marks left every... 1 10 no yes yes
Select outer viewport: 0, 8, 0, 9.5

beginPause("Examine last signal")
clickedMore=endPause("Again", "Done",1)
more=clickedMore==1
until more==0
#pauseScript: "Click to clear the pictures then run again"
select all
Remove