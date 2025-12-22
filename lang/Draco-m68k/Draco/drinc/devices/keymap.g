type
„Node_t=unknown14,
„List_t=unknown14,

„KeyMap_t=struct{
ˆ*bytekm_LoKeyMapTypes;
ˆ*ulongkm_LoKeyMap;
ˆ*bytekm_LoCapsable;
ˆ*bytekm_LoRepeatable;
ˆ*bytekm_HiKeyMapTypes;
ˆ*ulongkm_HiKeyMap;
ˆ*bytekm_HiCapsable;
ˆ*bytekm_HiRepeatable;
„},

„KeyMapNode_t=struct{
ˆNode_tkn_Node;
ˆKeyMap_tkn_KeyMap;
„},

„KeyMapResource_t=struct{
ˆNode_tkr_Node;
ˆList_tkr_List;
„};

byte
„KC_NOQUALƒ=0,
„KC_VANILLA‚=7,
„KCB_SHIFTƒ=0,
„KCF_SHIFTƒ=1<<KCB_SHIFT,
„KCB_ALT…=1,
„KCF_ALT…=1<<KCB_ALT,
„KCB_CONTROL=2,
„KCF_CONTROL=1<<KCB_CONTROL,
„KCB_DOWNUP‚=3,
„KCF_DOWNUP‚=1<<KCB_DOWNUP,

„KCB_DEAD„=5,
„KCF_DEAD„=1<<KCB_DEAD,

„KCB_STRING‚=6,
„KCF_STRING‚=1<<KCB_STRING,

„KCB_NOP…=7,
„KCF_NOP…=1<<KCB_NOP,

„DPB_MOD…=0,
„DPF_MOD…=1<<DPB_MOD,
„DPB_DEAD„=1,
„DPF_DEAD„=1<<DPB_DEAD,

„DP_2DINDEXMASK†=0x0f,
„DP_2DFACSHIFT‡=4;
