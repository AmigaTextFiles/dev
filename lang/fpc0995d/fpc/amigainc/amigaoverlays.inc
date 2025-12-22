
{  amigaoverlays.inc }

{
    This file is part of the Free Pascal run time library.

    A file in Amiga system run time library.
    Copyright (c) 1998-2000 by Nils Sjoholm
    member of the Amiga RTL development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{
   This includefile sets the define amiga_overlays.
   I have tried to make overlay functions for most
   of the pchar functions in the amiga units.

   That means you can use either a pchar or a string
   as arg for the function.

   If you don't like the idea of overlays just put a
   space before $define amiga_overlays.

   16 Jul 2000.

   nils.sjoholm@mailbox.swipnet.se

}

{$ifndef amiga_overlays}
   {$define amiga_overlays}
{$endif}