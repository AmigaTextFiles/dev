
/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     dsp.e
      Description:    dsp related stuff
      Contains:   dsp manager and dsp sequence editors
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT MODULE
OPT PREPROCESS


MODULE '*declarations','muimaster','libraries/mui','tools/boopsi'
MODULE '*gui_declarations','*common','utility/hooks','tools/installhook'
MODULE 'libraries/asl','*adst:dsp/dummy','*global'



            EXPORT DEF loadeddsps   -> no. of loaded DSPs
            EXPORT DEF cfg:PTR TO obj_cfg
            EXPORT DEF mdata:PTR TO obj_mdata
            EXPORT DEF changed      -> bool
            EXPORT DEF songs  -> songs present
            EXPORT DEF ts:PTR TO CHAR

            EXPORT DEF _appm:PTR TO obj_appmenu
            EXPORT DEF _sels:PTR TO objw_selectsong
            EXPORT DEF _sdsp:PTR TO objw_songdsp
            EXPORT DEF _tdsp:PTR TO objw_trackdsp
            EXPORT DEF _info:PTR TO objw_info
            EXPORT DEF _dspm:PTR TO objw_dspmanager
            


EXPORT PROC flush_all_dsp_plugins()  -> use for QUIT only!
DEF temp:PTR TO obj_dsp
DEF x:PTR TO obj_dspstatus
DEF i

      FOR i:=0 TO loadeddsps-1
            temp:=mdata.dsplist[mdata.dspl[i]]
            dummybase:=temp.base
            Dsp_shutdown()
            CloseLibrary(temp.base)
      ENDFOR
ENDPROC



                  /*  DSP MANAGER  */





EXPORT PROC pf_dm_load(hook,obj,msg) HANDLE
DEF req:PTR TO filerequester
DEF mywindow
DEF pathname[80]:STRING
DEF base,i
DEF temp:PTR TO obj_dsp
DEF temp2
DEF ss[32]:ARRAY

      IF loadeddsps=32
            error('Too many DSPs loaded')
            RETURN
      ENDIF
      get(_dspm.base,MUIA_Window_Window,{mywindow})
      req:=Mui_AllocAslRequest(ASL_FILEREQUEST,[ASLFR_WINDOW,mywindow,
           ASLFR_TITLETEXT,'Select DSP to load',
           ASLFR_INITIALDRAWER,cfg.defdspdir,
           ASLFR_INITIALPATTERN,'#?.dsp',
           ASLFR_DOPATTERNS,TRUE])
      IF req=NIL THEN RETURN
      sleep()
      IF Mui_AslRequest(req,NIL)
            StrCopy(pathname,req.drawer,ALL)
            AddPart(pathname,req.file,80)
            AstrCopy(ss,req.file,32)
            i:=InStr(ss,'.')
            IF i<>-1 THEN ss[i]:=0  
            FOR i:=0 TO loadeddsps-1 
                  temp:=mdata.dsplist[mdata.dspl[i]]
                  EXIT StrCmp(temp.name,ss,ALL)
            ENDFOR
            IF (temp) AND (StrCmp(temp.name,ss,ALL)) THEN Raise("DALD")
            IF (base:=OpenLibrary(pathname,0))=NIL THEN Raise("NDSP")

            NEW temp
            
            logit('Loading DSP PlugIn...')

            AstrCopy(temp.name,ss,32)
            temp.base:=base
            dummybase:=base
            temp.info:=Dsp_getinfo()
            FOR i:=0 TO 31 DO EXIT mdata.dsplist[i]=NIL
            mdata.dspl[loadeddsps]:=i
            mdata.dsplist[i]:=temp
            domethod(_dspm.lvdsps,[MUIM_List_InsertSingle,
                  temp.name,MUIV_List_Insert_Bottom])
            set(_dspm.lvdsps,MUIA_List_Active,MUIV_List_Active_Bottom)
            domethod(_sdsp.lvdsppool,[MUIM_List_InsertSingle,
                  temp.name,MUIV_List_Insert_Bottom])
            domethod(_tdsp.lvdsppool,[MUIM_List_InsertSingle,
                  temp.name,MUIV_List_Insert_Bottom])
            INC loadeddsps
      ENDIF
      awake()

EXCEPT 
      awake()     
   SELECT exception
     CASE "MEM"
     errnomem()
     CASE "NDSP"
     error('Unable to open requested DSP')
     CASE "MISC"
     errunknown()
     CASE "DALD"
     error('DSP already loaded')          
   ENDSELECT


         Mui_FreeAslRequest(req)
ENDPROC



EXPORT PROC f_dspm_active(hook,obj,msg:PTR TO LONG)
DEF e
DEF temp:PTR TO obj_dsp

      e:=^msg
      IF e=MUIV_List_Active_Off 
            set(_dspm.lvinfo2,MUIA_Floattext_Text,0)
            RETURN
      ENDIF
      temp:=mdata.dsplist[mdata.dspl[e]]
      set(_dspm.lvinfo2,MUIA_Floattext_Text,temp.info.info)
ENDPROC




EXPORT PROC pf_dm_flush(hook,obj,msg)
DEF k,i,temp:PTR TO obj_dspstatus
DEF l:PTR TO obj_dsp

      get (_dspm.lvdsps,MUIA_List_Active,{k})
      IF k=MUIV_List_Active_Off THEN RETURN
      l:=mdata.dsplist[mdata.dspl[k]]                       
      
      dummybase:=l.base
      temp:=Dsp_status()

      IF temp.handles>0 
            error('This DSP is still used somewhere')
            RETURN
      ENDIF

      mdata.dsplist[mdata.dspl[k]]:=NIL
      FOR i:=k+1 TO loadeddsps-1 DO mdata.dspl[i-1]:=mdata.dspl[i]
      DEC loadeddsps
      CloseLibrary(l.base)
      END l
      domethod(_dspm.lvdsps,[MUIM_List_Remove,k])
      domethod(_sdsp.lvdsppool,[MUIM_List_Remove,k])
      domethod(_tdsp.lvdsppool,[MUIM_List_Remove,k])
ENDPROC


EXPORT PROC pf_dm_flushall(hook,obj,msg)
DEF someused=0
DEF i
DEF temp:PTR TO obj_dsp
DEF temp2:PTR TO obj_dspstatus

      IF loadeddsps=0 THEN RETURN
      FOR i:=0 TO loadeddsps-1 
            temp:=mdata.dsplist[mdata.dspl[i]]
            dummybase:=temp.base
            temp2:=Dsp_status()
            IF temp2.handles>0 THEN someused:=TRUE
      ENDFOR

      IF someused
            error('Some of those DSPs is/are still used somewhere')
            RETURN
      ENDIF

      IF confirm('Are you sure to flush all DSPs ?')

            domethod(_dspm.lvdsps,[MUIM_List_Clear])
            domethod(_sdsp.lvdsppool,[MUIM_List_Clear])
            domethod(_tdsp.lvdsppool,[MUIM_List_Clear])
            FOR i:=0 TO 31
                  temp:=mdata.dsplist[i]
                  IF temp
                        CloseLibrary(temp.base)
                        END temp
                        mdata.dsplist[i]:=NIL
                        ENDIF
            ENDFOR
            loadeddsps:=0
      ENDIF
ENDPROC





-> -------------------- SONG DSP SEQUENCE window


/*
PROC update_songseqlist()
DEF i,cp

      domethod(_sdsp.lvdspsequence,[MUIM_List_Clear])
      listq(_sdsp.lvdspsequence)
      FOR i:=0 TO icc([CG_SONG,IC_NDSP])-1
            domethod(_sdsp.lvdspsequence,[MUIM_List_InsertSingle,
                 cursongp.dsps[i],MUIV_List_Insert_Bottom])
      ENDFOR
      listnq(_sdsp.lvdspsequence)
ENDPROC
  */


/*
EXPORT PROC pf_dspe_add(hook,obj,msg) HANDLE
DEF k,i
DEF temp:PTR TO obj_dsp
DEF temp2:PTR TO obj_dspid
DEF handle
DEF t1:PTR TO obj_dspinfo


      get(_sdsp.lvdsppool,MUIA_List_Active,{k})
      IF k=MUIV_List_Active_Off THEN RETURN
      IF cursongp.ndsp=16
            error('DSP sequence too long')
            RETURN
      ENDIF

      temp2:=     cursongp.dsps[cursongp.ndsp]  
      clrmem(temp2,SIZEOF obj_dspid)
      
      temp2.cmdassign:=255
      temp2.linkedid:=mdata.dspl[k]
      

      temp:=mdata.dsplist[mdata.dspl[k]]

      dummybase:=temp.base

      t1:=Dsp_getinfo()
      i:=0
      WHILE t1.pnames[i]
            temp2.params[i].offset:=t1.pminvals[i]
            temp2.params[i].coef:=256
            temp2.params[i].lfo.period:=50
            i++
      ENDWHILE    

      handle:=Dsp_allochandle()
      IF handle=-1 THEN Raise("NHND")
      
      temp2.handle:=handle
   
      

      domethod(_sdsp.lvdspsequence,[MUIM_List_InsertSingle,
      temp2,MUIV_List_Insert_Bottom])
      set(_sdsp.lvdspsequence,MUIA_List_Active,cursongp.ndsp)
      
      cursongp.ndsp:=cursongp.ndsp+1

      setchanged(TRUE)
EXCEPT

      IF exception="MEM"
            errnomem()
      ELSEIF exception="NHND"
            error('DSP-Plugin Error: Initialization Failed')      
      ELSE
            errunknown()
      ENDIF

ENDPROC
  */

/*
EXPORT PROC pf_dspe_insert(hook,obj,msg) HANDLE
DEF k,l,i,m
DEF tempid:PTR TO obj_dspid
DEF temp:PTR TO obj_dsp
DEF t1:PTR TO obj_dspinfo

      get(_sdsp.lvdsppool,MUIA_List_Active,{k})
      get(_sdsp.lvdspsequence,MUIA_List_Active,{l})

      IF (k=MUIV_List_Active_Off) OR (l=MUIV_List_Active_Off) THEN RETURN
      IF cursongp.ndsp=16
            error('DSP sequence too long')
            RETURN
      ENDIF

      FOR i:=cursongp.ndsp-1 TO l STEP -1 DO CopyMem(cursongp.dsps[i],cursongp.dsps[i+1],SIZEOF obj_dspid)
      tempid:=cursongp.dsps[l]
      clrmem(tempid,SIZEOF obj_dspid)

      tempid.cmdassign:=255
      tempid.linkedid:=mdata.dspl[k]

      temp:=mdata.dsplist[mdata.dspl[k]]
      dummybase:=temp.base

      t1:=Dsp_getinfo()
      i:=0
      WHILE t1.pnames[i]
            tempid.params[i].offset:=t1.pminvals[i]
            tempid.params[i].coef:=256
            tempid.params[i].lfo.period:=50
            i++
      ENDWHILE    


      tempid.handle:=Dsp_allochandle()
      IF tempid.handle=-1 THEN Raise("NHND")
   
      
      cursongp.ndsp:=cursongp.ndsp+1
      update_songseqlist()
      set(_sdsp.lvdspsequence,MUIA_List_Active,l)
      setchanged(TRUE)

EXCEPT

      IF exception="MEM"
            errnomem()
      ELSEIF exception="NHND"
            error('DSP-Plugin Error: Initialization Failed')      
      ELSE
            errunknown()
      ENDIF

ENDPROC

  */
/*
EXPORT PROC pf_dspe_delete(hook,obj,msg)
DEF k
DEF l,i
DEF temp:PTR TO obj_dsp
DEF tempid:PTR TO obj_dspid

      get(_sdsp.lvdspsequence,MUIA_List_Active,{k})
      IF k=MUIV_List_Active_Off THEN RETURN

      tempid:=cursongp.dsps[k]
      l:=tempid.linkedid
      temp:=mdata.dsplist[l]
      dummybase:=temp.base
      Dsp_freehandle(tempid.handle)

   FOR i:=k+1 TO cursongp.ndsp-1 DO CopyMem(cursongp.dsps[i],
     cursongp.dsps[i-1],SIZEOF obj_dspid)
   cursongp.ndsp:=cursongp.ndsp-1
      update_songseqlist()
setchanged(TRUE)
ENDPROC
  */
/*
EXPORT PROC pf_dspe_delall(hook,obj,msg)
DEF i,l
DEF temp:PTR TO obj_dsp
DEF tempid:PTR TO obj_dspid


      IF cursongp.ndsp=0 THEN RETURN
      IF confirm('Are you sure to delete whole dsp sequence?')
      FOR i:=0 TO cursongp.ndsp-1 
            tempid:=cursongp.dsps[i]
            l:=tempid.linkedid
            temp:=mdata.dsplist[l]
            dummybase:=temp.base
            Dsp_freehandle(tempid.handle)       
      ENDFOR
     cursongp.ndsp:=0
     domethod(_sdsp.lvdspsequence,[MUIM_List_Clear])
   ENDIF
setchanged(TRUE)
ENDPROC
  */




EXPORT PROC sdsp_disphook(hovno,array:PTR TO LONG,entry:PTR TO obj_dspid)

DEF temp:PTR TO obj_dsp
DEF s[4]:STRING

      IF entry
            StringF(s,'\d[2]',array[-1]+1)
            AstrCopy(entry.dummy,s,4)
            ^array++:=entry.dummy
            temp:=mdata.dsplist[entry.linkedid]
            ^array++:=temp.name
            IF entry.cmdassign<255
                  StringF(s,'#\d[1]',entry.cmdassign)
                  AstrCopy(entry.dummy2,s,4)
                  ^array++:=entry.dummy2
            ELSE
                  ^array++:='N/A'
            ENDIF
      ELSE
            ^array++:='\e8POS'
            ^array++:='\e8NAME'
            ^array++:='\e8CTRL #'
      ENDIF
ENDPROC

/*
PROC sdsp_action2(obj,msg)   -> parameter event
DEF e,f,a
DEF p:PTR TO obj_dspparam

      a:=^msg
      IF cursongp=0 THEN RETURN
      get(_sdsp.lvdspsequence,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      get(_sdsp.lvparams,MUIA_List_Active,{f})
      IF f=MUIV_List_Active_Off THEN RETURN
      p:=cursongp.dsps[e].params[f]

      SELECT obj
      CASE _sdsp.sloffset
            nset(_sdsp.stoffset,MUIA_String_Integer,a)
            p.offset:=a
      CASE _sdsp.stoffset
            get(_sdsp.stoffset,MUIA_String_Integer,{a})     
            set(_sdsp.sloffset,MUIA_Numeric_Value,a)
      CASE _sdsp.slcoef
            nset(_sdsp.stcoef,MUIA_String_Integer,a)
            p.coef:=a
      CASE _sdsp.stcoef
            get(_sdsp.stcoef,MUIA_String_Integer,{a}) 
            set(_sdsp.slcoef,MUIA_Numeric_Value,a)
      CASE _sdsp.sllfoper
            p.lfo.period:=a
      CASE _sdsp.chtempo
            p.tempof:=a
      CASE _sdsp.chlfo
            p.lfof:=a
      CASE _sdsp.chlfotempo
            p.lfo.bylines:=a
      CASE _sdsp.cylfotype
            p.lfo.type:=a
      ENDSELECT
      setchanged(TRUE)
ENDPROC
  */
/*
EXPORT PROC sdsp_action(hook,obj,msg)
DEF e
      SELECT obj

      CASE _sdsp.cyccassign
            get(_sdsp.lvdspsequence,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  IF ^msg=0
                        cursongp.dsps[e].cmdassign:=255
                  ELSE
                        cursongp.dsps[e].cmdassign:=^msg-1
                  ENDIF
                  domethod(_sdsp.lvdspsequence,[MUIM_List_Redraw,MUIV_List_Redraw_Active])
                  setchanged(TRUE)
            ENDIF
            
      CASE _sdsp.chforce
            get(_sdsp.lvdspsequence,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  cursongp.dsps[e].affects:=^msg
                  setchanged(TRUE)
            ENDIF
            
      ENDSELECT
      sdsp_action2(obj,msg)
ENDPROC     
  */
/*
PROC sdsp_l1active(pos)
DEF temp:PTR TO obj_dspid
DEF t1:PTR TO obj_dsp
DEF t2:PTR TO obj_dspinfo
DEF pnames:PTR TO LONG

      IF cursongp=NIL THEN RETURN

      IF pos=MUIV_List_Active_Off
            nset(_sdsp.cyccassign,MUIA_Cycle_Active,0)
            set(_sdsp.txparam,MUIA_Text_Contents,NIL)
            domethod(_sdsp.lvparams,[MUIM_List_Clear])
            nset(_sdsp.chforce,MUIA_Selected,FALSE)
            
      ELSE
            temp:=cursongp.dsps[pos]
            nset(_sdsp.chforce,MUIA_Selected,temp.affects)
            IF temp.cmdassign=255
                  nset(_sdsp.cyccassign,MUIA_Cycle_Active,0)
            ELSE
                  nset(_sdsp.cyccassign,MUIA_Cycle_Active,temp.cmdassign+1)
            ENDIF
            t1:=mdata.dsplist[temp.linkedid]
            dummybase:=t1.base
            t2:=Dsp_getinfo()
            pnames:=t2.pnames
            
            nset(_sdsp.lvparams,MUIA_List_Active,MUIV_List_Active_Off)
            listq(_sdsp.lvparams)
            domethod(_sdsp.lvparams,[MUIM_List_Clear])
            WHILE pnames[]
                  domethod(_sdsp.lvparams,[MUIM_List_InsertSingle,pnames[]++,MUIV_List_Insert_Bottom])
            ENDWHILE
            listnq(_sdsp.lvparams)
            set(_sdsp.lvparams,MUIA_List_Active,MUIV_List_Active_Top)
      ENDIF
ENDPROC
  */
  /*
PROC sdsp_l2active(pos)
DEF s[50]:STRING
DEF temp:PTR TO obj_dspid,e,fmts,minv,maxv
DEF t1:PTR TO obj_dsp
DEF t2:PTR TO obj_dspinfo
DEF t3:PTR TO obj_dspparam
DEF pnames:PTR TO LONG

            IF cursongp=NIL THEN RETURN
            IF pos=MUIV_List_Active_Off
                  set(_sdsp.txparam,MUIA_Text_Contents,NIL)
                  nset(_sdsp.sloffset,MUIA_Numeric_Value,0)
                  nset(_sdsp.stoffset,MUIA_String_Integer,0)
                  nset(_sdsp.slcoef,MUIA_Numeric_Value,256)
                  nset(_sdsp.stcoef,MUIA_String_Integer,0)
                  nset(_sdsp.sllfoper,MUIA_Numeric_Value,50)
                  nset(_sdsp.sloffset,MUIA_Slider_Min,0)
                  nset(_sdsp.sloffset,MUIA_Slider_Max,0)
                  nset(_sdsp.chtempo,MUIA_Selected,FALSE)
                  nset(_sdsp.chlfotempo,MUIA_Selected,FALSE)
                  nset(_sdsp.chlfo,MUIA_Selected,FALSE)
                  nset(_sdsp.cylfotype,MUIA_Cycle_Active,0)
            ELSE
                  get(_sdsp.lvdspsequence,MUIA_List_Active,{e})
                  IF e=MUIV_List_Active_Off THEN RETURN

                  temp:=cursongp.dsps[e]
                  t3:=temp.params[pos]
                  t1:=mdata.dsplist[temp.linkedid]
                  dummybase:=t1.base
                  t2:=Dsp_getinfo()
                  fmts:=t2.pformat[pos]
                  minv:=t2.pminvals[pos]
                  maxv:=t2.pmaxvals[pos]
                  StringF(s,'Param Unit: \e8\s \e0Range: \e8\d..\d',fmts,minv,maxv)
                  set(_sdsp.txparam,MUIA_Text_Contents,s)
                  
                  
                  nset(_sdsp.stoffset,MUIA_String_Integer,t3.offset)
                  nset(_sdsp.slcoef,MUIA_Numeric_Value,t3.coef)
                  nset(_sdsp.stcoef,MUIA_String_Integer,t3.coef)

                  nset(_sdsp.sllfoper,MUIA_Numeric_Value,t3.lfo.period)

                  nset(_sdsp.sloffset,MUIA_Slider_Min,minv)
                  nset(_sdsp.sloffset,MUIA_Slider_Max,maxv)
                  nset(_sdsp.sloffset,MUIA_Numeric_Value,t3.offset)
            
                  nset(_sdsp.chtempo,MUIA_Selected,t3.tempof)
                  nset(_sdsp.chlfotempo,MUIA_Selected,t3.lfo.bylines)
                  nset(_sdsp.chlfo,MUIA_Selected,t3.lfof)
                  nset(_sdsp.cylfotype,MUIA_Cycle_Active,t3.lfo.type)

                  
            ENDIF                         
                  
ENDPROC
    */
/*

EXPORT PROC sdsp_lactive(hook,obj,msg)

      SELECT obj
      CASE _sdsp.lvdspsequence
            sdsp_l1active(^msg)
      CASE _sdsp.lvparams
            sdsp_l2active(^msg)
      ENDSELECT
ENDPROC           
  */

  /*
EXPORT PROC sdsp_dragdrop(hook,obj,msg:PTR TO LONG)
DEF src,dest,i,srcp:PTR TO obj_dspid

      IF cursongp=NIL THEN RETURN
        
      src:=msg[0]
      dest:=msg[1]
      IF src=dest THEN RETURN
      
      NEW srcp
      nset(_sdsp.lvdspsequence,MUIA_List_Active,MUIV_List_Active_Off)
      CopyMem(cursongp.dsps[src],srcp,SIZEOF obj_dspid)

      FOR i:=src+1 TO cursongp.ndsp-1 DO CopyMem(cursongp.dsps[i],cursongp.dsps[i-1],SIZEOF obj_dspid)
      IF dest>src THEN DEC dest
      IF dest<cursongp.ndsp
            FOR i:=cursongp.ndsp-2 TO dest STEP -1 DO CopyMem(cursongp.dsps[i],cursongp.dsps[i+1],SIZEOF obj_dspid)
      ENDIF
      CopyMem(srcp,cursongp.dsps[dest],SIZEOF obj_dspid)
      setchanged(TRUE)
      END srcp
      update_songseqlist()    
      set(_sdsp.lvdspsequence,MUIA_List_Active,dest)
      setchanged(TRUE)
ENDPROC

    */







-> -------------------- TRACK DSP SEQUENCE window



PROC update_trackseqlist()
DEF i
/*
      domethod(_tdsp.lvdspsequence,[MUIM_List_Clear])
      listq(_tdsp.lvdspsequence)
      FOR i:=0 TO ctp.ndsp-1
            domethod(_tdsp.lvdspsequence,[MUIM_List_InsertSingle,
                 ctp.dsps[i],MUIV_List_Insert_Bottom])
      ENDFOR
      listnq(_tdsp.lvdspsequence)*/
ENDPROC




PROC tdsp_add() ->HANDLE
DEF k,i
DEF temp:PTR TO obj_dsp
DEF temp2:PTR TO obj_dspid
DEF handle
DEF t1:PTR TO obj_dspinfo

/*
      get(_tdsp.lvdsppool,MUIA_List_Active,{k})
      IF k=MUIV_List_Active_Off THEN RETURN
      IF ctp.ndsp=16
            error('DSP sequence too long')
            RETURN
      ENDIF

      temp2:=     ctp.dsps[ctp.ndsp]      
      clrmem(temp2,SIZEOF obj_dspid)
      
      temp2.cmdassign:=255
      temp2.linkedid:=mdata.dspl[k]
      

      temp:=mdata.dsplist[mdata.dspl[k]]

      dummybase:=temp.base

      t1:=Dsp_getinfo()
      i:=0
      WHILE t1.pnames[i]
            temp2.params[i].offset:=t1.pminvals[i]
            temp2.params[i].coef:=256
            temp2.params[i].lfo.period:=50
            i++
      ENDWHILE    

      handle:=Dsp_allochandle()
      IF handle=-1 THEN Raise("NHND")
      
      temp2.handle:=handle
   
      

      domethod(_tdsp.lvdspsequence,[MUIM_List_InsertSingle,
      temp2,MUIV_List_Insert_Bottom])
      set(_tdsp.lvdspsequence,MUIA_List_Active,ctp.ndsp)
      
      ctp.ndsp:=ctp.ndsp+1

      setchanged(TRUE)
EXCEPT

      IF exception="MEM"
            errnomem()
      ELSEIF exception="NHND"
            error('DSP-Plugin Error: Initialization Failed')      
      ELSE
            errunknown()
      ENDIF
  */
ENDPROC



PROC tdsp_insert()-> HANDLE
      /*
DEF k,l,i,m
DEF tempid:PTR TO obj_dspid
DEF temp:PTR TO obj_dsp
DEF t1:PTR TO obj_dspinfo

      get(_tdsp.lvdsppool,MUIA_List_Active,{k})
      get(_tdsp.lvdspsequence,MUIA_List_Active,{l})

      IF (k=MUIV_List_Active_Off) OR (l=MUIV_List_Active_Off) THEN RETURN
      IF ctp.ndsp=16
            error('DSP sequence too long')
            RETURN
      ENDIF

      FOR i:=ctp.ndsp-1 TO l STEP -1 DO CopyMem(ctp.dsps[i],ctp.dsps[i+1],SIZEOF obj_dspid)
      tempid:=ctp.dsps[l]
      clrmem(tempid,SIZEOF obj_dspid)

      tempid.cmdassign:=255
      tempid.linkedid:=mdata.dspl[k]

      temp:=mdata.dsplist[mdata.dspl[k]]
      dummybase:=temp.base

      t1:=Dsp_getinfo()
      i:=0
      WHILE t1.pnames[i]
            tempid.params[i].offset:=t1.pminvals[i]
            tempid.params[i].coef:=256
            tempid.params[i].lfo.period:=50
            i++
      ENDWHILE    


      tempid.handle:=Dsp_allochandle()
      IF tempid.handle=-1 THEN Raise("NHND")
   
      
      ctp.ndsp:=ctp.ndsp+1
      update_trackseqlist()
      set(_tdsp.lvdspsequence,MUIA_List_Active,l)
      setchanged(TRUE)

EXCEPT

      IF exception="MEM"
            errnomem()
      ELSEIF exception="NHND"
            error('DSP-Plugin Error: Initialization Failed')      
      ELSE
            errunknown()
      ENDIF
        */
ENDPROC



EXPORT PROC tdsp_delete()
DEF k
DEF l,i
DEF temp:PTR TO obj_dsp
DEF tempid:PTR TO obj_dspid
          /*
      get(_tdsp.lvdspsequence,MUIA_List_Active,{k})
      IF k=MUIV_List_Active_Off THEN RETURN

      tempid:=ctp.dsps[k]
      l:=tempid.linkedid
      temp:=mdata.dsplist[l]
      dummybase:=temp.base
      Dsp_freehandle(tempid.handle)

   FOR i:=k+1 TO ctp.ndsp-1 DO CopyMem(ctp.dsps[i],
     ctp.dsps[i-1],SIZEOF obj_dspid)
   ctp.ndsp:=ctp.ndsp-1
      update_trackseqlist()
setchanged(TRUE)*/
ENDPROC


EXPORT PROC tdsp_delall()
DEF i,l
DEF temp:PTR TO obj_dsp
DEF tempid:PTR TO obj_dspid

                  /*
      IF ctp.ndsp=0 THEN RETURN
      IF confirm('Are you sure to delete whole dsp sequence?')
      FOR i:=0 TO ctp.ndsp-1 
            tempid:=ctp.dsps[i]
            l:=tempid.linkedid
            temp:=mdata.dsplist[l]
            dummybase:=temp.base
            Dsp_freehandle(tempid.handle)       
      ENDFOR
     ctp.ndsp:=0
     domethod(_tdsp.lvdspsequence,[MUIM_List_Clear])
   ENDIF
setchanged(TRUE)    */
ENDPROC





EXPORT PROC tdsp_disphook(hovno,array:PTR TO LONG,entry:PTR TO obj_dspid)

DEF temp:PTR TO obj_dsp
DEF s[4]:STRING

      IF entry
            StringF(s,'\d[2]',array[-1]+1)
            AstrCopy(entry.dummy,s,4)
            ^array++:=entry.dummy
            temp:=mdata.dsplist[entry.linkedid]
            ^array++:=temp.name
            IF entry.cmdassign<255
                  StringF(s,'#\d[1]',entry.cmdassign)
                  AstrCopy(entry.dummy2,s,4)
                  ^array++:=entry.dummy2
            ELSE
                  ^array++:='N/A'
            ENDIF
      ELSE
            ^array++:='\e8POS'
            ^array++:='\e8NAME'
            ^array++:='\e8CTRL #'
      ENDIF
ENDPROC


PROC tdsp_action2(obj,msg)   -> parameter event
DEF e,f,a
DEF p:PTR TO obj_dspparam

      a:=^msg
          /*
      get(_tdsp.lvdspsequence,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN
      get(_tdsp.lvparams,MUIA_List_Active,{f})
      IF f=MUIV_List_Active_Off THEN RETURN
      p:=ctp.dsps[e].params[f]

      SELECT obj
      CASE _tdsp.sloffset
            nset(_tdsp.stoffset,MUIA_String_Integer,a)
            p.offset:=a
      CASE _tdsp.stoffset
            get(_tdsp.stoffset,MUIA_String_Integer,{a})     
            set(_tdsp.sloffset,MUIA_Numeric_Value,a)
      CASE _tdsp.slcoef
            nset(_tdsp.stcoef,MUIA_String_Integer,a)
            p.coef:=a
      CASE _tdsp.stcoef
            get(_tdsp.stcoef,MUIA_String_Integer,{a}) 
            set(_tdsp.slcoef,MUIA_Numeric_Value,a)
      CASE _tdsp.sllfoper
            p.lfo.period:=a
      CASE _tdsp.chtempo
            p.tempof:=a
      CASE _tdsp.chlfo
            p.lfof:=a
      CASE _tdsp.chlfotempo
            p.lfo.bylines:=a
      CASE _tdsp.cylfotype
            p.lfo.type:=a
      ENDSELECT
      setchanged(TRUE)*/
ENDPROC
      

EXPORT PROC tdsp_action(hook,obj,msg)
DEF e
                        /*
      IF ctp=0 THEN RETURN
      SELECT obj

      CASE _tdsp.cyccassign
            get(_tdsp.lvdspsequence,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  IF ^msg=0
                        ctp.dsps[e].cmdassign:=255
                  ELSE
                        ctp.dsps[e].cmdassign:=^msg-1
                  ENDIF
                  domethod(_tdsp.lvdspsequence,[MUIM_List_Redraw,MUIV_List_Redraw_Active])
                  setchanged(TRUE)
            ENDIF
      CASE _tdsp.btadd
            tdsp_add()
      CASE _tdsp.btinsert
            tdsp_insert()
      CASE _tdsp.btdelete
            tdsp_delete()
      CASE _tdsp.btdeleteall
            tdsp_delall()
            
      ENDSELECT
      tdsp_action2(obj,msg)*/
ENDPROC     


PROC tdsp_l1active(pos)
DEF temp:PTR TO obj_dspid
DEF t1:PTR TO obj_dsp
DEF t2:PTR TO obj_dspinfo
DEF pnames:PTR TO LONG

                       /*
      IF pos=MUIV_List_Active_Off
            nset(_tdsp.cyccassign,MUIA_Cycle_Active,0)
            set(_tdsp.txparam,MUIA_Text_Contents,NIL)
            domethod(_tdsp.lvparams,[MUIM_List_Clear])

            
      ELSE
            temp:=ctp.dsps[pos]
            IF temp.cmdassign=255
                  nset(_tdsp.cyccassign,MUIA_Cycle_Active,0)
            ELSE
                  nset(_tdsp.cyccassign,MUIA_Cycle_Active,temp.cmdassign+1)
            ENDIF
            t1:=mdata.dsplist[temp.linkedid]
            dummybase:=t1.base
            t2:=Dsp_getinfo()
            pnames:=t2.pnames
            
            nset(_tdsp.lvparams,MUIA_List_Active,MUIV_List_Active_Off)
            listq(_tdsp.lvparams)
            domethod(_tdsp.lvparams,[MUIM_List_Clear])
            WHILE pnames[]
                  domethod(_tdsp.lvparams,[MUIM_List_InsertSingle,pnames[]++,MUIV_List_Insert_Bottom])
            ENDWHILE
            listnq(_tdsp.lvparams)
            set(_tdsp.lvparams,MUIA_List_Active,MUIV_List_Active_Top)
ENDIF
*/
ENDPROC
                                                            
PROC tdsp_l2active(pos)
DEF s[50]:STRING
DEF temp:PTR TO obj_dspid,e,fmts,minv,maxv
DEF t1:PTR TO obj_dsp
DEF t2:PTR TO obj_dspinfo
DEF t3:PTR TO obj_dspparam
DEF pnames:PTR TO LONG

                       /*
            IF pos=MUIV_List_Active_Off
                  set(_tdsp.txparam,MUIA_Text_Contents,NIL)
                  nset(_tdsp.sloffset,MUIA_Numeric_Value,0)
                  nset(_tdsp.stoffset,MUIA_String_Integer,0)
                  nset(_tdsp.slcoef,MUIA_Numeric_Value,256)
                  nset(_tdsp.stcoef,MUIA_String_Integer,0)
                  nset(_tdsp.sllfoper,MUIA_Numeric_Value,50)
                  nset(_tdsp.sloffset,MUIA_Slider_Min,0)
                  nset(_tdsp.sloffset,MUIA_Slider_Max,0)
                  nset(_tdsp.chtempo,MUIA_Selected,FALSE)
                  nset(_tdsp.chlfotempo,MUIA_Selected,FALSE)
                  nset(_tdsp.chlfo,MUIA_Selected,FALSE)
                  nset(_tdsp.cylfotype,MUIA_Cycle_Active,0)
            ELSE
                  get(_tdsp.lvdspsequence,MUIA_List_Active,{e})
                  IF e=MUIV_List_Active_Off THEN RETURN

                  temp:=ctp.dsps[e]
                  t3:=temp.params[pos]
                  t1:=mdata.dsplist[temp.linkedid]
                  dummybase:=t1.base
                  t2:=Dsp_getinfo()
                  fmts:=t2.pformat[pos]
                  minv:=t2.pminvals[pos]
                  maxv:=t2.pmaxvals[pos]
                  StringF(s,'Param Unit: \e8\s \e0Range: \e8\d..\d',fmts,minv,maxv)
                  set(_tdsp.txparam,MUIA_Text_Contents,s)
                  
                  
                  nset(_tdsp.stoffset,MUIA_String_Integer,t3.offset)
                  nset(_tdsp.slcoef,MUIA_Numeric_Value,t3.coef)
                  nset(_tdsp.stcoef,MUIA_String_Integer,t3.coef)

                  nset(_tdsp.sllfoper,MUIA_Numeric_Value,t3.lfo.period)

                  nset(_tdsp.sloffset,MUIA_Slider_Min,minv)
                  nset(_tdsp.sloffset,MUIA_Slider_Max,maxv)
                  nset(_tdsp.sloffset,MUIA_Numeric_Value,t3.offset)
            
                  nset(_tdsp.chtempo,MUIA_Selected,t3.tempof)
                  nset(_tdsp.chlfotempo,MUIA_Selected,t3.lfo.bylines)
                  nset(_tdsp.chlfo,MUIA_Selected,t3.lfof)
                  nset(_tdsp.cylfotype,MUIA_Cycle_Active,t3.lfo.type)

                  
            ENDIF                         
                         */
ENDPROC


EXPORT PROC tdsp_lactive(hook,obj,msg)


                           /*
      SELECT obj
      CASE _tdsp.lvdspsequence
            tdsp_l1active(^msg)
      CASE _tdsp.lvparams
            tdsp_l2active(^msg)
      ENDSELECT
ENDPROC           

EXPORT PROC tdsp_dragdrop(hook,obj,msg:PTR TO LONG)
DEF src,dest,i,srcp:PTR TO obj_dspid

      IF ctp=NIL THEN RETURN
        
      src:=msg[0]
      dest:=msg[1]
      IF src=dest THEN RETURN
      
      NEW srcp
      nset(_tdsp.lvdspsequence,MUIA_List_Active,MUIV_List_Active_Off)
      CopyMem(ctp.dsps[src],srcp,SIZEOF obj_dspid)

      FOR i:=src+1 TO ctp.ndsp-1 DO CopyMem(ctp.dsps[i],ctp.dsps[i-1],SIZEOF obj_dspid)
      IF dest>src THEN DEC dest
      IF dest<ctp.ndsp
            FOR i:=ctp.ndsp-2 TO dest STEP -1 DO CopyMem(ctp.dsps[i],ctp.dsps[i+1],SIZEOF obj_dspid)
      ENDIF
      CopyMem(srcp,ctp.dsps[dest],SIZEOF obj_dspid)
      setchanged(TRUE)
      END srcp
      update_trackseqlist()   
      set(_tdsp.lvdspsequence,MUIA_List_Active,dest)
      setchanged(TRUE)
      */
ENDPROC


