/*                        LFLocalize.c
 *                      ©LFSoft 1994-96
 *
 *   Sorry for this small doc and my english but I don't want to loose time
 *  for such bullshits. Look Commodore's Localize documentation for more !!
 *
 *  Some French words:
 *   Je n'ai vraiment pas le temps de faire une doc complète. Ce source contient
 *  des explications en anglais (Pensez au autres; quel est votre sentiment
 *  face a un super utilitaire méga-génial mais qui n'est qu'en allemand ? -
 *  si vous ne parlez pas cette langue bien sur ! -).
 *
 *   Ce fichier est bourré de "fôtes d'aurtografe". Prenez votre plus belle
 *  plume et faites en une que je puisse inclure dans cette distribution.
 *
 *   En faisant ce programme, mon but n'est pas de faire un exemple de l'art
 *  de la programmation, mais simplement un truc qui fonctionne. Si vous n'
 *  aimez pas les codes "plats de nouille" comme au bon vieux temps du BASIC,
 *  c'est pas la peine d'allez plus loin...
 *
 *   Si vous voulez que ce programme 'cause la France', ajoutez dans votre
 *  s:User-Startup la commande :
 *      Setenv Lang Français
 *
 *  Purpose: To localize C sources file.
 *  ~~~~~~~~
 *  Because C='s Localize doesn't work.
 *  LFLocalise user's interface looks like Localize but temporaries files are
 *  not compatible.
 *
 *  LFLocalize is distributed "AS-IS", use it at your own risk.
 *  This product is FreeWare meening that you can redistribute it for non-
 *  commercial purpose only. You can use it for localize non-commercial as
 *  well as commercial products but add in documentation that you have used
 *  "LFLocalize v0.5 from LFSoft".
 *
 *  WARNING : Don't change sources codes between PARSE and PATCH, and don't
 *  alter ordering of line in the data file.
 *
 *  Options:
 *  ~~~~~~~~
 *   LFLocalize support following options w/ a 2.0+ shell commands template:
 *  $ indicat not currently supported keywords
 *
 *  PATCH/S : If not given, LFLocalize print out information about strings that
 *          may be redirected ( ">" ) to a "stringfile".
 *          With PATCH keyword, LFLocalize create a localized source file
 *          according to the "stringfile".
 *  MERGECATALOG/K or MC : Create only a common catalog for all source file.
 *          *Must be present in this version*
 *  SILENT/S or SH: Be quiet. ( Only print errors ).
 *  NEST/S : Allow nested comments ( not recommended & unsupported by ANSI ).
 *  FILES/M : List of all source file to be localized.
 *  OPTIMIZE/S or OPT : With this keyword, duplicated message got uniq ID
 *  FUNCTION/K or FUNC: Specifies the name of the fonction to be called to
 *          localize a string (default : GetCatalogStr)
 *  TEMPLATE/K or TEMP : Specifies the calling convention for fonction.
 *      With locale.library, the substitutions available are :
 *              %F The fonction name.
 *              %I Message tag for the string
 *              %S String tag ( message tag + _STR )
 *              %D default string
 *          default :
 *              (catalog ? %F(catalog, %I, %S) : %S)
 *      With INTERNAL flags, the substitutions available are :
 *              %V The name of the variable (see VARIABLE),
 *              %A array of string
 *          default:
 *              %A[%V]
 *
 *  DIRECTORY/K or DIR : The directory to puts localized sources files (only for
 *          sources files, not for catalogs or others...).
 *$ PREPENDSTRING/K or PS and PREPENDFILE/K or PF : Prepend a string or a file
 *          to the localized source file.
 *$ APPENDSTRING/K or AS and APPENDFILE/K or AF : Append a string or a file to
 *          the localized source file
 *
 *  INTERNAL/S or INT: With this option, your localized source file doesn't use
 *          catalogs nor locale.library, but translation is done internaly. This
 *          source file is an example how to use this feature. In INTERNAL mode,
 *          cd file(s) hold code to include into your source.
 *
 *  VARIABLE/K or VAR: Variable index for array of localized string.
 *          ( default Lang )
 *
 *  SORT/S : Ignored, for compatibility only.
 *
 *  OLDCD/K : read a previewsly created description file (.CD) and add this file
 *          to the database. Usefull for localize a modified source file that
 *          has previously be localized.
 *          - In parse mode, with OPTIMIZE flag, check if this string is not in
 *          the old cd,
 *          - In patch mode, doesn't recreate old strings descriptions in the
 *          new CD file.
 *      => If you just want to expand your old catalog, use OLDCD in patch mode
 *          and JOIN the old and new CD. The new CD file old only new strings.
 *      => If you totaly new catalog, don't use OLDCD and you'll get a CD file
 *          containing ALL strings (defined in sources files).
 *
 *  According to the running mode ( parse or patch ) some options are silently
 *  ignored ...
 *
 *  Know bugs, warnings & limits :
 *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  I think LFLocalize have many bugs (not enought tests for syntaxe validity,
 *  but, in the other hand, C='s Localize does the same), and it wasn't
 *  programmed in 'the stat of the art' ways (in fact it's realy a "code Plat
 *  de nouille" as french programmers said ) but it work well /w my own source
 *  code, (better than Localize 2.9).
 *
 *  Before patching, make a backup of sources files. If something goes wrong,
 *  send me original and patched sources, so I can fixe LFLocalize.
 *
 *  Some options are not implemented.
 *
 *  CD files used w/ OLDCD can't have line longer than 255 characters. (STRLMT)
 *
 *   Some Amiga specific functions are used for parsing arguments but, with
 *  minors change, this code may be portable to others systems.
 *  NOTEZ-BIEN: As standard C allocation function are used, all resources are
 *  freed by _exit().
 *
 *  CopyRight:
 *  ~~~~~~~~~~
 *  Even if this tool is FREEWARE, gifts are wellcome ( Amiga 4000, Multi-Sync
 *  monitor, chocolates, ... or only a post card ).
 *  Write to:
 *                      Laurent Faillie
 *                       "Les Vuardes"
 *                      74930 Pers-Jussy
 *                          FRANCE
 *
 *  This little peace of code was compiled by M.Dillon's wanderfull Dice C
 *  version 2.07.54R ( tanks to SomeWare for importating Dice in France ).
 *  It is a PURE executable.
 *
 *  Only some part of this header was inspired from C='s Localize documentation.
 *  All of this code was writen from scratch ( execept LFformat() that come
 *  from my very own DiceConfig 2.1 ), so this code is under my copyright.
 *
 *  Attention:
 *      - LFatal() used in this code simply open an alerte for displaying
 *  passed message. LFGets() act like fgets() but discard remaining '\n'
 *  Functions included in my LF.lib...
 *      - Libraries are auto opened by DICE,
 *      - Memories are allocated using malloc(), so free()s are done by exit()
 *
 *  Note: Reading strange things like / * \ * / is accorded to Dice.
 *        Nested comment aren't supported by ANSI standard.
 *
 *  Strings types :
 *      L : Localizable,
 *      M : Multi-lines localizable string, ( not currently supported )
 *      E : External (No Localizable)
 *
 *  NOTEZ-BIEN:
 *  - Only 'L' strings are localized. if you want to localize External strings,
 *  you may change E to L.
 *
 *  Look for my latest PDs tools ...
 *
 *  History: BF: Bug fix, A: Added
 *  ~~~~~~~~
 *  15-01-1994: Start of development.
 *
 *  v0.1    02-03-1994
 *      First useable version released
 *
 *  v0.2    27-04-1994
 *      BF: Msg_ID are only in UPPER CASE because catcomp doesn't like lowers,
 *      BF: In patch mode a source file is not needed
 *      A: Optimize can be switched off
 *      A: Optimize cd file.
 *      A: Added TEMPLATE and FUNCTION mechanism
 *
 *  v0.3
 *      A: Added INTERNAL mecanisme.
 *
 *  v0.4
 *      BF: Enforcer hits when reading arguments fixed.
 *
 *  v0.5
 *      A: Rewritten code, with many more comments
 *      A: Added DIRECTORY mechanism
 *      A: Added OLDCD mechanism
 *      BF: In internal mode, change variable from UBYTE * to size_t
 *
 *  e.g.:
 *      LFLocalise >ram:string file.c OPT
 *      LFLocalise PATCH ram:string MC my.cd
 *          -> *.cl The results localized source file
 *          -> *.cd the catalog description file
 *
 *  e.g.2:
 *      LFLocalise >ram:string file.c OPT OLDCD my.oldcd
 *      LFLocalise PATCH ram:string MC my.cd DIR t: OLDCD my.oldcd FUNC GetLocStr TEMP "%F(%I)"
 *          -> The results localized source file in t:
 *          -> my.cd the catalog description file
 *          -> my.oldcd : Old cd file.
 *          -> The function used is GetLocStr() and take string id as argument.
 *
 *  This code is an example of internaly localized source code...
 *
 */

#include <LF.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <proto/Dos.h>

#define EOL '\n'
#define STRLMT 256

#ifdef _DCC
    void OS2_0( void );
#endif

#ifdef DEBUG
    #define DMSG(x) {fputs(x,stderr);}
    /*
    #define DEBUGALL
    */
#else
    #define DMSG(x)
#endif

/*
 *      Code for localized strings
 *      Generated by LFLocalize 0.3ß
 *      from LFSoft (©1994)
 */

#include <exec/types.h>
const UBYTE *MSG_STRLG[]={"String to long\n","Chaîne trop longue"};
const UBYTE *MSG_NOM[]={"Not enough memory","Pas assez de mémoire"};
const UBYTE *MSG_ENT[]={"Error : %%%c is not an token","Erreur : %%%c n'est pas un token"};
const UBYTE *MSG_ETE[]={" Strange Error\n NULL string for %%%c"," Etrange erreur\nChaîne NULLE pour %%%c"};
const UBYTE *MSG_PFS[]={"String file is missing","Le fichier des chaînes doit être spécifié"};
const UBYTE *MSG_COSF[]={"Can't open strings file","Impossible d'ouvrir le fichier des chaînes"};
const UBYTE *MSG_COCF[]={"Can't open cd file","Impossible d'ouvrir le fichier cd"};
const UBYTE *MSG_MCN[]={"This version need a merged cd file ( MERGECATALOG )\n","Cette version nécéssite l'utilisation d'un seul fichier CD ( MERGECATALOG )\n"};
const UBYTE *MSG_HCDI[]={"/*\n *\tCode for localized strings\n *\tGenerated by LFLocalize 0.5ß\n *\tfrom LFSoft (©1994)\n */\n\n#include <exec/types.h>\n\n",
                   "/*\n *\tCode des chaînes localisées\n *\tGénéré par LFLocalize 0.5ß\n *\td' LFSoft (©1994)\n */\n\n#inlude <exec/types.h>\n"};
const UBYTE *MSG_HCDL[]={";\n;\tDescription generated by LFLocalize 0.5ß\n;\t\tfrom LFSoft (©1994)\n;\n",
                   ";\n;\tDescription créée par LFLocalize 0.5ß\n;\t\td' LFSoft (©1994)\n;\n"};
const UBYTE *MSG_HSF[]={"#C\n#C\tFile generated by LFLocalize 0.5ß\n#C\t\tfrom LFSoft (©1994-96)\n#C\n\n#C Tp|l#|sc# |ec# | Msg ID |",
                   "#C\n#C\tFichier créée par LFLocalize 0.5ß\n#C\t\td' LFSoft (©1994-96)\n#C\n\n#C Tp|l#|cd# |cf# | ID Msg |"};
const UBYTE *MSG_PROC[]={"Processing %s\n","Traitemant de %s\n" };
const UBYTE *MSG_COP[]={"Can't open '%s'\n","Impossible d'ouvrir '%s'\n"};
const UBYTE *MSG_CPF[]={"Corrupted patch file","Fichier de patch modifié"};
const UBYTE *MSG_UEOF[]={"Unexpected EOF","Fin de fichier inattendu"};
const UBYTE *MSG_UEOL[]={"Unexpected EOL","Fin de ligne inattendu"};
const UBYTE *MSG_EXPC[]={"Expected \"","\" attendu"};
const UBYTE *MSG_REDS[]={"Reading '%s'\n","Lecture de '%s'\n"};
const UBYTE *MSG_EUSTR[]={"Unterminated string in %s line %d\n","Chaîne sans fin dans %s ligne %d\n"};
const UBYTE *MSG_ENC[]={"Possibly nested comment (ignored) in %s line %d\n","Commentaire imbriqué ( & ignoré ) dans %s ligne %d\n"};
const UBYTE *MSG_UMC[]={"Unmatching */ in %s line %d\n","*/ sans correspondance dans %s ligne %d\n"};
const UBYTE *MSG_UMB[]={/*{*/"Unmatching '}' in %s line %d\n",/*{*/"'}' sans correspondance dans %s ligne %d\n"};
const UBYTE *MSG_PB[]={"pending %d bloc%c\n","%d bloc%c en suspend\n"};
const UBYTE *MSG_PC[]={"pending %d comment%c\n","%d commentaire%c en suspend\n"};
const UBYTE *MSG_UTS[]={"Unterminated string","Chaîne sans fin"};
const UBYTE *MSG_FNTL[]={"Target file name is too long","Le fichier de destination est trop long"};
const UBYTE *MSG_BFCD[]={"Bad formated description file","Fichier de description mal formaté"};
UBYTE Lang=0;

    /*
     *  Arguments management
     */

    // Keys of 'template'
#define NBRE_MC 17
    // template
#define TEMP \
"PATCH/S,DIR=DIRECTORY/K,MC=MERGECATALOG/K,SORT/S,FUNC=FUNCTION/K,TEMP=TEMPLATE/K,SH=SILENT/S,NEST/S,PS=PREPENDSTRING/K,PF=PREPENDFILE/K,AS=APPENDSTRING/K,AF=APPENDFILE/K,OPT=OPTIMIZE/S,FILES/M,INT=INTERNAL/S,VAR=VARIABLE/K,OLDCD/K"
// 0          1              2               3         4               5              6         7           8                9              10                11             12            13       14              15            16

struct  RDArgs *argt;
long    argr[NBRE_MC];

void fini(void){
    if(argt) FreeArgs(argt);
}

// Some usefulls define
#define apatch  ((BOOL)argr[0])
#define adir    ((char *)argr[1])
#define amc     ((char *)argr[2])
#define asort   ((BOOL)argr[3])
#define afonc   ((char *)argr[4])
#define atemp   ((char *)argr[5])
#define ash     ((BOOL)argr[6])
#define anest   ((BOOL)argr[7])
#define aps     ((char *)argr[8])
#define apf     ((char *)argr[9])
#define aas     ((char *)argr[10])
#define aaf     ((char *)argr[11])
#define aopt    ((BOOL)argr[12])
#define afch    ((char **)argr[13])
#define aint    ((BOOL)argr[14])
#define avar    ((char *)argr[15])
#define aocd    ((char *)argr[16])

struct {    // Store current status
    ULONG       msgid;      // Current id for msgs
    ULONG       nl;         // Line number
    UWORD       nc;         // Char number
    UWORD       com;        // Comments '/* */'
    UWORD       bloc;       // In bloc '{ }'
    UBYTE       isdefine;   // Define. ( if == 7 else we are reading '#define' )
    unsigned    lcom :1;    // C++ Comments '//' (according to Dice, ignored in /* */)
    unsigned    fonc :1;    // In fonction.
    unsigned    maf :1;     // /*(*/ Last char is ')'
    unsigned    slt :1;     // Last char is '/'
    unsigned    star :1;    // Last char is '*'
    unsigned    ignore :1;  // Last char is '\' or '''
    unsigned    instr :1;   // We are reading a string
    unsigned    mlstre:1;   // Multi line strings enable
} status;

/* HOW DOES IT WORK ?
 * If com !=0, we are in (nested) comment
 * If ignore, skip the next char ( Not EOF if instr )
 * If instr, We are reading a string ( EOF -> Syntaxe Error )
 */


    /*
     *  Linked list for strings' data base
     */

struct sstr {
    struct sstr *next;  // Next string in the list
    const char *string; // the string
    const char *sid;    // The StringID
} *fmsg;    // The first string in the list

struct sstr *findstr(struct sstr *list,const char *s){
    for(;list;list=list->next)
        if(!strcmp(s,list->string)) break;

    return list;
}

struct sstr *addstr(struct sstr **list, const char *s,const char *id){
/* Add string 's' to list 'list'. If id=NULL, a new string id is created using
 * status.msgid
 */
    struct sstr *cmsg;
    char t[14]; // maxlenght = strlen("MSG_FFFFFFFF")

    if(!id){
        sprintf(t,"MSG_%04X",++status.msgid);
        id = t;
    }

    if(!(cmsg=malloc(sizeof(struct sstr)))){
        LFatal(MSG_NOM[Lang]);
        exit(20);
    }

    cmsg->next = *list;
    cmsg->string = strdup(s);
    cmsg->sid = strdup(id);

    if(!cmsg->string || !cmsg->sid){
        LFatal(MSG_NOM[Lang]);
        exit(20);
    }

    return(*list = cmsg);
}

    /*
     * Mechanism for reading strings
     */

char stl[STRLMT];   // Buffer for storing current string
char ctp;           // Current string's type
size_t sti;         // Idx in the buffer
size_t ci;          // Idx in the readed line

void debstr( UBYTE type ){  // We are starting to read a new string
    ctp=type;
    ci=status.nc;
    *stl=0;
    sti=0;
}

void addchar(const char c){
/* Add 'c' in the buffer
 */
    #ifdef DEBUGALL
        fprintf(stderr,"*D*Addchar(%x) sti=%d\n",c,sti);
    #endif

    if(sti<STRLMT-1)
        stl[sti++]=c;
    else {
        fprintf(stderr,MSG_STRLG[Lang]);
        exit(20);
    }
}

void endstr(struct sstr **list){
/* String over
 */

    if(*stl){
        struct sstr *cmsg=NULL;
        stl[sti]=0;

        if(!ash && !IsInteractive(Output())){ // print the type of the readed string
            fputc(ctp,stderr); fflush(stderr);
        }

        if(aopt) // Look if it's an already stored string
            cmsg = findstr(list,stl);

        if(!cmsg) // Add this new string
            cmsg = addstr(list, stl,NULL);

        printf("%c|%6d|%4d|%4d|%s|\"%s\"\n",
                    ctp,status.nl,ci,status.nc,cmsg->sid,stl);
        return;
    }
}

void readcd(struct sstr **list, const char *cd){
/* Read an old cd file. Doesn't look for duplicate strings...
 */
    char l[STRLMT],sid[STRLMT];
    FILE *fcd;

    if(!(fcd=fopen(aocd,"r"))){
        PrintFault(IoErr(),aocd);
        fprintf(stderr,MSG_COP[Lang],aocd);
        exit(20);
    }

    FOREVER{
        char *lmt;
        ULONG id;

        LFgets(fcd,sid,STRLMT-1);
        if(feof(fcd)) break;
        if(*sid==';') continue; // Comment

        do {
            LFgets(fcd,l,STRLMT-1);
            if(feof(fcd)){
                fprintf(stderr,MSG_BFCD[Lang]);
                exit(20);
            }
        } while(*sid==';');

        if(lmt=strchr(sid,' '))
            *lmt=0;
        else if(lmt=strchr(sid,'(' /*)*/))
            *lmt=0;

        addstr(list,l,sid); // Add this string in the database

        if(!strncmp(sid,"MSG_",4)){  // Check this msgid
            id = (ULONG)strtol(sid+4,&lmt,16);
            if(id>status.msgid) status.msgid = id;
        }
    }

    fclose(fcd);
}

__stkargs char *LFformat(const char *fmt, const char *cmd, char *premier,...){
/* From my DiceConfig 2.1 source file.
 * This function is © LFSoft 1994
 * cmd = ordered arguments.
 * eg : if cmd = "abc"
 *              -> %a became the 1st argument,
 *              -> %b the 2nd,
 *              -> %c the 3rd
 */

    char *c, *p, *cp;
    int len = strlen(fmt) + 1;
    char **arg;

    arg = (char **)&premier;

    if(!(p=fmt) || !cmd)    // Rien a formater
        return NULL;

    if(!(cp=c=malloc(len)))
        LFatal(MSG_NOM[Lang]);
    else while(*p){
        if(*p == '%'){
            unsigned short idx;
            char *x;

            *cp = 0; p++;
            if(!(x=strchr(cmd,*p))){
                fprintf(stderr,MSG_ENT[Lang],*p);
                free(c);
                return NULL;
            } else {
                idx = x-cmd;
                if(!arg[idx]){
                    fprintf(stderr,MSG_ETE[Lang],*p);
                    return NULL;
                }
                if(!(c = realloc(c, len += strlen(arg[idx]) - 2))){
                    LFatal(MSG_NOM[Lang]);
                    return NULL;
                }
                strcat(c,arg[idx]);
                cp=c; while(*cp) cp++;
                *cp = 0; p++;
            }
        } else
            *cp++ = *p++;
    }
    if(cp)
        *cp= 0;

    return c;
}

int main(int ac, char **av){
    char *var;
    int f=0;

    fmsg=NULL;

    #ifdef _DCC
        OS2_0();    // OS2.0+ is needed
    #endif

    if(var=getenv("Lang")){ // Localization
        if(!stricmp(var,"Français"))
            Lang=1;
    }

        /* Default argument */
    argr[ 0]=(long)FALSE;                           //patch
    argr[ 1]=(long)NULL;                            //Dir
    argr[ 2]=(long)NULL;                            //mc
    argr[ 3]=(long)FALSE;                           //sort
    argr[ 4]=(long)"GetCatalogString";              //fonc
    argr[ 5]=(long)NULL;                            //temp
    argr[ 6]=(long)FALSE;                           //sh
    argr[ 7]=(long)FALSE;                           //nest
    argr[ 8]=(long)NULL;                            //ps
    argr[ 9]=(long)NULL;                            //pf
    argr[10]=(long)NULL;                            //ass
    argr[11]=(long)NULL;                            //af
    argr[12]=(long)FALSE;                           //opt
    argr[13]=(long)NULL;                            //files
    argr[14]=(long)FALSE;                           //internal
    argr[15]=(long)"Lang";                          //variable
    argr[16]=(long)NULL;                            //OldCD

    atexit(fini);

    if(!(argt=ReadArgs(TEMP,argr,NULL))){
        PrintFault(IoErr(),av[0]);
        exit(20);
    }

    if(!argr[5]) {
        if(aint)
            argr[5]=(long)"%A[%V]";
        else
            argr[5]=(long)"(catalog?%F(catalog,%I,%S):%S)";
    }

#ifdef DEBUG
    fprintf(stderr,"*D* patch = %d\n",apatch);
    fprintf(stderr,"*D* dir = '%s'\n",adir?adir:"NO");
    fprintf(stderr,"*D* MC = '%s'\n",amc?amc:"NO");
    fprintf(stderr,"*D* Sort = %d\n",asort);
    fprintf(stderr,"*D* Fonct = '%s'\n",afonc);
    fprintf(stderr,"*D* Temp = '%s'\n",atemp);
    fprintf(stderr,"*D* Silent = %d\n",ash);
    fprintf(stderr,"*D* nest = %d\n",anest);
    fprintf(stderr,"*D* ps ='%s'\n",aps?aps:"NO");
    fprintf(stderr,"*D* pf ='%s'\n",apf?apf:"NO");
    fprintf(stderr,"*D* as ='%s'\n",aas?aas:"NO");
    fprintf(stderr,"*D* af ='%s'\n",aaf?aaf:"NO");
    fprintf(stderr,"*D* opt = %d\n",aopt);
    fprintf(stderr,"*D* fch = %08x\n",afch);
    fprintf(stderr,"*D* internal =%d\n",aint);
    fprintf(stderr,"*D* var = %08x\n",avar);
    fprintf(stderr,"*D* OldCD = '%s'\n",aocd?aocd:"NO");
#endif

    if(!ash) fprintf(stderr," LFLocalize V0.5ß © LFSoft 1994-96\n");

    if(apatch){ // Patch mode
        FILE *pf,*sf,*df,*cdf;
        // patchfile, src, dst, cd file
        char l[STRLMT*2];
        ULONG el;       // line of msg
        USHORT sc,ec;   // First and last colone for msg
        struct sstr *cmsg;
        BOOL firststr;

        DMSG("*D* Patch mode\n");

        sf=NULL;

        if(!afch){  // No patch file ?
            LFatal(MSG_PFS[Lang]);
            exit(20);
        }
        if(!(pf=fopen(afch[0],"r"))){
            LFatal(MSG_COSF[Lang]);
            exit(20);
        }

        if(amc){
            if(!(cdf=fopen(amc,"w"))){
                LFatal(MSG_COCF[Lang]);
                exit(20);
            }

            /* NOTE: If no merge Catalog, the database must be freed and
                this file readed between all source file */

            if(aocd) // Read an old CD file
                readcd(&fmsg,aocd);
            firststr = !aocd;

        } else {
            fputs(MSG_MCN[Lang],stderr);
            exit(20);
        }

        if(aint){
            fputs(MSG_HCDI[Lang],cdf);
            fprintf(cdf,"size_t %s;\n\n",avar);
        } else
            fputs(MSG_HCDL[Lang],cdf);

        while(!feof(pf)){
            LFgets(pf,l,511);   // Read a line in patch file
            if(feof(pf)) break;

            if(!strnicmp(l,"#C",2)) // A comment
                continue;
            else if(!strnicmp(l,"#F",2)){ // New source file
                if(sf){ // But it's not the first
                    char c;
                    while((c=fgetc(sf))!=EOF) // Copy until end of file
                        fputc(c,df);
                    fclose(df);
                    fclose(sf); sf=NULL;
                }

                strcpy(l,l+2);
                if(!ash){
                    putchar('\n');
                    fprintf(stderr,MSG_PROC[Lang],l);
                }
                if(!(sf=fopen(l,"r"))){
                    fprintf(stderr,MSG_COP[Lang],l);
                    exit(20);
                }

                if(adir){   // Compute the new destination filename
                    char tmp[512], *dfch;
                    strcpy(tmp,l);
                    dfch = FilePart(tmp);
                    strcpy(l,adir);
                    if(!AddPart(l,dfch,512)){
                        fprintf(stderr,MSG_FNTL[Lang]);
                        exit(20);
                    }
                } else
                    strcat(l,"l");

                if(!(df=fopen(l,"w"))){
                    fprintf(stderr,MSG_COP[Lang],l);
                    exit(20);
                }
                status.nc=0; status.nl=1;
            } else if(!strncmp(l,"L|",2)){ // A localized string
                char *x=l+2;
                char *y,*z;
                char c;

                el=strtol(x,&x,0);
                if(*x!='|'){
                    LFatal(MSG_CPF[Lang]);
                    exit(20);
                }
                sc=strtol(++x,&x,0);
                if(*x!='|'){
                    LFatal(MSG_CPF[Lang]);
                    exit(20);
                }
                ec=strtol(++x,&x,0);
                if(*x!='|'){
                    LFatal(MSG_CPF[Lang]);
                    exit(20);
                }
                x++;
                if(y=strchr(x,'|')){
                    *y=0;
                    y+=2;
                    z=y+strlen(y)-1;
                    if(*z=='"') *z=0;
                } else {
                    LFatal(MSG_CPF[Lang]);
                    exit(20);
                }

                for(cmsg = fmsg; cmsg; cmsg=cmsg->next) // Already created in CD file ?
                    if(!strcmp(cmsg->sid,x)) break;

                if(!cmsg){  // No: we must create it
                    if(!ash){
                        putchar('L');fflush(stdout);
                    }
                    if(aint)
                        fprintf(cdf,"const UBYTE *%s[]={\"%s\"};\n",x,y);
                    else {
/* Even if catcomp and locale.library can handle id starting from 0, it's safety
 * to use 1 as first id as some others tools like CatEdit discard string 0.
 */
                        fprintf(cdf,
                            firststr? "%s (1//)\n%s\n;\n"
                                    : "%s (//)\n%s\n;\n"
                            ,x,y);
                    }
                    firststr = FALSE;

                    addstr(&fmsg, "",x); // Add this new StringID in data base
                } else
                    if(!ash){   // Already localized
                        putchar('l');fflush(stdout);
                    }

                if(status.nl>el){ // Sanity check
                    fprintf(stderr," Corrupted patch file el=%d < cl=%d\n",el,status.nl);
                    exit(20);
                }
                while(status.nl<el) switch(c=fgetc(sf)){ // Goto the next line to patch
                    case EOF:
                        LFatal(MSG_UEOF[Lang]);
                        exit(20);
                    case EOL:
                        status.nl++;status.nc=0;
                    default :
                        fputc(c,df);
                }

                if(status.nc>sc){ // Sanity check
                    fprintf(stderr,"Corrupted patch file el=%d < cl=%d\n",el,status.nl);
                    exit(20);
                }
                while(++status.nc<sc) switch(c=fgetc(sf)){
                    case EOF:
                        LFatal(MSG_UEOF[Lang]);
                        exit(20);
                    case EOL:
                        LFatal(MSG_UEOL[Lang]);
                        exit(20);
                    default :
                        fputc(c,df);
                }

                if(fgetc(sf)!='"'){
                    LFatal(MSG_EXPC[Lang]);
                    exit(20);
                }

                if(!(z=malloc(strlen(x)+5))){
                    LFatal(MSG_NOM[Lang]);
                    exit(20);
                } else {
                    if(aint){ // Internal methode
                        char *r;
                        if(r=LFformat(atemp,"AV",x,avar)){
                            fputs(r,df);
                            free(r);
                        } else
                            exit(20);
                    } else { // Use catalogs
                        char *s;

                        strcpy(z,x);
                        strcat(z,"_STR");
                        if(s=malloc(strlen(y)+5)){
                            char *r;
                            *s='"'; s[1]=0;
                            strcat(s,y);strcat(s,"\"");
                            if(r=LFformat(atemp,"FISD",afonc,x,z,s)){
                                fputs(r,df);
                                free(r);
                            } else
                                exit(20);
                            free(s);
                        } else {
                            LFatal(MSG_NOM[Lang]);
                            exit(20);
                        }
                    }
                    free(z);
                }

                while(++status.nc<ec) switch(c=fgetc(sf)){ // Skip the string
                    case EOF:
                        LFatal(MSG_UEOF[Lang]);
                        exit(20);
                    case EOL:
                        LFatal(MSG_UEOL[Lang]);
                        exit(20);
                }
                if(fgetc(sf)!='"'){
                    LFatal(MSG_EXPC[Lang]);
                    exit(20);
                }
            }
        }

        if(!ash) putchar('\n');

        if(sf){
            char c;
            while((c=fgetc(sf))!=EOF)
                fputc(c,df);
            fclose(df);
            fclose(sf); sf=NULL;
        }
    } else {    // Parsing mode
        DMSG("*D* Parsing mode\n");
        puts(MSG_HSF[Lang]);

        if(aocd) // Read an old CD file
            readcd(&fmsg,aocd);

        if(afch) while(afch[f]){ // Read all source files
            FILE *fp;
            char c;

            if(!*afch[f])
                break;

            #ifndef DEBUG
            if(!ash)
            #endif
                fprintf(stderr,MSG_REDS[Lang],afch[f]);

            if(!(fp=fopen(afch[f],"r"))){
                PrintFault(IoErr(),afch[f]);
                fprintf(stderr,MSG_COP[Lang],afch[f]);
                exit(20);
            }

            printf("#F%s\n",afch[f]);
            status.nl = 1; status.nc=0;
            status.com = status.bloc = 0;status.fonc=0;status.maf=0;
            status.lcom = 0; status.slt = 0; status.ignore = 0;
            status.isdefine = 0; status.instr = 0; status.mlstre = 0;

            while((c=fgetc(fp))!=EOF){
                status.nc++;

                if(status.instr) switch(c){ // in a string
                case EOL:
                    fprintf(stderr,MSG_EUSTR[Lang],afch[f],status.nl);
                    exit(20);
                case '\\':
                    if(status.ignore){
                        status.ignore = 0;
                        addchar('\\');
                        break;
                    } else {
                        status.ignore = 1;
                        addchar('\\');
                        break;
                    }
                case '"':
                    if(status.ignore){
                        status.ignore = 0;
                        addchar('"');
                        break;
                    } else {
                        status.instr = 0; status.mlstre = 1;
                        endstr(&fmsg);
                        break;
                    }
                default:
                    status.ignore = 0;
                    addchar(c);
                } else if(status.lcom){ // Are we in a C++ comment ?
                    if(c == EOL){
                        status.lcom = 0;
                        status.nl++;status.nc=0;
                    }
                } else if(status.com){ // Are we in a comment ?
                    if(c == EOL){
                        status.nl++; status.nc=0; status.star = 0;
                    } else if(c=='*'){
                        if(status.slt){ // nesting ?
                            status.slt = 0;
                            if(!anest){ // nested comment not allowed
                                fprintf(stderr,MSG_ENC[Lang],afch[f],status.nl);
                            } else
                                status.com++;
                            status.star = 0;
                        } else
                            status.star = 1;
                    } else if(c=='/'){
                        if(status.star){ // closing
                            status.star = 0;
                            status.com--;
                        } else
                            status.slt = 1;
                    } else {
                        status.star = 0; status.slt = 0;
                    }
                } else if(status.maf){ // a new fonction ?
                    switch(c){
                    case '/':
                        if(status.slt){ // C++ comment ?
                            status.slt = 0; status.lcom = 1;
                        } else
                            status.slt = 1;
                        break;
                    case '*':
                        if(status.slt){ // Opening a comment ?
                            status.com++; status.slt =0;
                        } else { // * or */ mean error
                            status.maf = 0;
                            status.star = 1;
                        }
                        break;
                    case EOL:
                        status.nl++; status.nc=0;
                        break;
                    case '\\':
                        status.ignore = 1;
                        break;
                    case ' ':
                    case '\t':
                        break;
                    case '{': /*}*/
                        status.fonc = 1; status.bloc++;
                        break;
                    default:
                        status.maf = 0;
                        goto autre;
                    }
                    continue;
                } else {    // In a line ...
                    if(status.mlstre){ // a multi-line string ?
                        switch(c){
                        case '/':
                            if(status.slt){ // C++ comment ?
                                status.slt = 0; status.lcom = 1;
                            } else
                                status.slt = 1;
                            break;
                        case '*':
                            if(status.slt){ // Opening a comment ?
                                status.com++; status.slt =0;
                            } else { // * or */ mean error
                                status.mlstre = 0;
                                status.star = 1;
                            }
                            break;
                        case EOL:
                            status.nl++; status.nc=0;
                            break;
                        case '\\':
                            status.ignore = 1;
                            break;
                        case ' ':
                        case '\t':
                            break;
                        case '"':
                            if(status.fonc)
                                debstr('M');
                            else
                                debstr('E');
                            status.instr = 1;
                            break;
                        default:
                            status.mlstre = 0;
                            goto autre;
                        }
                        continue;
                    }

                    if(status.ignore){
                        if(c==EOL){
                            status.nl++;status.nc=0;
                        }
                        status.ignore = 0;
                        continue;
                    }

                autre:
                    switch(c){
                    case '/':
                        if(status.slt){ // C++ comment ?
                            status.slt = 0; status.lcom = 1;
                        } else if(status.star) {
                            fprintf(stderr,MSG_UMC[Lang],afch[f],status.nl);
                            exit(20);
                        } else
                            status.slt = 1;
                        status.star =0;
                        break;
                    case '*':
                        if(status.slt){ // Opening a comment ?
                            status.com++;
                        } else
                            status.star = 1;
                        status.slt =0;
                        break;
                    case EOL:
                        status.nl++;status.nc=0;status.star=0;status.slt=0;
                        break;
                    case '\\':
                    case '\'':
                        status.ignore = 1;
                        break;
                    case '"':
                        if(status.fonc)
                            debstr('L');
                        else
                            debstr('E');
                        status.instr = 1;status.star=0;status.slt=0;
                        break;
                    case /*(*/ ')':
                        if(!status.bloc)
                            status.maf=1;
                        status.star=0;status.slt=0;
                        break;
                    case '{':
                        status.bloc++;status.star=0;status.slt=0;
                        break;
                    case '}':
                        if(!status.bloc){
                            fprintf(stderr,MSG_UMB[Lang],afch[f],status.nl);
                            exit(20);
                        } else
                            if(!--status.bloc)
                                status.fonc=0;
                        status.star=0;status.slt=0;
                        break;
                    default:
                        status.star=0;status.slt=0;
                    }
                }
            }
            fclose(fp);

            if(!ash){
                fputc('\n',stderr);
                if(status.bloc)
                    fprintf(stderr,MSG_PB[Lang],status.bloc,(status.bloc>1) ? 's':'');
                if(status.com)
                    fprintf(stderr,MSG_PC[Lang],status.com,(status.com>1) ? 's':'');
                if(status.instr)
                    fprintf(stderr,MSG_UTS[Lang]);
            }

            f++;
        }

#ifdef DEBUG
        {
            struct sstr *cmsg;
            for(cmsg=fmsg;cmsg;cmsg=cmsg->next)
                printf("id:'%s' s:'%s'\n",cmsg->sid,cmsg->string);

            printf("\nnew msgid:%04x\n",status.msgid);
        }
#endif

    }

    exit(0);
}
