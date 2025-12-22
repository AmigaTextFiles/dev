/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0

      =================================================

      Source:     stools.e
      Description:    sample tools - mpeg decoder, cdda reader, tools
      Contains:   sample editor tools
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT PREPROCESS,MODULE

MODULE '*declarations','muimaster','libraries/mui','tools/boopsi'
MODULE '*gui_declarations','*common','utility/hooks','tools/installhook'
MODULE '*global','mpega','libraries/mpega','exec/memory'


      DEF mpstream:PTR TO mpega_stream

      DEF mpegok

      EXPORT DEF rxm,rxr


      EXPORT DEF _mpeg:PTR TO objw_mpegdecoder

      DEF mptype, mpstereo, mpstart, mpend
      DEF mpegrate

EXPORT PROC mpeggetfile(x)
      DEF len
      DEF mpctrl:mpega_ctrl
      DEF mpstream:PTR TO mpega_stream

      mpegok:=FALSE
      mpstream:=NIL
      CDEBUG(MPEG: File selected \s,x)

      set(_mpeg.chstereo,MUIA_Disabled,FALSE)

      IF mpegabase=0
            mpegabase:=OpenLibrary ('mpega.library',2)
            IF mpegabase=0
                  mpstream:=0
                  mpegrefreshgui(0)
                  err(ERR_MPEGA)
                  RETURN
            ENDIF
            CDEBUG(MPEG: mpega.library v2+ opened at \h,mpegabase)
      ENDIF

      /*IF mpstream
            CDEBUG(MPEG: mpeg stream closed,0)
            Mpega_close(mpstream)
            mpstream:=NIL
      ENDIF*/


      len:=FileLength(x)
      IF len=-1
            mpegrefreshgui(0)
            err(ERR_NOTFOUND)
            RETURN
      ENDIF

      mpctrl.bs_access:=NIL
      mpctrl.layer_1_2.force_mono:=0
      mpctrl.layer_1_2.mono.freq_div:=1
      mpctrl.layer_1_2.mono.quality:=2
      mpctrl.layer_1_2.mono.freq_max:=0
      mpctrl.layer_1_2.stereo.freq_div:=1
      mpctrl.layer_1_2.stereo.quality:=2
      mpctrl.layer_1_2.stereo.freq_max:=0
      mpctrl.layer_3.force_mono:=0
      mpctrl.layer_3.mono.freq_div:=1
      mpctrl.layer_3.mono.quality:=2
      mpctrl.layer_3.mono.freq_max:=0
      mpctrl.layer_3.stereo.freq_div:=1
      mpctrl.layer_3.stereo.quality:=2
      mpctrl.layer_3.stereo.freq_max:=0
      mpctrl.check_mpeg:=0
      mpctrl.stream_buffer_size:=32768

      mpstream:=Mpega_open(x,mpctrl)
      IF mpstream=0
            mpegrefreshgui(0)
            err(ERR_MPSTREAM)
            RETURN
      ENDIF
      CDEBUG(MPEG: mpeg audio stream opened at \h,mpstream)
      mpegok:=TRUE
      mpegrefreshgui(mpstream)
      mpegrate:=mpstream.frequency
      IF mpstream.mode=MPEGA_MODE_MONO
            set(_mpeg.chstereo,MUIA_Selected,FALSE)
            set(_mpeg.chstereo,MUIA_Disabled,MUI_TRUE)
      ENDIF
      CDEBUG(MPEG: mpeg stream closed,0)
      Mpega_close(mpstream)
      mpstream:=NIL
ENDPROC


EXPORT PROC mpegflushstuff()

mpegok:=FALSE
/*IF mpstream
      Mpega_close(mpstream)
      mpstream:=NIL
      CDEBUG(MPEG: MPEG stream closed,0)
ENDIF*/
ENDPROC


PROC mpegrefreshgui(mpstream:PTR TO mpega_stream)
      DEF mode

      IF mpstream
            settas(_mpeg.txlayer, '%ld',mpstream.layer)
            settas(_mpeg.txbitrate, '%ld kbps',mpstream.bitrate)
            settas(_mpeg.txfreq, '%ld Hz',mpstream.frequency)
            settas(_mpeg.txduration, '%ld sec',Div(mpstream.ms_duration,1000))

            mode:=mpstream.mode
            SELECT mode
                  CASE MPEGA_MODE_STEREO
                        set(_mpeg.txmode,MUIA_Text_Contents,'Stereo')
                  CASE MPEGA_MODE_J_STEREO
                        set(_mpeg.txmode,MUIA_Text_Contents,'J-Stereo')
                  CASE MPEGA_MODE_DUAL
                        set(_mpeg.txmode,MUIA_Text_Contents,'Dual')
                  CASE MPEGA_MODE_MONO
                        set(_mpeg.txmode,MUIA_Text_Contents,'Mono')
            ENDSELECT

            set(_mpeg.btstart,MUIA_Disabled,FALSE)
            ->set(_mpeg.btabort,MUIA_Disabled,FALSE)

            set(_mpeg.slstart,MUIA_Slider_Level,0)
            set(_mpeg.slstart,MUIA_Slider_Max,Div(mpstream.ms_duration,1000))
            set(_mpeg.slend,MUIA_Slider_Level,0)
            set(_mpeg.slend,MUIA_Slider_Max,Div(mpstream.ms_duration,1000))

      ELSE
            mpstart:=0;mpend:=0
            set(_mpeg.txlayer,MUIA_Text_Contents,NIL)
            set(_mpeg.txbitrate,MUIA_Text_Contents,NIL)
            set(_mpeg.txfreq,MUIA_Text_Contents,NIL)
            set(_mpeg.txmode,MUIA_Text_Contents,NIL)
            set(_mpeg.txduration,MUIA_Text_Contents,NIL)
            
            set(_mpeg.slstart,MUIA_Slider_Level,0)
            set(_mpeg.slstart,MUIA_Slider_Max,0)
            set(_mpeg.slend,MUIA_Slider_Level,0)
            set(_mpeg.slend,MUIA_Slider_Max,0)
            set(_mpeg.btstart,MUIA_Disabled,MUI_TRUE)
            ->set(_mpeg.btabort,MUIA_Disabled,MUI_TRUE)

      ENDIF
      updatememory()
ENDPROC


EXPORT PROC mpegparam(p,x)

      SELECT p
            CASE MPTYPE
                  mptype:=x
                  updatememory()
            CASE MPSTEREO
                  mpstereo:=x
                  updatememory()
            CASE MPSTART
                  mpstart:=x
                  IF mpstart>mpend
                        mpend:=mpstart
                        nset(_mpeg.slend,MUIA_Numeric_Value,mpend)
                  ENDIF
                  updatememory()
            CASE MPEND
                  IF x<mpstart
                        x:=mpstart
                        nset(_mpeg.slend,MUIA_Numeric_Value,x)
                  ENDIF
                  mpend:=x
                  updatememory()
      ENDSELECT

ENDPROC

PROC updatememory()
      DEF length,coef
      IF mpegok
            IF mptype
                  IF mpstereo THEN coef:=Shl(mpegrate,2) ELSE coef:=Shl(mpegrate,1)
            ELSE
                  IF mpstereo THEN coef:=Shl(mpegrate,1) ELSE coef:=mpegrate
            ENDIF
            length:=Mul((mpend-mpstart),coef)
            settas(_mpeg.txmemory,'%ld kB',Div(length,1000))
      ELSE
            set(_mpeg.txmemory,MUIA_Text_Contents,NIL)
      ENDIF
ENDPROC

EXPORT PROC mpeginit()
      mptype:=MUI_TRUE
      mpstereo:=MUI_TRUE
      mpstart:=0
      mpend:=0
ENDPROC

EXPORT PROC mpegdecode(slot) HANDLE
      DEF buffer=0,buflen,pcm1=0,pcm2=0,pcmlen,dur,start,stop,coef,res
      DEF scount,buffer2,cpos
      DEF name,percentage,frames
      DEF mpctrl:mpega_ctrl
      DEF mpstream:PTR TO mpega_stream
      DEF oldperc

      mpstream:=NIL

      start:=Mul(mpstart,1000);stop:=Mul(mpend,1000)
      dur:=stop-start
      IF dur=0 THEN RETURN


      mpctrl.bs_access:=NIL
      IF mpstereo
            mpctrl.layer_1_2.force_mono:=0
            mpctrl.layer_3.force_mono:=0
      ELSE
            mpctrl.layer_1_2.force_mono:=1
            mpctrl.layer_3.force_mono:=1
      ENDIF

      mpctrl.layer_1_2.mono.freq_div:=1
      mpctrl.layer_1_2.mono.quality:=2
      mpctrl.layer_1_2.mono.freq_max:=0
      mpctrl.layer_1_2.stereo.freq_div:=1
      mpctrl.layer_1_2.stereo.quality:=2
      mpctrl.layer_1_2.stereo.freq_max:=0
      
      mpctrl.layer_3.mono.freq_div:=1
      mpctrl.layer_3.mono.quality:=2
      mpctrl.layer_3.mono.freq_max:=0
      mpctrl.layer_3.stereo.freq_div:=1
      mpctrl.layer_3.stereo.quality:=2
      mpctrl.layer_3.stereo.freq_max:=0
      mpctrl.check_mpeg:=0
      mpctrl.stream_buffer_size:=32768

      get(_mpeg.stfile,MUIA_String_Contents,{name})

      mpstream:=Mpega_open(name,mpctrl)
      IF mpstream=0
            mpegrefreshgui(0)
            mpegok:=FALSE
            err(ERR_MPSTREAM)
            RETURN
      ENDIF

      CDEBUG(MPEG: mpeg audio stream opened at \h,mpstream)

      

      IF mptype
                  IF mpstereo THEN coef:=Shl(mpstream.frequency,2) ELSE coef:=Shl(mpstream.frequency,1)
            ELSE
                  IF mpstereo THEN coef:=Shl(mpstream.frequency,1) ELSE coef:=mpstream.frequency
            ENDIF

      buflen:=Mul((mpend-mpstart),coef)
      pcmlen:=MPEGA_PCM_SIZE*2
      pcm1:=AllocVec(pcmlen,MEMF_PUBLIC)
      pcm2:=AllocVec(pcmlen,MEMF_PUBLIC)
      IF (pcm1=0) OR (pcm2=0) THEN Raise("NMEM")

      buffer:=AllocVec(buflen,MEMF_ANY)
      IF buffer=0 THEN Raise("NMEM")
      buffer2:=buffer

      res:=Mpega_seek(mpstream,start)
      IF res<0 THEN Raise("MERR")

      status('Decoding MPEG Audio file')
      sleep()
      set(_mpeg.gampeg,MUIA_Gauge_Current,0)
      set(_mpeg.gampeg,MUIA_Gauge_InfoText,'0%% done')
      frames:=0;oldperc:=0

      WHILE (scount:=Mpega_decode_frame(mpstream,[pcm1,pcm2]))>=0
            IF mptype
                  IF mpstereo
                        buffer2:=interleave16(pcm1,pcm2,scount,buffer2)
                  ELSE
                        CopyMem(pcm1,buffer2,Shl(scount,1))
                        buffer2:=buffer2+Shl(scount,1)

                  ENDIF
            ELSE
                  IF mpstereo
                        buffer2:=interleave8(pcm1,pcm2,scount,buffer2)
                  ELSE
                        buffer2:=copy16to8(pcm1,scount,buffer2)
                  ENDIF
            ENDIF
            res:=Mpega_time(mpstream,{cpos})
            IF res<0 THEN Raise("MERR")
            percentage:=Div(Mul(100,(cpos-start)),(stop-start))
            IF percentage<>oldperc
                  set(_mpeg.gampeg,MUIA_Gauge_Current,percentage)
                  set(_mpeg.gampeg,MUIA_Gauge_InfoText,'%ld%% done')
                  oldperc:=percentage
            ENDIF

            frames:=frames+scount
            EXIT cpos>=stop
      ENDWHILE

      set(_mpeg.gampeg,MUIA_Gauge_Current,0)
      set(_mpeg.gampeg,MUIA_Gauge_InfoText,NIL)
      
      icc([CG_SED,ICP_ADDSAMPLE,FilePart(name),buffer,frames,
            mptype,mpstereo,mpstream.frequency,slot])

      EXCEPT DO
            awake()
            sidle()
            SELECT exception
                  CASE "NMEM"
                        IF buffer THEN FreeVec(buffer)
                        errnomem()
                  CASE "MERR"
                        IF buffer THEN FreeVec(buffer)
                        err(ERR_FSTRUCT)
            ENDSELECT
            IF pcm1 THEN FreeVec(pcm1)
            IF pcm2 THEN FreeVec(pcm2)

            IF mpstream
                  CDEBUG(MPEG: mpeg stream closed,0)
                  Mpega_close(mpstream)
                  mpstream:=NIL
            ENDIF


ENDPROC


/* ------------------- change volume stuff --------------------- */

EXPORT PROC sschangevol(buf,len,vol,type)

      IF len=0 THEN RETURN
      IF vol=256 THEN RETURN

      IF type

            MOVE.L buf,A0
            MOVEQ.L #0,D2
            MOVE.L vol,D1

      cvl1: MOVE.W (A0),D0
            EXT.L D0
            LONG $4C010800    -> MULS.L D1,D0
            ASR.L #8,D0
            CMP.L #$00007fff,D0
            BLE cv1a
            MOVE.L #$00007fff,D0
      cv1a: CMP.L #$ffff8000,D0
            BGE cv1b
            MOVE.L #$ffff8000,D0
      cv1b: MOVE.W D0,(A0)+
            ADDQ.L #2,D2
            CMP.L len,D2
            BNE cvl1
      ELSE
            MOVE.L buf,A0
            MOVEQ.L #0,D2
            MOVE.L vol,D1

      cvl2: MOVE.B (A0),D0
            EXT.W D0
            EXT.L D0
            LONG $4C010800    -> MULS.L D1,D0
            ASR.L #8,D0
            CMP.L #$0000007f,D0
            BLE cv2a
            MOVE.L #$0000007f,D0
      cv2a: CMP.L #$ffffff80,D0
            BGE cv2b
            MOVE.L #$ffffff80,D0
      cv2b: MOVE.B D0,(A0)+
            ADDQ.L #1,D2
            CMP.L len,D2
            BNE cvl2
      ENDIF
ENDPROC


