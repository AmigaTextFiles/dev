/*

Code:       file.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   This is script used to perform file copy, rename and move 
operations.

*/

options results
signal on error

parse arg portname' 'ndir' 'ctype' 'sfile';'dfile

address VALUE portname

select

/* rename file (and associated icon if appropriate) from source to destination */

    when ctype = 1 then do
        if exists(dfile) then do
            address command 'delete > T:err "'dfile'" ALL QUIET'
            list ID HST NODUP INSERT UPDATE STRING 'delete 'dfile' ALL QUIET'
        end
        address command 'rename > T:err "'sfile'" to "'dfile'" QUIET'
        list ID HST NODUP INSERT UPDATE STRING 'rename 'sfile' to 'dfile' QUIET'
        check ID ICN||ndir
        if result = '1' & exists(sfile'.info') then do
            if exists(dfile'.info') then do
                address command 'delete > T:err "'dfile'.info" ALL QUIET'
                list ID HST NODUP INSERT UPDATE STRING 'delete 'dfile'.info ALL QUIET'
            end
            address command 'rename > T:err "'sfile'.info" to "'dfile'.info" QUIET'
            list ID HST NODUP INSERT UPDATE STRING 'rename 'sfile'.info to 'dfile'.info QUIET'
        end
    end

/* move file (and associated icon if appropriate) from source to destination */

    when ctype = 2 then do
        address command 'copy > T:err "'sfile'" to "'dfile'" ALL CLONE QUIET'
        list ID HST NODUP INSERT UPDATE STRING 'copy 'sfile' to 'dfile' ALL CLONE QUIET'
        address command 'delete > T:err "'sfile'" ALL QUIET'
        list ID HST NODUP INSERT UPDATE STRING 'delete 'sfile' ALL QUIET'
        check ID ICN||ndir
        if result = '1' & exists(sfile'.info') then do
            address command 'copy > T:err "'sfile'.info" to "'dfile'.info" ALL CLONE QUIET'
            list ID HST NODUP INSERT UPDATE STRING 'copy 'sfile'.info to 'dfile'.info ALL CLONE QUIET'
            address command 'delete > T:err "'sfile'.info" ALL QUIET'
            list ID HST NODUP INSERT UPDATE STRING 'delete 'sfile'.info ALL QUIET'
        end
    end

/* copy file (and associated icon if appropriate) from source to destination */

    when ctype = 3 then do
        address command 'copy > T:err "'sfile'" to "'dfile'" ALL CLONE QUIET'
        list ID HST NODUP INSERT UPDATE STRING 'copy 'sfile' to 'dfile' ALL CLONE QUIET'
        check ID ICN||ndir
        if result = '1' & exists(sfile'.info') then do
            address command 'copy > T:err "'sfile'.info" to "'dfile'.info" ALL CLONE QUIET'
            list ID HST NODUP INSERT UPDATE STRING 'copy 'sfile'.info to 'dfile'.info ALL CLONE QUIET'
        end
    end
    otherwise nop
end
if exists('T:err') then address command 'delete T:err quiet'
exit


/* if an error occurs then display it */

error:
    if exists('T:err') then do
        call open('err','T:err')
        err = readln('err')
        call close('err')
        address command 'delete T:err quiet'
        request ID MDIR TITLE '" "' GADGETS '"OK"' '"'err'"'
    end
exit
