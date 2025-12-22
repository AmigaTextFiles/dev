#ifndef KERN_AMIGA_CONFIG_H
#define KERN_AMIGA_CONFIG_H

#ifndef AMIGA_CONFIG_H
#define AMIGA_CONFIG_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef DOS_RDARGS_H
#include <dos/rdargs.h>
#endif

extern BOOL initialized;	/* are we up? */

#define CURRENT(X) ((X)->CS_Buffer+(X)->CS_CurChr)
#define SPACE(X)   ((X)->CS_Length-(X)->CS_CurChr)

#define KEYWORDLEN 24		/* buffer len for keywords */
#define CONFIGLINELEN 1024	/* buffer len for configuration line */
#define REPLYBUFLEN 255
#define MAXRVALLEN 10

/* Parsing error messages */
extern UBYTE ERR_UNKNOWN[];
extern UBYTE ERR_ILLEGAL_VAR[];
extern UBYTE ERR_ILLEGAL_IND[];
extern UBYTE ERR_SYNTAX[];
extern UBYTE ERR_TOO_LONG[];
extern UBYTE ERR_MEMORY[];
extern UBYTE ERR_NONETDB[];
extern UBYTE ERR_VALUE[];
extern UBYTE ERR_NOWRITE[];

/* The command keywords and their tokens */
/* Note: ROUTE is currently not implemented */
#define REXXKEYWORDS "Q=QUERY,S=SET,READ,ROUTE,ADD,RESET,KILL"
enum keyword
{ KEY_QUERY, KEY_SET, KEY_READ, KEY_ROUTE, KEY_ADD, KEY_RESET, KEY_KILL };

/* Variable types */
/* Note: Query calls value, Set calls notify functions */
enum var_type
{
 VAR_FUNC = 1,		/* value is function pointer */
 VAR_LONG,		/* value is pointer to LONG */
 VAR_STRP,		/* value is pointer to string */
 VAR_FLAG,		/* LONG value is set once */
 VAR_INET,		/* struct sockaddr_in */
 VAR_ENUM		/* value is pointer to long, whose value is set
                           according to a enumeration string in notify */
};

typedef LONG 
  (*var_f)(struct CSource *args, UBYTE **errstrp, struct CSource *res);
typedef int (*notify_f)(void *pt, LONG new);

/* Configurable variable structure */
struct cfg_variable {
  enum var_type type;		/* type of value */
  WORD  flags;			/* see below */
  const UBYTE *index;		/* optional index keyword list */
  void  *value;			/* pointer to value... */
  notify_f notify;		/* notification function */
};

#define boolean_enum (notify_f)"NO=FALSE=OFF=0,YES=TRUE=ON=1"

/* Variable flags */
#define VF_TABLE    (1<<0) /* with an index... */
#define VF_READ     (1<<1) /* readable */
#define VF_WRITE    (1<<2) /* writeable */
#define VF_CONF     (1<<3) /* writeable only during configuration */
#define VF_RW       (VF_WRITE|VF_READ)
#define VF_RCONF    (VF_CONF|VF_READ)
#define VF_FREE     (1<<8) /* free when replaced? */

BOOL readconfig(void);

LONG parsefile(UBYTE const *fname, UBYTE **errstrp, struct CSource *res);
LONG parseline(struct CSource *args, UBYTE **errstrp, struct CSource *res);
LONG readfile(struct CSource *args, UBYTE **errstrp, struct CSource *res);
LONG getvalue(struct CSource *args, UBYTE **errstrp, struct CSource *res);
LONG setvalue(struct CSource *args, UBYTE **errstrp, struct CSource *res);
LONG sendbreak(struct CSource *args, UBYTE **errstrp, struct CSource *res);

/*LONG read_gets(struct CSource *args, UBYTE **errstrp, struct CSource *res);*/
LONG read_sets(struct CSource *args, UBYTE **errstrp, struct CSource *res);

LONG parseroute(struct CSource *args, UBYTE **errstrp, struct CSource *res);

#endif /* !AMIGA_CONFIG_H */

#endif /* KERN_AMIGA_CONFIG_H */
