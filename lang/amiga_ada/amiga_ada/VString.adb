with Unchecked_Deallocation;

package body VString is

   procedure Deallocate_Substring is new Unchecked_Deallocation(Substring,String_Ptr);

   function Allocate_VString( str : in Substring ) return String is

   return_str : String;

   begin
      return_str.The_Length := str'Length;
      return_str.The_Items := new Substring'(str);

      return return_str;
   end Allocate_VString;

   procedure COPY (FROM_THE_STRING: in     STRING;
                   TO_THE_STRING:   in out STRING) is

   temp_string_ptr : String_Ptr := To_The_String.The_Items;

   begin

   To_The_String.The_Length := From_The_String.The_Length;
   To_The_String.The_Items := new Substring(1..From_The_String.The_Length);
   To_The_String.The_Items.all(1..From_The_String.The_Length) := From_The_String.The_Items.all;

--   if temp_string_ptr /= Null_String then
--      Deallocate_Substring( temp_string_ptr );
--   end if;

   end Copy;
--   begin
--
--      if FROM_THE_STRING.THE_LENGTH > TO_THE_STRING.THE_SIZE then
--         raise OVERFLOW;
--      else
--         TO_THE_STRING.THE_ITEMS(1..FROM_THE_STRING.THE_LENGTH):=
--            FROM_THE_STRING.THE_ITEMS(1..FROM_THE_STRING.THE_LENGTH);
--         TO_THE_STRING.THE_LENGTH:= FROM_THE_STRING.THE_LENGTH;
--      end if;
--
--   end COPY;

   procedure COPY (FROM_THE_SUBSTRING: in     SUBSTRING;
                   TO_THE_STRING:      in out STRING) is

   temp_string_ptr : String_Ptr := To_The_String.The_Items;

   begin

   To_The_String.The_Length := From_The_Substring'Length;
   To_The_String.The_Items := new Substring(1..From_The_Substring'Length);
   To_The_String.The_Items.all(1..From_The_Substring'Length) := From_The_Substring;

--   if temp_string_ptr /= Null_String then
--      Deallocate_Substring( temp_string_ptr );
--   end if;

   end Copy;
--   begin
--
--      if FROM_THE_SUBSTRING'LENGTH > TO_THE_STRING.THE_SIZE then
--         raise OVERFLOW;
--      else
--         TO_THE_STRING.THE_ITEMS(1..FROM_THE_SUBSTRING'LENGTH):=
--            FROM_THE_SUBSTRING;
--         TO_THE_STRING.THE_LENGTH:= FROM_THE_SUBSTRING'LENGTH;
--      end if;
--
--   end COPY;

   procedure CLEAR (THE_STRING: in out STRING) is

   begin

      THE_STRING.THE_LENGTH:= 0;

   end CLEAR;

   procedure PREPEND (THE_STRING:    in     STRING;
                      TO_THE_STRING: in out STRING) is

      NEW_LENGTH: NATURAL:= TO_THE_STRING.THE_LENGTH + THE_STRING.THE_LENGTH;

   begin

      if NEW_LENGTH > TO_THE_STRING.The_Items'Last then
         raise OVERFLOW;
      else
         TO_THE_STRING.THE_ITEMS((THE_STRING.THE_LENGTH +1)..NEW_LENGTH):=
            TO_THE_STRING.THE_ITEMS(1..TO_THE_STRING.THE_LENGTH);
         TO_THE_STRING.THE_ITEMS(1..THE_STRING.THE_LENGTH):=
            THE_STRING.THE_ITEMS(1..THE_STRING.THE_LENGTH);
         TO_THE_STRING.THE_LENGTH:= NEW_LENGTH;
      end if;

   end PREPEND;

   procedure PREPEND (THE_SUBSTRING: in SUBSTRING;
                      TO_THE_STRING: in out STRING) is

      NEW_LENGTH: NATURAL:= TO_THE_STRING.THE_LENGTH + THE_SUBSTRING'LENGTH;

   begin

      if NEW_LENGTH > TO_THE_STRING.The_Items'Last then
         raise OVERFLOW;
      else
         TO_THE_STRING.THE_ITEMS((THE_SUBSTRING'LENGTH + 1)..NEW_LENGTH):=
            TO_THE_STRING.THE_ITEMS(1..TO_THE_STRING.THE_LENGTH);
         TO_THE_STRING.THE_ITEMS(1..THE_SUBSTRING'LENGTH):= THE_SUBSTRING;
         TO_THE_STRING.THE_LENGTH:= NEW_LENGTH;
      end if;

   end PREPEND;

   procedure APPEND (THE_STRING:   in     STRING;
                     TO_THE_STRING:in out STRING) is

      NEW_LENGTH: NATURAL:= TO_THE_STRING.THE_LENGTH + THE_STRING.THE_LENGTH;

   begin

      if NEW_LENGTH > TO_THE_STRING.The_Items'Last then
         raise OVERFLOW;
      else
         TO_THE_STRING.THE_ITEMS((TO_THE_STRING.THE_LENGTH + 1)..NEW_LENGTH):=
            THE_STRING.THE_ITEMS(1..THE_STRING.THE_LENGTH);
         TO_THE_STRING.THE_LENGTH:= NEW_LENGTH;
      end if;

   end APPEND;

   procedure APPEND (THE_SUBSTRING: in     SUBSTRING;
                     TO_THE_STRING: in out STRING) is

      NEW_LENGTH: NATURAL:= TO_THE_STRING.THE_LENGTH + THE_SUBSTRING'LENGTH;

   begin

      if NEW_LENGTH > TO_THE_STRING.The_Items'Last then
         raise OVERFLOW;
      else
         TO_THE_STRING.THE_ITEMS((TO_THE_STRING.THE_LENGTH + 1)..NEW_LENGTH):=
            THE_SUBSTRING;
         TO_THE_STRING.THE_LENGTH:= NEW_LENGTH;
      end if;

   end APPEND;

   procedure INSERT (THE_STRING:   in     STRING;
                     IN_THE_STRING:in out STRING;
                     AT_THE_POSITION: in  POSITIVE) is

      NEW_LENGTH: NATURAL:= IN_THE_STRING.THE_LENGTH + THE_STRING.THE_LENGTH;
      END_POSITION: NATURAL:= AT_THE_POSITION + THE_STRING.THE_LENGTH;

   begin

      if AT_THE_POSITION > IN_THE_STRING.THE_LENGTH then
         raise POSITION_ERROR;
      elsif NEW_LENGTH > IN_THE_STRING.The_Items'Last then
         raise OVERFLOW;
      else
         IN_THE_STRING.THE_ITEMS(END_POSITION..NEW_LENGTH):=
            IN_THE_STRING.THE_ITEMS(AT_THE_POSITION..IN_THE_STRING.THE_LENGTH);
         IN_THE_STRING.THE_ITEMS(AT_THE_POSITION..(END_POSITION -1)):=
            THE_STRING.THE_ITEMS(1..THE_STRING.THE_LENGTH);
         IN_THE_STRING.THE_LENGTH:= NEW_LENGTH;
      end if;

   end INSERT;

   procedure INSERT (THE_SUBSTRING: in     SUBSTRING;
                     IN_THE_STRING: in out STRING;
                     AT_THE_POSITION: in    POSITIVE) is

      NEW_LENGTH: NATURAL:= IN_THE_STRING.THE_LENGTH + THE_SUBSTRING'LENGTH;
      END_POSITION: NATURAL:= AT_THE_POSITION + THE_SUBSTRING'LENGTH;

   begin

      if AT_THE_POSITION > IN_THE_STRING.THE_LENGTH then
         raise POSITION_ERROR;
      elsif NEW_LENGTH > IN_THE_STRING.The_Items'Last then
         raise OVERFLOW;
      else
         IN_THE_STRING.THE_ITEMS(END_POSITION..NEW_LENGTH):=
            IN_THE_STRING.THE_ITEMS(AT_THE_POSITION..IN_THE_STRING.THE_LENGTH);
         IN_THE_STRING.THE_ITEMS(AT_THE_POSITION..(END_POSITION - 1)):=
            THE_SUBSTRING;
         IN_THE_STRING.THE_LENGTH:= NEW_LENGTH;
      end if;

   end INSERT;

   procedure DELETE (IN_THE_STRING: in out STRING;
                     FROM_THE_POSITION: in     POSITIVE;
                     TO_THE_POSITION:   in     POSITIVE) is

      NEW_LENGTH: NATURAL;

   begin

      if (FROM_THE_POSITION > IN_THE_STRING.THE_LENGTH) or else
         (TO_THE_POSITION > IN_THE_STRING.THE_LENGTH) or else
         (FROM_THE_POSITION > TO_THE_POSITION) then
         raise POSITION_ERROR;
      else
         NEW_LENGTH:= IN_THE_STRING.THE_LENGTH - (TO_THE_POSITION -
                         FROM_THE_POSITION + 1);
         IN_THE_STRING.THE_ITEMS(FROM_THE_POSITION..NEW_LENGTH):=
            IN_THE_STRING.THE_ITEMS((TO_THE_POSITION + 1)..IN_THE_STRING.THE_LENGTH);
         IN_THE_STRING.THE_LENGTH:= NEW_LENGTH;
       end if;

   end DELETE;

   procedure REPLACE (IN_THE_STRING:  in out STRING;
                      AT_THE_POSITION:in     POSITIVE;
                      WITH_THE_STRING:in     STRING) is

      END_POSITION: NATURAL:= AT_THE_POSITION + WITH_THE_STRING.THE_LENGTH -1;

   begin

      if (AT_THE_POSITION > IN_THE_STRING.THE_LENGTH) or else
         (END_POSITION > IN_THE_STRING.THE_LENGTH) then
         raise POSITION_ERROR;
      else
         IN_THE_STRING.THE_ITEMS(AT_THE_POSITION..END_POSITION):=
            WITH_THE_STRING.THE_ITEMS(1..WITH_THE_STRING.THE_LENGTH);
      end if;

   end REPLACE;

   procedure REPLACE (IN_THE_STRING:      in out STRING;
                      AT_THE_POSITION:    in     POSITIVE;
                      WITH_THE_SUBSTRING: in    SUBSTRING) is

      END_POSITION: NATURAL:= AT_THE_POSITION + WITH_THE_SUBSTRING'LENGTH - 1;

   begin

      if (AT_THE_POSITION > IN_THE_STRING.THE_LENGTH) or else
         (END_POSITION > IN_THE_STRING.THE_LENGTH) then
         raise POSITION_ERROR;
      else
         IN_THE_STRING.THE_ITEMS(AT_THE_POSITION..END_POSITION):=
            WITH_THE_SUBSTRING;
      end if;

   end REPLACE;

   procedure SET_ITEM (IN_THE_STRING:   in out STRING;
                       AT_THE_POSITION: in     POSITIVE;
                       WITH_THE_ITEM:   in     ITEM) is

   begin

     if AT_THE_POSITION > IN_THE_STRING.THE_LENGTH then
        IN_THE_STRING.THE_LENGTH := AT_THE_POSITION;
     end if;

     IN_THE_STRING.THE_ITEMS(AT_THE_POSITION):= WITH_THE_ITEM;

   end SET_ITEM;

   function IS_EQUAL (LEFT:  in STRING;
                      RIGHT: in STRING)    return BOOLEAN is

   begin

      if LEFT.THE_LENGTH /= RIGHT.THE_LENGTH then
         return FALSE;
      else
         for INDEX in 1..LEFT.THE_LENGTH loop
            if LEFT.THE_ITEMS(INDEX) /= RIGHT.THE_ITEMS(INDEX) then
               return FALSE;
            end if;
         end loop;
         return TRUE;
      end if;

   end IS_EQUAL;

   function IS_EQUAL (LEFT:  in SUBSTRING;
                      RIGHT: in STRING)    return BOOLEAN is

   begin

      if LEFT'LENGTH /= RIGHT.THE_LENGTH then
         return FALSE;
      else
         for INDEX in 1.. LEFT'LENGTH loop
            if LEFT(LEFT'FIRST + INDEX - 1) /= RIGHT.THE_ITEMS(INDEX) then
               return FALSE;
            end if;
         end loop;
         return TRUE;
      end if;

   end IS_EQUAL;

   function IS_EQUAL (LEFT:  in STRING;
                      RIGHT: in SUBSTRING)   return BOOLEAN is

   begin

      if LEFT.THE_LENGTH /= RIGHT'LENGTH then
         return FALSE;
      else
         for INDEX in 1..LEFT.THE_LENGTH loop
            if LEFT.THE_ITEMS(INDEX) /= RIGHT(RIGHT'FIRST +INDEX -1) then
               return FALSE;
            end if;
         end loop;
         return TRUE;
      end if;

   end IS_EQUAL;

   function IS_LESS_THAN (LEFT:  in STRING;
                          RIGHT: in STRING)   return BOOLEAN is

   begin

      for INDEX in 1..LEFT.THE_LENGTH loop
         if INDEX > RIGHT.THE_LENGTH then
            return FALSE;
         elsif LEFT.THE_ITEMS(INDEX) < RIGHT.THE_ITEMS(INDEX) then
            return TRUE;
         elsif RIGHT.THE_ITEMS(INDEX) < LEFT.THE_ITEMS(INDEX) then
            return FALSE;
        end if;
      end loop;
      return (LEFT.THE_LENGTH < RIGHT.THE_LENGTH);

   end IS_LESS_THAN;

   function IS_LESS_THAN (LEFT:  in SUBSTRING;
                          RIGHT: in STRING)    return BOOLEAN is

   begin

      for INDEX in 1..LEFT'LENGTH loop
         if INDEX > RIGHT.THE_LENGTH then
            return FALSE;
         elsif LEFT(LEFT'FIRST + INDEX - 1) < RIGHT.THE_ITEMS(INDEX) then
            return TRUE;
         elsif RIGHT.THE_ITEMS(INDEX) < LEFT(LEFT'FIRST + INDEX - 1) then
            return FALSE;
         end if;
      end loop;
      return (LEFT'LENGTH < RIGHT.THE_LENGTH);
      
   end IS_LESS_THAN;

   function IS_LESS_THAN (LEFT:  in STRING;
                          RIGHT: in SUBSTRING)  return BOOLEAN is

   begin

      for INDEX in 1..LEFT.THE_LENGTH loop
         if INDEX > RIGHT'LENGTH then
            return FALSE;
         elsif LEFT.THE_ITEMS(INDEX) < RIGHT(RIGHT'FIRST + INDEX - 1) then
            return TRUE;
         elsif RIGHT(RIGHT'FIRST + INDEX - 1) < LEFT.THE_ITEMS(INDEX) then
            return FALSE;
         end if;
      end loop;
      return (LEFT.THE_LENGTH < RIGHT'LENGTH);

   end IS_LESS_THAN;

   function IS_GREATER_THAN (LEFT:  in STRING;
                             RIGHT: in STRING)   return BOOLEAN is

   begin

      for INDEX in 1..LEFT.THE_LENGTH loop
         if INDEX > RIGHT.THE_LENGTH then
            return TRUE;
         elsif LEFT.THE_ITEMS(INDEX) < RIGHT.THE_ITEMS(INDEX) then
            return FALSE;
         elsif RIGHT.THE_ITEMS(INDEX) < LEFT.THE_ITEMS(INDEX) then
            return TRUE;
         end if;
      end loop;
      return FALSE;

   end IS_GREATER_THAN;

   function IS_GREATER_THAN (LEFT:  in SUBSTRING;
                             RIGHT: in STRING)     return BOOLEAN is

   begin

      for INDEX in 1.. LEFT'LENGTH loop
         if INDEX > RIGHT.THE_LENGTH then
            return TRUE;
         elsif LEFT(LEFT'FIRST + INDEX - 1) < RIGHT.THE_ITEMS(INDEX) then
           return FALSE;
         elsif RIGHT.THE_ITEMS(INDEX) < LEFT(LEFT'FIRST + INDEX - 1) then
            return TRUE;
         end if;
      end loop;
      return FALSE;

   end IS_GREATER_THAN;

   function IS_GREATER_THAN (LEFT:  in STRING;
                             RIGHT: in SUBSTRING)  return BOOLEAN is

   begin

      for INDEX IN 1..LEFT.THE_LENGTH loop
         if INDEX > RIGHT'LENGTH then
            return TRUE;
         elsif LEFT.THE_ITEMS(INDEX) < RIGHT(RIGHT'FIRST + INDEX - 1) then
            return FALSE;
         elsif RIGHT(RIGHT'FIRST + INDEX - 1) < LEFT.THE_ITEMS(INDEX) then
            return TRUE;
         end if;
      end loop;
      return FALSE;

   end IS_GREATER_THAN;

   function LENGTH_OF (THE_STRING: in STRING) return NATURAL is

   begin

      return THE_STRING.THE_LENGTH;
   end LENGTH_OF;

   function IS_NULL (THE_STRING: in STRING) return BOOLEAN is

   begin 

      return (THE_STRING.THE_LENGTH = 0);

   end IS_NULL;

   function ITEM_OF (THE_STRING:      in STRING;
                     AT_THE_POSITION: in POSITIVE) return ITEM is

   begin

      if AT_THE_POSITION > THE_STRING.THE_LENGTH then
         raise POSITION_ERROR;
      else
         return THE_STRING.THE_ITEMS(AT_THE_POSITION);
      end if;

   end ITEM_OF;

   function SUBSTRING_OF (THE_STRING: in STRING) return SUBSTRING is

   begin

      return THE_STRING.THE_ITEMS(1..THE_STRING.THE_LENGTH);

   end SUBSTRING_OF;

   function SUBSTRING_OF (THE_STRING:        in STRING;
                          FROM_THE_POSITION: in POSITIVE;
                          TO_THE_POSITION:   in POSITIVE) return SUBSTRING is

   begin

      if (FROM_THE_POSITION > THE_STRING.THE_LENGTH) or else
         (TO_THE_POSITION > THE_STRING.THE_LENGTH) or else
         (FROM_THE_POSITION > TO_THE_POSITION) then
         raise POSITION_ERROR;
      else
         return THE_STRING.THE_ITEMS(FROM_THE_POSITION ..TO_THE_POSITION);
      end if;

   end SUBSTRING_OF;

   procedure Free( Old_String : in out String) is
   begin
      if Old_String.The_Items /= Null_String then
--         Deallocate_Substring(Old_String.The_Items);
--         Old_String.The_Items := Null_String;
Null;
      end if;
end Free;
end VString;