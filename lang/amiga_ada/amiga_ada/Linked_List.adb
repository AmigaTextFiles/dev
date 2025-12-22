with TEXT_IO; use TEXT_IO;
with Unchecked_Deallocation;

package body LINKED_LIST is

   type NODE is
      record
         THE_ITEM: ITEM;
         NEXT    : LIST;
      end record;


-- constructors

   procedure COPY (FROM_THE_LIST: in LIST;
                   TO_THE_LIST  : in out LIST) is

      FROM_INDEX: LIST:= FROM_THE_LIST;
      TO_INDEX  : LIST;

   begin

      if FROM_THE_LIST = null then
         TO_THE_LIST:= null;
      else
         TO_THE_LIST:= new NODE'(THE_ITEM => FROM_INDEX.THE_ITEM,
                                 NEXT     => null);
         TO_INDEX:= TO_THE_LIST;
         FROM_INDEX:= FROM_INDEX.NEXT;
         while FROM_INDEX /= null loop
            TO_INDEX.NEXT:= new NODE'(THE_ITEM => FROM_INDEX.THE_ITEM,
                                      NEXT     => null);
            TO_INDEX:= TO_INDEX.NEXT;
            FROM_INDEX:= FROM_INDEX.NEXT;
         end loop;
      end if;
   
   exception
      when STORAGE_ERROR => raise OVERFLOW;

end COPY;

   procedure CLEAR (THE_LIST: in out LIST) is

   begin

      THE_LIST:= null;

   end CLEAR;

   procedure CONSTRUCT_Head (THE_ITEM: in    ITEM;
                        AND_THE_LIST: in out LIST) is

   begin

      AND_THE_LIST:= new NODE'(THE_ITEM => THE_ITEM,
                               NEXT     => AND_THE_LIST);

   exception
      when STORAGE_ERROR => raise OVERFLOW;

   end CONSTRUCT_Head;

   procedure CONSTRUCT_Tail (THE_ITEM: in    ITEM;
                        AND_THE_LIST: in out LIST) is

     INDEX: LIST:= AND_THE_LIST;

   begin

      if INDEX = NULL_LIST then
         And_The_List := new NODE'(THE_ITEM => THE_ITEM,
                                  NEXT     => NULL_LIST );
         return;
      end if;

      while INDEX.NEXT /= null loop
         INDEX:= INDEX.NEXT;
      end loop;

      INDEX.NEXT := new NODE'(THE_ITEM => THE_ITEM,
                               NEXT     => NULL_LIST );

   exception
      when STORAGE_ERROR => raise OVERFLOW;

   end CONSTRUCT_Tail;

   procedure SET_HEAD (OF_THE_LIST: in out LIST;
                       TO_THE_ITEM: in     ITEM) is

   begin

      Free(Of_The_List.The_Item);
      Copy(To_THE_ITEM,OF_THE_LIST.THE_ITEM);

   exception
      when CONSTRAINT_ERROR => raise LIST_IS_NULL;

   end SET_HEAD;

   procedure SWAP_TAIL (OF_THE_LIST: in out LIST;
                        AND_THE_LIST: in out LIST) is

      TEMPORARY_NODE: LIST;

   begin

      TEMPORARY_NODE:= OF_THE_LIST.NEXT;
      OF_THE_LIST.NEXT:= AND_THE_LIST;
      AND_THE_LIST:= TEMPORARY_NODE;

   exception
      when CONSTRAINT_ERROR => raise LIST_IS_NULL;

   end SWAP_TAIL;

-- selectors

   function IS_EQUAL (LEFT: in LIST;
                      RIGHT: in LIST) return BOOLEAN is

      LEFT_INDEX: LIST:= LEFT;
      RIGHT_INDEX: LIST:= RIGHT;

   begin

      while LEFT_INDEX /= null loop
         if NOT Is_Equal(LEFT_INDEX.THE_ITEM,RIGHT_INDEX.THE_ITEM) then
            return FALSE;
         end if;
         LEFT_INDEX:= LEFT_INDEX.NEXT;
         RIGHT_INDEX:= RIGHT_INDEX.NEXT;
      end loop;
      return (RIGHT_INDEX = null);

   exception
      when CONSTRAINT_ERROR => return FALSE;

   end IS_EQUAL;

   function LENGTH_OF (THE_LIST: in LIST) return NATURAL is

      COUNT: NATURAL:= 0;
      INDEX: LIST:= THE_LIST;

   begin

      while INDEX /= null loop
         COUNT:= COUNT + 1;
         INDEX:= INDEX.NEXT;
      end loop;
      return COUNT;

   end LENGTH_OF;

   function IS_NULL (THE_LIST: in LIST) return BOOLEAN is

   begin

      return (THE_LIST = null);

   end IS_NULL;

   function HEAD_OF (THE_LIST: in LIST) return ITEM is

   begin

      return THE_LIST.THE_ITEM;

   exception
      when CONSTRAINT_ERROR => raise LIST_IS_NULL;

   end HEAD_OF;

   function NTH_MEMBER (THE_LIST: in LIST; NTH : POSITIVE) return ITEM is

      COUNT: NATURAL:= 1;
      INDEX: LIST:= THE_LIST;

   begin

      if INDEX = NULL_LIST then
         raise LIST_IS_NULL;
      end if;

      while COUNT /= NTH loop
         COUNT:= COUNT + 1;
         INDEX:= INDEX.NEXT;
         if INDEX = NULL_LIST then
            raise Constraint_Error;
         end if;
      end loop;
      return INDEX.THE_ITEM;

   end NTH_MEMBER;

   function TAIL_OF (THE_LIST: in LIST) return LIST is

   begin

      if The_List = Null_List then
         raise List_Is_Null;
      end if;

      return THE_LIST.NEXT;

   end TAIL_OF;

procedure Free( The_List : in out List ) is

   procedure Deallocate_Node is new Unchecked_Deallocation(Node,List);

   begin
   if The_List /= Null_List then
      Free(The_List.The_Item);
      Free(The_List.Next);
      Deallocate_Node(The_List);
      The_List := Null_List;
   end if;
end Free;
end LINKED_LIST;
