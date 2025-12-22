/*
 * hotlinks_pragmas.h - pragma definitions for hotlinks.library
 *
 *
 */

#ifndef HOTLINKS_HOTLINKS_PRAGMAS_H
#define HOTLINKS_HOTLINKS_PRAGMAS_H       1

/* pragmas for direct calling of the hotlinks.library routines */
#pragma libcall HotLinksBase GetPub 1e 1002
#pragma libcall HotLinksBase PutPub 24 1002
#pragma libcall HotLinksBase PubInfo 2a 001
#pragma libcall HotLinksBase HLSysInfo 30 001   
#pragma libcall HotLinksBase HLRegister 36 21003
#pragma libcall HotLinksBase UnRegister 3c 001   
#pragma libcall HotLinksBase AllocPBlock 42 001   
#pragma libcall HotLinksBase FreePBlock 48 001
#pragma libcall HotLinksBase SetUser 4e 98003
#pragma libcall HotLinksBase ChgPassword 54 a98004
#pragma libcall HotLinksBase FirstPub 5a 001
#pragma libcall HotLinksBase NextPub 60 001   
#pragma libcall HotLinksBase RemovePub 66 001   
#pragma libcall HotLinksBase Notify 6c 821004
#pragma libcall HotLinksBase PubStatus 72 001  
#pragma libcall HotLinksBase GetInfo 78 001   
#pragma libcall HotLinksBase SetInfo 7e 001   
#pragma libcall HotLinksBase LockPub 84 1002   
#pragma libcall HotLinksBase OpenPub 8a 1002  
#pragma libcall HotLinksBase ReadPub 90 21003  
#pragma libcall HotLinksBase WritePub 96 21003  
#pragma libcall HotLinksBase SeekPub 9c 21003
#pragma libcall HotLinksBase ClosePub a2 001
#pragma libcall HotLinksBase Publish a8 001
#pragma libcall HotLinksBase Subscribe ae 001
#pragma libcall HotLinksBase NewPassword b4 001
#pragma libcall HotLinksBase UnSubscribe ba 001

#endif HOTLINKS_HOTLINKS_PRAGMAS_H