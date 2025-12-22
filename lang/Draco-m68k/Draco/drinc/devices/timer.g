/*requirespreviousinclusionofinclude:exec/io.g*/
type
„timeval_t=struct{
ˆulongtv_secs,tv_micro;
„},

„timerequest_t=struct{
ˆIORequest_ttr_node;
ˆtimeval_ttr_time;
„};

uint
„UNIT_MICROHZˆ=0,
„UNIT_VBLANK‰=1;

*charTIMERNAME="timer.device";

uint
„TR_ADDREQUEST‡=CMD_NONSTD,
„TR_GETSYSTIME‡=CMD_NONSTD+1,
„TR_SETSYSTIME‡=CMD_NONSTD+1;

extern
„AddTime(*timeval_tdest,source)void,
„CmpTime(*timeval_tdest,source)int,
„SubTime(*timeval_tdest,source)void;
