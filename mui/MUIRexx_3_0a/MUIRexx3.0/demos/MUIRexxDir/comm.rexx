/*

Code:       comm.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   This is script used to perform file operations.  It is executed
when certain gadgets are selected in the muidir GUI.

*/

options results
signal on error

/* TAG ID definitions */

Draggable =                       0x80420b6e /* V11 isg BOOL              */
Dirlist_Directory =               0x8042ea41 /* V4  isg STRPTR            */
Dirlist_RejectIcons =             0x80424808 /* V4  is. BOOL              */
List_Quiet =                      0x8042d8c7 /* V4  .s. BOOL              */

/* TAG variable definitions */

TRUE = 1
FALSE = 0
List_Insert_Bottom = -3

parse arg portname comm' ['name']'

call pragma('Directory','muidir:')

address VALUE portname

comm = strip(comm)

group ID DIR REGISTER
ndir = result

select

/* copy the selected files from the source to destination directory */

    when index(comm,'COPY') = 1 then call copyfiles(3)

/* move the selected files from the source to destination directory */

    when index(comm,'MOVE') = 1 then do
        dirlist ID DIR||ndir ATTRS Dirlist_Directory
        sdir = import(d2c(result))
        dirlist ID DIR||(3-ndir) ATTRS Dirlist_Directory
        ddir = import(d2c(result))
        if substr(sdir,1,pos(':',sdir)) = substr(ddir,1,pos(':',ddir)) then
            copy = 1
        else copy = 2
        call copyfiles(copy)
    end

/* delete the selected files from the source directory */

    when index(comm,'DELETE') = 1 then do
        request ID MDIR TITLE '" "' GADGETS '"OK|Cancel"' "Delete selected entries?"
        if result = 1 then do
            do forever
                dirlist ID DIR||ndir
                sfile = result
                if sfile = '' then break
                address command 'delete > T:err "'sfile'" ALL QUIET'
                list ID HST INSERT POS List_Insert_Bottom STRING 'delete 'sfile' ALL QUIET'
                check ID ICN||ndir
                if result = '1' & exists(sfile'.info') then do
                    address command 'delete > T:err "'sfile'.info" ALL QUIET'
                    list ID HST INSERT POS List_Insert_Bottom STRING 'delete 'sfile'.info ALL QUIET'
                end
            end
            if exists('T:err') then address command 'delete T:err quiet'
            check ID ICN||ndir
            dirlist ID DIR||ndir REREAD ATTRS Dirlist_RejectIcons result
        end
    end

/* either display the selected files icon or change source to the selected 
   directory */

    when index(comm,'DIR') = 1 then do
        name = strip(name)
        if index(statef(name),'DIR') ~= 0 then do

/* the selected entry is a directory, so change to it */

            call changedir(name)
            exit
        end
        else do

/* otherwise, if the entry does not exist assume it is suppose to be a
directory and create it */

            if ~exists(name) then do
                address command 'makedir "'name'"'
                list ID HST INSERT POS List_Insert_Bottom STRING 'makedir 'name
                if rc = 0 then call changedir(name)
                exit
            end
            call defcomm portname name
        end
    end
    when index(comm,'ICON') = 1 then do
        name = strip(name)
        if lastpos('/',name) ~= 0 then file = substr(name,lastpos('/',name)+1)
        else file = substr(name,lastpos(':',name)+1)

/*      text ID NAM||ndir LABEL file */

        group ID GRP||ndir
            button ID IMG||ndir ICON deficon(name) COMMAND '"muidir:defcomm 'portname' %s"' ATTRS Draggable TRUE LABEL name
        endgroup
    end

/* clear the text icon and string */

    when index(comm,'CLEAR') = 1 then do
        group ID GRP||ndir
            image ID IMG||ndir ICON '""' LABEL ' '
        endgroup
    end
    when index(comm,'HCLEAR') = 1 then do
        list ID HST STRING
    end
    when index(comm,'HEXE') = 1 then do
        do forever

        /* get next entry */

            list ID HST
            line = result
            if line = '' then break

        /* execute entry */

            address command line' >T:err'
        end
        if exists('T:err') then address command 'delete T:err quiet'
    end

/* compile a list of files to copy from the source to destination directory */

    when index(comm,'CCOPY') = 1 then do

        /* clear the copy list */

        list ID CLST STRING

        /* get the source directory name */

        dirlist ID DIR||ndir ATTRS Dirlist_Directory
        sname = import(d2c(result))

        /* get the destination directory name */

        dirlist ID DIR||(3-ndir) ATTRS Dirlist_Directory
        dname = import(d2c(result))

        /* temporarily disable list update */

        list ID CLST ATTRS List_Quiet TRUE

        /* call the nextcopy procedure to process the current directory */

        call nextcopy sname';'dname

        /* update the copy list (i.e. display the contents) */

        list ID CLST ATTRS List_Quiet FALSE
    end

/* perform copy based on list of compiled files */

    when index(comm,'MCOPY') = 1 then do
        do forever

        /* get next entry */

            list ID CLST
            line = result
            if line = '' then break

        /* parse entry */

            parse var line sfile' -> 'dfile' ['flags']'

        /* execute copy */

            address command 'copy > T:err "'sfile'" to "'dfile'" 'flags' CLONE QUIET'
        end
        if exists('T:err') then address command 'delete T:err quiet'

        /* update dirlist */

        check ID ICN||(3-ndir)
        dirlist ID DIR||(3-ndir) REREAD ATTRS Dirlist_RejectIcons result
    end

/* compile a list of files to delete from the destination directory */

    when index(comm,'CDEL') = 1 then do

        /* clear the delete list */

        list ID DLST STRING

        /* get the source directory name */

        dirlist ID DIR||ndir ATTRS Dirlist_Directory
        sname = import(d2c(result))

        /* get the destination directory name */

        dirlist ID DIR||(3-ndir) ATTRS Dirlist_Directory
        dname = import(d2c(result))

        /* temporarily disable list update */

        list ID DLST ATTRS List_Quiet TRUE

        /* call the nextdel procedure to process the current directory */

        call nextdel sname';'dname

        /* update the delete list (i.e. display the contents) */

        list ID DLST ATTRS List_Quiet FALSE
    end

/* perform delete based on list of compiled files */

    when index(comm,'MDEL') = 1 then do
        do forever

        /* get next entry */

            list ID DLST
            line = result
            if line = '' then break

        /* parse entry */

            parse var line sfile' ['flags']'

        /* execute delete */

            address command 'delete > T:err "'sfile'" 'flags' QUIET'
        end
        if exists('T:err') then address command 'delete T:err quiet'

        /* update dirlist */

        check ID ICN||(3-ndir)
        dirlist ID DIR||(3-ndir) REREAD ATTRS Dirlist_RejectIcons result
    end

/* Edit selected files */

    when index(comm,'EDIT') = 1 then do
        getvar screen
        pub = result
        files = ''
        do forever
            dirlist ID DIR||ndir
            sfile = result
            if sfile = '' then break
            files = files' "'sfile'"'
        end
        address command 'ced -pubscreen='pub' 'files
    end

/* View selected files */

    when index(comm,'VIEW') = 1 then do
        files = ''
        do forever
            dirlist ID DIR||ndir
            sfile = result
            if sfile = '' then break
            files = files' "'sfile'"'
        end
        address command 'tools:graphics/PicassoII/Viewer/IntuiView now'files
    end

/* Make icons for selected files */

    when index(comm,'ICON') = 1 then do
        files = ''
        do forever
            dirlist ID DIR||ndir
            sfile = result
            if sfile = '' then break
            files = files' "'sfile'"'
        end
        address command 'tools:graphics/Picticon/Picticon ADDICON=YES CHUNKYMODE=YES FREE_ICON_POS=YES NEWICON=YES OVERWRITE=YES QUIET=YES TEMPLATE_ICON=tools:graphics/Picticon/envsys/def_picture'files
    end

/* Execute selected files */

    when index(comm,'EXECUTE') = 1 then do
        do forever
            dirlist ID DIR||ndir
            sfile = result
            if sfile = '' then break
            address command sfile
        end
    end
end

exit

/* procedure to change the source dirlist directory */

changedir:
parse arg name

    dirlist ID DIR||ndir ATTRS Dirlist_Directory
    if result = 0 then dirname = ''
    else dirname = import(d2c(result))

/* if the name is empty then set directory to RAM: */

    if strip(name) = '' then name = 'RAM:'

/* if the name is the currently displayed directory then just reread it */

/*
    if name = dirname then do
        check ID ICN||ndir
        dirlist ID DIR||ndir REREAD ATTRS Dirlist_RejectIcons result
        return
    end
*/

/* if the name is a / then get parent directory */

    if index(name,'/') = 1 then do
        if lastpos('/',dirname) ~= 0 then name = substr(dirname,1,lastpos('/',dirname)-1)
        else name = substr(dirname,1,lastpos(':',dirname))
    end

/* if the name is not a directory then extract directory name */

    if index(statef(name),'DIR') = 0 then do
        if lastpos('/',name) ~= 0 then name = substr(name,1,lastpos('/',name)-1)
        else name = substr(name,1,lastpos(':',name))
    end

/* determine volume name and percentage full */

    vol = substr(name,1,pos(':',name))
    address command 'assign >pipe: exists "'vol'"'
    call open('pipe','pipe:','R')
    line = readln('pipe')
    call close('pipe')
    parse var line vname aname
    aname = strip(aname)
    if index(aname,'[Mounted]') = 1 then vname = vname':'
    else do
        if aname = '' then vname = vol
        else vname = substr(aname,1,lastpos(':',aname))
    end
    address command 'info >pipe: 'vname
    call open('pipe','pipe:','R')
    line = readln('pipe')
    line = readln('pipe')
    line = readln('pipe')
    line = readln('pipe')
    parse var line unit size used free full errs status vname
    do until eof('pipe')
        line = readln('pipe')
    end
    call close('pipe')

    if lastpos('/',name) = length(name) then name = substr(name,1,length(name)-1)

/* set appropriate gadgets with information */

    text ID TXT||ndir LABEL strip(vname)'  'full' full'
    string ID SRC||ndir CONTENT name
    check ID ICN||ndir
    dirlist ID DIR||ndir PATH '"'name'"' ATTRS Dirlist_RejectIcons result
    group ID REG REGISTER LABEL "Directory"
    list ID LST NODUP INSERT STRING name
return

/* procedure to copy, rename, or move files from source to destination */

copyfiles:
parse arg type

dirlist ID DIR||(3-ndir) ATTRS Dirlist_Directory
ddir = import(d2c(result))
if lastpos('/',ddir) ~= length(ddir) then do
    if lastpos(':',ddir) ~= length(ddir) then ddir = ddir'/'
end

do forever

/* find next selected file */

    dirlist ID DIR||ndir
    sfile = result

/* if there is no selected file then reread dirlist and return */

    if sfile = '' then do
        check ID ICN||ndir
        flag = result
        dirlist ID DIR||ndir REREAD ATTRS Dirlist_RejectIcons flag
        dirlist ID DIR||(3-ndir) REREAD ATTRS Dirlist_RejectIcons flag
        return
    end
    if lastpos('/',sfile) ~= 0 then dfile = ddir||substr(sfile,lastpos('/',sfile)+1)
    else dfile = ddir||substr(sfile,lastpos(':',sfile)+1)

/* if the file exists at the destination then put up a requester to allow
the user to decide on the action */

    if exists(dfile) & (type > 0) then do
        request ID MDIR TITLE '" "' GADGETS '"_OK|_ALL|_SKIP|_CANCEL"' '\033bFile already exists!\033n Do you wish to overwrite?'
        select
            when result = 0 then return
            when result = 1 then nop
            when result = 2 then type = 0-type
            when result = 3 then iterate
            otherwise return
        end
    end

    if type < 0 then ctype = 0 - type
    else ctype = type

    call file portname ndir ctype sfile';'dfile
end
return

/* this procedure is used to determine names of files and directories to be
   copied.  It is called recursivily to traverse directory trees. */

nextcopy: procedure
parse arg sname';'dname

sname = strip(sname)
dname = strip(dname)
if sname = '' | dname = '' then return

/* get list of entries in source directory */

slist = showdir(sname,'ALL',';')

if lastpos('/',sname) ~= length(sname) then do
    if lastpos(':',sname) ~= length(sname) then sname = sname'/'
end
if lastpos('/',dname) ~= length(dname) then do
    if lastpos(':',dname) ~= length(dname) then dname = dname'/'
end

/* process each entry */

do while slist ~= ''
    parse var slist sfile';'slist

/* assemble full path names for source and destination files */

    dfile = dname||sfile
    sfile = sname||sfile

/* get file information */

    state = statef(sfile)
    parse var state type size blocks protect s1 s2 s3 .

/* create time numerical stamp */

    sstamp = right(s1,4,'0')||right(s2,4,'0')||right(s3,4,'0')

/* if destination file exists then do the following */

    if exists(dfile) then do

/* if entry is a directory then recursivily call this routine with the
   subdirectory name as the argument */

        if index(type,'DIR') then call nextcopy sfile';'dfile

/* else compare the destination time stamp to the source */

        else do
            state = statef(dfile)
            parse var state type size blocks protect s1 s2 s3 .
            dstamp = right(s1,4,'0')||right(s2,4,'0')||right(s3,4,'0')

/* if the source file is newer then add entry to copy list */

            if sstamp > dstamp then do
                list ID CLST INSERT POS List_Insert_Bottom STRING sfile '->' dfile' [] *'
            end
        end
    end

/* if destination file does not exist then add entry to copy list */

    else do
        if index(type,'DIR') then list ID CLST INSERT POS List_Insert_Bottom STRING sfile '->' dfile' [ALL]'
        else list ID CLST INSERT POS List_Insert_Bottom STRING sfile '->' dfile' []'
    end
end
return

/* this procedure is used to determine names of files and directories to be
   deleted.  It is called recursivily to traverse directory trees. */

nextdel: procedure
parse arg sname';'dname

sname = strip(sname)
dname = strip(dname)
if sname = '' | dname = '' then return

/* get list of entries in destination directory */

dlist = showdir(dname,'ALL',';')

if lastpos('/',sname) ~= length(sname) then do
    if lastpos(':',sname) ~= length(sname) then sname = sname'/'
end
if lastpos('/',dname) ~= length(dname) then do
    if lastpos(':',dname) ~= length(dname) then dname = dname'/'
end

/* process each entry */

do while dlist ~= ''
    parse var dlist dfile';'dlist

/* assemble full path names for source and destination files */

    sfile = sname||dfile
    dfile = dname||dfile

/* get file information */

    state = statef(dfile)
    parse var state type size blocks protect stamp

/* if source file exists then do the following */

    if exists(sfile) then do

/* if entry is a directory then recursivily call this routine with the

   subdirectory name as the argument */
        if index(type,'DIR') then call nextdel sfile';'dfile
    end

/* else add the file or directory to the delete list */

    else do
        if index(type,'DIR') then list ID DLST INSERT POS List_Insert_Bottom STRING dfile' [ALL]'
        else list ID DLST INSERT POS List_Insert_Bottom STRING dfile' []'
    end
end
return

/* if an error occurs then display it */

error:
    if exists('T:err') then do
        call open('err','T:err')
        err = readln('err')
        call close('err')
        address command 'delete T:err quiet'
        request ID MDIR TITLE '" "' GADGETS '"OK"' err
    end
exit
