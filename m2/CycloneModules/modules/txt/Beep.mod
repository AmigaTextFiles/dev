(*#
*   Program         :   Beep
*   Author          :   Marcel Timmermans
*   Address         :   A. Dekenstr 22, 6836 RM , ARNHEM, HOLLAND.
*   Creation Date   :   30-dec-1994
*   Current version :   1.1
*   Language        :   Modula-2
*   Translator      :   AMC V0.42
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*
**)

IMPLEMENTATION MODULE Beep;

FROM SYSTEM IMPORT CAST,ADDRESS,ADR,LONGSET;
IMPORT el:ExecL,
       ed:ExecD,
       au:Audio,
       es:ExecSupport,
       h:Heap,
       ml:ModulaLib;


CONST
  AllocationMap = "\x01\x02\x04\x08";
  Clock = 3546895;
  samples = 6;
  samsyc = 1;

TYPE
  wave = POINTER TO ARRAY[0..samples-1] OF SHORTINT;

VAR
  AllocPort: ed.MsgPortPtr;
  Audio    : au.IOAudioPtr;
  AudioOpen: BOOLEAN;
  waveptr  : wave;

PROCEDURE Sound(frequency,time:CARDINAL);
BEGIN
  h.AllocMem(Audio,SIZE(au.IOAudio),FALSE);
  ml.Assert(Audio#NIL,ADR("Out of memory"));
  
  WITH Audio^ DO
   request.message.replyPort := AllocPort;
   request.message.node.pri  := 0;
   request.command := au.allocate;
   request.flags   := au.noWait;
   allocKey := 0;
   data   := ADR(AllocationMap);
   length := 4;
  END;

  el.OpenDevice(ADR(au.audioName),0,Audio,LONGSET{});
  IF (Audio^.request.error = 0) THEN

    AudioOpen:=TRUE;

    h.AllocMem(waveptr,SIZE(samples),TRUE);
    ml.Assert(waveptr#NIL,ADR("Out of memory"));  

    waveptr^[0]:=60;
    waveptr^[1]:=127;
    waveptr^[2]:=60;
    waveptr^[3]:=-60;
    waveptr^[4]:=-127;
    waveptr^[5]:=-60;

    WITH Audio^ DO
      request.message.replyPort := AllocPort;
      request.command := ed.write;
      request.flags   := au.pervol;
      data            := waveptr;
      length          := samples;
      period          := Clock*samsyc/(samples*frequency);
      cycles          := time;
      volume          := 64;
    END;

    es.BeginIO(CAST(ADDRESS,Audio));
    el.WaitIO(CAST(ADDRESS,Audio));

    AudioOpen:=FALSE;
    el.CloseDevice(CAST(ADDRESS,Audio));
  END;
END Sound;


BEGIN
  AudioOpen := FALSE;
  AllocPort := es.CreatePort(NIL,0);
  ml.Assert(AllocPort#NIL,ADR("No port available for beep"));
CLOSE
  IF AudioOpen THEN el.CloseDevice(CAST(ADDRESS,Audio)) END;
  IF AllocPort#NIL THEN es.DeletePort(AllocPort); END;
END Beep.

