/* -- ----------------------------------------------------- -- *
 * -- Name........: absy.e                                  -- *
 * -- Description.: Simple description of our grammar.      -- *
 * -- Author......: Daniel Kasmeroglu                       -- *
 * -- E-Mail......: raptor@cs.tu-berlin.de                  -- *
 * --               daniel.kasmeroglu@daimlerchrysler.com   -- *
 * -- Date........: 05-Mar-00                               -- *
 * -- Version.....: 0.1                                     -- *
 * -- ----------------------------------------------------- -- */

/* -- ----------------------------------------------------- -- *
 * --                          Options                      -- *
 * -- ----------------------------------------------------- -- */

OPT MODULE
OPT EXPORT


/* -- ----------------------------------------------------- -- *
 * --                          Modules                      -- *
 * -- ----------------------------------------------------- -- */

MODULE  'exec/nodes'    ,
	'exec/lists'


/* -- ----------------------------------------------------- -- *
 * --                         Constants                     -- *
 * -- ----------------------------------------------------- -- */

ENUM    VARIANT_INCLUDEFILE = 1 ,
	VARIANT_STRUCT          ,
	VARIANT_POINTING        ,
	VARIANT_TYPE            ,
	VARIANT_ARGUMENT        ,
	VARIANT_ARGS            ,
	VARIANT_FUNCTION        ,
	VARIANT_EXPRESSION      ,
	VARIANT_CONSTANT        ,
	VARIANT_INCFILE         ,
	VARIANT_CONDITIONAL     ,
	VARIANT_IDELIST         ,
	VARIANT_COMPONENT       ,
	VARIANT_COMPS           ,
	VARIANT_STRUCT          ,
	VARIANT_VARIABLE        ,
	VARIANT_IDEARRAYED      ,
	VARIANT_COMPRIGHT       ,
	VARIANT_CAST            ,
	VARIANT_FAULTY

ENUM    TYP_STRUCT = 100    ,
	TYP_DEFINED

ENUM    EXTYP_ID = 200      ,
	EXTYP_SIGNED        ,
	EXTYP_STRING        ,
	EXTYP_HEXVALUE      ,
	EXTYP_DECVALUE      ,
	EXTYP_NEGOTIATE     ,
	EXTYP_SHIFTLEFT     ,
	EXTYP_SHIFTRIGHT    ,
	EXTYP_PLUS          ,
	EXTYP_MINUS         ,
	EXTYP_BITAND        ,
	EXTYP_BITOR         ,
	EXTYP_MUL           ,
	EXTYP_DIV


/* -- ----------------------------------------------------- -- *
 * --                        Structures                     -- *
 * -- ----------------------------------------------------- -- */

-> Basic structure of each component. [ ABSY = Abstract Syntax ]
-> Note that not all components are used at the end since
-> a lot of them are only existing for easier work.

->> STRUCTURE absy
OBJECT absy OF mln
  variant : INT
ENDOBJECT
-><


->> VARIANT includefile     : absy
OBJECT includefile OF absy
  entries : mlh
ENDOBJECT
-><

->> VARIANT pointing        : absy
OBJECT pointing OF absy
  number : INT
ENDOBJECT
-><

->> VARIANT type            : absy
OBJECT type OF absy
  specification : INT
  name          : PTR TO CHAR
ENDOBJECT
-><

->> VARIANT argument        : absy
OBJECT argument OF absy
  type     : PTR TO type
  pointing : PTR TO pointing
  name     : PTR TO CHAR
ENDOBJECT
-><

->> VARIANT args            : absy
OBJECT args OF absy
  arguments : mlh
ENDOBJECT
-><

->> VARIANT function        : absy
OBJECT function OF absy
  type     : PTR TO type
  pointing : PTR TO pointing
  name     : PTR TO CHAR
  args     : PTR TO args
ENDOBJECT
-><

->> VARIANT expression      : absy
OBJECT expression OF absy
  extyp : INT
  value : LONG
  id    : PTR TO CHAR
  left  : PTR TO expression
  right : PTR TO expression
  cast  : PTR TO cast
ENDOBJECT
-><

->> VARIANT constant        : absy
OBJECT constant OF absy
  id    : PTR TO CHAR
  expr  : PTR TO expression
ENDOBJECT
-><

->> VARIANT incfile         : absy
OBJECT incfile OF absy
  current : INT
  path    : PTR TO CHAR
ENDOBJECT
-><

->> VARIANT conditional     : absy
OBJECT conditional OF absy
  test    : PTR TO CHAR
  neg     : INT
  include : PTR TO includefile
ENDOBJECT
-><

->> VARIANT idelist         : absy
OBJECT idelist OF absy
  comprights : mlh
ENDOBJECT
-><

->> VARIANT component       : absy
OBJECT component OF absy
  type      : PTR TO type
  idelist   : PTR TO idelist
ENDOBJECT
-><

->> VARIANT comps           : absy
OBJECT comps OF absy
  components : mlh
ENDOBJECT
-><

->> VARIANT struct          : absy
OBJECT struct OF absy
  name       : PTR TO CHAR
  components : PTR TO comps
ENDOBJECT
-><

->> VARIANT variable        : absy
OBJECT variable OF absy
  type     : PTR TO type
  idelist  : PTR TO idelist
ENDOBJECT
-><

->> VARIANT idearrayed      : absy
OBJECT idearrayed OF absy
  identifier : PTR TO CHAR
  times      : INT
ENDOBJECT
-><

->> VARIANT compright       : absy
OBJECT compright OF absy
  pointing   : PTR TO pointing
  idearrayed : PTR TO idearrayed
ENDOBJECT
-><

->> VARIANT cast            : absy
OBJECT cast OF absy
  name     : PTR TO CHAR
  isstruct : INT
  pointing : PTR TO pointing
ENDOBJECT
-><

