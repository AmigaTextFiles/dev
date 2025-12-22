/* 
** Mandelbrot generator V0.5 -- For use with AmiSlate.
**
** Copyright 1995 Johan Torin
**
** Contact me at johan@artworks.apana.org.au
**
*/


/*
For the best apperance, extract and load this picture into AmiSlate
before running this script.

begin 644 MandelColors.iff
M1D]230```(!)3$)-0DU(1````!0``@`!``````0"`````!8L`H`!`$--05``V
M```P``````#P("#P0$#P8&#P@(#PH*#PP,#PX.#P\/#P\/"@\/!0\/``\-``0
M\,``\+``1U)!0@````0``0``0T%-1P````0``I``0D]$60````@`````````5
!`,```
``
end
size 136
*/



parse arg CommandPort ActiveString

address (CommandPort)

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx mandelbrot.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end

options results

/* Calculate center of drawing area */
GetWindowAttrs stem win.
X_Size = trunc((win.width-58))
Y_Size = trunc((win.height-53))

/* Init some variables */
PixelSize = 3                         /* The size of each dot in pixels */

Iterations = 32

Z_r = 0
Z_i = 0
C_r = 0
C_i = 0
K_r = 0
K_i = 0
Delta_r = 0
Delta_i = 0
Itt = 0
X = 0
Y = 0

Start_r = -2.5
Start_i = -1.75
End_r = 1.5
End_i = 1.75


Ul_r = Start_r
Ul_i = Start_i
Lr_r = End_r
Lr_i = End_i

Delta_r = Lr_r-Ul_r
Delta_i = Lr_i-Ul_r


Do Y = 0 to Y_Size-1 BY PixelSize+1
   C_i = Delta_i/Y_Size*Y+Ul_i
   Do X = 0 to X_Size-1 BY PixelSize+1
      C_r = Delta_r/X_Size*X+Ul_r
      Z_r = C_r
      Z_i = C_i
      K_r = Z_r * Z_r
      K_i = Z_i * Z_i
      Itt = 0
      Do While ((K_r + K_i) < 4) & (Itt < Iterations)
         Z_i = 2 * Z_r * Z_i + C_i
         Z_r = K_r - K_i + C_r
         K_r = Z_r * Z_r
         K_i = Z_i * Z_i
         Itt = Itt + 1
         end
      If Itt > Iterations-2 then Itt = -3

      SetFPen Itt+4
      Square X Y X+PixelSize Y+PixelSize FILL

   End
End
