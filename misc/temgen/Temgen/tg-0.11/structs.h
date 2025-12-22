#ifndef __structs_h_
#define __structs_h_

#include "txttab.h"
#include "lintab.h"

struct object
{
    struct object *h;
    struct object_part *t;
};

struct object_part
{
    char      type;
    union op_value {
        int      name;
        struct   funpart {
            struct object_part *h;
            struct explist *l;
        } f;
        struct   tabpart {
            struct object_part *h;
            struct expression *e;
        } t;
        struct   exppart {
            struct expression *e;
        } e;
    } val;
};

struct expression
{
    char    type;
    union   ex_value {
        int            i;
        float          f;
        char          *s;
        struct object *o;
        struct   operation {
            struct expression *a, *b;
            char op;     /*  + - * / e = < > !("!=") l g n("!")
                             i (x++)  d (x--)  I (++x)  D (--x) 
                             1 (*=)   2 (/=)   3 (+=)   4 (-=)     .....  */
        } oper;
        struct array {
            int           reg;
            struct explist *l;
        } a;
        struct record {
            int           reg;
            struct fldlist *l;
        } r;
    } val;
};

struct explist  {
    struct explist *h;
    struct expression *t;
};

struct fldlist {
    struct fldlist    *h;
    int             name;
    struct expression *e;
};

/* command types */
#define      CMD_IF             'i'  
#define      CMD_FUNCTION       'F'
#define      CMD_SWITCH         's'
#define      CMD_FOR            'f'
#define      CMD_RETURN         'r'
#define      CMD_BREAK          'b'
#define      CMD_GOTO           'g'
#define      CMD_EXP            'e'
#define      CMD_DATA           'd'
#define      CMD_EMBED          '<'
#define      CMD_EMIT           '>'
#define      CMD_PUSH           'p'
#define      CMD_POP            'P'
#define      CMD_OUTPUT         'o'
#define      CMD_LOCAL          'l'
#define      CMD_USE            'u'
#define      CMD_EXIT           'x'

struct param {
    struct  param *h; 
    int            t;
};

struct paramlist {
    struct  paramlist *h; 
    char              *t;
};

struct caselist
{
    struct caselist     *h;
    struct expression   *e;
    int               line;
};

struct forctl {
    char type;
    union ctl_data_val {
        struct {           /* eg. "for ($i=0; $i<100; $i++)" */
            struct expression *e1; 
            struct expression *e2;
            struct expression *e3;
        } c;
        struct {           /* eg. "for ($i in $obj)" */
            struct expression *i;
            struct expression *obj;
        } l;
    } val;
};

struct dataitem {
    int start, end;
    struct expression *exp;
};

struct command {
    char  type;

    union cmd_value {
        struct cmd_if_struct {
            struct expression   *cond;
            int                  else_line; 
            int                  end_line;
        } cmd_if;

        struct cmd_function_struct {
            int            name;
            struct  param *par;
            int            end_line;
        } cmd_function;

        struct cmd_switch_struct {
            struct expression     *cond;
            struct caselist       *cl;
            int                    end_line;
        } cmd_switch;

        struct cmd_for_struct {
            struct forctl ctl;
            int end_line;
        } cmd_for;

        struct cmd_exp_struct {           /* return, exp, embed, emit, exit */
            struct expression *e;
        } cmd_exp;

        struct cmd_data_struct {
            struct dataitem *tab;
            unsigned size, count;
        } cmd_data;
        
        struct cmd_local_struct {
            int name;
        } cmd_local;
        
        struct cmd_use_struct {
            int name;
        } cmd_use;
        
        struct cmd_goto_struct {
            int line;
        } cmd_goto;
    } cmd;
};

struct sourcefile {
    int        fname;
    struct txttab *tt;
    struct lintab *lt;
};

struct sysfun {
    int            name;
    struct  param *par;
    int          (*fun)( void );
};

#endif
