/*
** Arexx Port Library Demo Test script
*/

/* Try some commands */
demo.lasterror=''

'load fish'

say "Command 'load fish' returned "rc

if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end;

say ">> Any Key <<"
pull a

'saveas skate overwrite'
say "Command 'saveas skate overwrite' returned "rc" String '"result"'"
if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end
say ">> Any Key <<"
pull a

say 'Returning values in variables'
'saveas skate overwrite TEST'

say "Command 'saveas skate overwrite test' returned "rc" String '"test"'"
if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end
say ">> Any Key <<"
pull a

say "At a different port"
address test_port.2
'quit'
say "Command 'quit' returned "rc
if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end
say ">> Any Key <<"
pull a

address

'zoom'
say "Command 'zoom' returned "rc
if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end

say ">> Any Key <<"
pull a
'quit me oh me'
say "Command 'quit me oh me' returned "rc
if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end
say ">> Any Key <<"
pull a

say "Chaining scripts together"

'test2.rexx'

say "Script 'test2' returned "rc
if rc ~= 0 then do
    'fault ER'
    say 'Error : 'ER
end; else say 'Result = 'result

say ">> Any Key <<"
pull a

say "An syntax error in a macro"
say ">> Any Key <<"
pull a

end

exit