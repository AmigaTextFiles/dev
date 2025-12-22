/* ARexx script run by Startup-menu on exit. Quits OctamedPlayer*/

ADDRESS OCTAMEDPLAYER
Stop
Quit

/* Or you could do it like this if the above does not work (dosn't with me)

  ADDRESS Command "C:Break 3 C"
  
  where 3 is the process number that the player is loaded into. Find out by 
  running OMP at startup with OMP_sminit.Rexx but not this script and then
  use Status in a Shell to determine */

