------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--               A D A . S T R I N G S . W I D E _ F I X E D                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.3 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------

--  Note: This code is derived from the ADAR.CSH public domain Ada 83
--  versions of the Appendix C string handling packages. One change is
--  to avoid the use of Is_In, so that we are not dependent on inlining.
--  Note that the search function implementations are to be found in the
--  auxiliary package Ada.Strings.Wide_Search. Also the Move procedure is
--  directly incorporated (ADAR used a subunit for this procedure)


package body Ada.Strings.Wide_Fixed is

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Max (Item_1, Item_2 : Integer) return Integer;
   --  Return maximum of two integers (this should be replaced by use of
   --  the 'Max attribute when GNAT implements this attribute ???)

   function Max (Item_1, Item_2 : Integer) return Integer is
   begin
      if Item_1 >= Item_2 then
         return Item_1;
      else
         return Item_2;
      end if;
   end Max;

   ---------
   -- "*" --
   ---------

   function "*" (Left  : in Natural;
                 Right : in Wide_Character) return Wide_String
   is
      Result : Wide_String (1 .. Left);

   begin
      for I in Result'range loop
         Result (I) := Right;
      end loop;

      return Result;
   end "*";

   function "*" (Left  : in Natural;
                 Right : in Wide_String) return Wide_String
   is
      Result : Wide_String (1 .. Left * Right'Length);
      Ptr    : Integer := 1;

   begin
      for I in 1 .. Left loop
         Result (Ptr .. Ptr + Right'Length - 1) := Right;
         Ptr := Ptr + Right'Length;
      end loop;

      return Result;
   end "*";

   ------------
   -- Delete --
   ------------

   function Delete (Source  : in Wide_String;
                    From    : in Positive;
                    Through : in Natural)
     return Wide_String
   is
      Result : Wide_String (1 .. Source'Length - Max (Through - From + 1, 0));
   begin
      if From not in Source'range or else Through > Source'Last then
         raise Index_Error;
      end if;

      Result := Source (Source'First .. From - 1) &
                Source (Through + 1 .. Source'Last);
      return Result;
   end Delete;

   procedure Delete (Source  : in out Wide_String;
                     From    : in Positive;
                     Through : in Natural;
                     Justify : in Alignment := Left;
                     Pad     : in Wide_Character := Wide_Fixed.Pad) is
   begin
      Move (Source  => Delete (Source, From, Through),
            Target  => Source,
            Justify => Justify,
            Pad     => Pad);
   end Delete;

   ----------
   -- Head --
   ----------

   function Head (Source : in Wide_String;
                  Count  : in Natural;
                  Pad    : in Wide_Character := Wide_Fixed.Pad)
     return Wide_String
   is
      Result : Wide_String (1 .. Count);

   begin
      if Count < Source'Length then
         Result := Source (Source'First .. Source'First + Count - 1);

      else
         Result (1 .. Source'Length) := Source;

         for I in Source'Length + 1 .. Count loop
            Result (I) := Pad;
         end loop;
      end if;

      return Result;
   end Head;

   ------------
   -- Insert --
   ------------

   function Insert (Source   : in Wide_String;
                    Before   : in Positive;
                    New_Item : in Wide_String)
     return Wide_String
   is
      Result : Wide_String (1 .. Source'Length + New_Item'Length);

   begin
      if Before < Source'First or else Before > Source'Last + 1 then
         raise Index_Error;
      end if;

      Result := Source (Source'First .. Before - 1) & New_Item &
                Source (Before .. Source'Last);
      return Result;
   end Insert;

   procedure Insert (Source   : in out Wide_String;
                     Before   : in Positive;
                     New_Item : in Wide_String;
                     Drop     : in Truncation := Error) is
   begin
      Move (Source => Insert (Source, Before, New_Item),
            Target => Source,
            Drop   => Drop);
   end Insert;

   ----------
   -- Move --
   ----------

   procedure Move (Source  : in  Wide_String;
                   Target  : out Wide_String;
                   Drop    : in  Truncation := Error;
                   Justify : in  Alignment  := Left;
                   Pad     : in  Wide_Character  := Ada.Strings.Wide_Fixed.Pad)
   is
      Sfirst  : constant Integer := Source'First;
      Slast   : constant Integer := Source'Last;
      Slength : constant Integer := Source'Length;

      Tfirst  : constant Integer := Target'First;
      Tlast   : constant Integer := Target'Last;
      Tlength : constant Integer := Target'Length;

      function Is_Padding (Item : Wide_String) return Boolean is
      begin
         for I in Item'range loop
            if Item (I) /= Pad then
               return False;
            end if;
         end loop;

         return True;
      end Is_Padding;

   --  Start of processing for Move

   begin
      if Slength = Tlength then
         Target := Source;

      elsif Slength > Tlength then

         case Drop is
            when Left =>
               Target := Source (Slast - Tlength + 1 .. Slast);

            when Right =>
               Target := Source (Sfirst .. Sfirst + Tlength - 1);

            when Error =>
               case Justify is
                  when Left =>
                     if Is_Padding (Source (Sfirst + Tlength .. Slast)) then
                        Target :=
                          Source (Sfirst .. Sfirst + Target'Length - 1);
                     else
                        raise Length_Error;
                     end if;

                  when Right =>
                     if Is_Padding (Source (Sfirst .. Slast - Tlength)) then
                        Target := Source (Slast - Tlength + 1 .. Slast);
                     else
                        raise Length_Error;
                     end if;

                  when Center =>
                     raise Length_Error;
               end case;

         end case;

      else -- Source'Length < Target'Length

         case Justify is
            when Left =>
               Target (Tfirst .. Tfirst + Slength - 1) := Source;

               for I in Tfirst + Slength .. Tlast loop
                  Target (I) := Pad;
               end loop;

            when Right =>
               for I in Tfirst .. Tlast - Slength loop
                  Target (I) := Pad;
               end loop;

               Target (Tlast - Slength + 1 .. Tlast) := Source;

            when Center =>
               declare
                  Front_Pad   : constant Integer := (Tlength - Slength) / 2;
                  Tfirst_Fpad : constant Integer := Tfirst + Front_Pad;

               begin
                  for I in Tfirst .. Tfirst_Fpad - 1 loop
                     Target (I) := Pad;
                  end loop;

                  Target (Tfirst_Fpad .. Tfirst_Fpad + Slength - 1) := Source;

                  for I in Tfirst_Fpad + Slength .. Tlast loop
                     Target (I) := Pad;
                  end loop;
               end;
         end case;
      end if;
   end Move;

   ---------------
   -- Overwrite --
   ---------------

   function Overwrite (Source   : in Wide_String;
                       Position : in Positive;
                       New_Item : in Wide_String)
     return Wide_String is
   begin
      if Position not in Source'First .. Source'Last + 1 then
         raise Index_Error;
      end if;

      declare
         Result_Length : Natural :=
           Max (Source'Length, Position - Source'First + New_Item'Length);
         Result : Wide_String (1 .. Result_Length);

      begin
         Result := Source (Source'First .. Position - 1) & New_Item &
                   Source (Position + New_Item'Length .. Source'Last);
         return Result;
      end;
   end Overwrite;

   procedure Overwrite (Source   : in out Wide_String;
                        Position : in Positive;
                        New_Item : in Wide_String;
                        Drop     : in Truncation := Right) is
   begin
      Move (Source => Overwrite (Source, Position, New_Item),
            Target => Source,
            Drop   => Drop);
   end Overwrite;

   -------------------
   -- Replace_Slice --
   -------------------

   function Replace_Slice (Source   : in Wide_String;
                           Low      : in Positive;
                           High     : in Natural;
                           By       : in Wide_String)
     return Wide_String
   is
      Result_Length : Natural;

   begin
      if Low > Source'Last + 1 or High < Source'First - 1 then
         raise Index_Error;
      end if;

      Result_Length := Source'Length - Max (High - Low + 1, 0) + By'Length;

      declare
         Result : Wide_String (1 .. Result_Length);

      begin
         if High >= Low then
            Result :=
               Source (Source'First .. Low - 1) & By &
               Source (High + 1 .. Source'Last);
         else
            Result := Source (Source'First .. Low - 1) & By &
                      Source (Low .. Source'Last);
         end if;
         return Result;
      end;
   end Replace_Slice;

   procedure Replace_Slice (Source   : in out Wide_String;
                            Low      : in Positive;
                            High     : in Natural;
                            By       : in Wide_String;
                            Drop     : in Truncation := Error;
                            Justify  : in Alignment  := Left;
                            Pad      : in Wide_Character  := Wide_Fixed.Pad) is
   begin
      Move (Replace_Slice (Source, Low, High, By), Source, Drop, Justify, Pad);
   end Replace_Slice;

   ----------
   -- Tail --
   ----------

   function Tail (Source : in Wide_String;
                  Count  : in Natural;
                  Pad    : in Wide_Character := Wide_Fixed.Pad)
     return Wide_String
   is
      Result : Wide_String (1 .. Count);

   begin
      if Count < Source'Length then
         Result := Source (Source'Last - Count + 1 .. Source'Last);

      --  Pad on left

      else
         for I in 1 .. Count - Source'Length loop
            Result (I) := Pad;
         end loop;

         Result (Count - Source'Length + 1 .. Count) := Source;
      end if;

      return Result;
   end Tail;

   ---------------
   -- Translate --
   ---------------

   function Translate
     (Source  : in Wide_String;
      Mapping : in Wide_Maps.Wide_Character_Mapping)
     return Wide_String
   is
      Result : Wide_String (1 .. Source'Length);

   begin
      for J in Source'range loop
         if Source (J) in Mapping'range then
            Result (J - (Source'First - 1)) := Mapping (Source (J));
         else
            Result (J - (Source'First - 1)) := Source (J);
         end if;
      end loop;

      return Result;
   end Translate;

   procedure Translate
     (Source  : in out Wide_String;
      Mapping : in Wide_Maps.Wide_Character_Mapping) is
   begin
      for I in Source'range loop
         if Source (I) in Mapping'range then
            Source (I) := Mapping (Source (I));
         end if;
      end loop;
   end Translate;

   function Translate
     (Source  : in Wide_String;
      Mapping : in Wide_Maps.Wide_Character_Mapping_Function)
     return Wide_String
   is
      Result : Wide_String (1 .. Source'Length);

   begin
      for J in Source'range loop
         Result (J - (Source'First - 1)) := Mapping (Source (J));
      end loop;

      return Result;
   end Translate;

   procedure Translate
     (Source  : in out Wide_String;
      Mapping : in Wide_Maps.Wide_Character_Mapping_Function) is
   begin
      for I in Source'range loop
         Source (I) := Mapping (Source (I));
      end loop;
   end Translate;

   ----------
   -- Trim --
   ----------

   function Trim (Source : in Wide_String) return Wide_String is
      Low, High : Integer;

   begin
      Low  := Index_Non_Blank (Source, Forward);

      --  All blanks case

      if Low = 0 then
         return "";

      --  At least one non-blank

      else
         High := Index_Non_Blank (Source, Backward);

         declare
            Result : Wide_String (1 .. High - Low + 1);

         begin
            Result := Source (Low .. High);
            return Result;
         end;
      end if;
   end Trim;

   function Trim
      (Source : in Wide_String;
       Left   : in Wide_Maps.Wide_Character_Set;
       Right  : in Wide_Maps.Wide_Character_Set)
     return Wide_String
   is
      High, Low : Integer;

   begin
      Low := Index (Source, Set => Left, Test  => Outside, Going => Forward);

      --  Case where source comprises only characters in Left

      if Low = 0 then
         return "";
      end if;

      High :=
        Index (Source, Set => Right, Test  => Outside, Going => Backward);

      --  Case where source comprises only characters in Right

      if High = 0 then
         return "";
      end if;

      declare
         Result : Wide_String (1 .. High - Low + 1);

      begin
         Result := Source (Low .. High);
         return Result;
      end;
   end Trim;

   procedure Trim
      (Source  : in out Wide_String;
       Left    : in Wide_Maps.Wide_Character_Set;
       Right   : in Wide_Maps.Wide_Character_Set;
       Justify : in Alignment := Ada.Strings.Left;
       Pad     : in Wide_Character := Wide_Fixed.Pad) is

   begin
      Move (Source  => Trim (Source, Left, Right),
            Target  => Source,
            Justify => Justify,
            Pad     => Pad);
   end Trim;

end Ada.Strings.Wide_Fixed;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 00:51:52 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Mon Dec 27 09:13:21 1993;  author: dewar
--  Add missing Translate functions (the ones using a mapping Function)
--  ----------------------------
--  revision 1.3
--  date: Sun Jan  9 10:55:35 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
