/* List all the Arexx Error Messages */

    if ~show("L","arexxport.library") then
        if ~addlib("arexxport.library", 37, -108) then exit

    do n = 1 to 49
        say localerrortext( n )
    end

exit
