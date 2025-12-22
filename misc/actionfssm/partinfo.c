/*
** PartInfo.c - obtain device and geometry data pertaining to a partition
** Copyright © 1993, 1994 by Ralph Babel, Falkenweg 3, D-65232 Taunusstein, FRG
** all rights reserved - alle Rechte vorbehalten
**
** 09-Jun-1993 created
** 07-Jul-1993 fixed memcpy() call
** 24-Feb-1994 fixed Forbid()/Permit()
*/

/*** included files ***/

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/filehandler.h>
#include <clib/macros.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <stdio.h>
#include <string.h>

/*** constants ***/

#define ACTION_GET_DISK_FSSM  4201
#define ACTION_FREE_DISK_FSSM 4202

/*** types ***/

struct PartInfo
 {
 char *deviceName;      /* OpenDevice()'s A0 parameter */
 ULONG deviceUnit;      /* OpenDevice()'s D0 parameter */
 ULONG deviceFlags;     /* OpenDevice()'s D1 parameter */
 ULONG bytesPerSector;  /* partition geometry */
 ULONG sectorsPerBlock; /* partition geometry */
 ULONG blocksPerTrack;  /* partition geometry */
 ULONG surfaces;        /* partition geometry */
 ULONG lowCylinder;     /* partition geometry */
 ULONG highCylinder;    /* partition geometry */
 ULONG reservedBlocks;  /* concession to default filesystem */
 ULONG bootBlocks;      /* for Install-like programs */
 ULONG memoryType;      /* safe io_Data default */
 ULONG addressMask;     /* io_Data restriction */
 ULONG maxTransfer;     /* io_Length restriction */
 ULONG defaultDosType;  /* Format()'s default D3 parameter */
 };

/*** code section ***/

void __regargs __chkabort(void) {} /* disable SAS/C Ctrl-C checking */

static LONG doStdPkt(struct StandardPacket *sp, struct MsgPort *mp, LONG *pIoErr)
 {
 struct MsgPort *rp;

 rp = &((struct Process *)FindTask(NULL))->pr_MsgPort;

 sp->sp_Msg.mn_Node.ln_Name = (char *)&sp->sp_Pkt;
 sp->sp_Pkt.dp_Link         = &sp->sp_Msg;
 sp->sp_Pkt.dp_Port         = rp;

 PutMsg(mp, &sp->sp_Msg);
 (void)WaitPort(rp);
 (void)GetMsg(rp); /* assumes that no other packets are pending */

 *pIoErr = sp->sp_Pkt.dp_Res2;

 return sp->sp_Pkt.dp_Res1;
 }

static struct FileSysStartupMsg *getDiskFssm(struct MsgPort *mp)
 {
 LONG ioErr;
 struct FileSysStartupMsg *fssm;
 char SP[sizeof(struct StandardPacket) + 3];
 struct StandardPacket *sp = (struct StandardPacket *)((ULONG)(SP + 3) & ~3);

 sp->sp_Pkt.dp_Type = ACTION_GET_DISK_FSSM;

 fssm = (struct FileSysStartupMsg *)doStdPkt(sp, mp, &ioErr);

 /*
 ** If need be, try alternative scheme if and only if fssm
 ** equals NULL and ioErr equals ERROR_ACTION_NOT_KNOWN.
 */

 return fssm;
 }

static void freeDiskFssm(struct MsgPort *mp, struct FileSysStartupMsg *fssm)
 {
 LONG ioErr;
 char SP[sizeof(struct StandardPacket) + 3];
 struct StandardPacket *sp = (struct StandardPacket *)((ULONG)(SP + 3) & ~3);

 sp->sp_Pkt.dp_Type = ACTION_FREE_DISK_FSSM;
 sp->sp_Pkt.dp_Arg1 = (LONG)fssm;

 (void)doStdPkt(sp, mp, &ioErr);
 }

static struct PartInfo *getPartInfo(const char *name)
 {
 struct MsgPort *mp;
 struct FileSysStartupMsg *fssm;
 struct PartInfo *pi;
 struct DosEnvec *de, DE;
 char *deviceName;
 size_t tableSize;

 pi = NULL;

 if((mp = DeviceProc((char *)name)) != NULL)
  {
  if((fssm = getDiskFssm(mp)) != NULL)
   {
   deviceName = 1 + (char *)BADDR(fssm->fssm_Device);

   if((pi = AllocMem((ULONG)(sizeof(struct PartInfo) + strlen(deviceName) + 1), 0)) != NULL)
    {
    pi->deviceName  = strcpy((char *)pi + sizeof(struct PartInfo), deviceName);
    pi->deviceUnit  = fssm->fssm_Unit;
    pi->deviceFlags = fssm->fssm_Flags;

    DE.de_BufMemType  = MEMF_CHIP | MEMF_PUBLIC;
    DE.de_MaxTransfer = 0x7fffffff;
    DE.de_Mask        = 0xfffffffe;
    DE.de_DosType     = 0x444f5300;
    DE.de_BootBlocks  = 2;

    de        = BADDR(fssm->fssm_Environ);
    tableSize = (MIN(de->de_TableSize, DE_BOOTBLOCKS) + 1) * sizeof(ULONG);

    Forbid();
    (void)memcpy(&DE, de, tableSize);
    Permit();

    pi->bytesPerSector  = DE.de_SizeBlock * BYTESPERLONG;
    pi->sectorsPerBlock = DE.de_SectorPerBlock;
    pi->blocksPerTrack  = DE.de_BlocksPerTrack;
    pi->surfaces        = DE.de_Surfaces;
    pi->lowCylinder     = DE.de_LowCyl;
    pi->highCylinder    = DE.de_HighCyl;
    pi->reservedBlocks  = DE.de_Reserved;
    pi->bootBlocks      = DE.de_BootBlocks;
    pi->memoryType      = DE.de_BufMemType;
    pi->addressMask     = DE.de_Mask;
    pi->maxTransfer     = DE.de_MaxTransfer;
    pi->defaultDosType  = DE.de_DosType;
    }

   freeDiskFssm(mp, fssm);
   }
  }

 return pi;
 }

static void freePartInfo(struct PartInfo *pi)
 {
 FreeMem(pi, (ULONG)(sizeof(struct PartInfo) + strlen(pi->deviceName) + 1));
 }

/*** entry point ***/

int main(int argc, char *argv[])
 {
 int result;
 struct PartInfo *pi;

 result = RETURN_FAIL;

 if(argc == 2)
  {
  result = RETURN_ERROR;

  if((pi = getPartInfo(argv[1])) != NULL)
   {
   result = RETURN_OK;

   printf("deviceName      = \"%s\"\n", pi->deviceName);
   printf("deviceUnit      = %ld\n",    pi->deviceUnit);
   printf("deviceFlags     = %ld\n",    pi->deviceFlags);
   printf("bytesPerSector  = %ld\n",    pi->bytesPerSector);
   printf("sectorsPerBlock = %ld\n",    pi->sectorsPerBlock);
   printf("blocksPerTrack  = %ld\n",    pi->blocksPerTrack);
   printf("surfaces        = %ld\n",    pi->surfaces);
   printf("lowCylinder     = %ld\n",    pi->lowCylinder);
   printf("highCylinder    = %ld\n",    pi->highCylinder);
   printf("reservedBlocks  = %ld\n",    pi->reservedBlocks);
   printf("bootBlocks      = %ld\n",    pi->bootBlocks);
   printf("memoryType      = $%08lx\n", pi->memoryType);
   printf("addressMask     = $%08lx\n", pi->addressMask);
   printf("maxTransfer     = $%08lx\n", pi->maxTransfer);
   printf("defaultDosType  = $%08lx\n", pi->defaultDosType);

   freePartInfo(pi);
   }
  else
   fprintf(stderr, "Unable to obtain partition information.\n");
  }
 else
  fprintf(stderr, "Usage: %s <devicename>\n", argv[0]);

 return result;
 }
