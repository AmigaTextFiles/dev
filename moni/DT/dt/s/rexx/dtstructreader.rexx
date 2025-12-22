/* Struct-Reader for DT */
/* $VER: 0.6 (23-05-94) */

/* History:
    25-05-94:
        Version 0.4
            First try to construct a reader for the Asm-includes.
    27-05-94:
        Version 0.5
            Not very effective to search trough all dir & files for a Struct,
            I have to generate a XRef-File. Writing.....
    28-05-94:
        Version 0.3 of MakeXRef
        Version 0.6 of StructReader
            Well, I got the XRef-File.
            Its hard to read the assembler-includes, so I try it with the
            C-incs.
    30-05-94
        Version 0.6 of MakeXRef
        Version 1.0 of StructReader
            OK, got the c-incs running, some troubles with enclosed Structs,
            trying, trying, trying......
    02-06-94
        Version 1.0 of MakeXRef
        Version 1.2 of StructReader
            Writing the Sub-Struct routine new......
            Added STRPTR, if forgot it

    05-06-94
        Version 1.0 of MakeXRef
        Version 1.5 of StructReader
            Well, finaly I think it works.
    06-06-94
        Version 1.0 of MakeXRef
        Version 1.6 of StructReader
            Made some improvements, now it`s faster.
            Now you can add a filename on startup to be loaded as reference-file
*/


Parse Arg XRefName

Options Results

DTHere=0
RealHere=0
StartA=1
null=d2c(0)||d2c(0)||d2c(0)||d2c(0)
InvertOn=d2c(27)||'[7m'
ItalicsOn=d2c(27)||'[3m'
InvertOff=d2c(27)||'[27m'
ItalicsOff=d2c(27)||'[23m '
null=d2c(0)||d2c(0)||d2c(0)||d2c(0)
spaces='    '
mystack=1
pcount=0
fcount=0
pnum=0
skhfjg=''
intex=''

    If show('p','DT.1') Then DTHere=1
    RealHere=DTHere

    /* Open console window and initialize variables*/

    IF ~open('console','CON:0/50/640/200/Struct-Reader/CLOSE','W') THEN EXIT 20

    if DTHere=1 then ADDRESS DT.1 

    if XRefName='' then XRefName='ENV:DT/StructRef'

    offen=Open(dirfile,XRefName,'read')

    if offen=0 then Address command "sys:rexxc/rx DTMakeXRefFile"

    CALL Close(dirfile)

    do forever
        DTHere=RealHere
        StartA=1
        spaces='    '
        mystack=1
        raus=0
        CALL Print('')    
        CALL WriteCH('console',InvertOn||ItalicsOn||'Which structure ?'||InvertOff||ItalicsOff)
        li.mystack=ReadLN('console')
        if li.mystack='' then exit
        CALL Print('')    
        mystruct=UPPER(li.mystack) 

        if li.mystack='?' then do
            raus=3
            li.mystack=' '
            CALL Print('StructReader for DT®')
            CALL Print('©1994 by Stefan Guttmann')
            CALL Print('Type '||InvertOn||'?pattern'||InvertOff||' to show all structs that exist in a dir (or file).')
            CALL Print('Type '||InvertOn||'?*'||InvertOff||' to show all structs that exist.')
        end 
        if left(li.mystack,1)='?' then do
            raus=3
            li.mystack=right(li.mystack,length(li.mystack)-1)
    
            offen=Open(dirfile,XRefName,'read')
            if offen=1 Then Do
                aa.mystack=ReadLN(dirfile)
                if ~(aa.mystack='**StructRefs**') Then Exit
                IncDir=ReadLN(dirfile)
                rausraus=0
                printit=0
                printed=0
                aa.mystack=ReadLN(dirfile)
                Do until eof(dirfile)
                    if left(aa.mystack,1)='#' then Do
                        printit=0
                        if index(aa.mystack,li.mystack)>0 then printit=1
                        if li.mystack='*' then printit=1
                        if printit=1 then do
                            CALL Print('')
                            CALL Print('Listing of '||right(aa.mystack,length(aa.mystack)-1))
                        end
                    end
                    if left(aa.mystack,1)='&' then do
                        if printit=1 then do
                            CALL WriteCH('console','    '||right('    '||right(aa.mystack,length(aa.mystack)-1),4)||'   -   ')
                            CALL Print(ReadLN(dirfile))
                        end
                    end
                    aa.mystack=ReadLN(dirfile)
                end
            end
            CALL Close(dirfile)
        end


        if (raus~=2)&(raus~=3) then do

            mystruct=mystruct||','
            do until index(mystruct,',')=0
                my2=left(mystruct,index(mystruct,',')-1)
                mystruct=right(mystruct,length(mystruct)-index(mystruct,','))
    
                qui=SearchName(my2)
                if qui=TRUE then do 
        
                    xx=open(kmf.mystack,file.mystack)
                
                    do t=1 to line
                        a=ReadLN(kmf.mystack)
                    end
        
                    StartAdr=' '
                    
                    if DTHere=1 then do
                        GetEx '?From which Startadress ?'
                        sa=Result
                        CALC sa
                        StartAdr=X2C(Result)
                    end
                    if DTHere=0 then do
                        CALL Print('DebuggerTool® not found, enter address in hex or <enter> for Offsets')
                        CALL WriteCH('console','Address->  0x')
                        sa=ReadLN('console')
                        if sa~='' then do
                            if left(sa,1)='$' then sa=right(sa,length(sa)-1)
                            if left(sa,2)='0x' then sa=right(sa,length(sa)-2)
                            DTHere=1
                            StartAdr=X2C(right('00000000'||sa,8))
                        end
                    end 
        
                    CALL Print('------------- Start of Structure '||struct.mystack||' -------------')
                    CALL Print('')
                    Offset=0
                    aa=ShowStruct(StartAdr)     
                    CALL Print('')
                    CALL Print('-------------  End of Structure '||struct.mystack||'  -------------')
                    call close (kmf.mystack)
                end
            end
            if qui=FALSE then raus=2
        end
        if raus=2 then CALL Print('Sorry, unknown structure')
    end



ShowStruct:

    Parse Arg StartA
    raus.mystack=0

    do until raus.mystack=1
        li.mystack=ReadLN(kmf.mystack)
        li.mystack=StripAll(li.mystack)

        if index(li.mystack,'}')>0 then leave

        if(upper(left(li.mystack,4))='VOID') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA,0,'V ')
                li.mystack='s'
            end
        end
        if(upper(left(li.mystack,4))='BYTE') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-4)
                a=StripIt(a)
                CALL ShowLine(a,1,StartA ,0,'B ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,4))='WORD') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-4)
                a=StripIt(a)
                CALL ShowLine(a,2,StartA ,0,'W ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,5))='UWORD') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-5)
                a=StripIt(a)
                CALL ShowLine(a,2,StartA ,0,'W ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,4))='APTR') then do
            a=right(li.mystack,length(li.mystack)-4)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,0,'L ')
        end
        if(upper(left(li.mystack,4))='BPTR') then do
            a=right(li.mystack,length(li.mystack)-4)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,0,'L ')
        end
        if(upper(left(li.mystack,4))='BSTR') then do
            a=right(li.mystack,length(li.mystack)-4)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,0,'L ')
        end
        if(upper(left(li.mystack,4))='LONG') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-4)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA,1,'L ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,5))='ULONG') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-5)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA,0,'L ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,3))='TAG') then do
            a=right(li.mystack,length(li.mystack)-3)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,0,'L ')
        end
        if(upper(left(li.mystack,5))='FIXED') then do
            a=right(li.mystack,length(li.mystack)-5)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,0,'L ')
        end
        if(upper(left(li.mystack,5))='UBYTE') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,import(right(null||StartA,4),4) ,2,'T ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-5)
                a=StripIt(a)
                CALL ShowLine(a,1,StartA,0,'B ')
            li.mystack='s'
            end
        end
        if(upper(left(li.mystack,5))='RPTR') then do
            a=right(li.mystack,length(li.mystack)-5)
            a=StripIt(a)
            CALL ShowLine(a,2,StartA,0,'W ')
        end
        if(upper(left(li.mystack,3))='INT') then do
            a=right(li.mystack,length(li.mystack)-3)
            a=StripIt(a)
            CALL ShowLine(a,2,StartA,0,'W ')
        end
        if(upper(left(li.mystack,5))='SHORT') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-5)
                a=StripIt(a)
                CALL ShowLine(a,2,StartA,1,'W ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,6))='USHORT') then do
            li.mystack=StripIt(li.mystack)
            if index(li.mystack,'*')>0 then do
                a=right(li.mystack,length(li.mystack)-index(li.mystack,'*')+1)
                a=StripIt(a)
                CALL ShowLine(a,4,StartA ,0,'L ')
            end
            else do
                a=right(li.mystack,length(li.mystack)-6)
                a=StripIt(a)
                CALL ShowLine(a,2,StartA,0,'W ')
            end
            li.mystack='s'
        end
        if(upper(left(li.mystack,5))='FLOAT') then do
            a=right(li.mystack,length(li.mystack)-5)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,0,'L ')
        end
        if(upper(left(li.mystack,6))='DOUBLE') then do
            a=right(li.mystack,length(li.mystack)-6)
            a=StripIt(a)
            CALL ShowLine(a,8,StartA,0,'D ')
        end
        if(upper(left(li.mystack,4))='BOOL') then do
            a=right(li.mystack,length(li.mystack)-4)
            a=StripIt(a)
            CALL ShowLine(a,1,StartA,3,'B ')
        end
        if(upper(left(li.mystack,4))='TEXT') then do
            a=right(li.mystack,length(li.mystack)-4)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,2,'T ')
        end
        if(upper(left(li.mystack,4))='CHAR') then do
            a=right(li.mystack,length(li.mystack)-4)
            a=StripIt(a)
            CALL ShowLine(a,4,StartA,2,'T ')
        end
        if(upper(left(li.mystack,6))='STRPTR') then do
            a=right(li.mystack,length(li.mystack)-6)
            a=StripIt(a)
            CALL ShowLine(a,4,import(right(null||StartA,4),4),2,'T ')
        end



        if(upper(left(li.mystack,6))='STRUCT') then do

            mystack2=mystack
            li.mystack=right(li.mystack,length(li.mystack)-7) /* 'bltnode *blthd,*blttl;' */
            li.mystack=stripit(li.mystack)

            if index(li.mystack,d2c(9))>0 then do
                typ.mystack2=left(li.mystack,index(li.mystack,d2c(9))-1)
                names.mystack=right(li.mystack,length(li.mystack)-index(li.mystack,d2c(9)))||','
            end
            else do
                typ.mystack2=left(li.mystack,index(li.mystack,' ')-1)   /* typ.mystack2 = 'bltnode' */
                names.mystack=right(li.mystack,length(li.mystack)-index(li.mystack,' '))||',' /* names.mystack= '*blthd,*blttl,'*/
            end

            do until index(names.mystack,',')=0
                sname.mystack=stripall(left(names.mystack,index(names.mystack,',')-1))
                names.mystack=right(names.mystack,length(names.mystack)-index(names.mystack,','))
            
                q=0
                r=1
                rausq.mystack2=0
                rausi=0
                if index(sname.mystack,'*')>0 then rausq.mystack2=2
            
                if rausq.mystack2~=2 then do
                    mystack=mystack+1
                    ra=SearchName(typ.mystack2)
                    if ra=TRUE then do
                        xx=0
                        offen=Open(kmf.mystack,file.mystack,'read')
                        if offen~=0 then do
                            t=0
                            do until t=line
                                t=t+1
                                a=ReadLN(kmf.mystack)
                            end
                            kjdszgfh=StripIt(sname.mystack2)
            
                            CALL Print(d2c(27)||'[33m'||spaces||'  --->'||kjdszgfh||d2c(27)||'[39m')
                            spaces=spaces||'    '
            
                            aa=ShowStruct(StartA)
            
                            spaces=left(spaces,length(spaces)-4)
                            call close (kmf.mystack)
                            CALL Print(d2c(27)||'[33m'||spaces||'  <---'||struct.mystack||d2c(27)||'[39m')
                        end
                    end
                    mystack=mystack-1
                    mystack2=mystack2-1
                end
                else do
                    if DTHere=1 then do
                        msahg=c2x(IMPORT(right(null||StartA,4),4))
                        b='S Struct->'||sname.mystack||left('-----------------------',23-length(sname.mystack))||' $'||msahg
                        CALL Print(d2c(27)||'[32m'||spaces||'$'||c2x(right(null||d2c(Offset),2))||'  '||b||d2c(27)||'[39m')
                        Offset=Offset+4
                        StartA=d2c(c2d(StartA)+4)
                    end
                    if DTHere=0 then do
                        b='S Struct->'||sname.mystack
                        CALL Print(d2c(27)||'[32m'||spaces||'$'||c2x(right(null||d2c(Offset),2))||'  '||b||d2c(27)||'[39m')
                        Offset=Offset+4
                    end
                end
            end
        end
    end
return(raus.mystack)




ShowLine:
    Parse arg lin,lngt,adre,signed,txet

    if DTHere=1 then do

        lin=','||lin
        do until index(lin,',')=0
            lin=right(lin,length(lin)-index(lin,','))
            lia=lin
            if index(lin,',')>0 then lia=left(lin,index(lin,',')-1)
            lia=StripAll(lia)
            y=0
            if index(lin,'[')>0 then do
                b=right(lin,length(lin)-index(lin,'['))
                b=left(b,index(b,']')-1)
                y=CalcIt(b)
            end
            la=0
            if y>0 then la=((y*lngt)-lngt)
            msahg='$'||c2x(IMPORT(right(null||adre,4),lngt+la))
            if signed=2 then do
                    if c2d(adre)~=0 then do
                        msahg="'"||IMPORT(right(null||adre,4),40)||"...'"
                        if index(msahg,d2c(0))>0 then msahg=left(msahg,index(msahg,d2c(0))-1)||"'"
                        intex=msahg
                    end
                    if c2d(adre)=0 then msahg="NULL"
            end
            if signed=3 then do
                msahg=IMPORT(right(null||adre,4),1)
        		if c2d(msahg)=0 then msahg='FALSE ($'||c2x(msahg)||')'
		        if c2d(msahg)~=0 then msahg='TRUE ($'||c2x(msahg)||')'
                lngt=1
            end
            skhfjg=spaces||'$'||c2x(right(null||d2c(Offset),2))||'  '||txet||lia||" "||left('------------------------------',30-length(lia))||' '||msahg

            CALL Print(skhfjg)
            adre=d2c(c2d(adre)+lngt)
            x=0
            y=y-1
            if y>0 then x=y*lngt
            Offset=Offset+lngt+x

            StartA=d2c(c2d(StartA)+lngt+x)
        end


    end
    if DTHere=0 then do
        lin=','||lin
        do until index(lin,',')=0
            lin=right(lin,length(lin)-index(lin,','))
            lia=lin
            if index(lin,',')>0 then lia=left(lin,index(lin,',')-1)
            lia=StripAll(lia)
            y=0
            if index(lin,'[')>0 then do
                b=right(lin,length(lin)-index(lin,'['))
                b=left(b,index(b,']')-1)
                y=CalcIt(b)
            end
            la=0
            if y>0 then la=((y*lngt)-lngt)
            skhfjg=spaces||'$'||c2x(right(null||d2c(Offset),2))||'  '||txet||lia
            CALL Print(skhfjg)
            x=0
            y=y-1
            if y>0 then x=y*lngt
            Offset=Offset+lngt+x

        end
    end
return

StripAll:
    Parse arg stripvar
    stripvar=strip(stripvar)
    DO while left(stripvar,1)=d2c(9)
        stripvar=right(stripvar,Length(stripvar)-1)
    end
    DO while right(stripvar,1)=d2c(9)
         stripvar=left(stripvar,Length(stripvar)-1)
    end
    stripvar=strip(stripvar)
return(stripvar)

StripIt:
    Parse Arg lin
    if index(lin,'/*')>0 Then Do
        lin=left(lin,index(lin,'/*')-1)
        lin=StripAll(lin)
    end 
    if index(lin,';')>0 Then Do
        lin=left(lin,index(lin,';')-1)
        lin=StripAll(lin)
    end 
return(lin)

Extract:
    Parse Arg lin
    do while index(lin,d2c(9))~=0
        a=left(lin,index(lin,d2c(9))-1)
        b=right(lin,length(lin)-(index(lin,d2c(9))))
        lin=a||'    '||b
    end
return(lin)

CalcIt:
    Parse Arg cal
    xx=length(cal)
    ca=1
    x=0
    do while xx>0
        a=right(cal,1)
        cal=left(cal,xx-1)
        y=c2d(a)-48
        x=x+(y*ca)
        xx=xx-1
        ca=ca*10
    end
return(x)

SearchName:
    Parse Arg StructName

    if index(StructName,' ')>0 then StructName=left(StructName,index(StructName,' ')-1)
    if index(StructName,',')>0 then StructName=right(StructName,length(StructName)-1)
    if index(StructName,d2c(9))>0 then StructName=left(StructName,index(StructName,d2c(9))-1)
    offen=Open(dirfile,XRefName,'read')
    re=FALSE
    if offen=1 Then Do
        li.mystack=ReadLN(dirfile)
        if ~(li.mystack='**StructRefs**') Then Exit
        IncDir=ReadLN(dirfile)
        rausraus=0
        li.mystack=ReadLN(dirfile)
        Do until eof(dirfile)
            Do until rausraus~=0
                if left(li.mystack,1)='#' then Do
                    pathname=right(li.mystack,length(li.mystack)-1)
                end
                if left(li.mystack,1)='&' then do
                    filepos=right(li.mystack,length(li.mystack)-1)
                    li.mystack=ReadLN(dirfile)
                    if upper(StructName)=upper(li.mystack) then rausraus=1
                end
                li.mystack=ReadLN(dirfile)
                if length(li.mystack)=0 then rausraus=2
            end
            axa=SEEK(dirfile,0,E)
            li.mystack=ReadLN(dirfile)
        end
    end
    CALL Close(dirfile)
    file.mystack=pathname
    struct.mystack=StructName
    line=filepos
    if rausraus=1 then re=TRUE
return(re)

Print:
    Parse Arg prin
    CALL WriteLN('console',prin)
return
