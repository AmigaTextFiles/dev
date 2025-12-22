/* $VER: bcpl.rexx 1.0 $
Usage: RX bcpl file
© by Stefan Haubenthal 1997 */

if ~arg() then do
	say sourceline(2)
	exit 20
end
parse arg name"."ext
address command
"icint s.int "arg(1)
if rc=0 then "icint c.int OCODE"
if rc=0 then "join iclib.int blib.int INTCODE to "name".int"
exit rc
