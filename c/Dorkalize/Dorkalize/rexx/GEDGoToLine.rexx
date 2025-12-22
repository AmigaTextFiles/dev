/*
    GoToLine script for GoldEd $VER: GEDGoToLine.rexx 0.91
    Usage: rx GEDGoToLine <file_to_open>, <line>, <column>
*/
parse arg filename ',' line ',' column
if filename = '' then
do
    say "GEDGoToLine error: File name required"
    exit 20
end
if ~open(sourcefile, filename, 'r') then
do
    say "GEDGoToLine error: Can't open file" filename
    exit 21
end
close(sourcefile)
address command 'ged ' filename
if line = '' then exit
do i = 1 to 10 while ~show("P", "GOLDED.1")
    call delay(50)
end
if i > 10 then
do
    say "GEDGoToLine error: Can't find GoldED ARexx port"
    exit 22
end
address 'GOLDED.1'
if column = '' then
    'GOTO line='line
else
    'GOTO line='line' column='column


