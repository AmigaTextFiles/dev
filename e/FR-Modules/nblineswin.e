/* $VER: nblineswin 1.0 (4.10.97) © Frédéric Rodrigues
   Returns number of lines displayable on a window
*/

OPT MODULE

MODULE 'intuition/intuition','graphics/rastport'

EXPORT PROC nblineswin(win:PTR TO window) IS (win.height-win.bordertop)/win.rport.txheight
