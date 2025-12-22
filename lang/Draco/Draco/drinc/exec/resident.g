type
„Resident_t=struct{
ˆuintrt_MatchWord;
ˆ*Resident_trt_MatchTag;
ˆ*bytert_EndSkip;
ˆushortrt_Flags;
ˆushortrt_Version;
ˆushortrt_Type;
ˆshortrt_Pri;
ˆ*charrt_Name;
ˆ*charrt_IdString;
ˆ*bytert_Init;
„};

uint
„RTC_MATCHWORD=0x4AFC;

ushort
„RTF_AUTOINIT‚=1<<7,
„RTF_COLDSTART=1<<0,

„RTM_WHEN†=3,
„RTM_NEVER…=0,
„RTM_COLDSTART=1;

extern
„FindResident(*charname)*Resident_t,
„InitCode(ulongstartClass,version)void,
„InitResident(*Resident_tres;*SegList_tseglist)void,
„SumKickData()void;
