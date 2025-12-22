/* Structure-Maker for Struct-Reader */

OPTIONS RESULTS

fil=0
append=0

IF ~open('console','CON:0/50/640/200/Struct-Maker/CLOSE','W') THEN EXIT 20

CALL WriteLN('console','Welcome to Struct-Maker V1.0')
CALL WriteLN('console','Before using Struct-Reader for the first time,')
CALL WriteLN('console','you have to create a reference-file of your')
CALL WriteLN('console','C-Includes.')
CALL WriteLN('console','Use > for appending a file or directory to the')
CALL WriteLN('console','existing reference.')
CALL WriteLN('console',' ')

CALL WriteCH('console','Where is your Include-Directory (Enter = INCLUDE:) ?')

incdir=ReadLN('console')

if left(incdir,1)='>' then do
    incdir=right(incdir,length(incdir)-1)
    append=1
end

if incdir='' then incdir='INCLUDE:'

if Open(aa,incdir,'r')=1 then do
    fil=1
    CALL Close(aa)
end

if fil=0 then do

    ADDRESS Command "c:list "||incdir||" pat ~(cli#?|pragm#?) nodates to ram:dirs nohead dirs"

    dirs=Open(dirfile,'ram:dirs','read')

    dircount=0
    li=READLN(dirfile)

    RetName=' '

    do until eof(dirfile)
        dircount=dircount+1
        aa=left(li,index(li,' ')-1)
        dircs.dircount=incdir||aa
        li=READLN(dirfile)
    End

    CALL Close(dirfile)
end

if append=0 then do
    if fil=0 then do
        address command 'c:delete >nil: ram:dirs'

        address command 'c:delete >nil: envarc:dt/structref'
        address command 'c:delete >nil: env:dt/structref'

        dest=Open(destfile,'envarc:dt/StructRef','write')

        WriteLN(destfile,'**StructRefs**')
        WriteLN(destfile,incdir)
    end
    if fil=1 then do
        address command 'c:delete >nil: ram:dirs'

        address command 'c:rename >nil: envarc:dt/structref envarc:dt/StructRef2'
        address command 'c:delete >nil: env:dt/structref'
        address command 'c:delete >nil: envarc:dt/structref'

        dest=Open(destfile,'envarc:dt/StructRef','write')

        WriteLN(destfile,'**StructRefs**')
        WriteLN(destfile,incdir)
    end
end

if append=1 then do
    address command 'c:delete >nil: ram:dirs'
    address command 'c:delete >nil: env:dt/structref'
    dest=Open(destfile,'envarc:dt/StructRef','append')
end

if fil=0 then do
    filecount=0
    do x=1 to dircount

        /* Read in current directory */  

        ADDRESS Command "c:list "||dircs.x||" pat #?.h nodates to ram:files nohead files"

        dirs=Open(dirfile,'ram:files','read')
        li=READLN(dirfile)

        do until eof(dirfile)
            if length(li)>0 Then do
                filecount=filecount+1
                aa=left(li,index(li,' ')-1)
                files.filecount=dircs.x||'/'||aa
                li=READLN(dirfile)
            end
        End
        CALL Close(dirfile)
    end
end

CALL WriteLN('console','Files to parse: '||filecount)
CALL WriteLN('console',' ')

/* Scan each File for a >>STRUCTURE<<-Keyword, then read the Struct */

if fil=1 then do
    filecount=1
    files.1=incdir
end

structcount=0
filco=0

do until filco=filecount
    filco=filco+1
    fisjh=0
    dirs=Open(dirfile,files.filco,'read')
    CALL WriteLN('console',d2c(27)||'M'||x2c('9b')||x2c('4d')||d2c(27)||'M'||x2c('9b')||x2c('4d')||'Files to go: '||filecount-filco)
    CALL WriteLN('console',x2c('9b')||x2c('4d')||'File: '||files.filco)
    if dirs=0 then leave
    li=ReadLN(dirfile)
    li=StripAll(li)
    counter=1
    do until eof(dirfile)
        if length(li)>0 then do
            if index(li,'=')=0 then do
                if LEFT(upper(li),6)='STRUCT' then do
                    if index(upper(li),'{')>0 then ra=1
                    if index(upper(li),'{')=0 then do
                         aa=ReadLN(dirfile)
                         counter=counter+1
                         if index(upper(aa),'{')>0 then ra=1
                    end
                    if ra=1 then do
                        ra=0
                        a=strip(li)
                        a=right(a,length(a)-7)
                        if index(a,'{')>0 then a=left(a,index(a,'{')-1)
                        b=strip(a)
                        b=stripall(b)
                        if length(b)>0 then do
                            if fisjh=0 then WriteLN(destfile,'#'||files.filco)
                            fisjh=1
                            WriteLN(destfile,'&'||counter)
                            CALL Parsetoend;
                            WriteLN(destfile,b)
                        end
                    end
                end
            end
        end
        li=ReadLN(dirfile)
        li=StripAll(li)
        counter=counter+1
    end
    CALL Close(dirfile)
end

CALL Close(destfile)

address command 'c:delete envarc:dt/StructRef2'
address command 'c:delete ram:dirs'
address command 'c:copy envarc:dt/structref env:DT/structref'

exit    


ParseToEnd:
    aa=' '||d2c(9)
    raus=0
    li=ReadLN(dirfile)
    counter=counter+1
    RetName=' '
    do until eof(dirfile)
        a=stripall(li)
        if (index(li,'};')~=0)|(index(li,'} ;')~=0)|(index(li,'}'||d2c(9)||';')~=0) then do
            raus=1
        end
        if raus=1 then leave
        li=ReadLN(dirfile)
        counter=counter+1
    end

Return

StripAll:
    Parse arg stripvar

	do while index(stripvar,'/*')>0 
        stripvar=left(stripvar,index(stripvar,'/*')-1)
    end

    stripvar=strip(stripvar)

    DO while left(stripvar,1)=d2c(9)
        stripvar=right(stripvar,Length(stripvar)-1) 
    end
    DO while right(stripvar,1)=d2c(9)
         stripvar=left(stripvar,Length(stripvar)-1) 
    end
    stripvar=strip(stripvar)

return(stripvar)

