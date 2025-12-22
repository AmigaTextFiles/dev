{ TagItem.i }

{$I   "Include:Exec/Types.i"}

{ ======================================================================= }
{ ==== TagItem ========================================================== }
{ ======================================================================= }
{ This data type may propagate through the system for more general use.
 * In the meantime, it is used as a general mechanism of extensible data
 * arrays for parameter specification and property inquiry (coming soon
 * to a display controller near you).
 *
 * In practice, an array (or chain of arrays) of TagItems is used.
 }
Type
    Tag = Integer;
    TagPtr = ^Tag;

    TagItem = Record
     ti_Tag  : Tag;
     ti_Data : Integer;
    END;
    TagItemPtr = ^TagItem;


{ ---- system tag values ----------------------------- }
CONST
 TAG_DONE          = 0; { terminates array of TagItems. ti_Data unused }
 TAG_END           = TAG_DONE;
 TAG_IGNORE        = 1; { ignore this item, not END of array           }
 TAG_MORE          = 2; { ti_Data is pointer to another array of TagItems
                         * note that this tag terminates the current array
                         }
 TAG_SKIP          = 3; { skip this AND the next ti_Data items         }

{ differentiates user tags from control tags }
 TAG_USER          = $80000000;    { differentiates user tags from system tags}

{* If the TAG_USER bit is set in a tag number, it tells utility.library that
 * the tag is not a control tag (like TAG_DONE, TAG_IGNORE, TAG_MORE) and is
 * instead an application tag. "USER" means a client of utility.library in
 * general, including system code like Intuition or ASL, it has nothing to do
 * with user code.
 *}


{ Tag filter logic specifiers for use with FilterTagItems() }
 TAGFILTER_AND     = 0;       { exclude everything but filter hits   }
 TAGFILTER_NOT     = 1;       { exclude only filter hits             }

{ Mapping types for use with MapTags() }
 MAP_REMOVE_NOT_FOUND = 0;  { remove tags that aren't in mapList }
 MAP_KEEP_NOT_FOUND   = 1;  { keep tags that aren't in mapList   }


FUNCTION CloneTagItems(tagList : Address) : Address;
    External;

FUNCTION AllocateTagItems(num : Integer) : Address;
    External;

PROCEDURE FreeTagItems(TagList : Address);
    External;

FUNCTION NextTagItem(Item : Address) : tagItemPtr;
    External;

PROCEDURE FilterTagChanges(changelist, oldvalues : Address; apply : Integer);
    External;

FUNCTION FilterTagItems(taglist, tagArray : Address; logic : Integer) : Integer;
    External;

FUNCTION FindTagItem(TagVal : Tag; TagList : Address) : TagItemPtr;
    External;

FUNCTION GetTagData(tagval : Tag; default : Integer; TagList : Address) : Integer;
    External;

PROCEDURE MapTags(TagList : Address; maplist : TagItemPtr; IncludeMiss : Integer);
    External;

FUNCTION PackBoolTags(InitialFlags : Integer; TagList, boolmap : Address) : Integer;
    External;

PROCEDURE RefreshTagItemClones(cloneTagItems, OriginalTagItems : Address);
    External;

FUNCTION TagInArray(t : Tag; TagArray : Address) : Boolean;
    External;




