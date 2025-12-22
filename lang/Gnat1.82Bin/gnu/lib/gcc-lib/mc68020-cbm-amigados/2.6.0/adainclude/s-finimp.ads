------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--    S Y S T E M . F I N A L I Z A T I O N _ I M P L E M E N T A T I O N   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.10 $                              --
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

--  ??? this package should be a private package. It is set as public for now
--  in order to simplify testing

package System.Finalization_Implementation is

   type Empty_Root is abstract tagged null record;
   --  Empty_Root is defined only to allow the definition of the general
   --  class-wide access type Finalization_List

   type Finalizable_Ptr is access all Empty_Root'Class;

   ----------------------------------------------
   --  The Two Required Controlled Root types  --
   ----------------------------------------------

   --  See RM 7.6 (11)

   type Root_Controlled is tagged record
      Previous : Finalizable_Ptr;
      Next     : Finalizable_Ptr;
   end record;

   procedure Initialize (Object : in out Root_Controlled);
   procedure Finalize   (Object : in out Root_Controlled);

   type Root_Limited_Controlled is tagged limited record
      Previous : Finalizable_Ptr;
      Next     : Finalizable_Ptr;
   end record;

   procedure Initialize (Object : in out Root_Limited_Controlled);
   procedure Finalize   (Object : in out Root_Limited_Controlled);

   -------------------------------------------------
   --  Finalization Management Abstract Interface --
   -------------------------------------------------

   Global_Final_List : Finalizable_Ptr;
   --  This list stores the controlled objects defined in library-level
   --  packages. They will be finalized after the main program completion.

   procedure Finalize_Global_List;
   --  The procedure to be called in order to finalize the global list;

   type Root is abstract new Empty_Root with record
      Previous : Finalizable_Ptr;
      Next     : Finalizable_Ptr;
   end record;

   subtype Finalizable is Root'Class;
   --  The classwide type for all finalizable objects

   procedure Initialize (Object : in out Root) is abstract;
   procedure Finalize   (Object : in out Root) is abstract;
   --  Root should logically be the common ancestor of Root_Limited_Controlled
   --  and Root_Controlled. It is not possible because a limited type and a non
   --  limited one cannot syntactically derive from the same ancestor.
   --  Therefore, it is a different type with exactly the same characteristics,
   --  and unchecked conversions will be used to go forth and back. It carries
   --  the pointers used to manage the doubly linked-list of controlled objects
   --  of each scope. Furthermore, Initialize and Finalize are defined as
   --  abstract primitives to insure the dispatch table compatibility with both
   --  Root_Limited_Controlled and Root_Controlled.

   procedure Attach_To_Final_List
    (L   : in out Finalizable_Ptr;
     Obj : in out Finalizable);
   --  Put the finalizable object on a list of finalizable elements. This
   --  procedure is called during the initialization of the controlled object.

   procedure Finalize_List (L : Finalizable_Ptr);
   --  Call Finalize on each element of the list L;

   procedure Finalize_One
    (From : in out Finalizable_Ptr;
     Obj  : in out Finalizable);
   --  Call Finalize on Obj and remove it from the list From.

end System.Finalization_Implementation;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Tue Feb 22 19:29:20 1994;  author: comar
--  Changes in naming. Remove temporarly the private status of this package for
--  testing purposes.
--  ----------------------------
--  revision 1.9
--  date: Tue Aug  2 12:23:57 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.10
--  date: Fri Aug 19 20:27:38 1994;  author: comar
--  Add procedure Finalize_Global_List.
--  remove Root_Part no more needed.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
