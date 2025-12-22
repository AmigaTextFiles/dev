#define ASSIGN_STMT 1
#define IF_STMT 2
#define IFELSE_STMT 3
#define ALIAS_STMT 4
#define REPWHILE_STMT 5
#define WHILE_STMT 6
#define FORNEXT_STMT 7
#define FUNCT_STMT 8
#define GOTO_STMT 9
#define GOSUB_STMT 10
#define RETURN_STMT 11
#define STMT_SEQ 12
#define EXPR_SEQ 13
#define ABS_IDENT 14
#define SUB_IDENT 15
#define EQ_EXPR 17
#define NE_EXPR 18
#define GT_EXPR 19
#define LT_EXPR 20
#define GTE_EXPR 21
#define LTE_EXPR 22
#define OR_EXPR 23
#define AND_EXPR 24
#define ADD_EXPR 25
#define SUB_EXPR 26
#define DIV_EXPR 27
#define MUL_EXPR 28
#define NEG_EXPR 29
#define IMM_EXPR 30
#define INCASSIGN_STMT 31
#define DECASSIGN_STMT 32
#define BREAK_STMT 33
#define STOP_STMT 34
#define EMPTY_STMT 35
#define SHIFTL_EXPR 36
#define SHIFTR_EXPR 37
#define EOR_EXPR 38
#define MOD_EXPR 39
#define NOT_EXPR 40
#define CONSTANT_DEF 41
#define GLOBAL_DEF 42
#define DATA_DEF 44
#define FUNCT_DEF 45
#define EXTFUNCT_DEF 46
#define IDENT_SEQ 47
#define DATA_STMT 48
#define STRINGDEF 49
#define STRINGDEF_SEQ 50
#define GLOBALARRAY_DEF 51
#define EXTERN_DEF 53
#define FUNCT_EXPR 55
#define FUNCT_BODY 56
#define RETURNEXPR_STMT 57
#define UNIT_SEQ 58
#define CASE_STMT 59
#define SWITCH_STMT 60
#define CHUNK_STMT 61
#define LOADPTR_STMT 62
#define DEFAULTCASE_STMT 63
#define FLUSH_STMT 64

#define M_NONE 0
#define M_SRC 1
#define M_SRCIF 2
#define M_DEST 3
#define M_INC 4
#define M_DEC 5
#define M_GOTO 6
#define M_DEFPARAMS 7
#define M_PASSPARAMS 8
#define M_DATA 9
#define M_SUBSCRIPT 10
#define M_CASE 11

#define A_VAR 0x00
#define A_VARIND 0x01
#define A_MEM 0x02
#define A_MEMIND 0x03
#define A_DAT 0x04
#define A_DATIND 0x05

#define I_PUSHIMMSMALL 0x00
#define I_PUSHIMM 0x10

#define I_PUSH 0x20
#define I_PUSHVAR 0x20
#define I_PUSHVARIND 0x21
#define I_PUSHMEM 0x22
#define I_PUSHMEMIND 0x23
#define I_PUSHDAT 0x24
#define I_PUSHDATIND 0x25

#define I_STORE 0x30
#define I_STOREVAR 0x30
#define I_STOREVARIND 0x31
#define I_STOREMEM 0x32
#define I_STOREMEMIND 0x33

#define I_INC 0x40
#define I_INCVAR 0x40
#define I_INCVARIND 0x41
#define I_INCMEM 0x42
#define I_INCMEMIND 0x43

#define I_DEC 0x50
#define I_DECVAR 0x50
#define I_DECVARIND 0x51
#define I_DECMEM 0x52
#define I_DECMEMIND 0x53

#define I_LOADVARSMALL 0x60

#define I_LOAD 0x70
#define I_LOADVAR 0x70
#define I_LOADVARIND 0x71
#define I_LOADMEM 0x72
#define I_LOADMEMIND 0x73

#define I_LOADPTR 0x80

#define I_MATH 0x90
#define I_ADD 0x90
#define I_SUB 0x91
#define I_MUL 0x92
#define I_DIV 0x93
#define I_MOD 0x94
#define I_NEG 0x95
#define I_2COMPL 0x96
#define I_SHIFTL 0x97
#define I_SHIFTR 0x98
#define I_AND 0x99
#define I_OR 0x9a
#define I_EOR 0x9b

#define I_IS 0xa0
#define I_ISEQ 0xa0
#define I_ISNE 0xa1
#define I_ISLT 0xa2
#define I_ISGT 0xa3
#define I_ISLTE 0xa4
#define I_ISGTE 0xa5
#define I_RETURN 0xa6
#define I_STOP 0xa7
#define I_JUMP 0xa8
#define I_JUMPSUB 0xa9
#define I_JUMPTRUE 0xaa
#define I_JUMPFALSE 0xab

#define I_EXTERNCALL 0xb0

#define I_JUMPL 0xc0
#define I_JUMPSUBL 0xd0
#define I_JUMPTRUEL 0xe0
#define I_JUMPFALSEL 0xf0

#define I_PTR 0xfd
#define I_DUMMY 0xfe
#define I_DATA 0xff
