;
; ** $VER: tagitem.h 40.1 (19.7.93)
; ** Includes Release 40.15
; **
; ** Extended specification mechanism
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga Inc.
; ** All Rights Reserved
;

; ***************************************************************************


;  Tags are a general mechanism of extensible data arrays for parameter
;  * specification and property inquiry. In practice, tags are used in arrays,
;  * or chain of arrays.
;  *
;

Structure TagItem
    ti_Tag.l ;  identifies the type of data
    ti_Data.l ;  type-specific data
EndStructure

;  constants for Tag.ti_Tag, control tag values
#TAG_DONE   = (0)   ;  terminates array of TagItems. ti_Data unused
#TAG_END    = (0)   ;  synonym for TAG_DONE
#TAG_IGNORE = (1)   ;  ignore this item, not end of array
#TAG_MORE   = (2)   ;  ti_Data is pointer to another array of TagItems
;       * note that this tag terminates the current array
;
#TAG_SKIP   = (3)   ;  skip this and the next ti_Data items

;  differentiates user tags from control tags
#TAG_USER   = ((1 << 31))

;  If the TAG_USER bit is set in a tag number, it tells utility.library that
;  * the tag is not a control tag (like TAG_DONE, TAG_IGNORE, TAG_MORE) and is
;  * instead an application tag. "USER" means a client of utility.library in
;  * general, including system code like Intuition or ASL, it has nothing to do
;  * with user code.
;


; ***************************************************************************


;  Tag filter logic specifiers for use with FilterTagItems()
#TAGFILTER_AND = 0  ;  exclude everything but filter hits
#TAGFILTER_NOT = 1  ;  exclude only filter hits


; ***************************************************************************


;  Mapping types for use with MapTags()
#MAP_REMOVE_NOT_FOUND = 0 ;  remove tags that aren't in mapList
#MAP_KEEP_NOT_FOUND   = 1 ;  keep tags that aren't in mapList


; ***************************************************************************


