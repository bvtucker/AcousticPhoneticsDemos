# Autocorrelation demo
# Version 1.0 March 12 2012
# Version 2.0 March 2022 Updated to work in the demo window
# Copyright TM Nearey, BV Tucker Lesser GPL 3 license
# Demonstration of steps involved "standard" autocorrelation
# Unnormalized autocorrelation is presented
# For a windowed signal chunk  Y(i)  for i=0 by 1 to N-1, the k-th coefficient,
#  for lag index k=0 by 1 to maxLag,
#	 the k-th unnormalized autocorrelation coefficient R(k) is given by
# R(k) = sum{m=0  step 1 to  N-1+k} [ y(m) * y(m+k)] 
# See e.g. Rabiner and Schafer 1978

repeat
      beginPause("Generate select or generate a part of a signal")
	comment("Create or load ONE sound, and select it,")
	comment("View and edit it and put cursor where")
	comment(" you want to view sections")
	comment("-----------------------------------")
	comment("Duration of chunk to autocorrelate")
	positive("Duration ms", 40)
	boolean("Create default sound",1)
	comment("-----------------------------------")
	comment("What kind of window would you like to use?")
#	choice window: 1
#	  button Hamming
#	  button rectangular
#	  button Gaussian1
#optionmenu Window: 1
#	  option Hamming
#	  option rectangular
#	  option Gaussian1
	comment("-----------------------------------")
	comment ("Click anywhere on the demo window to advance the demo to the next step.")
	comment("-----------------------------------")
      clicked=endPause("Ready",1)

select all
nSelectedSound=numberOfSelected("Sound")
if nSelectedSound>1
	Remove
	nSelectedSound=0
endif
if create_default_sound & nSelectedSound=0
	Create Sound from formula... twoTones 1 0 1 11025 1/2 * sin(2*pi*300*x) +1/2 * sin(2*pi*500*x) 
endif
nSelectedSound=numberOfSelected("Sound")

 if nSelectedSound <>1
	pause "Sorry there can only be one sound -- please remove extra"
 endif 
until numberOfSelected("Sound")=1


 Erase all

select all


durSec=duration_ms/1000
sID=selected("Sound",1);
s$=selected$("Sound",1)
#pause Signal 's$'
fs=Get sampling frequency
fsAna=fs;

Edit
editor Sound 's$'


cursor = Get cursor
start = cursor

end = cursor + durSec
Select... start end

Extract selected sound (windowed)... slice Hamming 1 no

endeditor
Rename... windowedChunk

#Set up some key parameters
deltaT=1/fsAna
maxLagTimeSec=1/80
maxLag=round(maxLagTimeSec/deltaT)
maxLagP1=maxLag+1

# Create the key matrices
Down to Matrix
Copy... shiftedWindowedChunk
ncol=Get number of columns
Copy... crossProdVec
# Create a place for the autocorr to be stored
Create Matrix... autocor 0 'maxLag' 'maxLagP1' 1 0 1 1 1 1 1 0


demo demoWindowTitle ("Autocorrelation Demo")

# name the new Sound object according to the time point where the cursor was

for iLag from 0 to maxLag
	delay=iLag*deltaT
	select Matrix shiftedWindowedChunk
	sumCrossProd=0
	for i from 1 to ncol
		iPlusLag=i+iLag
		if iPlusLag<=ncol
		select Matrix windowedChunk
		tmp=Get value in cell... 1 'iPlusLag'
		# Get the earlier signal for cross product
		tmpBase=Get value in cell... 1 'i'
		crossProd=tmp*tmpBase;
		sumCrossProd=sumCrossProd+crossProd
		else
		tmp=0
		endif
		select Matrix shiftedWindowedChunk
		Set value... 1 'i' 'tmp'
		select Matrix crossProdVec
		Set value... 1 'i' 'crossProd'
	    
	endfor
	iLagP1=iLag+1
 	select Matrix autocor
	Set value... 1 'iLagP1' 'sumCrossProd'
	demo Erase all
	@drawTopBox
	@drawLaggedSignal
	@drawCrossProdVec
	@drawAutocor
#	sleep (0.05)
	demoWaitForInput ( )
endfor



	


# Draw top box
procedure drawTopBox
	demo Select outer viewport... 0 100 60 100
	demo Draw inner box
	demo select Matrix windowedChunk
	demo Black
	demo Draw rows... 0 0 0 0 0 0
	demo Marks bottom... 6 yes yes yes
	demo Marks left... 6 yes yes yes
	tstr$ = "Black original; Red lagged by "+fixed$(iLag,0)+" samples"
	demo Text top... no 'tstr$'
	demo Text bottom... yes Time from start time (s)
endproc



# Draw lagged signal
procedure drawLaggedSignal
	demo select Matrix shiftedWindowedChunk
	demo Red
	demo Draw rows... 0 0 0 0 0 0
endproc

# Draw crossProdVec
procedure drawCrossProdVec
	demo Select outer viewport... 0 100 33 60
	demo Draw inner box

	select Matrix crossProdVec
	demo Green
	demo Draw rows... 0 0 0 0 0 0
	demo Marks bottom... 6 yes yes yes
	demo Marks left... 6 yes yes yes
	demo Text top... no Cross product at each sample point

endproc
# Draw Autocor
procedure drawAutocor
	demo Select outer viewport... 0 100 0 33
	demo Draw inner box
	demo select Matrix autocor
	demo Navy
	demo Draw rows... 0 0 0 0 0 0
	demo Marks bottom... 6 yes yes yes
	demo Marks left... 6 yes yes yes
	demo Text top... no Autocorrelation (unnormalized)
	demo Text bottom... yes Lag in samples
endproc