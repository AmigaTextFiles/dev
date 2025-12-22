#define METHOD      1
#define ATTRIBUTE   2
#define PUBLIC      4

enum {GET_HEADER=0, GET_VARS, SET_HEADER, SET_VARS, MTH_HEADER, MTH_VARS, MTH_VARS_SMALL,
	  MTH_VARS_SUPER_GET_OBJ, MTH_VARS_SUPER_CHECK, MTH_VARS_SUPER,
	  GET_DEFS_TRAILER, GET_TRAILER, SET_DEFS_TRAILER, SET_TRAILER, MTH_TRAILER, MTH_TRAILER_SMALL,
	  MTH_TRAILER_RET_OBJ, MTH_TRAILER_RET_ZERO, MTH_TRAILER_RET_TRUE,
	  GET_ATT_TRAILER, SET_ATT_TRAILER, ATT_TRAILER_SMALL, INGETMETH, INSETMETH, CASE, DISPATCH_HEADER,
	  DISPATCH_CASE, DISPATCH_TRAILER, CONSTRUCTOR_HEADER, CONSTRUCTOR_BODY, ERROPENR,
	  ERROPENW, HEADER, DEFINES};

extern char *messages[];
extern char clsname[];
extern char dataname[];

void CheckSpecialCases(char *name, unsigned long *vars, unsigned long *trailer);
void SetClassName(char *name);
void SetSuperClassName(char *name);
void SetDataName(char *name);
void Add(char *name, char type);
void MakePublic(void);
void MakeMainHeader(FILE *fp, char *headerfilename, char *privheaderfilename);
void MakeHeaders(char *headername, char *privheadername, long base);
void MakeHousekeeping(FILE *fp);
