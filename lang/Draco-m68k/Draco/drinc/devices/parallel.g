/*requirespreviousinclusionofinclude:exec/io.g*/
type
„IOPArray_t=struct{
ˆulongiop_PTermArray0,iop_PTermArray1;
„},

„IOExtPar_t=struct{
ˆIOStdReq_tiop_IOPar;
ˆulongiop_PExtFlags;
ˆushortiop_Status;
ˆushortiop_ParFlags;
ˆIOPArray_tiop_PTermArray;
„};

ushort
„PARB_SHARED‰=5,
„PARF_SHARED‰=1<<PARB_SHARED,
„PARB_RAD_BOOGIE…=3,
„PARF_RAD_BOOGIE…=1<<PARB_RAD_BOOGIE,
„PARB_EOFMODEˆ=1,
„PARF_EOFMODEˆ=1<<PARB_EOFMODE,
„IOPARB_QUEUED‡=6,
„IOPARF_QUEUED‡=1<<IOPARB_QUEUED,
„IOPARB_ABORTˆ=5,
„IOPARF_ABORTˆ=1<<IOPARB_ABORT,
„IOPARB_ACTIVE‡=4,
„IOPARF_ACTIVE‡=1<<IOPARB_ACTIVE,
„IOPTB_RWDIR‰=3,
„IOPTF_RWDIR‰=1<<IOPTB_RWDIR,
„IOPTB_PBUSY‰=2,
„IOPTF_PBUSY‰=1<<IOPTB_PBUSY,
„IOPTB_PAPEROUT†=1,
„IOPTF_PAPEROUT†=1<<IOPTB_PAPEROUT,
„IOPTB_PSELŠ=0,
„IOPTF_PSELŠ=1<<IOPTB_PSEL;

*charPARALLELNAME="parallel.device";

uint
„PDCMD_QUERY‰=CMD_NONSTD,
„PDCMD_SETPARAMS…=CMD_NONSTD+1;

int
„ParErr_DevBusy†=1,
„ParErr_BufTooBig„=2,
„ParErr_InvParam…=3,
„ParErr_LineErr†=4,
„ParErr_NotOpen†=5,
„ParErr_PortReset„=6,
„ParErr_InitErr†=7;
