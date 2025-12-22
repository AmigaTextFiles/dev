/* start this from CED */

OPTIONS results

parse arg CEDport
if CEDport = '' then CEDport = address()

address value CEDport

getword
func=result

if ~show(ports, FASTCREF) then
 do
  ADDRESS 'COMMAND' 'run >nil: Work:C/cref/FastCXRef XREFFILE=Work:C/cref/full3xref'
  ADDRESS 'COMMAND' 'SYS:REXXC/WaitForPort FASTCREF'
 end

ADDRESS FASTCREF

SEARCH stem a. WORD func

address value CEDport

if a.filename ~= "NONE" then do
	if a.filename ~= "OFF" then do

		OW a.filename
		STATUS EDITABLE
		if result = 1 then 'EDITABLE FILE'
		'EXPAND VIEW'
		LL a.linenumber

	end
end
else do
	OKAY1 func "not found"
end
