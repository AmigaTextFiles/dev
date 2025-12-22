/******************************************************************
*								  *
*	mpeg.e	V1.1  06.09.2000  by Rainer "No.3" Müller         *
*								  *
*  an example how to use mpega.library with the Amiga E Language  *
*								  *
*  compile: ec mpeg						  *
*								  *
*  use: mpeg ?	for list of options				  *
*								  *
*								  *
*  changes to:							  *
*								  *
*    V1.0  05.03.2000  fixed a machine crashing bug, when	  *
*		       running mpeg without arguments		  *
*		       checks for OS2.0+			  *
*								  *
******************************************************************/


MODULE	     'dos/dos',     'dos/rdargs',
	    'exec/memory',
       'libraries/mpega',       'mpega'


ENUM ER_NONE, ER_NOMEM, ER_BADARGS, ER_NOMPEGALIB, ER_NOMPEG, ER_NOOPEN, ER_NOWRITE, ER_MPEG, ER_NOKICK


RAISE ER_NOMEM IF AllocVec()=NIL
RAISE ER_MPEG  IF Mpega_decode_frame()<-1
RAISE ER_MPEG  IF Mpega_time	    ()<-1



PROC main() HANDLE
DEF	  buffer[MPEGA_MAX_CHANNELS]:ARRAY OF LONG    -> use as ARRAY OF PTR TO INT
DEF	  buf1=NIL:PTR	 TO INT
DEF	  buf2=NIL:PTR	 TO INT
DEF    outbuf =NIL:PTR	 TO INT
DEF	  file=NIL
DEF	myargs=NIL:PTR	 TO LONG
DEF	rdargs=NIL:PTR	 TO rdargs
DEF mpegstream=NIL:PTR	 TO mpega_stream
DEF mpegctrl	  :	    mpega_ctrl
DEF qual[1]	  :ARRAY OF LONG
DEF fdiv[1]	  :ARRAY OF LONG
DEF frames    =NIL
DEF count, curpos, mono, pos, i

   IF KickVersion(37)=NIL THEN Raise(ER_NOKICK)

   FOR i:=0 TO MPEGA_MAX_CHANNELS-1 DO buffer[i]:=NIL	-> save is better than sorry :-)

-> **************** read and set arguments

   qual[]:=2
   fdiv[]:=1
   myargs:=[0,0,qual,fdiv,0]

   IF (rdargs:=ReadArgs('InputFile/A,OutputFile/A,Quality/N,FreqDiv/N,ForceMono/S', myargs, NIL))=NIL THEN Raise(ER_BADARGS)

   qual:=myargs[2]
   fdiv:=myargs[3]
   mono:=IF myargs[4] THEN 1 ELSE 0

   IF (qual[] < 0) OR (2 < qual[])               THEN Raise(ER_BADARGS)
   IF (fdiv[] < 1) OR (4 < fdiv[]) OR (3 = fdiv) THEN Raise(ER_BADARGS)


-> **************** get and initialize mpega.library, get memory and files

   IF (mpegabase := OpenLibrary('mpega.library',2))=NIL THEN Raise(ER_NOMPEGALIB)

      mpegctrl.bs_access		:=NIL	    -> NIL for default access (file I/O) or give your own bitstream access
      mpegctrl.layer_1_2.force_mono	:=mono	    -> 1 to decode stereo stream in mono, 0 otherwise
      mpegctrl.layer_1_2.mono.freq_div	:=fdiv[]    -> 1, 2 or 4
      mpegctrl.layer_1_2.mono.quality	:=qual[]    -> 0 (low) .. 2 (high)
      mpegctrl.layer_1_2.mono.freq_max	:=48000     -> for automatic freq_div (if mono_freq_div = 0)
      mpegctrl.layer_1_2.stereo.freq_div:=fdiv[]
      mpegctrl.layer_1_2.stereo.quality :=qual[]
      mpegctrl.layer_1_2.stereo.freq_max:=48000
      mpegctrl.layer_3.force_mono	:=mono
      mpegctrl.layer_3.mono.freq_div	:=fdiv[]
      mpegctrl.layer_3.mono.quality	:=qual[]
      mpegctrl.layer_3.mono.freq_max	:=48000
      mpegctrl.layer_3.stereo.freq_div	:=fdiv[]
      mpegctrl.layer_3.stereo.quality	:=qual[]
      mpegctrl.layer_3.stereo.freq_max	:=48000
      mpegctrl.check_mpeg		:=1	  -> 1 to check for mpeg audio validity at start of stream, 0 otherwise
      mpegctrl.stream_buffer_size	:=0	  -> size of bitstream buffer in bytes (must be multiple of 4) (0 -> default size)

   IF (mpegstream:=Mpega_open(myargs[0],mpegctrl))=NIL THEN Raise(ER_NOMPEG)

   FOR i:=0 TO MPEGA_MAX_CHANNELS-1
      buffer[i]:=AllocVec( Mul(MPEGA_PCM_SIZE,  2) , MEMF_CLEAR OR MEMF_PUBLIC )
   ENDFOR

      outbuf   :=AllocVec( Mul(MPEGA_PCM_SIZE,2*2) , MEMF_CLEAR OR MEMF_PUBLIC )

   buf1:=buffer[0]
   buf2:=buffer[1]

   IF (file:=Open(myargs[1],MODE_NEWFILE))=NIL THEN Raise(ER_NOOPEN)


-> **************** print out some information about the file

   WriteF('norm      \d\n',       mpegstream.norm)
   WriteF('layer     \d\n',       mpegstream.layer)
   WriteF('mode      \d -> ',     mpegstream.mode)
   i:=mpegstream.mode
   SELECT i
      CASE MPEGA_MODE_STEREO;	WriteF('stereo \n')
      CASE MPEGA_MODE_J_STEREO; WriteF('joint stereo\n')
      CASE MPEGA_MODE_DUAL;	WriteF('dual\n')
      CASE MPEGA_MODE_MONO;	WriteF('mono\n')
   ENDSELECT
   WriteF('bitrate   \d kbps\n',  mpegstream.bitrate)
   WriteF('frequency \d Hz\n',    mpegstream.frequency)
   WriteF('channels  \d\n',       mpegstream.channels)
   WriteF('duration  \d ms\n',    mpegstream.ms_duration)
   WriteF('\n')
   WriteF('dec channels  \d\n',   mpegstream.dec_channels)
   WriteF('dec quality   \d -> ', mpegstream.dec_quality)
   i:=mpegstream.dec_quality
   SELECT i
      CASE MPEGA_QUALITY_LOW;	 WriteF('low quality\n')
      CASE MPEGA_QUALITY_MEDIUM; WriteF('medium quality\n')
      CASE MPEGA_QUALITY_HIGH;	 WriteF('high quality\n')
   ENDSELECT
   WriteF('dec frequency \d Hz\n',mpegstream.dec_frequency)


-> **************** start devoding

   WHILE (count:=Mpega_decode_frame(mpegstream,buffer))>=0
      pos:=0

      IF mpegstream.dec_channels=1
	 FOR i:=0 TO count-1
	    outbuf[pos++] := buf1[i]
	 ENDFOR

	 IF Write(file, outbuf, Mul(count,2)) <> Mul(count,2) THEN Raise(ER_NOWRITE)

      ELSE
	 FOR i:=0 TO count-1
	    outbuf[pos++] := buf1[i]
	    outbuf[pos++] := buf2[i]
	 ENDFOR

	 IF Write(file, outbuf, Mul(count,4)) <> Mul(count,4) THEN Raise(ER_NOWRITE)
      ENDIF

      frames:=frames+count

       count:=Mpega_time(mpegstream,{curpos})
      WriteF('\d%\n',Div(Mul(curpos,100),mpegstream.ms_duration))
   ENDWHILE

   WriteF('\nframes: \d\n\n',frames)


EXCEPT DO
   IF file   THEN Close  (file)
   IF outbuf THEN FreeVec(outbuf)

   FOR i:=0 TO MPEGA_MAX_CHANNELS-1
      IF buffer[i] THEN FreeVec(buffer[i])
   ENDFOR

   IF mpegstream THEN Mpega_close (mpegstream)
   IF mpegabase  THEN CloseLibrary(mpegabase)
   IF rdargs	 THEN FreeArgs	  (rdargs)

   SELECT exception
      CASE ER_NONE;	  WriteF('all ok\n')
      CASE ER_NOMPEGALIB; WriteF('no mpega.library V2+\n')
      CASE ER_NOMPEG;	  WriteF('no mpeg file/stream\n')
      CASE ER_NOMEM;	  WriteF('no memory\n')
      CASE ER_NOOPEN;	  WriteF('could not open output file\n')
      CASE ER_NOWRITE;	  WriteF('write error\n')
      CASE ER_MPEG;	  WriteF('mpeg-decode error: ')
			  SELECT count
			  /* CASE MPEGA_ERR_EOF;      WriteF('end of file reached\n') */
			     CASE MPEGA_ERR_BADFRAME; WriteF('badframe\n')
			     CASE MPEGA_ERR_MEM;      WriteF('memory\n')
			     CASE MPEGA_ERR_NO_SYNC;  WriteF('no sync\n')
			  ENDSELECT
      CASE ER_BADARGS;	  WriteF('bad args\n')
      CASE ER_NOKICK;	  WriteF('Kickstart V37+ required\n')
   ENDSELECT
ENDPROC


