generic

   type ITEM is private;

   with function "<" (LEFT : in ITEM;
                      RIGHT: in ITEM) return BOOLEAN;

   type SUBSTRING is array (POSITIVE range <>) of ITEM;

package VString is

   type String is limited private;

   function Allocate_VString( str : in Substring ) return String;

   procedure COPY     (FROM_THE_STRING: in     STRING;
                       TO_THE_STRING:   in out STRING);

   procedure COPY     (FROM_THE_SUBSTRING: in     SUBSTRING;
                       TO_THE_STRING:      in out STRING);

   procedure CLEAR    (THE_STRING:         in out STRING);

   procedure PREPEND  (THE_STRING:         in     STRING;
                       TO_THE_STRING:      in out STRING);

   procedure PREPEND  (THE_SUBSTRING:      in     SUBSTRING;
                       TO_THE_STRING:      in out STRING);

   procedure APPEND   (THE_STRING:         in     STRING;
                       TO_THE_STRING:      in out STRING);

   procedure APPEND   (THE_SUBSTRING:      in     SUBSTRING;
                       TO_THE_STRING:      in out STRING);

   procedure INSERT   (THE_STRING:         in     STRING;
                       IN_THE_STRING:      in out STRING;
                       AT_THE_POSITION:    in     POSITIVE);

   procedure INSERT   (THE_SUBSTRING:      in     SUBSTRING;
                       IN_THE_STRING:      in out STRING;
                       AT_THE_POSITION:    in     POSITIVE);

   procedure DELETE   (IN_THE_STRING:      in out STRING;
                       FROM_THE_POSITION:  in     POSITIVE;
                       TO_THE_POSITION:    in     POSITIVE);

   procedure REPLACE  (IN_THE_STRING:      in out STRING;
                       AT_THE_POSITION:    in     POSITIVE;
                       WITH_THE_STRING:    in     STRING);

   procedure REPLACE  (IN_THE_STRING:      in out STRING;
                       AT_THE_POSITION:    in     POSITIVE;
                       WITH_THE_SUBSTRING: in     SUBSTRING);

   procedure SET_ITEM (IN_THE_STRING:      in out STRING;
                       AT_THE_POSITION:    in     POSITIVE;
                       WITH_THE_ITEM:      in     ITEM);

   function IS_EQUAL       (LEFT:          in STRING;
                            RIGHT:         in STRING)    return BOOLEAN;

   function IS_EQUAL       (LEFT:          in SUBSTRING;
                            RIGHT:         in STRING)    return BOOLEAN;

   function IS_EQUAL       (LEFT:          in STRING;
                            RIGHT:         in SUBSTRING) return BOOLEAN;

   function IS_LESS_THAN   (LEFT:          in STRING;
                            RIGHT:         in STRING)    return BOOLEAN;

   function IS_LESS_THAN   (LEFT:          in SUBSTRING;
                            RIGHT:         in STRING)    return BOOLEAN;

   function IS_LESS_THAN   (LEFT:          in STRING;
                            RIGHT:         in SUBSTRING) return BOOLEAN;

   function IS_GREATER_THAN(LEFT:          in STRING;
                            RIGHT:         in STRING)    return BOOLEAN;

   function IS_GREATER_THAN(LEFT:          in SUBSTRING;
                            RIGHT:         in STRING)    return BOOLEAN;

   function IS_GREATER_THAN(LEFT:          in STRING;
                            RIGHT:         in SUBSTRING) return BOOLEAN;

   function LENGTH_OF      (THE_STRING:    in STRING)    return NATURAL;

   function IS_NULL        (THE_STRING:    in STRING)    return BOOLEAN;

   function ITEM_OF        (THE_STRING:    in STRING;
                            AT_THE_POSITION: in POSITIVE) return ITEM;

   function SUBSTRING_OF   (THE_STRING:    in STRING)     return SUBSTRING;

   function SUBSTRING_OF   (THE_STRING:    in STRING;
                            FROM_THE_POSITION: in POSITIVE;
                            TO_THE_POSITION:   in POSITIVE) return SUBSTRING;

   procedure Free( Old_String : in out String);

-- exceptions

   OVERFLOW:       exception;

   POSITION_ERROR: exception;

private
   type String_Ptr is access Substring;

   Null_String : String_Ptr := Null;

   type String is record
      THE_LENGTH: NATURAL:= 0;
      THE_ITEMS:  String_Ptr := Null_String;
      end record;

end VString;
