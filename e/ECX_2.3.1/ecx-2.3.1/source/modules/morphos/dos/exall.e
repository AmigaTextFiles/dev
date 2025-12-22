                                                                 OPT MODULE
OPT EXPORT

MODULE 'utility/hooks'

CONST ED_NAME=1,
      ED_TYPE=2,
      ED_SIZE=3,
      ED_PROTECTION=4,
      ED_DATE=5,
      ED_COMMENT=6,
      ED_OWNER=7

      /* 64bit DOS extensions - V51 */
 /* The ExAllData ed_Size64 field is filled. For files larger than 2^31-1
 * bytes, ed_Size is 0.
 */
CONST ED_SIZE64 = 8

OBJECT exalldata
  next:PTR TO exalldata
  name:PTR TO CHAR
  type:LONG
  size:LONG
  prot:LONG
  days:LONG
  mins:LONG
  ticks:LONG
  comment:PTR TO CHAR
  owneruid:WORD
  ownergid:WORD
  /* 64bit DOS extensions - V51 */
  /* Filled for ED_SIZE64 */
  size64:WIDE
ENDOBJECT     /* SIZEOF=48 */

OBJECT exallcontrol
  entries:LONG
  lastkey:LONG
  matchstring:PTR TO CHAR
  matchfunc:PTR TO hook
ENDOBJECT     /* SIZEOF=16 */

