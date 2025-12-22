
#define TYPE_INCFILE          1
#define TYPE_ADOCFILE         2
#define TYPE_ADOCNAME         3
#define TYPE_ADENTRY          4
#define TYPE_DEFINE           5
#define TYPE_TYPEDEF          6
#define TYPE_TYPEDEFSTRUCT    7
#define TYPE_STRUCT           8

#define TYPEMAX 8
extern char *TypeNameArray[TYPEMAX];

#define MAX_LEN 200                             /* Max. len for identifiers AND autodoc lines */
extern char Buffer[MAX_LEN];

#define TypeName(num)   ( ((num>=0) && (num<=TYPEMAX)) ? TypeNameArray[num-1] : "unknown!" )

BOOL Break(void);

char *stpcpy(char *to,const char *from);

