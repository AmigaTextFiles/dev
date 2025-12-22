
READ ME CAREFULLY

Due to a problem with lib module usage, in AmigaE environment the library
functions names starts with 'Cp_' instead of 'C2P_'. I have tested more
times using standard 'C2P_' names but the 'ec' compiler reports the error
"Undefined constant or symbol". It seems the problem is caused by adopting
the number '2' as second character, even if the 'showmodule' tool lists the
functions correctly..
If you find a solution, feel free to contact me.
