@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "midi.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY midibase                    /* informal notation */
  LockMidiBase()                    /* -30 (1E) */
  UnlockMidiBase()                  /* -36 (24) */
  CreateMSource(A0,A1)              /* -42 (2A) */
  DeleteMSource(A0)                 /* -48 (30) */
  FindMSource(A0)                   /* -54 (36) */
  CreateMDest(A0,A1)                /* -60 (3C) */
  DeleteMDest(A0)                   /* -66 (42) */
  FindMDest(A0)                     /* -72 (48) */
  CreateMRoute(A0,A1,A2)            /* -78 (4E) */
  ModifyMRoute(A0,A1)               /* -84 (54) */
  DeleteMRoute(A0)                  /* -90 (5A) */
  MrouteSource(A0,A1,A2)            /* -96 (60) */
  MrouteDest(A0,A1,A2)              /* -102 (66) */
  MroutePublic(A0,A1,A2)            /* -108 (6C) */
  GetMidiMsg(A0)                    /* -114 (72) */
  PutMidiMsg(A0,A1)                 /* -120 (78) */
  FreeMidiMsg(A0)                   /* -126 (7E) */
  MidiMsgType(A0)                   /* -132 (84) */
  MidiMsgLength(A0)                 /* -138 (8A) */
  PutMidiStream(A0,A1,A2,D0,D1)     /* -144 (90) */
  LockMRoutes()                     /* -150 (96) */
  UnlockMRoutes()                   /* -156 (9C) */
  FlushMDest(A0)                    /* -162 (A2) */
  GetMidiPacket(A0)                 /* -168 (A8) */
  FreeMidiPacket(A0)                /* -174 (AE) */
  SetDefaultMRouteInfo(A0,A1)       /* -180 (B4) */
  CreateMListSignal(D0)             /* -186 (BA) */
  DeleteMListSignal(A0)             /* -192 (C0) */
ENDLIBRARY
@endnode
