#ifndef ACTION_H_1279326587
#define ACTION_H_1279326587

typedef union {
  long alignment;
  char ag_vt_2[sizeof(int)];
  char ag_vt_4[sizeof(token)];
  char ag_vt_5[sizeof(NODE *)];
  char ag_vt_6[sizeof(symbol *)];
  char ag_vt_7[sizeof(void *)];
  char ag_vt_8[sizeof(CLIST *)];
  char ag_vt_9[sizeof(link *)];
  char ag_vt_10[sizeof(char *)];
} action_vs_type;

typedef enum {
  action_action_token = 1, action_FundDecl_token, action_RecIdentList_token,
  action_FundIdentList_token, action_ArrIdentList_token,
  action_PtrIdentList_token, action_SystemDecls_token,
  action_FUNCdecl_token, action_PROCdecl_token, action_modules_token,
  action_eof_token, action_module_token, action_MODULE_token,
  action_ProgModules_token, action_GlobalDecls_token, action_Routines_token,
  action_Routine_token, action_PROCroutine_token, action_FUNCroutine_token,
  action_Statements_token, action_ProcReturn_token, action_PROC_token,
  action_DeclIdent_token, action_VarDecl_token = 25,
  action_ProcInit_token = 27, action_OptStmtList_token,
  action_nothing_token, action_Addr_token = 31, action_RETURN_token,
  action_FuncReturn_token, action_FundType_token, action_FUNC_token,
  action_BitExp_token, action_Stmt_token, action_SimpStmt_token,
  action_StructStmt_token, action_CodeBlock_token, action_AssignStmt_token,
  action_EXITStmt_token, action_ProcCall_token, action_Return_token,
  action_PRETURN_token, action_EXIT_token, action_ProcIdent_token,
  action_Arguments_token, action_FuncCall_token, action_FuncIdent_token,
  action_PROCIDENT_token, action_FUNCIDENT_token, action_IFstmt_token,
  action_WHILEloop_token, action_FORloop_token, action_DOloop_token,
  action_DO_token, action_OptUntil_token, action_OD_token,
  action_UNTIL_token, action_CondExp_token, action_WHILE_token,
  action_FOR_token, action_Ident_token, action_TO_token,
  action_OptStep_token, action_STEP_token, action_IFpart_token,
  action_EndIf_token, action_ELSEpart_token, action_ELSEIFlist_token,
  action_FI_token, action_StartIf_token, action_IF_token, action_THEN_token,
  action_ELSEIFpart_token, action_ELSEIF_token, action_ELSE_token,
  action_MemContents_token, action_ADDassign_token, action_SUBassign_token,
  action_MULassign_token, action_DIVassign_token, action_MODassign_token,
  action_LSHassign_token, action_RSHassign_token, action_ANDassign_token,
  action_ORassign_token, action_XORassign_token, action_OR_token,
  action_AndExp_token, action_AND_token, action_RelExp_token,
  action_GTE_token = 97, action_LTE_token, action_NEQ_token,
  action_ShiftExp_token = 101, action_LSH_token = 104, action_AddExp_token,
  action_RSH_token, action_MulExp_token = 108, action_Urnary_token = 111,
  action_MOD_token = 113, action_Primary_token, action_MemRef_token,
  action_StrConst_token, action_Constant_token,
  action_CompConstList_token = 119, action_CompConst_token = 121,
  action_BitExpList_token, action_PtrRef_token = 125, action_ArrRef_token,
  action_RecRef_token, action_RecordIdent_token = 129,
  action_MembrIdent_token = 131, action_RECTYPE_token,
  action_SystemDecl_token, action_TYPEdecl_token, action_DEFINEdecl_token,
  action_ArrDecl_token, action_PtrDecl_token, action_RecDecl_token,
  action_RecPtrDecl_token, action_BaseVarDecl_token, action_POINTER_token,
  action_PtrIdent_token, action_ARRAY_token, action_ArrIdent_token,
  action_ConstList_token, action_BYTE_token, action_CHAR_token,
  action_INT_token, action_CARD_token, action_LONG_token,
  action_FundIdent_token, action_BaseCompConst_token,
  action_IDENTIFIER_token, action_RecType_token, action_TYPEDEF_token,
  action_RecIdent_token, action_TYPE_token, action_TypeIdentList_token,
  action_TypeIdent_token, action_LBracket_token, action_FieldInit_token,
  action_RBracket_token, action_DEFINE_token, action_DefIdentList_token,
  action_DefIdent_token, action_STRING_token, action_HEX_CONSTANT_token,
  action_CONSTANT_token, action_CHAR_CONSTANT_token
} action_token_type;

typedef struct action_pcb_struct{
  action_token_type token_number, reduction_token, error_frame_token;
  int input_code;
  token input_value;
  int line, column;
  int ssx, sn, error_frame_ssx;
  int drt, dssx, dsn;
  int ss[128];
  action_vs_type vs[128];
  int ag_ap;
  char *error_message;
  char read_flag;
  char exit_flag;
  token input_context;
  token cs[128];
  int bts[128], btsx;
  char ag_msg[82];
} action_pcb_type;

#ifndef PRULE_CONTEXT
#define PRULE_CONTEXT(pcb)  (&((pcb).cs[(pcb).ssx]))
#define PERROR_CONTEXT(pcb) ((pcb).cs[(pcb).error_frame_ssx])
#define PCONTEXT(pcb)       ((pcb).cs[(pcb).ssx])
#endif

#ifndef AG_RUNNING_CODE_CODE
/* PCB.exit_flag values */
#define AG_RUNNING_CODE         0
#define AG_SUCCESS_CODE         1
#define AG_SYNTAX_ERROR_CODE    2
#define AG_REDUCTION_ERROR_CODE 3
#define AG_STACK_ERROR_CODE     4
#define AG_SEMANTIC_ERROR_CODE  5
#endif

extern action_pcb_type action_pcb;
void init_action(void);
void action(void);
#endif

