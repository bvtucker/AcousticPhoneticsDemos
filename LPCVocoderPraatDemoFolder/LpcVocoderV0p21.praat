# LPC source filter demo
# This demo takes a recording and applies LPC filtering to the signal.
# This then separates out the source and the filter and allows the user
# to replace the sources with a user provided sources (the harmonica), 
# a hiss, or a buzz.
# Version 0.2 February 14 2010
# Version 0.21 Feb 16 2012 -- fixed name of resynthed buzz
# Version 0.3 Feb 9, 2022 -- made some minor changes and updates
# This is based on Praat manual Source-filter synthesis 4. Using existing sounds
naturalType=1
buzzType=2
hissType=3
##------------------ Get target sound and optionally source
maxformant=8;
nsel=0
allOK=0;
while not allOK
while nsel <1 or nsel>2
beginPause("Select sounds")
	comment(" Select ONE or TWO sounds")
	comment(" One will be target sound.")
	comment("Optional second will be new source.")
	comment("The sounds should be trimmed at the ends.")
endPause("Continue",1)
nsel= numberOfSelected("Sound")
endwhile
#  initial selection


haveNewSource=0
haveTarget=0
haveBuzzSource=0
haveHissSource=0
newSourceName$="<NULL>";
if nsel==2
haveNewSource=1
	soundID1= selected("Sound", 1)
	soundID2= selected("Sound", 2)
	soundName1$=selected$("Sound", 1);
	soundName2$=selected$("Sound", 2);
	beginPause("Which is target (to be vocoded)")

opt1$= soundName1$ +" is target"
opt2$ = soundName2$ +" is target"
printline 'opt1$' 'opt2$' 'soundName1$' 'soundName2$'
beginPause ("Choose target")
choice("Which is target",1)
	option("'opt1$'")
	option("'opt2$'")
	clicked = endPause("Continue",1)
newSourceID=0;
newSourceName$="<NULL>"
   if which_is_target == 1
	  newSourceName$=soundName2$
	  newSourceID=soundID2
	  targetSoundName$=soundName1$
	  targetSoundID=soundID1
   else
  	newSourceName$=soundName2$
   	newSourceID=soundID2
   	targetSoundName$=soundName2$
	targetSoundID=soundID2
 endif
 elsif nsel==1
 targetSoundID= selected("Sound", 1)
 targetSoundName$= selected$("Sound", 1)
	
endif
#nsel ==2

nSources=0;

haveAnySources=0
if haveNewSource
	cmnt1$="User source " + newSourceName$
	cmnt2$ = " will be used as well as any chosen below."
else
	cmnt1$= " Only target sound chosen (no newSource sound)"
	cmnt2$ = "You must choose AT LEAST one of  the sources below."
endif

 
while haveAnySources==0
	beginPause ("Select standard  sources\s") 
		comment(" 'cmnt1$' ")
		comment(" 'cmnt2$' ") 
		boolean("Buzz",1)
		boolean("Hiss",1)
		comment("Enter baseline neutral F1")
		comment ("(e.g.500 for male  575 for female 600+ for child)")
	  	real("Baseline F1", 550)
		comment(" NYI Note synthesis frequency will be limited to 12 * Baseline F1")
		comment("Click continue  when you're ready")
	clicked = endPause("Continue",1)
haveAnySources= haveNewSource or buzz or hiss
endwhile
# not haveAnySources

haveHissSource=hiss
haveBuzzSource=buzz
select Sound 'targetSoundName$'
Scale peak... 0.99
fs= Get sampling frequency
fs$=fixed$(fs,0)
# two factors of two one for formant spacing one to double nyquist
fmax= baseline_F1*2*maxformant*2 
fsAna=round(min(fmax,fs));
if fsAna<fs
	Resample... fsAna 50
	# change the target sound name to the resampled version
	targetSoundName$=selected$("Sound") 
	Scale peak... 0.99
endif
Edit

beginPause ("Info")
  str$="Sampling rate "+fs$ +" fsAna" +  fixed$(fsAna,0);
  comment (str$)

clicked = endPause("Continue",1)

Erase all

# do target LPC analysis
nformant=round( (fs/2)/(2*baseline_F1))
lpcOrder=nformant*2+3;
winDur=0.025
timeStep=0.005
preemphFreq=50
To LPC (burg)...     lpcOrder winDur timeStep preemphFreq

# Create inverse filtered signal
inverseFilteredName$=targetSoundName$+"_SourceEst"
select Sound 'targetSoundName$'
Copy...  targetSourceEstimate
select Sound targetSourceEstimate
plus LPC 'targetSoundName$'
Filter (inverse)
Rename... 'inverseFilteredName$'
Scale peak... 0.99
Edit
beginPause ("Info Source")
  comment ("Source estimate via inverse LPC filtering")
clicked = endPause("Continue",1)

select Sound 'targetSoundName$'
dur=Get total duration
## Use new source if available
if haveNewSource
	select Sound 'newSourceName$'
	
	Copy... 'newSourceAlteredName$'
	Resample... fsAna 50
	newSourceAlteredName$=selected$("Sound")+"_DurAltered"
	durNewSource=Get total duration
# use overlap add to match duration
	ratio=dur/durNewSource
	Lengthen (overlap-add)... 75 600 'ratio'
	Rename... 'newSourceAlteredName$'
		Edit
		beginPause ("Substitute source")
  comment ("Sound you chose to replace source")
  comment ("Time scale may have been altered to match")
clicked = endPause("Continue",1)


# refliter
	filteredNewSource$=targetSoundName$+"_"+newSourceName$
	beginPause ("newname")
  comment ("'filteredNewSource$'")
clicked = endPause("Continue",1)

	select Sound 'newSourceAlteredName$'
	plus LPC 'targetSoundName$'
	Filter... no
	
	Rename... 'filteredNewSource$'
	select Sound 'filteredNewSource$'
	Scale peak... 0.99
	Edit
	beginPause ("Info Source substituted Resynthesized LPC")
  comment ("Reconstruction of signal using (time modified) source signal")
clicked = endPause("Continue",1)
endif
## 
## Resynthesize
select Sound targetSourceEstimate
plus LPC 'targetSoundName$'
Filter... no
resynthLPC$=targetSoundName$+"_Resynth"
Rename... 'resynthLPC$'
Scale peak... 0.99
Edit
	beginPause ("Reconstructed signal Resynthesized LPC")
  comment ("Reconstruction of signal from  source + filter estimates")
clicked = endPause("Continue",1)

#  This is out of place - there is something in resynthesis to use LPC gain
# Can use pulses from target signal or from LPC residual
if haveBuzzSource

	resynthBuzz$=targetSoundName$+"_BUZZ"
	select Sound 'targetSoundName$'
	# To Sound (pulse train) AdaptationFactor AdaptationTime InterpolationDepth
To PointProcess (periodic, peaks)... 75 600 yes no
Rename... buzzSource
To Sound (pulse train)... 'fsAna' 1 0.05 2000
Edit
 beginPause ("Buzz source")
  comment ("Buzz source based on pitch of original")
clicked = endPause("Continue",1)

    select PointProcess buzzSource
   
	Remove
	select Sound buzzSource
	plus LPC 'targetSoundName$'
	Filter... no
	Rename... 'resynthBuzz$'
	Scale peak... 0.99
	Edit
	 beginPause ("Buzz source refiltered")
  comment ("Buzz filtered by LPC filter of original")
  
clicked = endPause("Continue",1)
endif

if haveHissSource
	Create Sound from formula... hissSource 1 0 'dur' 'fsAna' randomGauss(0,0.1)
	resynthHiss$=targetSoundName$+"_HISS"
	select Sound hissSource
	plus LPC 'targetSoundName$'
	Filter... no

	Rename... 'resynthHiss$'
	Scale peak... 0.99
	Edit
	
endif



#printline HISS 'haveHissSource' BUZZ 'haveBuzzSource'  New source available? 'haveNewSource'
#printline This is close need more viewports and Edit commands


