include "inc/exec/types.inc";

def SUSERFLAGS = $00ff;
def VSPRITE = $0001;
def SAVEBACK = $0002;
def OVERLAY = $0004;
def MUSTDRAW = $0008;

def BACKSAVED = $0100;
def BOBUPDATE = $0200;
def GELGONE = $0400;
def VSOVERFLOW = $0800;

def BUSERFLAGS = $00ff;
def SAVEBOB = $0001;
def BOBISCOMP = $0002;

def BWAITING = $0100;
def BDRAWN = $0200;
def BOBSAWAY = $0400;
def BOBNIX = $0800;
def SAVEPRESERVE = $1000;
def OUTSTEP = $2000;

def ANFRACSIZE = 6;
def ANIMHALF = $0020;
def RINGTRIGGER = $0001;

def VUserStuff = WORD;

def BUserStuff = WORD;

def AUserStuff = WORD;

struct VSprite is
  NextVSprite:ulong;
  PrevVSprite:ulong;
  DrawPath:ulong;
  ClearPath:ulong;
  OldY,OldX:word;
  Flags:word;
  Y,X:word;
  Height:word;
  Width:word;
  Depth:word;
  MeMask:word;
  HitMask:word;
  ImageData:ulong;
  BorderLine:ulong;
  CollMask:ulong;
  SprColors:ulong;
  VSBob:ulong;
  PlanePick:byte;
  PlaneOnOff:byte;
  VUserExt:word;
;

struct Bob is
  Flags:word;
  SaveBuffer:ulong;
  ImageShadow:ulong;
  Before:ulong;
  After:ulong;
  BobVSprite:ulong;
  BobComp:ulong;
  DBuffer:ulong;
  BUserExt:word;
;

struct AnimComp is
  Flags:word;
  Timer:word;
  TimeSet:word;
  NextComp:ulong;
  PrevComp:ulong;
  NextSeq:ulong;
  PrevSeq:ulong;
  AnimCRoutine:ulong;
  YTrans:word;
  XTrans:word;
  HeadOb:ulong;
  AnimBob:ulong;
;

struct AnimOb is
  NextOb:ulong;
  PrevOb:ulong;
  Clock:long;
  AnOldY,AnOldX:word;
  AnY,AnX:word;
  YVel,XVel:word;
  YAccel,XAccel:word;
  RingYTrans,RingXTrans:word;
  AnimORoutine:ulong;
  HeadComp:ulong;
  AUserExt:word;
;

struct DBufPacket is
  BufY,BufX:word;
  BufPath:ulong;
  BufBuffer:ulong;
;

def B2NORM = 0;
def B2SWAP = 1;
def B2BOBBER = 2;

struct collTable is
  collPtrs[16]:ulong;
;

