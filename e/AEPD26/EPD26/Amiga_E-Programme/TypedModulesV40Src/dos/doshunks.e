P=$8000009B,
      WA_HELPGROUPWINDOW=$8000009C,
      HC_GADGETHELP=1

OBJECT remember
  nextremember:PTR TO remember
  remembersize:LONG
  memory:PTR TO CHAR
ENDOBJECT     /* SIZEOF=12 */

OBJECT colorspec
  colorindex:INT
  red:INT  -> This is unsigned
  green:INT  -> This is unsigned
  blue:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=8 */

OBJECT easystruct
  structsize:LONG
  flags:LONG
  title:PTR TO CHAR
  textformat:PTR TO CHAR
  gadgetformat:PTR TO CHAR
ENDOBJECT     /* SIZEOF=20 */

#define MENUNUM(n) (n AND $1F)
#define ITEMNUM(n) (Shr(n,5) AND $3F)
#define SUBNUM(n) (Shr(n,11) AND $1F)

#define SHIFTMENU(n) (n AND $1F)
#define SHIFTITEM(n) (Shl(n AND $3F,5))
#define SHIFTSUB(n) (Shl(n AND $1F,11))

#define FULLMENUNUM(menu,item,sub) (SHIFTSUB(sub) OR SHIFTITEM(item) OR SHIFTMENU(menu))

#define SRBNUM(n) (8-Shr(n,4))
#define SWBNUM(n) (8-(n AND $F))
#define SSBNUM(n) (1+Shr(n,4))
#define SPARNUM(n) (Shr(n,4))
#define SHAKNUM(n) (n AND $F)

CONST NOMENU=31,
      NOITEM=$3F,
      NOSUB=31,
      MENUNULL=$FFFF,
      CHECKWIDTH=19,
      COMMWIDTH=27,
      LOWCHECKWIDTH=13,
      LOWCOMMWIDTH=16,
      ALERT_TYPE=$80000000,
      RECOVE