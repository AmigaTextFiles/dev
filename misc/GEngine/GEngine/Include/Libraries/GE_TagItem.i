{ GE_TagItem.i }

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


{FUNCTION CloneTagItems(tagList : Address) : Address;
    External;

FUNCTION AllocateTagItems(num : Integer) : Address;
    External;

PROCEDURE FreeTagItems(TagList : Address);
    External;}

{--GE_NextTagItem--}

Function GE_NextTagItem(VAR Item:TagItemPtr):TagItemPtr;
External;
{Function GE_NextTagItem(VAR Item:TagItemPtr):TagItemPtr;

Var
 ret : TagItemPtr;

Begin
 ret:= Nil;
 if (Item<>Nil) then begin
  ret:= Item;
  Case ret^.ti_tag of
	TAG_DONE : ret:= Nil;
	TAG_SKIP : begin
         inc(Item,ret^.ti_Data);
         ret:=Item;
      end;
	TAG_MORE : begin
         Item:= Address(ret^.ti_Data);
         ret:= Item;
      end;
  end;
  Item:= Address(Integer(Item)+SizeOF(TagItem));
 end;
 GE_NextTagItem:= ret;
end;}

{PROCEDURE FilterTagChanges(changelist, oldvalues : Address; apply : Integer);
    External;

FUNCTION FilterTagItems(taglist, tagArray : Address; logic : Integer) : Integer;
    External;}

FUNCTION GE_FindTagItem(TagVal : Tag; TagList : Address) : TagItemPtr;

Var
 Bend: Boolean;
 TList,TT: TagItemPtr;

Begin
 Bend:= false;
 TList:= TagList;
 Repeat
  TT:= GE_NextTagItem(TList);
  if (TT<>Nil)and(TT^.ti_Tag=TagVal) then
   Bend:= true;
 until (TT=Nil) or Bend;
 GE_FindTagItem:= TT;
end;

{--GE_GetTagData--}

Function GE_GetTagData(tagval,default:Integer; TagList:TagItemPtr):Integer;
External;
{Function GE_GetTagData(tagval,default:Integer; TagList:TagItemPtr):Integer;

Var
 TTag,TTemp: TagItemPtr;
 Ret : Integer;
 fin : Boolean;

Begin
 Ret:= default; fin:= false;
 TTag:= TagList;
 TTemp:= TTag;
 TTag := GE_NextTagItem(TTemp);
 While (TTag<>Nil) and not fin do begin
  if TTag^.ti_tag = tagval then begin
   Ret:= TTag^.ti_data;
   fin:= true;
  end else
   TTag:= GE_NextTagItem(TTemp);
 end;}
 {new!-
 While (TTag^.ti_Tag<>TAG_DONE) and not fin do begin
  if TTag^.ti_Tag = tagval then begin
    ret:= TTag^.ti_Data;
    fin:=True;
  end;
  inc(TTag);
 end;
 -}
{ GE_GetTagData:= Ret;
end;}

{PROCEDURE MapTags(TagList : Address; maplist : TagItemPtr; IncludeMiss : Integer);
    External;}

FUNCTION GE_PackBoolTags(InitialFlags : Integer; TagList, boolmap : Address) : Integer;

Var
 TTag,BTag,TList,BList: TagItemPtr;
 BB: Integer;

Begin
 BB:= InitialFlags;
 TList:= TagList;
 TTag:= GE_NextTagItem(TList);
 While TTag<>Nil do begin
  BTag:= GE_FindTagItem(TTag^.ti_Tag,boolmap);
  if BTag<>Nil then
   if TTag^.ti_Data<>0 then
     BB:= BB or BTag^.ti_Data
   else
     BB:= BB and not BTag^.ti_Data;
  TTag:= GE_NextTagItem(TList);
 end;
 GE_PackBoolTags:= BB;
end;

{PROCEDURE RefreshTagItemClones(cloneTagItems, OriginalTagItems : Address);
    External;}

{--GE_TagInArray--}

Function GE_TagInArray(TagValue:Tag; TagArray:Address):Boolean;

Var
 TT: ^Array [0..0] of TagItem;
 i : Integer;
 ret,bol: Boolean;

Begin
 ret:= false; bol:= false;
 TT:= TagArray;
 if TT<>Nil then begin
  i:= 0;
  While (TT^[i].ti_Tag<>TAG_DONE) and not bol do begin
   if TT^[i].ti_Tag = TagValue then begin
    bol:= true;
    ret:= true;
   end;
   inc(i);
  end;
 end;
 GE_TagInArray:= ret;
end;
