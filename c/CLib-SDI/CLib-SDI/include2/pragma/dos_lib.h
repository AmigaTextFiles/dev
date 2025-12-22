#ifndef _INCLUDE_PRAGMA_DOS_LIB_H
#define _INCLUDE_PRAGMA_DOS_LIB_H

#ifndef CLIB_DOS_PROTOS_H
#include <clib/dos_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(DOSBase,0x01e,Open(d1,d2))
#pragma amicall(DOSBase,0x024,Close(d1))
#pragma amicall(DOSBase,0x02a,Read(d1,d2,d3))
#pragma amicall(DOSBase,0x030,Write(d1,d2,d3))
#pragma amicall(DOSBase,0x036,Input())
#pragma amicall(DOSBase,0x03c,Output())
#pragma amicall(DOSBase,0x042,Seek(d1,d2,d3))
#pragma amicall(DOSBase,0x048,DeleteFile(d1))
#pragma amicall(DOSBase,0x04e,Rename(d1,d2))
#pragma amicall(DOSBase,0x054,Lock(d1,d2))
#pragma amicall(DOSBase,0x05a,UnLock(d1))
#pragma amicall(DOSBase,0x060,DupLock(d1))
#pragma amicall(DOSBase,0x066,Examine(d1,d2))
#pragma amicall(DOSBase,0x06c,ExNext(d1,d2))
#pragma amicall(DOSBase,0x072,Info(d1,d2))
#pragma amicall(DOSBase,0x078,CreateDir(d1))
#pragma amicall(DOSBase,0x07e,CurrentDir(d1))
#pragma amicall(DOSBase,0x084,IoErr())
#pragma amicall(DOSBase,0x08a,CreateProc(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x090,Exit(d1))
#pragma amicall(DOSBase,0x096,LoadSeg(d1))
#pragma amicall(DOSBase,0x09c,UnLoadSeg(d1))
#pragma amicall(DOSBase,0x0ae,DeviceProc(d1))
#pragma amicall(DOSBase,0x0b4,SetComment(d1,d2))
#pragma amicall(DOSBase,0x0ba,SetProtection(d1,d2))
#pragma amicall(DOSBase,0x0c0,DateStamp(d1))
#pragma amicall(DOSBase,0x0c6,Delay(d1))
#pragma amicall(DOSBase,0x0cc,WaitForChar(d1,d2))
#pragma amicall(DOSBase,0x0d2,ParentDir(d1))
#pragma amicall(DOSBase,0x0d8,IsInteractive(d1))
#pragma amicall(DOSBase,0x0de,Execute(d1,d2,d3))
#pragma amicall(DOSBase,0x0e4,AllocDosObject(d1,d2))
#pragma amicall(DOSBase,0x0e4,AllocDosObjectTagList(d1,d2))
#pragma amicall(DOSBase,0x0ea,FreeDosObject(d1,d2))
#pragma amicall(DOSBase,0x0f0,DoPkt(d1,d2,d3,d4,d5,d6,d7))
#pragma amicall(DOSBase,0x0f0,DoPkt0(d1,d2))
#pragma amicall(DOSBase,0x0f0,DoPkt1(d1,d2,d3))
#pragma amicall(DOSBase,0x0f0,DoPkt2(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x0f0,DoPkt3(d1,d2,d3,d4,d5))
#pragma amicall(DOSBase,0x0f0,DoPkt4(d1,d2,d3,d4,d5,d6))
#pragma amicall(DOSBase,0x0f6,SendPkt(d1,d2,d3))
#pragma amicall(DOSBase,0x0fc,WaitPkt())
#pragma amicall(DOSBase,0x102,ReplyPkt(d1,d2,d3))
#pragma amicall(DOSBase,0x108,AbortPkt(d1,d2))
#pragma amicall(DOSBase,0x10e,LockRecord(d1,d2,d3,d4,d5))
#pragma amicall(DOSBase,0x114,LockRecords(d1,d2))
#pragma amicall(DOSBase,0x11a,UnLockRecord(d1,d2,d3))
#pragma amicall(DOSBase,0x120,UnLockRecords(d1))
#pragma amicall(DOSBase,0x126,SelectInput(d1))
#pragma amicall(DOSBase,0x12c,SelectOutput(d1))
#pragma amicall(DOSBase,0x132,FGetC(d1))
#pragma amicall(DOSBase,0x138,FPutC(d1,d2))
#pragma amicall(DOSBase,0x13e,UnGetC(d1,d2))
#pragma amicall(DOSBase,0x144,FRead(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x14a,FWrite(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x150,FGets(d1,d2,d3))
#pragma amicall(DOSBase,0x156,FPuts(d1,d2))
#pragma amicall(DOSBase,0x15c,VFWritef(d1,d2,d3))
#pragma amicall(DOSBase,0x162,VFPrintf(d1,d2,d3))
#pragma amicall(DOSBase,0x168,Flush(d1))
#pragma amicall(DOSBase,0x16e,SetVBuf(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x174,DupLockFromFH(d1))
#pragma amicall(DOSBase,0x17a,OpenFromLock(d1))
#pragma amicall(DOSBase,0x180,ParentOfFH(d1))
#pragma amicall(DOSBase,0x186,ExamineFH(d1,d2))
#pragma amicall(DOSBase,0x18c,SetFileDate(d1,d2))
#pragma amicall(DOSBase,0x192,NameFromLock(d1,d2,d3))
#pragma amicall(DOSBase,0x198,NameFromFH(d1,d2,d3))
#pragma amicall(DOSBase,0x19e,SplitName(d1,d2,d3,d4,d5))
#pragma amicall(DOSBase,0x1a4,SameLock(d1,d2))
#pragma amicall(DOSBase,0x1aa,SetMode(d1,d2))
#pragma amicall(DOSBase,0x1b0,ExAll(d1,d2,d3,d4,d5))
#pragma amicall(DOSBase,0x1b6,ReadLink(d1,d2,d3,d4,d5))
#pragma amicall(DOSBase,0x1bc,MakeLink(d1,d2,d3))
#pragma amicall(DOSBase,0x1c2,ChangeMode(d1,d2,d3))
#pragma amicall(DOSBase,0x1c8,SetFileSize(d1,d2,d3))
#pragma amicall(DOSBase,0x1ce,SetIoErr(d1))
#pragma amicall(DOSBase,0x1d4,Fault(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x1da,PrintFault(d1,d2))
#pragma amicall(DOSBase,0x1e0,ErrorReport(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x1ec,Cli())
#pragma amicall(DOSBase,0x1f2,CreateNewProc(d1))
#pragma amicall(DOSBase,0x1f2,CreateNewProcTagList(d1))
#pragma amicall(DOSBase,0x1f8,RunCommand(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x1fe,GetConsoleTask())
#pragma amicall(DOSBase,0x204,SetConsoleTask(d1))
#pragma amicall(DOSBase,0x20a,GetFileSysTask())
#pragma amicall(DOSBase,0x210,SetFileSysTask(d1))
#pragma amicall(DOSBase,0x216,GetArgStr())
#pragma amicall(DOSBase,0x21c,SetArgStr(d1))
#pragma amicall(DOSBase,0x222,FindCliProc(d1))
#pragma amicall(DOSBase,0x228,MaxCli())
#pragma amicall(DOSBase,0x22e,SetCurrentDirName(d1))
#pragma amicall(DOSBase,0x234,GetCurrentDirName(d1,d2))
#pragma amicall(DOSBase,0x23a,SetProgramName(d1))
#pragma amicall(DOSBase,0x240,GetProgramName(d1,d2))
#pragma amicall(DOSBase,0x246,SetPrompt(d1))
#pragma amicall(DOSBase,0x24c,GetPrompt(d1,d2))
#pragma amicall(DOSBase,0x252,SetProgramDir(d1))
#pragma amicall(DOSBase,0x258,GetProgramDir())
#pragma amicall(DOSBase,0x25e,SystemTagList(d1,d2))
#pragma amicall(DOSBase,0x25e,System(d1,d2))
#pragma amicall(DOSBase,0x264,AssignLock(d1,d2))
#pragma amicall(DOSBase,0x26a,AssignLate(d1,d2))
#pragma amicall(DOSBase,0x270,AssignPath(d1,d2))
#pragma amicall(DOSBase,0x276,AssignAdd(d1,d2))
#pragma amicall(DOSBase,0x27c,RemAssignList(d1,d2))
#pragma amicall(DOSBase,0x282,GetDeviceProc(d1,d2))
#pragma amicall(DOSBase,0x288,FreeDeviceProc(d1))
#pragma amicall(DOSBase,0x28e,LockDosList(d1))
#pragma amicall(DOSBase,0x294,UnLockDosList(d1))
#pragma amicall(DOSBase,0x29a,AttemptLockDosList(d1))
#pragma amicall(DOSBase,0x2a0,RemDosEntry(d1))
#pragma amicall(DOSBase,0x2a6,AddDosEntry(d1))
#pragma amicall(DOSBase,0x2ac,FindDosEntry(d1,d2,d3))
#pragma amicall(DOSBase,0x2b2,NextDosEntry(d1,d2))
#pragma amicall(DOSBase,0x2b8,MakeDosEntry(d1,d2))
#pragma amicall(DOSBase,0x2be,FreeDosEntry(d1))
#pragma amicall(DOSBase,0x2c4,IsFileSystem(d1))
#pragma amicall(DOSBase,0x2ca,Format(d1,d2,d3))
#pragma amicall(DOSBase,0x2d0,Relabel(d1,d2))
#pragma amicall(DOSBase,0x2d6,Inhibit(d1,d2))
#pragma amicall(DOSBase,0x2dc,AddBuffers(d1,d2))
#pragma amicall(DOSBase,0x2e2,CompareDates(d1,d2))
#pragma amicall(DOSBase,0x2e8,DateToStr(d1))
#pragma amicall(DOSBase,0x2ee,StrToDate(d1))
#pragma amicall(DOSBase,0x2f4,InternalLoadSeg(d0,a0,a1,a2))
#pragma amicall(DOSBase,0x2fa,InternalUnLoadSeg(d1,a1))
#pragma amicall(DOSBase,0x300,NewLoadSeg(d1,d2))
#pragma amicall(DOSBase,0x300,NewLoadSegTagList(d1,d2))
#pragma amicall(DOSBase,0x306,AddSegment(d1,d2,d3))
#pragma amicall(DOSBase,0x30c,FindSegment(d1,d2,d3))
#pragma amicall(DOSBase,0x312,RemSegment(d1))
#pragma amicall(DOSBase,0x318,CheckSignal(d1))
#pragma amicall(DOSBase,0x31e,ReadArgs(d1,d2,d3))
#pragma amicall(DOSBase,0x324,FindArg(d1,d2))
#pragma amicall(DOSBase,0x32a,ReadItem(d1,d2,d3))
#pragma amicall(DOSBase,0x330,StrToLong(d1,d2))
#pragma amicall(DOSBase,0x336,MatchFirst(d1,d2))
#pragma amicall(DOSBase,0x33c,MatchNext(d1))
#pragma amicall(DOSBase,0x342,MatchEnd(d1))
#pragma amicall(DOSBase,0x348,ParsePattern(d1,d2,d3))
#pragma amicall(DOSBase,0x34e,MatchPattern(d1,d2))
#pragma amicall(DOSBase,0x35a,FreeArgs(d1))
#pragma amicall(DOSBase,0x366,FilePart(d1))
#pragma amicall(DOSBase,0x36c,PathPart(d1))
#pragma amicall(DOSBase,0x372,AddPart(d1,d2,d3))
#pragma amicall(DOSBase,0x378,StartNotify(d1))
#pragma amicall(DOSBase,0x37e,EndNotify(d1))
#pragma amicall(DOSBase,0x384,SetVar(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x38a,GetVar(d1,d2,d3,d4))
#pragma amicall(DOSBase,0x390,DeleteVar(d1,d2))
#pragma amicall(DOSBase,0x396,FindVar(d1,d2))
#pragma amicall(DOSBase,0x3a2,CliInitNewcli(a0))
#pragma amicall(DOSBase,0x3a8,CliInitRun(a0))
#pragma amicall(DOSBase,0x3ae,WriteChars(d1,d2))
#pragma amicall(DOSBase,0x3b4,PutStr(d1))
#pragma amicall(DOSBase,0x3ba,VPrintf(d1,d2))
#pragma amicall(DOSBase,0x3c6,ParsePatternNoCase(d1,d2,d3))
#pragma amicall(DOSBase,0x3cc,MatchPatternNoCase(d1,d2))
#pragma amicall(DOSBase,0x3d8,SameDevice(d1,d2))
#pragma amicall(DOSBase,0x3de,ExAllEnd(d1,d2,d3,d4,d5))
#pragma amicall(DOSBase,0x3e4,SetOwner(d1,d2))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall DOSBase Open                   01e 2102
#pragma  libcall DOSBase Close                  024 101
#pragma  libcall DOSBase Read                   02a 32103
#pragma  libcall DOSBase Write                  030 32103
#pragma  libcall DOSBase Input                  036 00
#pragma  libcall DOSBase Output                 03c 00
#pragma  libcall DOSBase Seek                   042 32103
#pragma  libcall DOSBase DeleteFile             048 101
#pragma  libcall DOSBase Rename                 04e 2102
#pragma  libcall DOSBase Lock                   054 2102
#pragma  libcall DOSBase UnLock                 05a 101
#pragma  libcall DOSBase DupLock                060 101
#pragma  libcall DOSBase Examine                066 2102
#pragma  libcall DOSBase ExNext                 06c 2102
#pragma  libcall DOSBase Info                   072 2102
#pragma  libcall DOSBase CreateDir              078 101
#pragma  libcall DOSBase CurrentDir             07e 101
#pragma  libcall DOSBase IoErr                  084 00
#pragma  libcall DOSBase CreateProc             08a 432104
#pragma  libcall DOSBase Exit                   090 101
#pragma  libcall DOSBase LoadSeg                096 101
#pragma  libcall DOSBase UnLoadSeg              09c 101
#pragma  libcall DOSBase DeviceProc             0ae 101
#pragma  libcall DOSBase SetComment             0b4 2102
#pragma  libcall DOSBase SetProtection          0ba 2102
#pragma  libcall DOSBase DateStamp              0c0 101
#pragma  libcall DOSBase Delay                  0c6 101
#pragma  libcall DOSBase WaitForChar            0cc 2102
#pragma  libcall DOSBase ParentDir              0d2 101
#pragma  libcall DOSBase IsInteractive          0d8 101
#pragma  libcall DOSBase Execute                0de 32103
#pragma  libcall DOSBase AllocDosObject         0e4 2102
#pragma  libcall DOSBase AllocDosObjectTagList  0e4 2102
#pragma  libcall DOSBase FreeDosObject          0ea 2102
#pragma  libcall DOSBase DoPkt                  0f0 765432107
#pragma  libcall DOSBase DoPkt0                 0f0 2102
#pragma  libcall DOSBase DoPkt1                 0f0 32103
#pragma  libcall DOSBase DoPkt2                 0f0 432104
#pragma  libcall DOSBase DoPkt3                 0f0 5432105
#pragma  libcall DOSBase DoPkt4                 0f0 65432106
#pragma  libcall DOSBase SendPkt                0f6 32103
#pragma  libcall DOSBase WaitPkt                0fc 00
#pragma  libcall DOSBase ReplyPkt               102 32103
#pragma  libcall DOSBase AbortPkt               108 2102
#pragma  libcall DOSBase LockRecord             10e 5432105
#pragma  libcall DOSBase LockRecords            114 2102
#pragma  libcall DOSBase UnLockRecord           11a 32103
#pragma  libcall DOSBase UnLockRecords          120 101
#pragma  libcall DOSBase SelectInput            126 101
#pragma  libcall DOSBase SelectOutput           12c 101
#pragma  libcall DOSBase FGetC                  132 101
#pragma  libcall DOSBase FPutC                  138 2102
#pragma  libcall DOSBase UnGetC                 13e 2102
#pragma  libcall DOSBase FRead                  144 432104
#pragma  libcall DOSBase FWrite                 14a 432104
#pragma  libcall DOSBase FGets                  150 32103
#pragma  libcall DOSBase FPuts                  156 2102
#pragma  libcall DOSBase VFWritef               15c 32103
#pragma  libcall DOSBase VFPrintf               162 32103
#pragma  libcall DOSBase Flush                  168 101
#pragma  libcall DOSBase SetVBuf                16e 432104
#pragma  libcall DOSBase DupLockFromFH          174 101
#pragma  libcall DOSBase OpenFromLock           17a 101
#pragma  libcall DOSBase ParentOfFH             180 101
#pragma  libcall DOSBase ExamineFH              186 2102
#pragma  libcall DOSBase SetFileDate            18c 2102
#pragma  libcall DOSBase NameFromLock           192 32103
#pragma  libcall DOSBase NameFromFH             198 32103
#pragma  libcall DOSBase SplitName              19e 5432105
#pragma  libcall DOSBase SameLock               1a4 2102
#pragma  libcall DOSBase SetMode                1aa 2102
#pragma  libcall DOSBase ExAll                  1b0 5432105
#pragma  libcall DOSBase ReadLink               1b6 5432105
#pragma  libcall DOSBase MakeLink               1bc 32103
#pragma  libcall DOSBase ChangeMode             1c2 32103
#pragma  libcall DOSBase SetFileSize            1c8 32103
#pragma  libcall DOSBase SetIoErr               1ce 101
#pragma  libcall DOSBase Fault                  1d4 432104
#pragma  libcall DOSBase PrintFault             1da 2102
#pragma  libcall DOSBase ErrorReport            1e0 432104
#pragma  libcall DOSBase Cli                    1ec 00
#pragma  libcall DOSBase CreateNewProc          1f2 101
#pragma  libcall DOSBase CreateNewProcTagList   1f2 101
#pragma  libcall DOSBase RunCommand             1f8 432104
#pragma  libcall DOSBase GetConsoleTask         1fe 00
#pragma  libcall DOSBase SetConsoleTask         204 101
#pragma  libcall DOSBase GetFileSysTask         20a 00
#pragma  libcall DOSBase SetFileSysTask         210 101
#pragma  libcall DOSBase GetArgStr              216 00
#pragma  libcall DOSBase SetArgStr              21c 101
#pragma  libcall DOSBase FindCliProc            222 101
#pragma  libcall DOSBase MaxCli                 228 00
#pragma  libcall DOSBase SetCurrentDirName      22e 101
#pragma  libcall DOSBase GetCurrentDirName      234 2102
#pragma  libcall DOSBase SetProgramName         23a 101
#pragma  libcall DOSBase GetProgramName         240 2102
#pragma  libcall DOSBase SetPrompt              246 101
#pragma  libcall DOSBase GetPrompt              24c 2102
#pragma  libcall DOSBase SetProgramDir          252 101
#pragma  libcall DOSBase GetProgramDir          258 00
#pragma  libcall DOSBase SystemTagList          25e 2102
#pragma  libcall DOSBase System                 25e 2102
#pragma  libcall DOSBase AssignLock             264 2102
#pragma  libcall DOSBase AssignLate             26a 2102
#pragma  libcall DOSBase AssignPath             270 2102
#pragma  libcall DOSBase AssignAdd              276 2102
#pragma  libcall DOSBase RemAssignList          27c 2102
#pragma  libcall DOSBase GetDeviceProc          282 2102
#pragma  libcall DOSBase FreeDeviceProc         288 101
#pragma  libcall DOSBase LockDosList            28e 101
#pragma  libcall DOSBase UnLockDosList          294 101
#pragma  libcall DOSBase AttemptLockDosList     29a 101
#pragma  libcall DOSBase RemDosEntry            2a0 101
#pragma  libcall DOSBase AddDosEntry            2a6 101
#pragma  libcall DOSBase FindDosEntry           2ac 32103
#pragma  libcall DOSBase NextDosEntry           2b2 2102
#pragma  libcall DOSBase MakeDosEntry           2b8 2102
#pragma  libcall DOSBase FreeDosEntry           2be 101
#pragma  libcall DOSBase IsFileSystem           2c4 101
#pragma  libcall DOSBase Format                 2ca 32103
#pragma  libcall DOSBase Relabel                2d0 2102
#pragma  libcall DOSBase Inhibit                2d6 2102
#pragma  libcall DOSBase AddBuffers             2dc 2102
#pragma  libcall DOSBase CompareDates           2e2 2102
#pragma  libcall DOSBase DateToStr              2e8 101
#pragma  libcall DOSBase StrToDate              2ee 101
#pragma  libcall DOSBase InternalLoadSeg        2f4 a98004
#pragma  libcall DOSBase InternalUnLoadSeg      2fa 9102
#pragma  libcall DOSBase NewLoadSeg             300 2102
#pragma  libcall DOSBase NewLoadSegTagList      300 2102
#pragma  libcall DOSBase AddSegment             306 32103
#pragma  libcall DOSBase FindSegment            30c 32103
#pragma  libcall DOSBase RemSegment             312 101
#pragma  libcall DOSBase CheckSignal            318 101
#pragma  libcall DOSBase ReadArgs               31e 32103
#pragma  libcall DOSBase FindArg                324 2102
#pragma  libcall DOSBase ReadItem               32a 32103
#pragma  libcall DOSBase StrToLong              330 2102
#pragma  libcall DOSBase MatchFirst             336 2102
#pragma  libcall DOSBase MatchNext              33c 101
#pragma  libcall DOSBase MatchEnd               342 101
#pragma  libcall DOSBase ParsePattern           348 32103
#pragma  libcall DOSBase MatchPattern           34e 2102
#pragma  libcall DOSBase FreeArgs               35a 101
#pragma  libcall DOSBase FilePart               366 101
#pragma  libcall DOSBase PathPart               36c 101
#pragma  libcall DOSBase AddPart                372 32103
#pragma  libcall DOSBase StartNotify            378 101
#pragma  libcall DOSBase EndNotify              37e 101
#pragma  libcall DOSBase SetVar                 384 432104
#pragma  libcall DOSBase GetVar                 38a 432104
#pragma  libcall DOSBase DeleteVar              390 2102
#pragma  libcall DOSBase FindVar                396 2102
#pragma  libcall DOSBase CliInitNewcli          3a2 801
#pragma  libcall DOSBase CliInitRun             3a8 801
#pragma  libcall DOSBase WriteChars             3ae 2102
#pragma  libcall DOSBase PutStr                 3b4 101
#pragma  libcall DOSBase VPrintf                3ba 2102
#pragma  libcall DOSBase ParsePatternNoCase     3c6 32103
#pragma  libcall DOSBase MatchPatternNoCase     3cc 2102
#pragma  libcall DOSBase SameDevice             3d8 2102
#pragma  libcall DOSBase ExAllEnd               3de 5432105
#pragma  libcall DOSBase SetOwner               3e4 2102
#endif
#ifdef __STORM__
#pragma tagcall(DOSBase,0x0e4,AllocDosObjectTags(d1,d2))
#pragma tagcall(DOSBase,0x15c,FWritef(d1,d2,d3))
#pragma tagcall(DOSBase,0x162,FPrintf(d1,d2,d3))
#pragma tagcall(DOSBase,0x1f2,CreateNewProcTags(d1))
#pragma tagcall(DOSBase,0x25e,SystemTags(d1,d2))
#pragma tagcall(DOSBase,0x300,NewLoadSegTags(d1,d2))
#pragma tagcall(DOSBase,0x3ba,Printf(d1,d2))
#endif
#ifdef __SASC_60
#pragma  tagcall DOSBase AllocDosObjectTags     0e4 2102
#pragma  tagcall DOSBase FWritef                15c 32103
#pragma  tagcall DOSBase FPrintf                162 32103
#pragma  tagcall DOSBase CreateNewProcTags      1f2 101
#pragma  tagcall DOSBase SystemTags             25e 2102
#pragma  tagcall DOSBase NewLoadSegTags         300 2102
#pragma  tagcall DOSBase Printf                 3ba 2102
#endif

#endif	/*  _INCLUDE_PRAGMA_DOS_LIB_H  */
