/*
 * Q.G - include file for Quest globals.
 */

type
    Id_t = ulong;		 /* used for all identifiers */

Id_t
    ID_NULL = 0;		 /* no such whatever found, etc. */

/*
 * screen routines.
 */

type

    /* type for two-character map area displays: */

    C2 = [2]char;

extern
    scInit()void,
    scTerm()void,
    scObjFree(*byte objList)void,
    scPut(char ch)void,
    scPrompt(*char prompt)void,
    scRead(*char buffer)void,
    scNewMap(proc(long l, c)C2 scenery; *byte oldObj)*byte,
    scWindow(long line, column)void,
    scNew(Id_t id; long line, column; C2 chars)void,
    scAt(long line, column)C2,
    scMove(Id_t id; long line, column)void,
    scDelete(Id_t id)void,
    scNumber(Id_t id; *char name; ushort line, column, len; *long ptr)void,
    scString(Id_t id; *char name; ushort line, column, len; **char ptr)void,
    scMult(Id_t id; *char name; ushort line, column, lines;
	   proc(bool first)*char gen)void,
    scUpdate(Id_t id)void,
    scRemove(Id_t id)void;

/*
 * parser routines.
 */

type
    PSForm_t = enum {f_reqId, f_reqType, f_optId, f_optType, f_multiple};

Id_t
    PS_NONE = ID_NULL,
    PS_ERROR = 0xffffffff;

extern
    psInit(bool prefixEnabled)void,
    psTerm()void,
    psWord(Id_t id; *char txt; Id_t typ)void,
    psDel(Id_t id)void,
    psgBegin(Id_t id)void,
    psgWord(PSForm_t form; Id_t data)void,
    psgEnd()void,
    psgDel(Id_t id)void,
    psFind(*char txt)Id_t,
    psGet(Id_t id)*char,
    psType(Id_t id)Id_t,
    psParse(*char sentence)Id_t,
    pspBad()*char,
    pspWord(uint pos)Id_t,
    pspPref()Id_t;

/*
 * list handling routines.
 */

type
    List_t = struct {
	*List_t il_next;
	Id_t il_this;
    };

extern
    lInit()void,
    lFree(*List_t il)void,
    lTerm()void,
    getId()Id_t,
    lAdd(**List_t pil; Id_t n)void,
    lAppend(**List_t pil; Id_t n)void,
    lDelete(**List_t pil; Id_t n)void,
    lGet(*List_t il; ulong n)Id_t,
    lIn(*List_t il; Id_t n)bool,
    putProp(Id_t id, prop)void,
    getProp(Id_t id, prop)bool,
    delProp(Id_t id, prop)void,
    putAttr(Id_t id, attr, val)void,
    getAttr(Id_t id, attr)Id_t,
    delAttr(Id_t id, attr)void;
