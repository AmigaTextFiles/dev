/*
   Random Module, Copyright © 2003 Kalle Raisanen.
   Based on PRNGs written by George Marsaglia.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


   Procedures:
	seedRand()
	   Sets seeds for random number generation, uses datestamp
	   to get the number of ticks since midnight.
	getRand()
	   Returns a 16 bit random number.
	getRandRange(max)
	   Returns a random number between 0 and max-1.

   Seeds:
	zold, wold, jsr, jcong
	   All 32 bit numbers, which are coerced into 16 bit by
	   getRand(). To seed getRand() yourself (rather than 
	   relying on seedRand()), just set these for variables.
*/
OPT MODULE

MODULE 'dos/dos'

EXPORT CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60
EXPORT DEF zold, wold, jsr, jcong

EXPORT PROC getRand()
   DEF mwc
   zold := Mul(36969,(zold AND $ffff))+(Shr(zold,16))
   wold := Mul(18000,(wold AND $ffff))+(Shr(wold,16))
   mwc  := Shl(zold,16)+wold
   jsr  := Eor(jsr, Shl(jsr, 17))
   jsr  := Eor(jsr, Shr(jsr, 13))
   jsr  := Eor(jsr, Shl(jsr, 5))
   jcong := Mul(jcong, 69069) + 1234567
   RETURN Shr(Eor(mwc, jcong) + jsr, 16) AND $ffff    -> "AND $ffff" is redundant, but clarifying :)
ENDPROC

EXPORT PROC seedRand()
   DEF ds:datestamp
   DateStamp(ds)
   zold := ds.minute * TICKS_PER_MINUTE + ds.tick
   wold := zold + ds.tick
   jsr  := wold + ds.tick
   jcong := ds.tick
ENDPROC

EXPORT PROC getRandRange(max) IS Mod(getRand(),max)

