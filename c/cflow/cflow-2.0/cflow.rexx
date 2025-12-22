/* $VER: cflow 0.1 $ */
/* Print a function call hierarchy */
/* © by Stefan Haubenthal 1999 */
if ~arg() then exit 0*writeln(stdout,"Usage: cflow file")
address command prcc arg(1) ">pipe:"
address command prcg "<pipe:"
