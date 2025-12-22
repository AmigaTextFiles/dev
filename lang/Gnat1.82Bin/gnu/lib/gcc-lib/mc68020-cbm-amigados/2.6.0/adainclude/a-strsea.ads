------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                   A D A . S T R I N G S . S E A R C H                    --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.7 $                              --
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

--  This package contains the search functions from Ada.Strings.Fixed. They
--  are separated out because they are shared by Ada.Strings.Bounded and
--  Ada.Strings.Unbounded, and we don't want to drag other irrelevant stuff
--  from Ada.Strings.Fixed when using the other two packages. We make this
--  a private package, since user programs should access these subprograms
--  via one of the standard string packages.


with Ada.Strings.Maps;

private package Ada.Strings.Search is
pragma Preelaborate (Search);

   function Index
     (Source   : in String;
      Pattern  : in String;
      Going    : in Direction := Forward;
      Mapping  : in Maps.Character_Mapping := Maps.Identity)
      return     Natural;

   function Index
     (Source   : in String;
      Pattern  : in String;
      Going    : in Direction := Forward;
      Mapping  : in Maps.Character_Mapping_Function)
      return     Natural;

   function Index
     (Source : in String;
      Set    : in Maps.Character_Set;
      Test   : in Membership := Inside;
      Going  : in Direction  := Forward)
      return   Natural;

   function Index_Non_Blank
     (Source : in String;
      Going  : in Direction := Forward)
      return   Natural;

   function Count
     (Source   : in String;
      Pattern  : in String;
      Mapping  : in Maps.Character_Mapping := Maps.Identity)
      return     Natural;

   function Count
     (Source   : in String;
      Pattern  : in String;
      Mapping  : in Maps.Character_Mapping_Function)
      return     Natural;

   function Count
     (Source   : in String;
      Set      : in Maps.Character_Set)
      return     Natural;


   procedure Find_Token
     (Source : in String;
      Set    : in Maps.Character_Set;
      Test   : in Membership;
      First  : out Positive;
      Last   : out Natural);

end Ada.Strings.Search;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Mon Jun 27 17:36:38 1994;  author: dewar
--  Change from Pure to Preelaborate (per RM 5.0)
--  ----------------------------
--  revision 1.6
--  date: Mon Jul 11 17:20:21 1994;  author: banner
--  Add new functions Index and Count (per RM9X 5.0)
--  ----------------------------
--  revision 1.7
--  date: Thu Jul 21 02:46:50 1994;  author: dewar
--  Reformat specs to GNAT style
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
