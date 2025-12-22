OPT TURBO

MODULE 'dos/dos'
PMODULE 'PMODULES:stack'

OBJECT et_procInfoType
  visits:LONG
  started:datestamp
  elapsed:datestamp
  name:LONG
ENDOBJECT

DEF et_procInfoArray:PTR TO et_procInfoType,
    et_stack:st_stackType,
    et_numberOfProcs=0,
    et_idRunning=-1 /* Used to turn timer off/on in case of recursive */
                     /* call.  Used by et_StartTime AND et_StopTime.  */

PROC et_init(numberOfProcs)
  DEF i, elapsed:PTR TO datestamp
  et_numberOfProcs:=numberOfProcs+1
  et_procInfoArray:=New(SIZEOF et_procInfoType*et_numberOfProcs)
  FOR i:=0 TO numberOfProcs
    et_procInfoArray[i].visits:=0
    elapsed:=et_procInfoArray[i].elapsed
    elapsed.minute:=0
    elapsed.tick:=0
  ENDFOR
  st_init(et_stack)
ENDPROC

PROC et_startTimer(id, name)
  DEF current:datestamp, started:PTR TO datestamp, elapsed:PTR TO datestamp
  DateStamp(current)
  /* Update the elapsed time of the proc that relinquished control to     */
  /* child.  Init if et_idRunning = -1 (PROC main () is the *only* case.) */
  IF et_idRunning=-1
    et_init(id)
  ELSE
    started:=et_procInfoArray[et_idRunning].started
    elapsed:=et_procInfoArray[et_idRunning].elapsed
    IF current.tick<started.tick
      current.tick:=current.tick+3000
      current.minute:=current.minute-1
    ENDIF
    elapsed.tick:=elapsed.tick+(current.tick-started.tick)
    elapsed.minute:=elapsed.minute+(current.minute-started.minute)
  ENDIF
  st_push(et_stack,et_idRunning)
  /* Update the start time of the child proc. */
  started:=et_procInfoArray[id].started
  started.minute:=current.minute
  started.tick:=current.tick
  et_procInfoArray[id].name:=IF name=NIL THEN '' ELSE name
  et_idRunning:=id
  et_procInfoArray[id].visits:=et_procInfoArray[id].visits+1
ENDPROC

PROC et_toMinutes(ticks) RETURN ticks/3000

PROC et_report()
  DEF i, totalMinute=0, totalTick=0, ds:PTR TO datestamp
  FOR i:=0 TO (et_numberOfProcs-1)
    ds:=et_procInfoArray[i].elapsed
    ds.minute:=ds.minute+et_toMinutes(ds.tick)
    ds.tick:=ds.tick-(et_toMinutes(ds.tick)*3000)
    WriteF('\nid=\d, visits=\d, minute=\d, tick=\d, name=\s',
            i, et_procInfoArray[i].visits, ds.minute, ds.tick,
            et_procInfoArray[i].name)
    totalMinute:=totalMinute+ds.minute
    totalTick:=totalTick+ds.tick
  ENDFOR
  totalMinute:=totalMinute+et_toMinutes(totalTick)
  totalTick:=totalTick-(et_toMinutes(totalTick)*3000)
  WriteF('\ntotalMinute=\d totalTick=\d\n', totalMinute, totalTick)
ENDPROC


PROC et_stopTimer ()
  DEF current:datestamp, started:PTR TO datestamp, elapsed:PTR TO datestamp
  DateStamp(current)
  /* Update the elapsed time of the child proc that id returning control */
  /* to the parent.  None if et_idRunning = -1 (PROC main () is the      */
  /* *only* case.)                                                       */
  started:=et_procInfoArray[et_idRunning].started
  elapsed:=et_procInfoArray[et_idRunning].elapsed
    IF current.tick<started.tick
      current.tick:=current.tick+(50*60)
      current.minute:=current.minute-1
    ENDIF
  elapsed.tick:=elapsed.tick+(current.tick-started.tick)
  elapsed.minute:=elapsed.minute+(current.minute-started.minute)
  /* Update the start time of the parent proc.  None if et_idRunning = -1 */
  /* (PROC main () is the *only* case.)                                   */
  et_idRunning:=st_pop(et_stack)
  IF et_idRunning>-1
    started:=et_procInfoArray[et_idRunning].started
    started.minute:=current.minute
    started.tick:=current.tick
  ELSE
    et_report()
  ENDIF
ENDPROC

