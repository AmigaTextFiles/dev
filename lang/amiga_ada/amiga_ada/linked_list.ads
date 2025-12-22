generic 

   type ITEM is private;
   with procedure Copy( Left : in Item; Right : in out Item );
   with procedure Free( Left : in out Item );
   with function Is_Equal ( Left, Right : in Item ) return Boolean;

package LINKED_LIST is

   type LIST is private;

   NULL_LIST: constant LIST;
-- constructors

   procedure COPY (FROM_THE_LIST: in     LIST;
                   TO_THE_LIST  : in out LIST);

   procedure CLEAR (THE_LIST    : in out LIST);

   procedure CONSTRUCT_Head (THE_ITEM: in     ITEM;
                        AND_THE_LIST: in out LIST);

   procedure CONSTRUCT_Tail (THE_ITEM: in     ITEM;
                        AND_THE_LIST: in out LIST);

   procedure SET_HEAD (OF_THE_LIST: in out LIST;
                       TO_THE_ITEM: in     ITEM);

   procedure SWAP_TAIL (OF_THE_LIST: in out LIST;
                        AND_THE_LIST: in out LIST); 
-- selectors

   function IS_EQUAL (LEFT: in LIST;
                       RIGHT: in LIST) return BOOLEAN;

   function LENGTH_OF (THE_LIST: in LIST) return NATURAL;

   function IS_NULL (THE_LIST: in LIST) return BOOLEAN;

   function HEAD_OF (THE_LIST: in LIST) return ITEM;

   function NTH_Member( THE_LIST : in LIST; NTH : POSITIVE ) return ITEM;

   function TAIL_OF (THE_LIST: in LIST) return LIST;

   procedure Free( The_List : in out List );

-- exceptions

   OVERFLOW     : exception;

   LIST_IS_NULL : exception;


private

   type NODE;

   type LIST is access NODE;

   NULL_LIST : constant LIST:= null;

end LINKED_LIST;

