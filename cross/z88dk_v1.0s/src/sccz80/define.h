/*      Define system dependent parameters     
 *
 * $Id: define.h 1.8 1999/03/22 21:27:18 djm8 Exp $
 */

/*      Stand-alone definitions                 */

#define NO              0
#define YES             1
#define NULL            0
#define NULL_FD 0

#define NULL_FN 0
#define NULL_CHAR 0

#define alloc malloc

/*      System wide name size (for symbols)     */

#define NAMESIZE 33
#define NAMEMAX  32 

#define MAXARGS 10

/*      Define the symbol table parameters      */

#define NUMGLBS         512
#define MASKGLBS        511
#define STARTGLB        symtab
#define ENDGLB          (STARTGLB+NUMGLBS)

#define NUMLOC          55
#define STARTLOC        loctab
#define ENDLOC          (STARTLOC+NUMLOC)

/*      Define symbol table entry format        */

#define SYMBOL struct symb
#define TAG_SYMBOL struct tag_symbol

SYMBOL {
        char name[NAMESIZE] ;
        char ident ;         /*VARIABLE, ARRAY, POINTER, FUNCTION, MACRO */
        char type ;          /* DOUBLE, CINT, CCHAR, STRUCT */
        char storage ;       /* STATIK, STKLOC, EXTERNAL */
        union xx  {          /* offset has a number of interpretations: */
                int i ;      /* local symbol:  offset into stack */
                             /* struct member: offset into struct */
                             /* global symbol: FUNCTION if symbol is                                 declared fn  */
                             /* or offset into macro table, else 0 */
                SYMBOL *p ;  /* also used to form linked list of fn args */
        } offset ;
        char more ;          /* index of linked entry in dummy_sym */
        char tag_idx ;       /* index of struct tag in tag table */
        int  size ;          /* djm, storage reqd! */
        char prototyped;
        unsigned char args[MAXARGS];       /* arguments */
        unsigned char tagarg[MAXARGS];   /* ptrs to tagsymbol entries*/
        char flags ;         /* djm, various flags:
                                bit 0 = unsigned
                                bit 1 = far data/pointer
                                bit 2 = access via far methods
                              */

} ;

#ifdef SMALL_C
#define NULL_SYM 0
#else
#define NULL_SYM (SYMBOL *)0
#endif

/*      Define possible entries for "ident"     */

#define VARIABLE        1
#define ARRAY           2
#define POINTER         3
#define FUNCTION        4
#define MACRO           5
/* function returning pointer */
#define FUNCTIONP       6
/* the following only used in processing, not in symbol table */
#define PTR_TO_FN       7
#define PTR_TO_PTR      8

/*      Define possible entries for "type"      */

#define DOUBLE  1
#define CINT    2
#define CCHAR   3
#define LONG    4       /* was 5 */
#define CPTR    5       /* was 6  - 3 byte pointer */
#define STRUCT  6       /* was 4 */
#define VOID    7       /* This does actually do sommat now */
#define ELLIPSES 8      /* Used for ANSI defs */

/*
 *      Value of ellipses in prototypes
 */

#define PELLIPSES 255

/*
 *      What void comes out to in a prototype
 */

#define PVOID 15

/* number of types to which pointers to pointers can be defined */
/* CHAR, CINT, DOUBLE, LONG & VOID */

#define NTYPE   7

/*      Define possible entries for "storage"   */

#define STATIK  1
#define STKLOC  2
#define EXTERNAL 3
#define EXTERNP  4
#define DECLEXTN 5
#define LSTATIC 6
#define FAR     7
#define LSTKEXT 8


/*      Flags */

#define UNSIGNED  1
#define FARPTR  2
#define FARACC  4

/*
 * MKDEF is for masking unsigned and far
 */
#define MKDEF   3
#define MKSIGN 254
#define MKFARP 253
#define MKFARA 251

/*      Define the structure tag table parameters */

#define NUMTAG          10
#define STARTTAG        tagtab
#define ENDTAG          tagtab+NUMTAG

struct tag_symbol {
        char name[NAMESIZE] ;     /* structure tag name */
        int size ;                /* size of struct in bytes */
        SYMBOL *ptr ;             /* pointer to first member */
        SYMBOL *end ;             /* pointer to beyond end of members */
} ;



#ifdef SMALL_C
#define NULL_TAG 0
#else
#define NULL_TAG (TAG_SYMBOL *)0
#endif

/*      Define the structure member table parameters */

#define NUMMEMB         200
#define STARTMEMB       membtab
#define ENDMEMB         (membtab+NUMMEMB)

/* switch table */

#define NUMCASE 80

struct sw_tab {
        int label ;             /* label for start of case */
        long value ;             /* value associated with case */
} ;

#define SW_TAB struct sw_tab

/*      Define the "while" statement queue      */

#define NUMWHILE        20
#define WQMAX           wqueue+(NUMWHILE-1)

struct while_tab {
        int sp ;                /* stack pointer */
        int loop ;              /* label for top of loop */
        int exit ;              /* label at end of loop */
} ;

#define WHILE_TAB struct while_tab

/*      Define the literal pool                 */

#define LITABSZ 950
#define LITMAX  LITABSZ-1

/*      For the function literal queues... */
#define FNLITQ 5000
#define FNMAX FNLITQ-1

/*      Define the input line                   */

#define LINESIZE        192
#define LINEMAX         (LINESIZE-1)
#define MPMAX           LINEMAX

/*  Output staging buffer size */

#define STAGESIZE       1450
#define STAGELIMIT      (STAGESIZE-1)

/*      Define the macro (define) pool          */

#define MACQSIZE        500
#define MACMAX          MACQSIZE-1

/*      Define statement types (tokens)         */

#define STIF            1
#define STWHILE         2
#define STRETURN        3
#define STBREAK         4
#define STCONT          5
#define STASM           6
#define STEXP           7
#define STDO            8
#define STFOR           9
#define STSWITCH        10
#define STCASE          11
#define STDEF           12
#define STGOTO          13


/* Maximum number of errors before we barf */

#define MAXERRORS 10


/* define length of names for assembler */

#define ASMLEN  32

#ifdef SMALL_C
#define SYM_CAST
#define TAG_CAST
#define WQ_CAST
#define SW_CAST
#else
#define SYM_CAST (SYMBOL *)
#define TAG_CAST (TAG_SYMBOL *)
#define WQ_CAST (WHILE_TAB *)
#define SW_CAST (SW_TAB *)
#endif



/*
 * djm, function for variable definitions now
 */

struct varid {
        unsigned char type;
        unsigned char zfar;
        unsigned char sign;
        unsigned char sflag;
};
