
/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     songs.e
      Description:    song related stuff
      Contains:   song editor,song dsp,song options,song menu
                  section editor
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT MODULE
OPT PREPROCESS
OPT LARGE


MODULE '*declarations','muimaster','libraries/mui','tools/boopsi','devices/inputevent'
MODULE '*gui_declarations','*common','utility/hooks','tools/installhook'
MODULE 'libraries/asl','*adst:dsp/dummy','*global'

EXPORT OBJECT obj_sglist OF obj_gss
ENDOBJECT


EXPORT OBJECT obj_songdata
      PRIVATE
      tempo:INT
      leftvol:INT
      rightvol:INT
      transpose:INT
      dspflag:CHAR
ENDOBJECT


EXPORT OBJECT obj_song OF obj_base
      data:obj_songdata
      PRIVATE
      annotation[64]:ARRAY
      ndsp:CHAR -> lenghth OF dsp sequence
      nsection:CHAR   -> length of section sequence
      dsps[16]:ARRAY OF obj_dspid
      sections[64]:ARRAY OF obj_sectionid
ENDOBJECT


            DEF cursongp:PTR TO obj_song
            EXPORT DEF sgl:PTR TO obj_sglist

            EXPORT DEF upd

            EXPORT DEF cfg:PTR TO obj_cfg
            EXPORT DEF mdata:PTR TO obj_mdata
            EXPORT DEF changed      -> bool
            EXPORT DEF songs  -> songs present


            EXPORT DEF sections -> sections present
            EXPORT DEF cursectp:PTR TO obj_section  
            EXPORT DEF cursect -> NUMBER of current section(not an ID)

            DEF secttbuf:PTR TO LONG -> tracklist copy buffer
            DEF secttbuflen          -> len of ...


            EXPORT DEF _main:PTR TO objw_maincontrol
            EXPORT DEF _appm:PTR TO obj_appmenu
            EXPORT DEF _sels:PTR TO objw_selectsong
            EXPORT DEF _sged:PTR TO objw_songeditor
            EXPORT DEF _sgop:PTR TO objw_songoptions
            EXPORT DEF _sdsp:PTR TO objw_songdsp
            EXPORT DEF _mopt:PTR TO objw_moduleoptions
            EXPORT DEF _info:PTR TO objw_info
            EXPORT DEF _sect:PTR TO objw_sectioneditor



-> ----------------------------------------------  SONGLIST SECTON

EXPORT PROC setactive(pos) OF obj_sglist

SUPER self.setactive(pos)
IF pos=-1
      cursongp:=NIL
      set(_main.btselect,MUIA_Disabled,MUI_TRUE)
      set(_main.btplay,MUIA_Disabled,MUI_TRUE)
      set(_main.btsongeditor,MUIA_Disabled,MUI_TRUE)
      set(_main.btcontinue,MUIA_Disabled,MUI_TRUE)
      set(_appm.deletecurrent,MUIA_Menuitem_Enabled,FALSE)
      set(_appm.smakeclone,MUIA_Menuitem_Enabled,FALSE)
      set(_appm.sedit,MUIA_Menuitem_Enabled,FALSE)
      set(_appm.soptions,MUIA_Menuitem_Enabled,FALSE)
      set(_appm.stranspose,MUIA_Menuitem_Enabled,FALSE)
      set(_appm.sdsp,MUIA_Menuitem_Enabled,FALSE)
      set(_sdsp.base,MUIA_Window_Open,FALSE)
      set(_sged.base,MUIA_Window_Open,FALSE)
      set(_sgop.base,MUIA_Window_Open,FALSE)
      set(_sels.btoptions,MUIA_Disabled,MUI_TRUE)
      set(_sels.btedit,MUIA_Disabled,MUI_TRUE)
      set(_sels.btdelete,MUIA_Disabled,MUI_TRUE)
      set(_sels.btdeleteall,MUIA_Disabled,MUI_TRUE)
      set(_info.txcursong,MUIA_Text_Contents,NIL)
      ->set(_info.txtempo,MUIA_Text_Contents,NIL)
ELSE
      IF cursongp=NIL
            set(_main.btselect,MUIA_Disabled,FALSE)
            set(_main.btplay,MUIA_Disabled,FALSE)
            set(_main.btsongeditor,MUIA_Disabled,FALSE)
            set(_main.btcontinue,MUIA_Disabled,FALSE)

            set(_appm.deletecurrent,MUIA_Menuitem_Enabled,MUI_TRUE)
            set(_appm.smakeclone,MUIA_Menuitem_Enabled,MUI_TRUE)
            set(_appm.sedit,MUIA_Menuitem_Enabled,MUI_TRUE)
            set(_appm.soptions,MUIA_Menuitem_Enabled,MUI_TRUE)
            set(_appm.stranspose,MUIA_Menuitem_Enabled,MUI_TRUE)
            set(_appm.sdsp,MUIA_Menuitem_Enabled,MUI_TRUE)

            set(_sels.btoptions,MUIA_Disabled,FALSE)
            set(_sels.btedit,MUIA_Disabled,FALSE)
            set(_sels.btdelete,MUIA_Disabled,FALSE)
            set(_sels.btdeleteall,MUIA_Disabled,FALSE)
      ENDIF
      cursongp:=self.getp(pos)
ENDIF
      nset(_sels.lvsongs,MUIA_List_Active,pos)
ENDPROC

EXPORT PROC add(what:PTR TO obj_song) OF obj_sglist
      DEF tmp:PTR TO obj_song

      tmp:=SUPER self.add(what)
      IF tmp
            domethod(_sels.lvsongs,[MUIM_List_InsertSingle,
         tmp.getname(),MUIV_List_Insert_Bottom]) ->activeentrry gets validated
            self.setactive(self.entries-1)
      ENDIF
ENDPROC tmp


EXPORT PROC newentry() OF obj_sglist
      DEF temp:PTR TO obj_song

      IF self.max=self.entries THEN RETURN FALSE -> no room
      NEW temp.create()
ENDPROC self.add(temp)


EXPORT PROC freeone(p:PTR TO obj_song) OF obj_sglist
DEF j,b1:PTR TO obj_dspid,b2:PTR TO obj_dsp
      -> free ALL dsp handles
      FOR j:=0 TO p.ndsp-1
                  b1:=p.dsps[j]
                  b2:=mdata.dsplist[b1.linkedid]
                  dummybase:=b2.base
                  Dsp_freehandle(b1.handle)
            ENDFOR
      END p
ENDPROC


EXPORT PROC delentry(pos) OF obj_sglist
      
      SUPER self.delentry(pos)
      domethod(_sels.lvsongs,[MUIM_List_Remove,pos]) -> act valid
      
ENDPROC

EXPORT PROC delall() OF obj_sglist

      domethod(_sels.lvsongs,[MUIM_List_Clear])
      SUPER self.delall()
ENDPROC


EXPORT PROC renam(pos,name) OF obj_sglist

      SUPER self.renam(pos,name)
      domethod(_sels.lvsongs,[MUIM_List_Redraw,pos])
ENDPROC
-> ----------------------------------------------  SONG SECTION


-> constructor
EXPORT PROC create() OF obj_song
      SUPER self.create()
      AstrCopy(self.annotation,'I''m Just A Song',64)
      self.data.tempo:=120
      self.data.leftvol:=256
      self.data.rightvol:=256
ENDPROC

EXPORT PROC activate() OF obj_song
      DEF i

      SUPER self.activate()
      IF upd
            nset(_info.txcursong,MUIA_Text_Contents,self.getname())
            nset(_sgop.stname,MUIA_String_Contents,self.getname())
            nset(_sgop.stannotation,MUIA_String_Contents,self.getparam(SGANNOT))
            nset(_sgop.sltempo,MUIA_Slider_Level,self.getparam(SGTEMPO))
            nset(_sgop.sltranspose,MUIA_Slider_Level,self.getparam(SGTRNSPS))
            nset(_sgop.slleft,MUIA_Slider_Level,self.getparam(SGLEFTVOL))
            nset(_sgop.slright,MUIA_Slider_Level,self.getparam(SGRIGHTVOL))
            nset(_sgop.chusedsp,MUIA_Selected,self.getparam(SGDSPFLG))
            icc([CG_SYSTEM,IC_UPDATEINFO])

      -> update song's dsp list
      domethod(_sdsp.lvdspsequence,[MUIM_List_Clear])
      listq(_sdsp.lvdspsequence)
      FOR i:=0 TO self.ndsp-1
      domethod(_sdsp.lvdspsequence,[MUIM_List_InsertSingle,
            self.dsps[i],MUIV_List_Insert_Bottom])
      ENDFOR
      listnq(_sdsp.lvdspsequence)
      nset(_sdsp.lvdspsequence,MUIA_List_Active,MUIV_List_Active_Top)

      -> update song's section sequence
      refreshsectseq()
      ENDIF
ENDPROC

EXPORT PROC setparam(pl:PTR TO LONG) OF obj_song
      DEF p,x

      p:=pl[0];x:=pl[1]

      SELECT p
            CASE SGANNOT
                  AstrCopy(self.annotation,x,64)
                  IF upd THEN nset(_sgop.stannotation,MUIA_String_Contents,self.annotation)
            CASE SGTEMPO
                  self.data.tempo:=x
                  IF upd
                        nset(_sgop.sltempo,MUIA_Slider_Level,self.data.tempo)
                        icc([CG_SYSTEM,IC_UPDATEINFO])
                  ENDIF
            CASE SGLEFTVOL
                  self.data.leftvol:=x
                  IF upd THEN nset(_sgop.slleft,MUIA_Slider_Level,self.data.leftvol)
            CASE SGRIGHTVOL
                  self.data.rightvol:=x
                  IF upd THEN nset(_sgop.slright,MUIA_Slider_Level,self.data.rightvol)
            CASE SGTRNSPS
                  self.data.transpose:=x
                  IF upd THEN nset(_sgop.sltranspose,MUIA_Slider_Level,self.data.transpose)
            CASE SGDSPFLG
                  self.data.dspflag:=x
                  IF upd THEN nset(_sgop.chusedsp,MUIA_Selected,self.data.dspflag)
     ENDSELECT
ENDPROC

EXPORT PROC getparam(p) OF obj_song

      SELECT p
            CASE SGANNOT
                  RETURN self.annotation
            CASE SGTEMPO
                  RETURN self.data.tempo
            CASE SGLEFTVOL
                  RETURN self.data.leftvol
            CASE SGRIGHTVOL
                  RETURN self.data.rightvol
            CASE SGTRNSPS
                  RETURN self.data.transpose
            CASE SGDSPFLG
                  RETURN self.data.dspflag
     ENDSELECT
ENDPROC -1

EXPORT PROC setname(x) OF obj_song
      SUPER self.setname(x)
      IF upd
            nset(_sgop.stname,MUIA_String_Contents,self.getname())
      ENDIF
ENDPROC


-> --------------------------- SELECT SONG WINDOW



            /* song related menu */


      


EXPORT PROC pfm_smakeclone(hook,obj,msg)
DEF temp:PTR TO obj_song,temp2:PTR TO obj_song
DEF temps[32]:STRING
DEF b1:PTR TO obj_dspid,b2:PTR TO obj_dsp,i,h
/*
      IF songs=16
            error('Too many songs requested')
            RETURN
      ENDIF
      temp2:=cursongp
      NEW temp
      mdata.songlist[songs]:=temp
      mdata.cursong:=songs
      cursongp:=temp
      CopyMem(temp2,temp,SIZEOF obj_song)
      StrCopy(temps,temp.name,ALL)
      StrAdd(temps,'.cloned',ALL)
      AstrCopy(temp.name,temps,32)

      -> validate DSP handles
      FOR i:=0 TO cursongp.ndsp-1
            b1:=cursongp.dsps[i]
            b2:=mdata.dsplist[b1.linkedid]
            dummybase:=b2.base
            h:=Dsp_allochandle()
            EXIT h=-1
            b1.handle:=h
      ENDFOR      

      IF h=-1
            error('DSP PlugIn: Can''t get more handles')
            cursongp.ndsp:=0
      ENDIF
            

      domethod(_sels.lvsongs,[MUIM_List_InsertSingle,
            temp.name,MUIV_List_Insert_Bottom])
      set(_sels.lvsongs,MUIA_List_Active,mdata.cursong)
      INC songs
      setchanged(TRUE)

EXCEPT

      IF exception="MEM"
            errnomem()
      ELSE
            errunknown()
      ENDIF
      setchanged(TRUE)
      */
ENDPROC




                  /* section editor stuff   */



EXPORT PROC initsectionstuff()  -> called from main source,init
      cursect:=0
      cursectp:=NIL
      sections:=0
      secttbuflen:=0
      NEW secttbuf[64]
      sections_update()
ENDPROC


PROC sections_new() HANDLE
DEF i
DEF temp:PTR TO obj_section
DEF str[20]:STRING


      IF sections=256 
            error('Too many sections requested')
            RETURN
      ENDIF
      FOR i:=0 TO 255 DO EXIT mdata.seclist[i]=NIL -> finds the free slot
      NEW temp
      StringF(str,'Unnamed (\z\h[2])',i)
      AstrCopy(temp.name,str,32)
      temp.nline:=0
      
      mdata.seclist[i]:=temp
      mdata.secl[sections]:=i
      cursect:=sections
      cursectp:=temp
      INC sections
      

      sections_update()
      refreshsectlist()
      setchanged(TRUE)  
EXCEPT

IF exception="MEM" THEN  errnomem()
      
ENDPROC
      
      
PROC sections_update()
DEF str[20]:STRING
DEF str2:PTR TO CHAR
DEF templ:PTR TO obj_sectionline
DEF i


      cursectp:=mdata.seclist[mdata.secl[cursect]]
      
      StringF(str,'\d/\d',cursect,sections)
      set(_sect.txslot,MUIA_Text_Contents,str)
      domethod(_sect.lv1,[MUIM_List_Clear])
      domethod(_sect.lv2,[MUIM_List_Clear])

      IF cursectp=NIL
            set(_sect.stname,MUIA_String_Contents,NIL)
            nset(_sged.lvsectionlist2,MUIA_List_Active,MUIV_List_Active_Off)
            
      ELSE
            set(_sect.stname,MUIA_String_Contents,cursectp.name)
            
            listq(_sect.lv1)
            FOR i:=0 TO cursectp.nline-1
                        domethod(_sect.lv1,[MUIM_List_InsertSingle,updatepositionstring(i),
                                    MUIV_List_Insert_Bottom])
            ENDFOR
            listnq(_sect.lv1)
            set(_sect.lv1,MUIA_List_Active,MUIV_List_Active_Top)
            nset(_sged.lvsectionlist2,MUIA_List_Active,cursect)
      ENDIF
ENDPROC           


PROC sect_del()
DEF i,j
DEF templ:PTR TO obj_sectionline
DEF str:PTR TO CHAR
DEF songp:PTR TO obj_song
DEF sgid,flag

      IF cursectp
            flag:=FALSE
            FOR i:=0 TO songs-1
                  songp:=mdata.songlist[i]
                  IF songp
                        FOR j:=0 TO songp.nsection-1
                              sgid:=songp.sections[j].linkedid
                              flag:=sgid=mdata.secl[cursect]
                              EXIT flag
                        ENDFOR
                  ENDIF
                  EXIT flag
            ENDFOR
            IF flag
                  error('This section is still used in some song(s)')
                  RETURN
            ENDIF


            FOR i:=0 TO cursectp.nline-1
                  templ:=cursectp.lines[i]
                  str:=templ.flv
                  END str[16]
                  END templ
            ENDFOR
            END cursectp
            mdata.seclist[mdata.secl[cursect]]:=NIL
            IF cursect<(sections-1)
                  FOR i:=cursect+1 TO sections-1 DO mdata.secl[i-1]:=mdata.secl[i]
            ELSE
                  DEC cursect
            ENDIF
            DEC sections
            IF sections=0 THEN cursect:=0
            sections_update()
            refreshsectlist()
            setchanged(TRUE)
      ENDIF
ENDPROC 
                  
            
PROC sect_newpos() HANDLE
DEF temp:PTR TO obj_sectionline
DEF str:PTR TO CHAR

      IF cursectp=NIL THEN RETURN
      IF cursectp.nline=256 
            error('Too many lines in the section')
            RETURN
      ENDIF
      NEW temp
      NEW str[16]
      temp.flv:=str
      temp.repeat:=1
      cursectp.lines[cursectp.nline]:=temp
      cursectp.nline:=cursectp.nline+1
      sections_update()
      setchanged(TRUE)        
EXCEPT

IF exception="MEM" THEN  errnomem()
ENDPROC


PROC sect_delpos()
DEF temp:PTR TO obj_sectionline
DEF e,i
DEF str:PTR TO CHAR

      IF cursectp=NIL THEN RETURN
      get(_sect.lv1,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      temp:=cursectp.lines[e]
      IF temp=NIL THEN RETURN

      str:=temp.flv
      END str[16]
      END temp

      FOR i:=e+1 TO cursectp.nline-1 DO cursectp.lines[i-1]:=cursectp.lines[i]
      cursectp.nline:=cursectp.nline-1
      sections_update()
      setchanged(TRUE)  
ENDPROC



PROC sect_inspos() HANDLE
DEF temp:PTR TO obj_sectionline
DEF e,i
DEF str:PTR TO CHAR

      IF cursectp=NIL THEN RETURN
      get(_sect.lv1,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN     
      IF cursectp.nline=256 
            error('Too many lines in the section')
            RETURN
      ENDIF
      NEW temp
      NEW str[16]
      temp.flv:=str
      temp.repeat:=1

      FOR i:=cursectp.nline-1 TO e STEP -1 DO cursectp.lines[i+1]:=cursectp.lines[i]


      cursectp.lines[e]:=temp
      cursectp.nline:=cursectp.nline+1
      sections_update()
      setchanged(TRUE)  

EXCEPT

IF exception="MEM" THEN  errnomem()

ENDPROC




PROC updatepositionstring(entry)
DEF templ:PTR TO obj_sectionline
DEF str[20]:STRING
DEF str2:PTR TO CHAR

      templ:=cursectp.lines[entry]
      str2:=templ.flv
      StringF(str,'\z\d[3]:\z\d[2]',entry,templ.repeat)
      AstrCopy(str2,str,16)

ENDPROC str2   -> returns the updated position string



PROC sect_viewtracks(e)
DEF templ:PTR TO obj_sectionline
->DEF trk:PTR TO obj_track
DEF i
/*
    domethod(_sect.lv2,[MUIM_List_Clear])
      IF e=MUIV_List_Active_Off THEN RETURN
      IF cursectp=NIL THEN RETURN
      templ:=cursectp.lines[e]
      IF templ
            listq(_sect.lv2)
            FOR i:=0 TO templ.ntrack-1
                  trk:=mdata.tracklist[templ.tracks[i]]
                  IF trk
                        domethod(_sect.lv2,[MUIM_List_InsertSingle,
                  trk.dummy,MUIV_List_Insert_Bottom])
                  ELSE
                        domethod(_sect.lv2,[MUIM_List_InsertSingle,
                  '<EMPTY TRACK>',MUIV_List_Insert_Bottom])
                  ENDIF
            ENDFOR            
            listnq(_sect.lv2)
      ENDIF
  */
ENDPROC


PROC sect_addtracks()
DEF e1,e2,i,l,trkn,id,j,flag
DEF templ:PTR TO obj_sectionline
/*DEF trk:PTR TO obj_track

      IF cursectp=NIL THEN RETURN
      get(_sect.lv1,MUIA_List_Active,{e1})
      IF e1=MUIV_List_Active_Off THEN RETURN
      get(_sect.lv3,MUIA_List_Active,{e2})
      templ:=cursectp.lines[e1]
      IF templ=NIL THEN RETURN

      id:=MUIV_List_NextSelected_Start
      domethod(_sect.lv3,[MUIM_List_NextSelected,{id}])
      WHILE id<>MUIV_List_NextSelected_End
            IF templ.ntrack>=64 THEN error('Too many tracks used in the section')
            EXIT templ.ntrack>=64
            l:=0
            FOR i:=0 TO 255 
                  IF mdata.tracklist[i]  
                        IF id=l THEN trkn:=i
                        INC l
                  ENDIF
            ENDFOR
            flag:=TRUE
            FOR j:=0 TO templ.ntrack-1 DO IF templ.tracks[j]=trkn THEN flag:=FALSE
            IF flag 
                  templ.tracks[templ.ntrack]:=trkn
                  templ.ntrack:=templ.ntrack+1
            ENDIF
            domethod(_sect.lv3,[MUIM_List_NextSelected,{id}])
      ENDWHILE

      sect_viewtracks(e1)*/
ENDPROC



PROC sect_deltracks()
DEF e,i,id
DEF templ:PTR TO obj_sectionline
                  

      IF cursectp=NIL THEN RETURN
      get(_sect.lv1,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN

      templ:=cursectp.lines[e]
      IF templ=NIL THEN RETURN

      id:=MUIV_List_NextSelected_Start
      domethod(_sect.lv2,[MUIM_List_NextSelected,{id}])
      WHILE id<>MUIV_List_NextSelected_End
            EXIT templ.ntrack=0
            FOR i:=id+1 TO templ.ntrack-1 DO templ.tracks[i-1]:=templ.tracks[i]
            templ.ntrack:=templ.ntrack-1
            domethod(_sect.lv2,[MUIM_List_NextSelected,{id}])
      ENDWHILE
      sect_viewtracks(e)
ENDPROC


PROC sect_tobuf()
DEF e,i
DEF templ:PTR TO obj_sectionline
                  
      IF cursectp=NIL THEN RETURN
      get(_sect.lv1,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN

      templ:=cursectp.lines[e]
      IF templ=NIL THEN RETURN

      secttbuflen:=templ.ntrack
      FOR i:=0 TO secttbuflen-1 DO secttbuf[i]:=templ.tracks[i]
      logit('Track list copied.')
ENDPROC     

PROC sect_frombuf()
DEF e,i,id
DEF templ:PTR TO obj_sectionline
                  
      IF cursectp=NIL THEN RETURN
      get(_sect.lv1,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN

      templ:=cursectp.lines[e]
      IF templ=NIL THEN RETURN

      IF secttbuflen=0
            error('Track list copy buffer empty')
            RETURN
      ENDIF
      templ.ntrack:=secttbuflen
      FOR i:=0 TO secttbuflen-1 DO templ.tracks[i]:=secttbuf[i]
      sect_viewtracks(e)
ENDPROC


EXPORT PROC f_sect_pressbutton(hook,obj,msg)
DEF templ:PTR TO obj_sectionline
DEF e


      SELECT obj

            CASE _sect.imleft
                  IF cursect>0 
                        DEC cursect
                        sections_update()
                  ENDIF
            CASE _sect.imright
                  IF cursect<(sections-1)
                        INC cursect
                        sections_update()
                  ENDIF 
            CASE _sect.btfirst
                  cursect:=0
                  sections_update()
            CASE _sect.btlast
                  IF sections>0
                        cursect:=sections-1
                        sections_update()
                  ENDIF
      

            CASE _sect.btnew  
            sections_new()
            CASE _sect.btdel
            sect_del()
            CASE _sect.stname
                  IF cursectp
                        AstrCopy(cursectp.name,^msg,32)
                        domethod(_sged.lvsectionlist2,[MUIM_List_Redraw,
                        MUIV_List_Redraw_Active])
                        refreshsectseq()
                  ENDIF
            



            CASE _sect.btnewpos
            sect_newpos()
            CASE _sect.rplus
                  IF cursectp
                  get(_sect.lv1,MUIA_List_Active,{e})
                  IF e<>MUIV_List_Active_Off
                  templ:=cursectp.lines[e]
                  IF templ 
                        templ.repeat:=templ.repeat+1
                        IF templ.repeat=17 THEN templ.repeat:=1
                        updatepositionstring(e)
                        domethod(_sect.lv1,[MUIM_List_Redraw,
                              MUIV_List_Redraw_Active])
                        setchanged(TRUE)
                  ENDIF
                  ENDIF
                  ENDIF
            CASE _sect.rminus
                  IF cursectp
                  get(_sect.lv1,MUIA_List_Active,{e})
                  IF e<>MUIV_List_Active_Off
                  templ:=cursectp.lines[e]
                  IF templ 
                        templ.repeat:=templ.repeat-1
                        IF templ.repeat=0 THEN templ.repeat:=16
                        updatepositionstring(e)
                        domethod(_sect.lv1,[MUIM_List_Redraw,
                              MUIV_List_Redraw_All])
                        setchanged(TRUE)
                  ENDIF
                  ENDIF
                  ENDIF
            CASE _sect.btdelpos
            sect_delpos()     
            CASE _sect.btinspos
            sect_inspos()



            CASE _sect.btaddtrack
            sect_addtracks()
            CASE _sect.btdeltrack
            sect_deltracks()
            CASE _sect.btclear
                  IF cursectp
                  get(_sect.lv1,MUIA_List_Active,{e})
                  IF e<>MUIV_List_Active_Off
                  templ:=cursectp.lines[e]
                  IF templ 
                        templ.ntrack:=0
                        sect_viewtracks(e)
                  ENDIF
                  ENDIF
                  ENDIF 
            CASE _sect.btcopy
            sect_tobuf()
            CASE _sect.btpaste
            sect_frombuf()
                  
      ENDSELECT
ENDPROC


EXPORT PROC f_sect_listactive(hook,obj,msg)

      
      SELECT obj
      CASE _sect.lv1
      sect_viewtracks(^msg)
      ENDSELECT
ENDPROC

EXPORT PROC f_sect_dragdrop(hook,obj,msg:PTR TO LONG)
DEF src,dest,i,srcp:PTR TO obj_sectionline

      IF cursectp=NIL THEN RETURN
        
      src:=msg[0]
      dest:=msg[1]
      IF src=dest THEN RETURN
      
      srcp:=cursectp.lines[src]
      FOR i:=src+1 TO cursectp.nline-1 DO cursectp.lines[i-1]:=cursectp.lines[i]
      IF dest>src THEN DEC dest
      IF dest<cursectp.nline
            FOR i:=cursectp.nline-2 TO dest STEP -1 DO cursectp.lines[i+1]:=cursectp.lines[i]
      ENDIF
      cursectp.lines[dest]:=srcp

      setchanged(TRUE)
      logit('Tracklist moved to new pos.')

ENDPROC







                  /* song editor stuff */









PROC refreshsectlist()
DEF i
DEF t:PTR TO obj_section


      domethod(_sged.lvsectionlist2,[MUIM_List_Clear])
      listq(_sged.lvsectionlist2)
      FOR i:=0 TO sections-1
            t:=mdata.seclist[mdata.secl[i]]
            domethod(_sged.lvsectionlist2,[MUIM_List_InsertSingle,
            t.name,MUIV_List_Insert_Bottom])
      ENDFOR      
      listnq(_sged.lvsectionlist2)
ENDPROC
      

PROC updateseqdummy(pos)
DEF t:PTR TO obj_section
DEF t2:PTR TO obj_sectionid
DEF s[50]:STRING

            t2:=cursongp.sections[pos]    
            t:=mdata.seclist[t2.linkedid]
            
            StringF(s,'\z\d[2],\z\d[3]',t2.repeat,t2.transpose)
            StrAdd(s,': ',ALL)
            StrAdd(s,t.name,ALL)          
            AstrCopy(t2.dummy,s,50)
ENDPROC t2.dummy




PROC refreshsectseq()
DEF i
DEF x:PTR TO CHAR

      IF cursongp=NIL THEN RETURN
      
      domethod(_sged.lvsectionlist,[MUIM_List_Clear])
      listq(_sged.lvsectionlist)

      FOR i:=0 TO cursongp.nsection-1
                  x:=updateseqdummy(i)
                  domethod(_sged.lvsectionlist,[MUIM_List_InsertSingle,
                  x,MUIV_List_Insert_Bottom])
      ENDFOR
      listnq(_sged.lvsectionlist)
      
ENDPROC


EXPORT PROC f_sged_listactive(hook,obj,msg:PTR TO LONG)
DEF e

      e:=^msg
      IF e=MUIV_List_Active_Off THEN RETURN

      cursect:=e
      sections_update()
ENDPROC     



PROC sged_add()
DEF e,s:PTR TO CHAR
DEF t2:PTR TO obj_sectionid

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist2,MUIA_List_Active,{e})
      IF cursongp.nsection=64
            error('Section sequence too large')
            RETURN
      ENDIF
      IF e=MUIV_List_Active_Off
            error('Select some section first')
            RETURN
      ENDIF
      
      t2:=cursongp.sections[cursongp.nsection]
      t2.repeat:=1
      t2.transpose:=0
      t2.linkedid:=mdata.secl[e]
      NEW s[50]
      t2.dummy:=s
      cursongp.nsection:=cursongp.nsection+1
      setchanged(TRUE)
      updateseqdummy(cursongp.nsection-1)
      domethod(_sged.lvsectionlist,[MUIM_List_InsertSingle,
      cursongp.sections[cursongp.nsection-1].dummy,MUIV_List_Insert_Bottom])
ENDPROC
      
PROC sged_delete()
DEF i,e,s:PTR TO CHAR

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN

      s:=cursongp.sections[e].dummy
      END s[50]

      FOR i:=e+1 TO cursongp.nsection-1 
            CopyMem(cursongp.sections[i],cursongp.sections[i-1],SIZEOF obj_sectionid)
            ENDFOR
                  
      cursongp.nsection:=cursongp.nsection-1
      setchanged(TRUE)
      domethod(_sged.lvsectionlist,[MUIM_List_Remove,MUIV_List_Remove_Active])
ENDPROC
      

PROC sged_delall()
DEF i,s:PTR TO CHAR
      
      IF cursongp=NIL THEN RETURN
      FOR i:=0 TO cursongp.nsection-1 
            s:=cursongp.sections[i].dummy
            END s[50]
      ENDFOR
      cursongp.nsection:=0
      
refreshsectseq()
      setchanged(TRUE)
ENDPROC
      


PROC sged_insert()
DEF e,e2,i,s:PTR TO CHAR
DEF t2:PTR TO obj_sectionid

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist,MUIA_List_Active,{e2})
      IF e2=MUIV_List_Active_Off THEN RETURN
      get(_sged.lvsectionlist2,MUIA_List_Active,{e})
      IF cursongp.nsection=64
            error('Section sequence too large')
            RETURN
      ENDIF
      IF e=MUIV_List_Active_Off
            error('Select some section first')
            RETURN
      ENDIF
      
      FOR i:=cursongp.nsection-1 TO e2 STEP -1 
            CopyMem(cursongp.sections[i],cursongp.sections[i+1],SIZEOF obj_sectionid)
      ENDFOR

      t2:=cursongp.sections[e2]
      t2.repeat:=1
      t2.transpose:=0
      t2.linkedid:=mdata.secl[e]
      NEW s[50]
      t2.dummy:=s
      cursongp.nsection:=cursongp.nsection+1
      setchanged(TRUE)
      updateseqdummy(e2)
      domethod(_sged.lvsectionlist,[MUIM_List_InsertSingle,
      cursongp.sections[e2].dummy,MUIV_List_Insert_Active])
ENDPROC


PROC sged_repplus()
DEF i,e,s

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      s:=cursongp.sections[e].repeat
      IF s=16 
            s:=1
      ELSE
            INC s
      ENDIF
      cursongp.sections[e].repeat:=s
      updateseqdummy(e)
      domethod(_sged.lvsectionlist,[MUIM_List_Redraw,MUIV_List_Redraw_Active])
ENDPROC     

PROC sged_repminus()
DEF i,e,s

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      s:=cursongp.sections[e].repeat
      IF s=1 
            s:=16
      ELSE
            DEC s
      ENDIF
      cursongp.sections[e].repeat:=s
      updateseqdummy(e)
      domethod(_sged.lvsectionlist,[MUIM_List_Redraw,MUIV_List_Redraw_Active])
ENDPROC     
      

PROC sged_transplus()
DEF i,e,s

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      s:=cursongp.sections[e].transpose
      IF s=16 
            s:=-16
      ELSE
            INC s
      ENDIF
      cursongp.sections[e].transpose:=s
      updateseqdummy(e)
      domethod(_sged.lvsectionlist,[MUIM_List_Redraw,MUIV_List_Redraw_Active])
ENDPROC     


PROC sged_transminus()
DEF i,e,s

      IF cursongp=NIL THEN RETURN
      get(_sged.lvsectionlist,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      s:=cursongp.sections[e].transpose
      IF s=-16 
            s:=16
      ELSE
            DEC s
      ENDIF
      cursongp.sections[e].transpose:=s
      updateseqdummy(e)
      domethod(_sged.lvsectionlist,[MUIM_List_Redraw,MUIV_List_Redraw_Active])
ENDPROC     


EXPORT PROC f_sged_pressbutton(hook,obj,msg:PTR TO LONG)
      
      SELECT obj

      CASE _sged.btadd
            sged_add()
      CASE _sged.btdelete
            sged_delete()
      CASE _sged.btdeleteall
            sged_delall()
      CASE _sged.btinsert
            sged_insert()
      CASE _sged.btrepeatplus
            sged_repplus()
      CASE _sged.btrepeatminus
            sged_repminus()
      CASE _sged.bttransposeplus
            sged_transplus()
      CASE _sged.bttransposeminus
            sged_transminus()
      ENDSELECT

ENDPROC


EXPORT PROC f_sged_dragdrop(hook,obj,msg:PTR TO LONG)
DEF src,dest,i,srcp:PTR TO obj_sectionid

      IF cursongp=NIL THEN RETURN
        
      src:=msg[0]
      dest:=msg[1]
      IF src=dest THEN RETURN
      
      NEW srcp
      CopyMem(cursongp.sections[src],srcp,SIZEOF obj_sectionid)

      FOR i:=src+1 TO cursongp.nsection-1 DO CopyMem(cursongp.sections[i],cursongp.sections[i-1],SIZEOF obj_sectionid)
      IF dest>src THEN DEC dest
      IF dest<cursongp.nsection
            FOR i:=cursongp.nsection-2 TO dest STEP -1 DO CopyMem(cursongp.sections[i],cursongp.sections[i+1],SIZEOF obj_sectionid)
      ENDIF
      CopyMem(srcp,cursongp.sections[dest],SIZEOF obj_sectionid)
      setchanged(TRUE)
      END srcp
      logit('Section order changed.')
      
ENDPROC

/* --------------------------------------------------------
                        ICI
*/


EXPORT PROC icisong(obj,ic,param:PTR TO LONG)
DEF tmp

      SELECT ic

            CASE IC_SPARAM
                  IF cursongp THEN cursongp.setparam(param)
                  CHANGED
            CASE IC_SETACTIVE
                  sgl.setactive(^param)
            CASE IC_NEXTSG
                  sgl.nextentry()
            CASE IC_PREVSG
                  sgl.preventry()
            CASE IC_SETSNAME
                  IF sgl.getactive()<>-1 THEN sgl.renam(sgl.getactive(),^param)
                  CHANGED
            CASE IC_DELSG
                  IF cursongp THEN sgl.delentry(sgl.getactive())
                  CHANGED
            CASE IC_DELALLSG
                  IF confirm('Are you sure to delete all songs?')
                        sgl.delall()
                        CHANGED
                  ENDIF
            CASE IC_NEWSG
                  tmp:=sgl.newentry()
                  IF tmp=0
                        error('Too many songs')
                  ELSE
                        CHANGED
                  ENDIF
            
            CASE IC_SETSNAME
                  cursongp.setname(^param)
                  CHANGED

      ENDSELECT
ENDPROC

