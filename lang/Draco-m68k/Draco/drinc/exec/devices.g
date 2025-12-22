type
„Library_t=unknown34,

„Device_t=struct{
ˆLibrary_tdd_Library;
„},

„Unit_t=struct{
ˆ*MsgPortunit_MsgPort;
ˆbyteunit_flags;
ˆbyteunit_pad;
ˆuintunit_OpenCnt;
„};

byte
„UNITF_ACTIVE=1<<0,
„UNITF_INTASK=1<<1;

extern
„AddDevice(*Device_td)void,
„RemDevice(*Device_td)bool;
