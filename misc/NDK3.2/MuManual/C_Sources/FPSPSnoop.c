/*************************************************
 ** FPSPSnoop                                   **
 ** print FPSP offending instructions out       **
 **                                             **
 ** Version 40.3 © 30.08.2001 Thomas Richter    **
 ** THOR Software                               **
 *************************************************/

/// Includes
#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/execbase.h>
#include <exec/tasks.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/rdargs.h>
#include <libraries/disassembler.h>
#include <mmu/context.h>
#include <thor/conversions.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/disassembler.h>
#include <proto/mmu.h>

#include <string.h>
#include <stdarg.h>
///
/// Defines
#define LINE_F          0x2c
#define OVERFLOW        0xd4
#define UNDERFLOW       0xcc
#define SNAN            0xd8
#define OPERR           0xd0
#define BUN             0xc0
#define UNIMPDATA       0xdc
#define INEX            0xc4
#define DIVZERO         0xc8
#define UNIMPEA         0xf0
#define UNIMPINT        0xf4

#define NONRESIDENT     (MAPP_BLANK|MAPP_INVALID|MAPP_SWAPPED|MAPP_IO)

#define TEMPLATE        "NOFPSP/S,NOISP/S,NOOVL/S,NOUVL/S,NOSNAN/S,NOOPERR/S,NOBUN/S,NOINEX/S,NODIVZ/S,NOUNEA/S,NOUNDT/S"
#define ARG_NOFPSP      0
#define ARG_NOISP       1
#define ARG_NOOVL       2
#define ARG_NOUVL       3
#define ARG_NOSNAN      4
#define ARG_NOOPERR     5
#define ARG_NOBUN       6
#define ARG_NOINEX      7
#define ARG_NODIVZ      8
#define ARG_NOUNEA      9
#define ARG_NOUNDT      10
#define ARG_NUM         11
///
/// Stuctures
struct RegisterSet {
        ULONG    rs_DataRegs[8];
        APTR     rs_AddrRegs[7];
                APTR     rs_USP;
        APTR     rs_SSP;
        UWORD   *rs_PC;
        UWORD    rs_SR;
        UWORD    rs_Vector;
        ULONG   *rs_EA;
        extendedfloat rs_FPRegs[8];
        ULONG    rs_FPCR;
        APTR     rs_FPIAR;
        ULONG    rs_FPSR;
};
///
/// Statics
char version[]="$VER: FPSPSnoop 40.3 (30.8.2001) © THOR";
struct ExecBase *SysBase;
struct DosLibrary *DOSBase;
struct Library *UtilityBase;
struct DisassemblerBase *DisassemblerBase;
struct MMUBase *MMUBase;
APTR OldVectors[0x100];
///
/// Externs
extern APTR __asm *GetVBR(void);
extern void __asm Exception_Callin(void);
extern void __asm VPrintFmt(register __a0 char *fmtstring,register __a1 ULONG *stream,register __a6 struct ExecBase *SysBase);
///
/// Protos
LONG __saveds main(void);
LONG InstallVecs(LONG *args);
LONG RemoveVecs(void);
void PrintFmt(char *fmtstring,...);
void __asm __saveds Exception_Handler(register __a0 struct RegisterSet *);
void __asm __saveds PutProc(register __d0 UBYTE c,register __a3 char **buf);
void PrintFPU(extendedfloat x);
BOOL IsValid(APTR addr);
///

/// main
LONG __saveds main(void)
{
LONG rc = 25;
LONG args[ARG_NUM];
struct RDArgs *rd;

        SysBase = *(struct ExecBase **)(4L);
        memset(args,0,sizeof(args));

        if (DOSBase = (struct DosLibrary *)OpenLibrary("dos.library",37)) {
                if (UtilityBase = OpenLibrary("utility.library",37L)) {
                        if (DisassemblerBase = (struct DisassemblerBase *)OpenLibrary("disassembler.library",40L)) {
                                if (MMUBase = (struct MMUBase *)OpenLibrary("mmu.library",40L)) {
                                        if (rd = ReadArgs(TEMPLATE,args,NULL)) {

                                                rc = InstallVecs(args);

                                                if (rc == 0) {
                                                        Wait(SIGBREAKF_CTRL_C);

                                                        RemoveVecs();
                                                }

                                                FreeArgs(rd);
                                        } else {
                                                PrintFault(IoErr(),"FPSPSnoop failed");
                                                rc = 10;
                                        }

                                        CloseLibrary((struct Library *)MMUBase);
                                } else {
                                        Printf("FPSPSnoop requires the mmu.library V40 or better.\n");
                                }

                                CloseLibrary((struct Library *)DisassemblerBase);
                        } else {
                                Printf("FPSPSnoop requires the disassembler.library V40 or better.\n");
                        }
                        CloseLibrary(UtilityBase);
                }
                CloseLibrary((struct Library *)DOSBase);
        }

        return rc;
}
///
/// InstallVecs
LONG InstallVecs(LONG *args)
{
APTR *vbr;
APTR exh = (APTR)(&Exception_Callin);

        Disable();

        vbr = GetVBR();

        memcpy(OldVectors,vbr,0x0100 * sizeof(ULONG));

        if (!args[ARG_NOFPSP])  vbr[LINE_F>>2]          = exh;
        if (!args[ARG_NOOVL])   vbr[OVERFLOW>>2]        = exh;
        if (!args[ARG_NOUVL])   vbr[UNDERFLOW>>2]       = exh;
        if (!args[ARG_NOSNAN])  vbr[SNAN>>2]            = exh;
        if (!args[ARG_NOOPERR]) vbr[OPERR>>2]           = exh;
        if (!args[ARG_NOBUN])   vbr[BUN>>2]             = exh;
        if (!args[ARG_NOUNDT])  vbr[UNIMPDATA>>2]       = exh;
        if (!args[ARG_NOINEX])  vbr[INEX>>2]            = exh;
        if (!args[ARG_NODIVZ])  vbr[DIVZERO>>2]         = exh;
        if (!args[ARG_NOUNEA])  vbr[UNIMPEA>>2]         = exh;
        if (!args[ARG_NOISP])   vbr[UNIMPINT>>2]        = exh;

        Enable();

        return 0;
}
///
/// RemoveVecs
LONG RemoveVecs(void)
{
APTR *vbr;

        Disable();

        vbr = GetVBR();

        memcpy(vbr,OldVectors,0x100 * sizeof(ULONG));

        Enable();

        return 0;
}
///
/// PrintFmt
void PrintFmt(char *fmtstring,...)
{
va_list args;

        va_start(args,fmtstring);

        VPrintFmt(fmtstring,(ULONG *)args,SysBase);

        va_end(args);
}
///
/// PutProc
void __asm __saveds PutProc(register __d0 UBYTE c,register __a3 char **buf)
{
        **buf = c;
        (*buf)++;
        **buf = 0;
}
///
/// Exception_Handler
void __asm __saveds Exception_Handler(register __a0 struct RegisterSet *rs)
{
BOOL dumpfpu = TRUE;
char sr[16],buffer[82],*bufptr;
char *name;
struct DisData ds;

        Disable();

        PrintFmt("Caught 68040/68060 trap conditition: ");

        switch(rs->rs_Vector) {
                case LINE_F:
                        PrintFmt("Unimplemented FPU instruction ");
                        break;
                case OVERFLOW:
                        PrintFmt("Overflow ");
                        break;
                case UNDERFLOW:
                        PrintFmt("Underflow ");
                        break;
                case SNAN:
                        PrintFmt("Signalling NAN ");
                        break;
                case OPERR:
                        PrintFmt("Operand Error ");
                        break;
                case BUN:
                        PrintFmt("Branch Unordered ");
                        break;
                case UNIMPDATA:
                        PrintFmt("Unimplemented FPU data type ");
                        break;
                case INEX:
                        PrintFmt("Inexact Result ");
                        break;
                case DIVZERO:
                        PrintFmt("FPU Divide by Zero ");
                        break;
                case UNIMPEA:
                        PrintFmt("Unimplemented EA ");
                        break;
                case UNIMPINT:
                        PrintFmt("Unimplemented integer instruction ");
                        dumpfpu = FALSE;
                        break;
                default:
                        PrintFmt("Unexpected exception ");
        }
        PrintFmt("\n");

        /* Fill in the SR */
        sr[0]  = (rs->rs_SR & 0x8000)?('T'):('_');
        sr[1]  = (rs->rs_SR & 0x4000)?('t'):('_');
        sr[2]  = (rs->rs_SR & 0x2000)?('S'):('_');
        sr[3]  = (rs->rs_SR & 0x1000)?('M'):('_');
        sr[4]  = ((rs->rs_SR & 0x0700)>>8) | '0';
        sr[5]  = (rs->rs_SR & 0x10)?('X'):('_');
        sr[6]  = (rs->rs_SR & 0x08)?('N'):('_');
        sr[7]  = (rs->rs_SR & 0x04)?('Z'):('_');
        sr[8]  = (rs->rs_SR & 0x02)?('V'):('_');
        sr[9] = (rs->rs_SR & 0x01)?('C'):('_');
        sr[10] = 0;

        if (rs->rs_SR & 0x0700) {
                name = "Autovector Interrupt";
        } else {
                name = SysBase->ThisTask->tc_Node.ln_Name;
                if (!IsValid(name)) {
                        name = "????";
                }
                if (SysBase->ThisTask->tc_Node.ln_Type == NT_PROCESS) {
                        struct Process *proc;
                        proc = (struct Process *)(SysBase->ThisTask);

                        if (proc->pr_CLI) {
                                struct CommandLineInterface *cli;

                                cli = (struct CommandLineInterface *)BADDR(proc->pr_CLI);

                                if (IsValid(cli)) {
                                        if (cli->cli_CommandName) {
                                                char *modname;
                                                modname = (char *)BADDR(cli->cli_CommandName);
                                                if (IsValid(modname) && (*modname)) {
                                                        name = modname+1;
                                                }
                                        }
                                }
                        }
                }
        }


        PrintFmt("PC   : %x SR: %s USP: %x SSP: %x EA: %x (%c)(%c)\n"
                 "Name : %s\n",rs->rs_PC,sr,rs->rs_USP,rs->rs_SSP,rs->rs_EA,
                  (SysBase->IDNestCnt == -1)?(' '):('I'),
                  (SysBase->TDNestCnt == -1)?(' '):('T'),
                  name);

        PrintFmt("Data : %x %x %x %x %x %x %x %x\n",
                rs->rs_DataRegs[0],rs->rs_DataRegs[1],rs->rs_DataRegs[2],rs->rs_DataRegs[3],
                rs->rs_DataRegs[4],rs->rs_DataRegs[5],rs->rs_DataRegs[6],rs->rs_DataRegs[7]);
        PrintFmt("Addr : %x %x %x %x %x %x %x %x\n",
                rs->rs_AddrRegs[0],rs->rs_AddrRegs[1],rs->rs_AddrRegs[2],rs->rs_AddrRegs[3],
                rs->rs_AddrRegs[4],rs->rs_AddrRegs[5],rs->rs_AddrRegs[6],
                (rs->rs_SR & 0x2000)?(rs->rs_SSP):(rs->rs_USP));

        if (rs->rs_EA) {
                if (IsValid(rs->rs_EA)) {
                        PrintFmt("EA   : %x %x %x %x %x %x %x %x\n",
                                 rs->rs_EA[0],rs->rs_EA[1],rs->rs_EA[2],rs->rs_EA[3],
                                 rs->rs_EA[4],rs->rs_EA[5],rs->rs_EA[6],rs->rs_EA[7]);
                }
        }

        if (dumpfpu) {
                int i;
                for (i = 0;i<8;i++) {
                        PrintFmt("FP%c  : ",i+'0');
                        PrintFPU((rs->rs_FPRegs[i]));
                }

                sr[0] = (rs->rs_FPCR & 0x8000)?('B'):('_');
                sr[1] = (rs->rs_FPCR & 0x4000)?('S'):('_');
                sr[2] = (rs->rs_FPCR & 0x2000)?('P'):('_');
                sr[3] = (rs->rs_FPCR & 0x1000)?('O'):('_');
                sr[4] = (rs->rs_FPCR & 0x0800)?('U'):('_');
                sr[5] = (rs->rs_FPCR & 0x0400)?('D'):('_');
                sr[6] = (rs->rs_FPCR & 0x0200)?('2'):('_');
                sr[7] = (rs->rs_FPCR & 0x0100)?('1'):('_');
                sr[8] = '.';
                switch (rs->rs_FPCR & 0xc0) {
                        case 0x00:
                                sr[9] = 'n';
                                break;
                        case 0x40:
                                sr[9] = '0';
                                break;
                        case 0x80:
                                sr[9] = '-';
                                break;
                        case 0xc0:
                                sr[9] = '+';
                                break;
                }
                switch (rs->rs_FPCR & 0x30) {
                        case 0x00:
                                sr[10] = 'x';
                                break;
                        case 0x10:
                                sr[10] = 's';
                                break;
                        case 0x20:
                                sr[10] = 'd';
                                break;
                        case 0x30:
                                sr[10] = '?';
                                break;
                }
                sr[11] = 0;

                PrintFmt("FPCR : %s ",sr);

                sr[0] = (rs->rs_FPSR & (1<<27))?('N'):('_');
                sr[1] = (rs->rs_FPSR & (1<<26))?('Z'):('_');
                sr[2] = (rs->rs_FPSR & (1<<25))?('I'):('_');
                sr[3] = (rs->rs_FPSR & (1<<24))?('U'):('_');
                sr[4] = 0;

                PrintFmt("FPSR : %s.%c%x",sr,(rs->rs_FPSR & (1<<23))?('-'):('+'),(rs->rs_FPSR >> 16) & 0x7f);

                sr[0] = (rs->rs_FPSR & 0x8000)?('B'):('_');
                sr[1] = (rs->rs_FPSR & 0x4000)?('S'):('_');
                sr[2] = (rs->rs_FPSR & 0x2000)?('P'):('_');
                sr[3] = (rs->rs_FPSR & 0x1000)?('O'):('_');
                sr[4] = (rs->rs_FPSR & 0x0800)?('U'):('_');
                sr[5] = (rs->rs_FPSR & 0x0400)?('D'):('_');
                sr[6] = (rs->rs_FPSR & 0x0200)?('2'):('_');
                sr[7] = (rs->rs_FPSR & 0x0100)?('1'):('_');
                sr[8] = '.';
                sr[9] = (rs->rs_FPSR & 0x80)?('v'):('_');
                sr[10] = (rs->rs_FPSR & 0x40)?('o'):('_');
                sr[11] = (rs->rs_FPSR & 0x20)?('u'):('_');
                sr[12] = (rs->rs_FPSR & 0x10)?('d'):('_');
                sr[13] = (rs->rs_FPSR & 0x08)?('i'):('_');
                sr[14] = 0;

                PrintFmt(" %s FPIAR : %x\n\n",sr,rs->rs_FPIAR);
        }

        bufptr         = buffer;
        ds.ds_From     = rs->rs_PC;
        ds.ds_UpTo     = rs->rs_PC+1;
        ds.ds_PC       = rs->rs_PC;
        ds.ds_PutProc  = (void *)(&PutProc);
        ds.ds_UserData = &bufptr;
        ds.ds_UserBase = NULL;
        ds.ds_Truncate = 80;
        ds.ds_reserved = 0;

        Disassemble(&ds);

        PrintFmt("%s\n",buffer);

        Enable();
}
///
/// PrintFPU
void PrintFPU(extendedfloat x)
{
char out[32];

        XToA(x,out);

        PrintFmt("%x%x%x = %s\n",x[0],x[1],x[2],out);
}
///
/// IsValid
BOOL IsValid(APTR addr)
{
struct MMUContext *ctx;
ULONG  prop;

        ctx = CurrentContext(NULL);
        ctx = SuperContext(ctx);

        prop = GetPageProperties(ctx,(ULONG)addr,TAG_DONE);

        if (prop & NONRESIDENT)
                return FALSE;

        prop = GetPageProperties(ctx,(ULONG)(addr) + 0x20,TAG_DONE);

        if (prop & NONRESIDENT)
                return FALSE;

        return TRUE;
}
///
