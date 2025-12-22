program led;

{ **************************************************************************

	Quickhack, (P) 12/1992 by "Diesel" Bernd Künnen ; dient
	zum Umschalten der Power-LED/Tiefpassfilter. Das Programm
	und der Quellcode sind übrigens Public Domain.

  ************************************************************************** }

type	ciaptr = ^byte;			{ Zeiger auf ein Byte }

var	wptr   : ciaptr;

begin
	wptr:= Address( $00bfe001 );

	if (wptr^ MOD 4)>1 then		{ Bit 1 gesetzt ? }
	  wptr^:=wptr^-2		{ ja -> löschen }
	else
	  wptr^:=wptr^+2;		{ sonst setzen }

					{ das war's schon ... }
end.
