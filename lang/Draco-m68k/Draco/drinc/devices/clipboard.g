/*requirespreviousinclusionofinclude:exec/io.g*/
uint
„CBD_POSTŒ=CMD_NONSTD+0,
„CBD_CURRENTREADIDƒ=CMD_NONSTD+1,
„CBD_CURRENTWRITEID‚=CMD_NONSTD+2;

int
„CBERR_OBSOLETEID„=1;

long
„PRIMARY_CLIPˆ=0;

type
„Node_t=unknown14,

„ClipboardUnitPartial_t=struct{
ˆNode_tcu_Node;
ˆulongcu_UnitNum;
„},

„IOClipReq_t=struct{
ˆMessage_tioc_Message;
ˆ*Device_tioc_Device;
ˆ*Unit_tioc_Unit;
ˆuintioc_Command;
ˆushortioc_Flags;
ˆshortioc_Error;
ˆulongioc_Actual;
ˆulongioc_Length;
ˆ*byteioc_Data;
ˆulongioc_Offset;
ˆlongioc_ClipId;
„},

„SatisfyMsg_t=struct{
ˆMessage_tsm_Msg;
ˆuintsm_Unit;
ˆlongsm_ClipID;
„};
