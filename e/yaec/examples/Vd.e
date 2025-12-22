/* A small virus detector */
/* By EA van Breemen */

-> rewritten for yaec by (LS)
-> first quote-argument is in special identifier "\1".

MODULE 'exec/execbase'

DEF base:PTR TO execbase -> not needed: ,x:PTR TO LONG

/* Main procedure */

PROC main()
 WriteF('The E Virusdetector \c1993\n',169)
 WriteF('By E.A. van Breemen\n')
 base:=execbase  /* get execbase */
 IF check_exec() THEN WriteF('Machine has been infected\n')
ENDPROC

/* Check procedure of execbase */

PROC check_exec() IS Exists(
  [[base.coldcapture,'ColdCapture'],[base.coolcapture,'CoolCapture'],
  [base.kickmemptr,'KickMemPtr'],[base.kicktagptr,'KickTagPtr']],
  `WriteF(IF Long(\1) THEN '\s Altered\n' ELSE '\s OK\n',ListItem(\1,1)) BUT Long(\1))
