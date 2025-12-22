/*
**
**  	Public Version
**
**	$VER: DumpCue 1.0 (01.12.97) by Kenneth "Kenny" Nilsen
**
**	Supports: TLC1, TYPE [Audio|AREXX], SAMP, EVNT chunks
**
**		Dumps the chunks in a Studio 16 cuelist file and formats
**		It's content.
**
**	NOTE: Arexx is slow on file I/O so you may have to wait a while
**	while dumping. A trick is to redirect the output to a tmp file:
**
**	 1> rx DumpCue <file> >ram:cuefile.tmp
**	 1> more ram:cuefile.tmp
*/

/*===========================================================================*/
DumpTLC1 = 1	/* 1 = dump info on chunk,  0 = don't dump info */
DumpTYPE = 1
DumpSAMP = 1
DumpEVNT = 1
DumpDATA = 1
/*===========================================================================*/

options results failat 31
parse arg filename

signal on Break_C

lf='0a'x
dlf=lf||lf

if (filename = '?' | filename="") then do
	say 'Usage: <Studio16 cuelist>'
	exit(5)
	end

if ~open('han', filename, 'R') then do
	say 'Failed to open file "'filename'"'
	exit(10)
	end

header=readch('han',4)

if header~="TLC1" then do
	say 'File is not a Studio 16 cuefile...'
	call close('han')
	exit(5)
	end

/* Read HEADER (TLC1) */

header=readch('han',16)

	trackpath   = readch('han',c2d(readch('han',4)))
	cuelistpath = readch('han',c2d(readch('han',4)))
	trackname   = readch('han',c2d(readch('han',4)))
	cuelistname = readch('han',c2d(readch('han',4)))

	if right(trackpath,1)~=":" then
		if right(trackpath,1)~="/" then trackpath=trackpath"/"

	if right(cuelistpath,1)~=":" then
		if right(cuelistpath,1)~="/" then cuelistpath=cuelistpath"/"

say "Cuelist prefs:"
say "------------------------------------------------------------------------"
say "     Cuelist: "cuelistpath||cuelistname
say "      Tracks: "trackpath||trackname||lf
say "      Header: 'TLC1' + "c2x(header)

if DumpTLC1 = 0 then call seek('han',1990,'C')
else do
	skip=c2x(readch('han',6))

	fadein=c2x(readch('han',1))
		if fadein=0 then fadein="LINEAR"
		if fadein=1 then fadein="NONE"
		if fadein=2 then fadein="LOGA IN"
		if fadein=4 then fadein="EXPO IN"

	fadeout=c2x(readch('han',1))
		if fadeout=0 then fadeout="LINEAR"
		if fadeout=1 then fadeout="NONE"
		if fadeout=2 then fadeout="LOGA OUT"
		if fadeout=4 then fadeout="EXPO OUT"

	call ftoi
	maxtime=result
	call ftoi
	grid=result
	call ftoi
	start=result
	totlen=c2d(readch('han',4))/100
	viewlen=c2d(readch('han',4))/100

	inview=c2x(readch('han',4))

	BPM=c2d(readch('han',4))
	BPMx=c2d(readch('han',4))
	BPMy=c2d(readch('han',4))

	Timer=c2x(readch('han',4))
		if timer=0 then timer="Hours Minutes Seconds"
		if timer=1 then timer="SMPTE"
		if timer=2 then timer="BPM"
		if timer=4 then timer="SMPTE PLUS"

	call seek('han',122,'c')

	say lf"TLC1 Preferences:"
	say "------------------------------------------------------------------------"
	if DumpDATA=1 then
	say " PREFS:      DATA(6): 0x"left(skip,8)" ("x2d(left(skip,8))")  0x"right(skip,4)" ("x2d(right(skip,2))")"
	say " PREFS:  FadeIn type: "fadein
	say " PREFS: FadeOut type: "fadeout
	say " PREFS: Maximum time: "maxtime" s"
	say " PREFS: Grid spacing: "grid" s"
	say " PREFS:    Starttime: "start" s"
	say " PREFS:  Totallength: "totlen" s"
	say " PREFS:     Viewsize: "viewlen" s"
	say " PREFS:       Inview: 0x"Inview" ("x2d(Inview)")"
	say " PREFS:          BPM: "bpm" ("bpmx"/"bpmy")"
	say " PREFS:        Timer: "timer||lf

/* List F flags */

	do i=1 to 10
		call ftoi
		mark=result
		Inview=c2d(readch('han',4))
		if inview="-1" then inview="OUTSIDE VIEW" else
			inview="IN VIEW"
		comment=readch('han',80)
		call seek('han',30,'c')
		if mark~="-1.0000" then do
			say "     F"right(i,2,'0')" mark position: "mark" s  ("Inview")"
			say "               Comment: "comment
			end
		end

/* Red location mark */

	call ftoi
	mark=result
	Inview=c2d(readch('han',4))
		if inview="-1" then inview="OUTSIDE VIEW" else
			inview="IN VIEW"
	comment=readch('han',80)
	if mark~="-1.0000" then do
		say "Location mark position: "mark" s  ("Inview")"
		say "               Comment: "comment
		end

/* show ASCII */

	say "   ASCII Location time: "readch('han',30)

/* list other flags */

	call ftoi
	mark=result
	Inview=c2d(readch('han',4))
	if inview="-1" then inview="OUTSIDE VIEW" else
		inview="IN VIEW"
	comment=readch('han',80)
	call seek('han',30)
	if mark~="-1.0000" then do
		say "   Start mark position: "mark" s  ("Inview")"
		say "               Comment: "comment
		end

	call ftoi
	mark=result
	Inview=c2d(readch('han',4))
	comment=readch('han',80)
	call seek('han',30)
	if mark~="0.0000" then do
		say "              Punch In: "mark" s  (Inview="Inview")"
		say "               Comment: "comment
		end

	call ftoi
	mark=result
	Inview=c2d(readch('han',4))
	if inview="-1" then inview="OUTSIDE VIEW" else
		inview="IN VIEW"
	comment=readch('han',80)
	call seek('han',30)
	if mark~="0.0000" then do
		say "             Punch Out: "mark" s  ("Inview")"
		say "               Comment: "comment
		end

	call seek('han',100,'c')
	say "------------------------------------------------------------------------"lf

end


if (DumpTYPE+DumpSAMP+DumpEVNT=0) then do
	call close('han')
	exit 0
	end

/*===========================================================================*/
/* MAIN LOOP - get chunk by chunk ===========================================*/
/*===========================================================================*/

trackcount=0

do forever
	say "SEEKPOS: "seek('han',0,'C')
	type=readch('han',4);say type
		if type="END!" then call GetEND
		if type="TYPE" then call GetTYPE
		if type="SAMP" then call GetSAMP
		if type="EVNT" then call GetEVNT
		end

/*===========================================================================*/

/*===========================================================================*/
GetSAMP:
	state=c2x(readch('han',4))
		if state="0" then state="NOEXIST"
		if state="1" then state="NOEXIST + SELECTED"
		if state="2" then state="OK"
		if state="3" then state="OK + SELECTED"

	call ftoi;startpos=result
	call ftoi;endpos=result

	data=c2x(readch('han',4))
	group=c2d(readch('han',4))

	samplepath=readch('han',c2d(readch('han',4)))

	data1=c2x(readch('han',2))

	fadein=c2x(readch('han',1))
		if fadein=0 then fadein="LINEAR"
		if fadein=1 then fadein="NONE"
		if fadein=2 then fadein="LOGA IN"
		if fadein=4 then fadein="EXPO IN"

	fadeout=c2x(readch('han',1))
		if fadeout=0 then fadeout="LINEAR"
		if fadeout=1 then fadeout="NONE"
		if fadeout=2 then fadeout="LOGA OUT"
		if fadeout=4 then fadeout="EXPO OUT"

	call ftoi;fadeintime=result
	call ftoi;fadeouttime=result

	regstart=c2d(readch('han',4));regend=c2d(readch('han',4))

	volume=c2d(readch('han',2))/32-100
	pan=c2d(readch('han',4))/32

	if pan<100 then pan=(pan-100)*-1;pant="LEFT ("pan" dB)"
	if pan>100 then pant="RIGHT ("pan-100" dB)"
	if pan=0 then pant="FULL LEFT"
	if pan=100 then pant="CENTER"
	if pan=200 then pant="FULL RIGHT"

	data2=c2x(readch('han',32))
	data3=c2x(readch('han',18))

	if DumpSAMP=1 then do

	ex="ERR";if open('sam',samplepath,'R') then do
			fid=readch('sam',4)
			if fid='KWK3' then ex="OK"
			call close('sam')
			end

	say "       TRACK NO: "trackcount
	say "      SAMPLE NO: "samplecount
	say "  Sample status: "state
	say "      START POS: "startpos" s"
	say "        END POS: "endpos" s"
	if DumpDATA=1 then
	say "       DATA (4): 0x"data
	say "       Group ID: "group
	say "Samplepath/name: "samplepath" ("ex")"
	if DumpDATA=1 then
	say "       DATA (2): 0x"data1
	say "  Fade-in  type: "fadein
	say "  Fade-out type: "fadeout
	say "  Fade-in  time: "fadeintime" s"
	say "  Fade-out time: "fadeouttime" s"
	say "   Region start: "regstart" samples"
	say "   Region   end: "regend" samples"
	say "         Volume: "volume" dB"
	say "            Pan: "pant
	if DumpDATA=1 then do
	say "     DATA  0-31: "left(data2,16)" "substr(data2,17,16)" "substr(data2,33,16)" "substr(data2,49,16)
	say "     DATA 32-50: "left(data3,16)" "substr(data3,17,16)" "substr(data3,33,4)
	end
	say "------------------------------------------------------------------------------------"
	samplecount=samplecount+1
	end

	return 0

/*===========================================================================*/
GetTYPE:
	samplecount=1

	tracktype=readch('han',c2d(readch('han',4)))
	trackname=readch('han',c2d(readch('han',4)))

	if tracktype="Audio" then do
		call ftoi;data=result

		flag=readch('han',1)
		unsel=""
		if bittst(flag,0)=1 then unsel="REGIONNAME+"
		if bittst(flag,1)=1 then unsel=unsel"STARTTIME+"
		if bittst(flag,2)=1 then unsel=unsel"SAMPLESIZE+"
		if bittst(flag,3)=1 then unsel=unsel"FADETIMES"
		if unsel="" then unsel="NONE" else
			if right(unsel,1)="+" then unsel=left(unsel,length(unsel)-1)

		flag=readch('han',1)
		sel=""
		if bittst(flag,0)=1 then sel="REGIONNAME+"
		if bittst(flag,1)=1 then sel=sel"STARTTIME+"
		if bittst(flag,2)=1 then sel=sel"SAMPLESIZE+"
		if bittst(flag,3)=1 then sel=sel"FADETIMES"
		if sel="" then sel="NONE" else
			if right(sel,1)="+" then sel=left(sel,length(sel)-1)

		flag=readch('han',1)
		track=""
		if bittst(flag,0)=1 then track="SOUND+"
		if bittst(flag,1)=1 then track=track"SOLO+"
		if bittst(flag,2)=1 then track=track"TRACK"
		if track="" then track="NONE" else
			if right(track,1)="+" then track=left(track,length(track)-1)

		flag=readch('han',1)
		entry="NO SELECTED ENTRIES"
		if bittst(flag,1)=1 then entry="SELECTED ENTRIES"
	
		playchan=readch('han',c2d(readch('han',4)))
		recchan=readch('han',c2d(readch('han',4)))
		data1=c2x(readch('han',32));data2=c2x(readch('han',32))
		data3=c2x(readch('han',32));data4=c2x(readch('han',4))
		end
	else do
		portname=readch('han',c2d(readch('han',4)))
		data1=c2x(readch('han',32));data2=c2x(readch('han',32))
		data3=c2x(readch('han',32));data4=c2x(readch('han',8))
		end

	if DumpType=1 then do
	if tracktype="Audio" then do
	trackcount=trackcount+1
		say "       TRACK NO: "trackcount
		say "     Track type: "tracktype
		say "     Track name: "trackname
		say "      Frequency: "data" HZ"
		say "Show Unselected: "unsel
		say "  Show Selected: "sel
		say "  Track contain: "entry
		say "      Play chan: "playchan
		say "       Rec chan: "recchan
		if DumpDATA=1 then do
		say "     DATA  0-31: "left(data1,16)" "substr(data1,17,16)" "substr(data1,33,16)" "substr(data1,49,16)
		say "     DATA 32-63: "left(data2,16)" "substr(data2,17,16)" "substr(data2,33,16)" "substr(data2,49,16)
		say "     DATA 64-95: "left(data3,16)" "substr(data3,17,16)" "substr(data3,33,16)" "substr(data3,49,16)
		say "     DATA 96-99: "data4
		end
		say "------------------------------------------------------------------------------------"
		end
	else do
		say "       TRACK NO: "trackcount
		say "     Track type: "tracktype
		say "     AREXX name: "trackname
		say "     AREXX port: "portname
		if DumpDATA=1 then do
		say "    DATA  0- 31: "left(data1,16)" "substr(data1,17,16)" "substr(data1,33,16)" "substr(data1,49,16)
		say "    DATA 32- 63: "left(data2,16)" "substr(data2,17,16)" "substr(data2,33,16)" "substr(data2,49,16)
		say "    DATA 64- 95: "left(data3,16)" "substr(data3,17,16)" "substr(data3,33,16)" "substr(data3,49,16)
		say "    DATA 96-103: "data4
		end
		say "------------------------------------------------------------------------------------"
		end
	end

	return 0

/*===========================================================================*/
GetEND:
	type=readch('han',4)
	say type
	if type="END!" then do
		call close('han')
		exit(0)
		end

	return 0

/*===========================================================================*/
GetEVNT:
	state=c2x(readch('han',4))
		if state="0" then state="UNSELECTED"
		if state="1" then state="SELECTED"

	call ftoi;startpos=result
	call ftoi;endpos=result

	dataA=c2x(readch('han',4))
	group=c2d(readch('han',4))
	dataB=c2x(readch('han',4))

	scriptpath.0=readch('han',c2d(readch('han',4)))

	Hour   = c2d(readch('han',1))
	Min    = c2d(readch('han',1))
	Sec    = c2d(readch('han',1))
	Frames = c2d(readch('han',1))

	do i=1 to 9;scriptpath.i=readch('han',c2d(readch('han',4)));end i

	data2=c2x(readch('han',32));data3=c2x(readch('han',18))

	if DumpEVNT=1 then do
	say "       TRACK NO: "trackcount
	say "       EVENT NO: "samplecount
	say "  Script status: "state
	say "      START POS: "startpos" s"
	say "        END POS: "endpos" s"
	say "       DATA (4): "dataA
	say "        GroupID: "group
	if DumpDATA=1 then
	say "       DATA (4): "dataB
	say "           Name: "scriptpath.0
	say "    SMPTE stamp: "right(hour,2,"0")":"right(min,2,"0")":"right(sec,2,"0")":"right(frames,2,"0")
	say "          Cmd 1: "scriptpath.1
	say "          Cmd 2: "scriptpath.2
	say "          Cmd 3: "scriptpath.3
	say "          Cmd 4: "scriptpath.4
	say "          Cmd 5: "scriptpath.5
	say "          Cmd 6: "scriptpath.6
	say "          Cmd 7: "scriptpath.7
	say "          Cmd 8: "scriptpath.8
	say "          Cmd 9: "scriptpath.9
	if DumpDATA=1 then do
	say "     DATA  0-31: "left(data2,16)" "substr(data2,17,16)" "substr(data2,33,16)" "substr(data2,49,16)
	say "     DATA 32-50: "left(data3,16)" "substr(data3,17,16)" "substr(data3,33,4)
	end
	say "------------------------------------------------------------------------------------"
	samplecount=samplecount+1
	end

	return 0
/*===========================================================================*/
Break_C:
	if han~=0 then call close('han')
	exit(5)

FtoI:
        float1=c2x(readch('han',4))
        float2=c2x(readch('han',4))

	if (float1='BFF00000' & float2='00000000') then return '-1.0000'
	if (float1='CFF00000' & float2='00000000') then return '0.0000'

        address command "Float2Int $"float1" $"float2" >t:f2i.tmp"
        if ~open('ihan', 't:f2i.tmp', 'R') then return 0
        value=readln('ihan');call close('ihan')

	return value
