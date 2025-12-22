(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Utility.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Utility;

(* !!! ATTENTION !!!
 * Before you use any routine of this library, you'll have to check
 * Utility.base # NIL.
 *)

IMPORT e * := Exec,
       SYSTEM;

CONST
  utilityName * = "utility.library";

(*****************************************************************************)
TYPE
  ClockDataPtr * = UNTRACED POINTER TO ClockData;
  HookPtr * = UNTRACED POINTER TO Hook;

  ClockData * = STRUCT
    sec  * : INTEGER;
    min  * : INTEGER;
    hour * : INTEGER;
    mday * : INTEGER;
    month* : INTEGER;
    year * : INTEGER;
    wday * : INTEGER;
  END;


(* Useful definition for casting function pointers:
 * hook.h_entry    = (ASMHOOKFUNC)AsmFunction
 * hook.h_SubEntry = (HOOKFUNC)AFunction
 *)
  HookFunc * = PROCEDURE(hook: HookPtr; object: e.APTR; message: e.APTR): e.APTR;
  AsmHookFunc * = PROCEDURE(hook{8}: HookPtr;
                            object{10}: e.APTR;
                            message{9}: e.APTR): e.APTR; (* assembler entry point *)


(* new standard hook structure *)
  Hook * = STRUCT (minNode * : e.MinNode)
    entry    *: AsmHookFunc;  (* assembler entry point *)
    subEntry *: HookFunc;     (* often HLL entry point *)
    data     *: e.APTR;       (* owner specific        *)
  END;

(* ---- Default Hook-Dispatcher ---- *)
PROCEDURE HookEntry*(hook{8}: HookPtr;               (* $SaveRegs+ $StackChk- *)
                     object{10}: e.APTR;
                     message{9}: e.APTR): e.APTR;
(*
 * Calls haook.subEntry. The contents of A5 have to be stored in hook.data,
 * else A5 would not be set correctly.
 *)

BEGIN
  SYSTEM.SETREG(13,hook.data);
  RETURN hook.subEntry(hook,object,message);
END HookEntry;


PROCEDURE InitHook* (hook{8}: HookPtr; entry{9}: HookFunc);
BEGIN
  hook.entry := HookEntry;     (* $NilChk- -- one check is enough *)
  hook.subEntry := entry;
  hook.data := SYSTEM.REG(13); (* $NilChk= *)
END InitHook;

(*
 * Hook calling conventions:
 *
 * The function pointed to by Hook.h_Entry is called with the following
 * parameters:
 *
 *    A0 - pointer to hook data structure itself
 *    A1 - pointer to parameter structure ("message")
 *    A2 - Hook specific address data ("object")
 *
 * Control will be passed to the routine h_Entry.  For many
 * High-Level Languages (HLL), this will be an assembly language
 * stub which pushes registers on the stack, does other setup,
 * and then calls the function at h_SubEntry.
 *
 * The standard C receiving code is:
 *
 *    HookFunc(struct Hook *hook, APTR object, APTR message)
 *
 * Note that register natural order differs from this convention for C
 * parameter order, which is A0,A2,A1.
 *
 * The assembly language stub for "vanilla" C parameter conventions
 * could be:
 *
 * _hookEntry:
 *    move.l  a1,-(sp)                ; push message packet pointer
 *    move.l  a2,-(sp)                ; push object pointer
 *    move.l  a0,-(sp)                ; push hook pointer
 *    move.l  h_SubEntry(a0),a0       ; fetch C entry point ...
 *    jsr     (a0)                    ; ... and call it
 *    lea     12(sp),sp               ; fix stack
 *    rts
 *
 * With this function as your interface stub, you can write a Hook setup
 * function as:
 *
 * InitHook(struct Hook *hook, ULONG ( *c_function)(), APTR userdata)
 * {
 * ULONG ( *hookEntry)();
 *
 *     hook->h_Entry  = hookEntry;
 *     hook->h_SubEntry = c_function;
 *     hook->h_Data   = userdata;
 * }
 *
 * With a compiler capable of registerized parameters, such as SAS C, you
 * can put the C function in the h_Entry field directly. For example, for
 * SAS C:
 *
 *   ULONG __saveds __asm HookFunc(register __a0 struct Hook *hook,
 *                               register __a2 APTR         object,
 *                               register __a1 APTR         message);
 *
 *)

(* ======================================================================= *)
(* ==== TagItem ========================================================== *)
(* ======================================================================= *)
(* Tags are a general mechanism of extensible data arrays for parameter
 * specification and property inquiry. In practice, tags are used in arrays,
 * or chain of arrays.
 *
 *)

TYPE
  Tag   * = e.APTR;
  TagID * = LONGINT;

  TagItem * = STRUCT
    tag  * : TagID; (* identifies the type of data *)
    data * : Tag;   (* type-specific data          *)
  END;

  TagItemPtr * = UNTRACED POINTER TO TagItem;
  TagListPtr * = UNTRACED POINTER TO ARRAY MAX(INTEGER) OF TagItem;

(* Types for 'ARRAY OF TagItem'-Parameters: *)

  Tags1  * = ARRAY  1 OF TagItem;
  Tags2  * = ARRAY  2 OF TagItem;
  Tags3  * = ARRAY  3 OF TagItem;
  Tags4  * = ARRAY  4 OF TagItem;
  Tags5  * = ARRAY  5 OF TagItem;
  Tags6  * = ARRAY  6 OF TagItem;
  Tags7  * = ARRAY  7 OF TagItem;
  Tags8  * = ARRAY  8 OF TagItem;
  Tags9  * = ARRAY  9 OF TagItem;
  Tags10 * = ARRAY 10 OF TagItem;
  Tags11 * = ARRAY 11 OF TagItem;
  Tags12 * = ARRAY 12 OF TagItem;
  Tags13 * = ARRAY 13 OF TagItem;
  Tags14 * = ARRAY 14 OF TagItem;
  Tags15 * = ARRAY 15 OF TagItem;
  Tags16 * = ARRAY 16 OF TagItem;
  Tags17 * = ARRAY 17 OF TagItem;
  Tags18 * = ARRAY 18 OF TagItem;
  Tags19 * = ARRAY 19 OF TagItem;
  Tags20 * = ARRAY 20 OF TagItem;
  Tags21 * = ARRAY 21 OF TagItem;
  Tags22 * = ARRAY 22 OF TagItem;
  Tags23 * = ARRAY 23 OF TagItem;
  Tags24 * = ARRAY 24 OF TagItem;
  Tags25 * = ARRAY 25 OF TagItem;
  Tags26 * = ARRAY 26 OF TagItem;
  Tags27 * = ARRAY 27 OF TagItem;
  Tags28 * = ARRAY 28 OF TagItem;
  Tags29 * = ARRAY 29 OF TagItem;

CONST
(*****************************************************************************)

(* constants for Tag.ti_Tag, control tag values *)
  done   * = 0;    (* terminates array of TagItems. ti_Data unused *)
  end    * = done; (* synonym for TAG_DONE                         *)
  ignore * = 1;    (* ignore this item, not end of array           *)
  more   * = 2;    (* ti_Data is pointer to another array of TagItems
                    * note that this tag terminates the current array
                    *)
  skip   * = 3;    (* skip this and the next TagItem.data items    *)

(* differentiates user tags from system tags*)
  user   * = 80000000H;

(* If the TAG_USER bit is set in a tag number, it tells utility.library that
 * the tag is not a control tag (like TAG_DONE, TAG_IGNORE, TAG_MORE) and is
 * instead an application tag. "USER" means a client of utility.library in
 * general, including system code like Intuition or ASL, it has nothing to do
 * with user code.
 *)

(*****************************************************************************)

(* Tag filter logic specifiers for use with FilterTagItems() *)
  filterAnd * = 0;     (* exclude everything but filter hits   *)
  filterNot * = 1;     (* exclude only filter hits             *)

(*****************************************************************************)

(* Mapping types for use with MapTags() *)
  removeNotFound * = 0;        (* remove tags that aren't in mapList *)
  keepNotFound   * = 1;        (* keep tags that aren't in mapList   *)

TYPE
(*****************************************************************************)

(* The named object structure
 *)
  NamedObjectPtr * = UNTRACED POINTER TO NamedObject;
  NamedObject * = STRUCT
    object * : e.APTR;     (* Your pointer, for whatever you want *)
  END;

(* Tags for AllocNamedObject() *)
CONST
  nameSpace  * =   4000;    (* tag to define namespace      *)
  userSpace  * =   4001;    (* tag to define userspace      *)
  priority   * =   4002;    (* tag to define priority       *)
  flags      * =   4003;    (* tag to define flags          *)

(* Flags for tag ANO_FLAGS *)
  noDups    * =   0;       (* Default allow duplicates *)
  case      * =   1;       (* Default to caseless... *)

(*****************************************************************************)


(* PackTable definition:
 *
 * The PackTable is a simple array of LONGWORDS that are evaluated by
 * PackStructureTags() and UnpackStructureTags().
 *
 * The table contains compressed information such as the tag offset from
 * the base tag. The tag offset has a limited range so the base tag is
 * defined in the first longword.
 *
 * After the first longword, the fields look as follows:
 *
 *      +--------- 1 = signed, 0 = unsigned (for bits, 1=inverted boolean)
 *      |
 *      |  +------ 00 = Pack/Unpack, 10 = Pack, 01 = Unpack, 11 = special
 *      | / \
 *      | | |  +-- 00 = Byte, 01 = Word, 10 = Long, 11 = Bit
 *      | | | / \
 *      | | | | | /----- For bit operations: 1 = TAG_EXISTS is TRUE
 *      | | | | | |
 *      | | | | | | /-------------------- Tag offset from base tag value
 *      | | | | | | |                 \
 *      m n n o o p q q q q q q q q q q r r r s s s s s s s s s s s s s
 *                                      \   | |               |
 *      Bit offset (for bit operations) ----/ |               |
 *                                            \                       |
 *      Offset into data structure -----------------------------------/
 *
 * A -1 longword signifies that the next longword will be a new base tag
 *
 * A 0 longword signifies that it is the end of the pack table.
 *
 * What this implies is that there are only 13-bits of address offset
 * and 10 bits for tag offsets from the base tag.  For most uses this
 * should be enough, but when this is not, either multiple pack tables
 * or a pack table with extra base tags would be able to do the trick.
 * The goal here was to make the tables small and yet flexible enough to
 * handle most cases.
 *)

  signed * = 31;
  unpack * = 30;    (* Note that these are active low... *)
  pack   * = 29;    (* Note that these are active low... *)
  exists * = 26;    (* Tag exists bit true flag hack...  *)

(*****************************************************************************)


  ctrlPackUnpack * = 000000000H;
  ctrlPackOnly   * = 040000000H;
  ctrlUnpackOnly * = 020000000H;

  ctrlByte       * = 080000000H;
  ctrlWord       * = 088000000H;
  ctrlLong       * = 090000000H;

  ctrlUByte      * = 000000000H;
  ctrlUWord      * = 008000000H;
  ctrlULong      * = 010000000H;

  ctrlBit        * = 018000000H;
  ctrlFlipBit    * = 098000000H;

(*****************************************************************************)

TYPE
  UtilityBasePtr * = UNTRACED POINTER TO UtilityBase;
  UtilityBase * = STRUCT (libNode * : e.Library)
    language   * : SHORTINT;
    reserved   * : SHORTINT;
  END;

(******************************************************************************)

(*
 * Sorry, but since Oberon has no precompiler (this is good) and thuth
 * no macros like in 'C', you this PACK macros can not be translated to
 * Oberon :-(. If you got an idea, how to solve this problen (e.g. you
 * have written a pre-compiler ;-) please contact me:
 * e-mail: interfaces@oberon.nbg.sub.org
 * THANKS!
 *)

(* Macros used by the next batch of macros below. Normally, you don't use
 * this batch directly. Then again, some folks are wierd
 *)
(*
#define PK_BITNUM1(flg) ((flg) == 0x01 ? 0 : (flg) == 0x02 ? 1 : (flg) == 0x04 ? 2 : (flg) == 0x08 ? 3 : (flg) == 0x10 ? 4 : (flg) == 0x20 ? 5 : (flg) == 0x40 ? 6 : 7)
#define PK_BITNUM2(flg) ((flg < 0x100 ? PK_BITNUM1(flg) : 8+PK_BITNUM1(flg >> 8)))
#define PK_BITNUM(flg) ((flg < 0x10000 ? PK_BITNUM2(flg) : 16+PK_BITNUM2(flg >> 16)))
#define PK_WORDOFFSET(flg) ((flg) < 0x100 ? 1 : 0)
#define PK_LONGOFFSET(flg) ((flg) < 0x100  ? 3 : (flg) < 0x10000 ? 2 : (flg) < 0x1000000 ? 1 : 0)
#define PK_CALCOFFSET(type,field) ((ULONG)(&((struct type * )0)->field))
*)

(*****************************************************************************)


(* Some handy dandy macros to easily create pack tables
 *
 * Use PACK_STARTTABLE() at the start of a pack table. You pass it the
 * base tag value that will be handled in the following chunk of the pack
 * table.
 *
 * PACK_ENDTABLE() is used to mark the end of a pack table.
 *
 * PACK_NEWOFFSET() lets you change the base tag value used for subsequent
 * entries in the table
 *
 * PACK_ENTRY() lets you define an entry in the pack table. You pass it the
 * base tag value, the tag of interest, the type of the structure to use,
 * the field name in the structure to affect and control bits (combinations of
 * the various PKCTRL_XXX bits)
 *
 * PACK_BYTEBIT() lets you define a bit-control entry in the pack table. You
 * pass it the same data as PACK_ENTRY, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is byte
 * sized.
 *
 * PACK_WORDBIT() lets you define a bit-control entry in the pack table. You
 * pass it the same data as PACK_ENTRY, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is word
 * sized.
 *
 * PACK_LONGBIT() lets you define a bit-control entry in the pack table. You
 * pass it the same data as PACK_ENTRY, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is longword
 * sized.
 *
 * EXAMPLE:
 *
 *    ULONG packTable[] =
 *    {
 *         PACK_STARTTABLE(GA_Dummy),
 *         PACK_ENTRY(GA_Dummy,GA_Left,Gadget,LeftEdge,PKCTRL_WORD|PKCTRL_PACKUNPACK),
 *         PACK_ENTRY(GA_Dummy,GA_Top,Gadget,TopEdge,PKCTRL_WORD|PKCTRL_PACKUNPACK),
 *         PACK_ENTRY(GA_Dummy,GA_Width,Gadget,Width,PKCTRL_UWORD|PKCTRL_PACKUNPACK),
 *         PACK_ENTRY(GA_Dummy,GA_Height,Gadget,Height,PKCTRL_UWORD|PKCTRL_PACKUNPACK),
 *         PACK_WORDBIT(GA_Dummy,GA_RelVerify,Gadget,Activation,PKCTRL_BIT|PKCTRL_PACKUNPACK,GACT_RELVERIFY)
 *         PACK_ENDTABLE
 *    };
 *)
(*
#define PACK_STARTTABLE(tagbase)                           (tagbase)
#define PACK_NEWOFFSET(tagbase)                            (-1L),(tagbase)
#define PACK_ENDTABLE                                      0
#define PACK_ENTRY(tagbase,tag,type,field,control)         (control | ((tag-tagbase) << 16L) | PK_CALCOFFSET(type,field))
#define PACK_BYTEBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16L) | PK_CALCOFFSET(type,field) | (PK_BITNUM(flags) << 13L))
#define PACK_WORDBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16L) | (PK_CALCOFFSET(type,field)+PK_WORDOFFSET(flags)) | ((PK_BITNUM(flags)&7) << 13L))
#define PACK_LONGBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16L) | (PK_CALCOFFSET(type,field)+PK_LONGOFFSET(flags)) | ((PK_BITNUM(flags)&7) << 13L))
 *)

(*****************************************************************************)

VAR
  base * : UtilityBasePtr;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)


(*--- functions in V36 or higher (Release 2.0) ---*)

(* Tag item functions *)

PROCEDURE FindTagItemA    *{base,- 30}(tagVar{0}      : TagID;
                                       tagList{8}     : ARRAY OF TagItem): TagItemPtr;
PROCEDURE FindTagItem     *{base,- 30}(tagVar{0}      : TagID;
                                       tags{8}        : TagListPtr): TagItemPtr;
PROCEDURE GetTagDataPA    *{base,- 36}(tagVal{0}      : TagID;
                                       defaultValue{1}: e.APTR;
                                       tagList{8}     : ARRAY OF TagItem): e.APTR;
PROCEDURE GetTagDataA     *{base,- 36}(tagVal{0}      : TagID;
                                       defaultValue{1}: LONGINT;
                                       tagList{8}     : ARRAY OF TagItem): LONGINT;
PROCEDURE GetTagDataP     *{base,- 36}(tagVal{0}      : TagID;
                                       defaultValue{1}: e.APTR;
                                       tags{8}        : TagListPtr): e.APTR;
PROCEDURE GetTagData      *{base,- 36}(tagVal{0}      : TagID;
                                       defaultValue{1}: LONGINT;
                                       tags{8}        : TagListPtr): LONGINT;
PROCEDURE PackBoolTagsA   *{base,- 42}(initialFlags{0}: LONGSET;
                                       tagList{8}     : ARRAY OF TagItem;
                                       boolMap{9}     : ARRAY OF TagItem): LONGSET;
PROCEDURE PackBoolTags    *{base,- 42}(initialFlags{0}: LONGSET;
                                       taga{8}        : TagListPtr;
                                       boolMap{9}     : ARRAY OF TagItem): LONGSET;
PROCEDURE NextTagItem     *{base,- 48}(VAR tagListPtr{8}: TagItemPtr): TagItemPtr;
PROCEDURE FilterTagChanges*{base,- 54}(changeList{8}  : ARRAY OF TagItem;
                                       originalList{9}: ARRAY OF TagItem;
                                       apply{0}       : BOOLEAN);
PROCEDURE MapTags         *{base,- 60}(tagList{8}     : ARRAY OF TagItem;
                                       mapList{9}     : ARRAY OF TagItem;
                                       mapType{0}     : LONGINT);
PROCEDURE AllocateTagItems*{base,- 66}(numTags{0}     : LONGINT): TagListPtr;
PROCEDURE CloneTagItemsA  *{base,- 72}(tagList{8}     : ARRAY OF TagItem): TagListPtr;
PROCEDURE CloneTagItems   *{base,- 72}(taga{8}        : TagListPtr): TagListPtr;
PROCEDURE FreeTagItems    *{base,- 78}(tagList{8}     : TagListPtr);
PROCEDURE RefreshTagItemClones*{base,- 84}(clone{8}   : ARRAY OF TagItem;
                                       original{9}    : ARRAY OF TagItem);
PROCEDURE TagInArray      *{base,- 90}(tagValue{0}    : TagID;
                                       tagArray{8}    : ARRAY OF TagID): BOOLEAN;
PROCEDURE FilterTagItems  *{base,- 96}(tagList{8}     : ARRAY OF TagItem;
                                       filterArray{9} : ARRAY OF TagID;
                                       logic{0}       : LONGINT): LONGINT;

(* HOOK FUNCTIONS *)

PROCEDURE CallHookPkt     *{base,-102}(hook{8}        : HookPtr;
                                       object{10}     : e.ADDRESS;
                                       paramPacket{9} : e.ADDRESS): LONGINT;

(* DATE FUNCTIONS *)

PROCEDURE Amiga2Date      *{base,-120}(seconds{0}     : LONGINT;
                                       VAR date{8}    : ClockData);
PROCEDURE Date2Amiga      *{base,-126}(VAR date{8}    : ClockData): LONGINT;
PROCEDURE CheckDate       *{base,-132}(VAR date{8}    : ClockData): LONGINT;

(* 32 bit integer muliply functions *)

PROCEDURE SMult32         *{base,-138}(factor1{0},  factor2{1} : LONGINT): LONGINT;
PROCEDURE UMult32         *{base,-144}(factor1{0},  factor2{1} : LONGINT): LONGINT;

(* 32 bit integer division funtions. The quotient and the remainder are *)
(* returned respectively in d0 and d1 *)

PROCEDURE SDivMod32       *{base,-150}(dividend{0}, divisor{1} : LONGINT): LONGINT;
PROCEDURE UDivMod32       *{base,-156}(dividend{0}, divisor{1} : LONGINT): LONGINT;

(*--- functions in V37 or higher (Release 2.04) ---*)

(* International string routines *)

PROCEDURE Stricmp         *{base,-162}(string1{8}: ARRAY OF CHAR;
                                       string2{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE Strnicmp        *{base,-168}(string1{8}: ARRAY OF CHAR;
                                       string2{9}: ARRAY OF CHAR;
                                       length{0}: LONGINT): LONGINT;
PROCEDURE ToUpper         *{base,-174}(character{0}: CHAR): CHAR;
PROCEDURE ToLower         *{base,-180}(character{0}: CHAR): CHAR;

(*--- functions in V39 or higher (Release 3) ---*)

(* More tag Item functions *)

PROCEDURE ApplyTagChangesA*{base,-0BAH}(list{8}          : ARRAY OF TagItem;
                                        changeList{9}    : ARRAY OF TagItem);
PROCEDURE ApplyTagChanges *{base,-0BAH}(list{8}          : ARRAY OF TagItem;
                                        changeList{9}    : TagListPtr);

(* 64 bit integer muliply functions. The results are 64 bit quantities *)
(* returned in D0 and D1 *)

PROCEDURE SMult64         *{base,-0C6H}(arg1{0}: LONGINT; arg2{1}: LONGINT): LONGINT;
PROCEDURE UMult64         *{base,-0CCH}(arg1{0}: LONGINT; arg2{1}: LONGINT): LONGINT;

(* Structure to Tag and Tag to Structure support routines *)

PROCEDURE PackStructureTagsA  *{base,-0D2H}(pack{8}      : e.APTR;
                                            packTable{9} : ARRAY OF LONGINT;
                                            tagList{10}  : ARRAY OF TagItem): LONGINT;
PROCEDURE PackStructureTags   *{base,-0D2H}(pack{8}      : e.APTR;
                                            packTable{9} : ARRAY OF LONGINT;
                                            tagList{10}  : TagListPtr): LONGINT;
PROCEDURE UnpackStructureTagsA*{base,-0D8H}(pack{8}      : Tag;
                                            packTable{9} : ARRAY OF LONGINT;
                                            tagList{10}  : ARRAY OF TagItem): LONGINT;
PROCEDURE UnpackStructureTags *{base,-0D8H}(pack{8}      : e.APTR;
                                            packTable{9} : ARRAY OF LONGINT;
                                            tagList{10}  : TagListPtr): LONGINT;

(* New, object-oriented NameSpaces *)

PROCEDURE AddNamedObject  *{base,-0DEH}(nameSpace{8}   : NamedObjectPtr;
                                        object{9}      : NamedObjectPtr): BOOLEAN;
PROCEDURE AllocNamedObjectA *{base,-0E4H}(name{8}      : ARRAY OF CHAR;
                                          tagList{9}   : ARRAY OF TagItem): NamedObjectPtr;
PROCEDURE AllocNamedObject  *{base,-0E4H}(name{8}      : ARRAY OF CHAR;
                                          tag1{9}..    : Tag): NamedObjectPtr;
PROCEDURE AttemptRemNamedObject*{base,-0EAH}( object{8}: NamedObjectPtr): BOOLEAN;
PROCEDURE FindNamedObject  *{base,-0F0H}(nameSpace{8}  : NamedObjectPtr;
                                         name{9}       : ARRAY OF CHAR;
                                         lastObject{10}: NamedObjectPtr): NamedObjectPtr;
PROCEDURE FreeNamedObject *{base,-0F6H}(object{8}      : NamedObjectPtr);
PROCEDURE NamedObjectName *{base,-0FCH}(object{8}      : NamedObjectPtr): e.LSTRPTR;
PROCEDURE ReleaseNamedObject*{base,-102H}(object{8}    : NamedObjectPtr);
PROCEDURE RemNamedObject  *{base,-108H}(object{8}      : NamedObjectPtr;
                                        message{9}     : e.MessagePtr);

(* Unique ID generator *)

PROCEDURE GetUniqueID     *{base,-10EH}(): LONGINT;


(*---- usefull procedures ---- *)

PROCEDURE IgnoreIfNIL * (tagVal{0}: TagID; data{1}: Tag): TagID;
BEGIN
  IF data # NIL THEN RETURN tagVal ELSE RETURN ignore END;
END IgnoreIfNIL;

PROCEDURE Bool2Long * (b{0}: BOOLEAN): e.LONGBOOL;
BEGIN
  IF b THEN RETURN e.LTRUE ELSE RETURN e.LFALSE; END;
END Bool2Long;

PROCEDURE Long2Bool * (value{0}: LONGINT): BOOLEAN;
BEGIN
  RETURN value # e.LFALSE;
END Long2Bool;

BEGIN
  base :=  e.OpenLibrary(utilityName,37);
CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END Utility.

