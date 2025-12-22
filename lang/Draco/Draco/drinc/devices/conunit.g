/*requirespreviousinclusionof:
„include:exec/io.ginclude:devices/console.ginclude:devices/inputevent.g*/
uint
„PMB_ASM…=M_LNM+1,
„PMB_AWM…=PMB_ASM+1,
„MAXTABS…=80;

type
„MsgPort_t=unknown34,
„KeyMap_t=unknown32,

„ConUnit_t=struct{
ˆMsgPort_tcu_MP;
ˆ*Window_tcu_Window;
ˆuintcu_XCP,cu_YCP;
ˆuintcu_XMax,cu_YMax;
ˆuintcu_XRSize,cu_YRSize;
ˆuintcu_XROrigin,cu_YROrigin;
ˆuintcu_XRExtant,cu_YRExtant;
ˆuintcu_XMinShrink,cu_YMinShrink;
ˆuintcu_XCCP,cu_YCCP;
ˆKeyMap_tcu_KeyMapStruct;
ˆ[MAXTABS]uintcu_TabStops;
ˆushortcu_Mask,cu_FgPen,cu_BgPen,cu_AOLPen,cu_DrawMode,cu_AreaPtSz;
ˆ*bytecu_AreaPtrn;
ˆ[8]bytecu_Minterms;
ˆ*TextFont_tcu_Font;
ˆushortcu_AlgoStyle,cu_TxFlags;
ˆuintcu_TxHeight,cu_TxWidth,cu_TxBaseLine,cu_TxSpacing;
ˆ[(PMB_AWM+7)/8]bytecu_Modes;
ˆ[(IECLASS_MAX+7)/8]bytecu_RawEvents;
„};

extern
„CDInputHandler(*InputEvent_tevents;*Device_tconsoleDevice)*InputEvent_t,
„RawKeyConvert(*InputEvent_tevent;*charbuffer;ulonglength;
’*KeyMap_tkeyMap)long;
