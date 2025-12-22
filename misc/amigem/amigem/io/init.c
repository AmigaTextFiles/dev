#define DEV_VERSION	1
#define DEV_ID		"$VER: io.device 1.0 (24.12.94)\0xa\0xd"

/* Choke if called from CLI */
int FirstAddress(void)
{ return -1; }

static const struct Resident initDDescrip=
{
  RTC_MATCHWORD,
  &initDDescrip,
  &EndCode,
  RTF_AUTOINIT,
  DEV_VERSION,
  NT_DEVICE,
  0,
  "io.device",
  &DEV_ID[6],
  &Init
};

struct dev
{
  struct Device Device;
  struct ExecBase *SysBase;
  BPTR SegList;
};

#define SysBase XIOBase->SysBase

const APTR Init[4]=
{
  (APTR)sizeof(struct dev),
  funcTable,
  dataTable,
  &IO_Init
};

FC3(struct Device *,IO_Init,struct dev *XIOBase,D0,BPTR segList,A0,struct Library *sysBase,A6)
{
  SysBase=sysBase; /* No need to read address 4 */
  XIOBase->SegList=segList;
  
}
