# SimpleVowelXfrFuncScript.praat
# Author T.M. Nearey Oct 30 2008- Feb 12 2013
# Creates 5-formant vowels.
# Displays preemphasized spectrum with LPC in drawing window.
# Bandwidths set at larger of 60 Hz or 6% of formant frequency.
# Default frequencies work best with samling rate (fs) of 10000 Hz
# Version 4.0 with extra note about 'digital version'
form supply_arguments 
	positive fs  10000
	comment This is digital synthesis. The transfer functions are a little
      comment  different than analog versions. Higher pole correction is implicit.
	comment Relative effects of varying formant frequencies within reason are very
	comment similar to analog world.
	comment Bandwiths are set at 6 percent of formant frequencies or min of 60 Hz
	positive vowelDuration  0.500
	positive windowDuration 0.0500
	positive f0 100
	positive f1 500
	positive f2 1500
	positive f3 2500
	positive f4 3500
	positive f5 4500
endform 

printline Formant frequencies 'f1' 'f2' 'f3' 'f4' 'f5'
printline Formant bandwiths 'b1' 'b2' 'b3' 'b4'
b1 = max(60, 0.06*f1)
b2 = max(60, 0.06*f2)
b3 = max(60, 0.06*f3)
b4 = max(60, 0.06*f4)
b5 = max(60, 0.06*f5)
Create PitchTier... source    0        vowelDuration
#                    name  timeStart timeEnd
Add point... 0 f0
#           time pitch
Add point... vowelDuration f0
To Sound (phonation)... 'fs' 1 0.05 0.7 0.03 3 4 no
#                 Fs   adapFac maxPer OpPhase ColisPhase Power1 Power2 'NoHum'
# Play
# Note this will actually produce enough formants to fill nyquist
Create FormantTier... FPattern 0 'vowelDuration'
#                   Name   tStart tEnd
	Add point... 0.0 'f1' 'b1' 'f2' 'b2' 'f3' 'b3' 'f4' 'b4' 'f5' 'b5'
#          time  f1 b1 f2 b2 .....
	Add point... 'vowelDuration' 'f1' 'b1' 'f2' 'b2' 'f3' 'b3' 'f4' 'b4'  'f5' 'b5'
select Sound source
plus FormantTier FPattern
Filter
select Sound source_filt
Rename...  source_filtVowel
Play
Edit
select Sound source_filtVowel
Filter (pre-emphasis)... 50
select Sound source_filtVowel_preemp
# To Spectrum... FAST=yes
To Spectrum... yes

Erase all
Black
# Draw... LowFreq HighFreq MinPowdB MaxPowDb Garnish

lowFreq=0
highFreq= fs/2

Draw... 'lowFreq'  'highFreq' 0 80 yes
#Preemph chosen for better envelope fit at high frequencies
#LPC smoothing... 5.5 200
#Red
# NO garnish
#Draw... 'lowFreq'  'highFreq' 0 80 no

Marks left every... 1 10 no yes yes

pause (' Click to here to clear picture then run again')
select all
Remove

