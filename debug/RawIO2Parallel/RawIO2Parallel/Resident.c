#include <exec/resident.h>

#include "ResidentEnd.h"
#include "ResidentInit.h"

const struct Resident ROMTag = {
	.rt_MatchWord = RTC_MATCHWORD,
	.rt_MatchTag  = (struct Resident *) &ROMTag,
	.rt_EndSkip   = (void *) &EndFunction,
	.rt_Flags     = RTF_COLDSTART,
	.rt_Version   = 1,
	.rt_Type      = 0, // Nothing, we just want to run rt_Init
	.rt_Pri       = 0, // Need to be initialized later than exec obviously
	.rt_Name      = "RawIO2Parallel",
	.rt_IdString  = "RawIO2Parallel 1.1 (24.10.2022) by Patrik Axelsson",
	.rt_Init      = (void *) &ResidentInit
};
