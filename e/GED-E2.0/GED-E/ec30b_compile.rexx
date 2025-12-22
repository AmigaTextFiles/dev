/* $VER: 2.0, ©1994 BURGHARD Eric.                            */

--8<--------- Cut this Speed up RexxMast Processing a little ---------------

   Compile current file using EC3.0 ,EPP1.4d and MAC2E4.0 if it must
   Errors, Warnings, Auto-Revision, Compile to disk,
   Run arguments, EC arguments are handled.
   File notification mechanism to avoid useless compilation
   EC,EPP,Mac2E must be located on EDEVICE:
   EC,EPP,Mac2E are put in RAM: on first use.
   A directory E/ is make in T:

 VARIABLES:
 ----------
   Environnement vars set: (name stand for "your E Source name")
              ENV:ECOpt    : ECompiler args (see EC docs)
              T:E/name.opt : Executable args
              T:E/name.mcf : Macros Files
              T:E/name.mcp : Macros Path

   GED boolean vars set:
              USER1  : Compile to disk
              USER2  : Replace Macros (Mac2E)
              USER3  : Auto-Revision
              USER4  : Warnings

 NOTEZ BIEN:  Errors handling depends on EPP or EC errors output,
 -----------   So you may have to modify this script if you use
               other version than 2.1b|3.0 for EC, 1.4d for EPP,
              and 4.0 for Mac2E.

 BUGS:        Perhaps Not all EPP1.4d are handled.
 -----        Folowing EC errors messages are not handled
                - 'not enought memory while (re-)allocating'
                - 'reference(s) out of 32k: switch to LARGE model'
                - 'reference(s) out of 256k'
                because EC2.1b don't return an error code. So you
                may have an error from this script like, 'can not
                rename ''filename1' as 'filename2'': object not find
                cause EC didn't generate executable file and didn't
                released an error code. So View T:Eerror to know the
                reason of the failure.
              As EC2.1b didn't release DOS warning code, i must
                parse t:Eerror to find them: Currently handled warning
                messages are the ones beginning with 'UNREFERENCED'
                or 'WARNING' in T:Eerror. This could change for another
                version of EC then 2.1b.
              Autorevision processing is space sensitive; check that
                parenthesis are present in string requester of GUI config
                panel; i could normally do it in this script but i can not
                succed. Autorevision force files to be always compiled
                because source are always 'modified'.

---------------------------------------------------------------------------
*/

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY FILE PATH USER1 ANYTEXT'
parse var result name ' ' path ' ' optcdisk ' ' anytext

if (anytext=="TRUE") then do
  if (upper(right(name,2)))='.E' then do
    if right(path,1)~=":" then path=''path'/'
    if ~exists("T:E") then address command 'Makedir T:E'
    oldname=name
    name=left(name,length(name)-2)
    if optcdisk="TRUE" then do
      name=''path''name''
    end
    else name='T:E/'name''
    nameo=name
    'QUERY MODIFY ABAK LINE COLUMN FIND'
    parse var result modify ' ' backup ' ' olne ' ' col ' ' fstr
    exist=exists(name)
    if (optcdisk="TRUE") then do
      'MISC AUTOBAK="TRUE"'
      if modify="TRUE" then 'SAVE ALL NAME 'nameo'.e'
    end
    else do
      'MISC AUTOBAK="FALSE"'
      if (~exist | modify="TRUE") then 'SAVE ALL NAME 'nameo'.e'
    end
    'MISC AUTOBAK="'backup'"'
    if exist then do
      'NOTIFY FILE 'path''oldname' CHECK'
      notify=result
      if rc=5 then do
        'NOTIFY FILE 'path''oldname' START'
        notify=1
      end
    end
    else notify=1
    if (~exist | (exist & (modify="TRUE" | (modify="FALSE" & notify~=0)))) then do
      call Compile
      if ~exist then 'NOTIFY FILE 'path''oldname' START'
    end
    else do
      'REQUEST BODY="File have already been compiled !" BUTTON="ReCompile|Run|Cancel"'
      if result=1 then do
        call Compile
      end
      else if result=2 then do
        cmd=''
        call Execute
      end
    end
    'FIND STRING="'fstr'" FIRST QUIET'
    'GOTO LINE='olne' COLUMN='col''
  end
  else 'REQUEST STATUS=" E Sources names must end with '.e'"'
end
else 'REQUEST STATUS=" Text buffer is empty ?!"'
'UNLOCK'
exit

Compile:
    /* ------------------------ Macros processing ------------------------ */
    load = 0                                /* Bool for right source error pos */
    if right(oldname,6)~="_mac.e" then do     /* Don't compile Mac2E outputs */
      'QUERY USER2'
      if result=="TRUE" then do
        load=1                               /* Bool for right source error pos */
        if ~exists("ram:MAC2E") then address command 'copy EDEVICE:MAC2E RAM:'
        if ~exists("T:E") then address command 'Makedir T:E'
        optname=left(oldname,length(oldname)-2)
        macfile='T:E/'optname'.mcf'
        macpath='T:E/'optname'.mcp'
        if ~exists(macpath) then do
          ok=open(fhandle,macpath,"write")
          ok=writeln(fhandle,"EDEVICE:PreAnalyzedMacroFiles")
          ok=close(fhandle)
        end
        if exists(macfile) then do
          ok=open(fhandle,macfile,"read")
          macname=readln(fhandle)
          ok=close(fhandle)
        end
        else do
          address command 'EDEVICE:RtRequest 'macfile' 'macpath' TITLE="Select macros definitions files" EXIST'
          if rc~=0 then do
            'NAME 'path''oldname''
            'REQUEST STATUS=" You must specifie a macros definitions file !"'
            'UNLOCK'
            exit
          end
          else do
            ok=open(fhandle,macfile,"read")
            macname=readln(fhandle)
            ok=close(fhandle)
          end
        end
        errhdlr=1
        'REQUEST STATUS=" Begining macro remplacement ..."'
        signal on error
        address command 'RAM:Mac2E >T:Eerror 'name'.e 'nameo'_mac.e 'macname''
        signal off error
        'REQUEST STATUS=""'
        name=''nameo'_mac'                    /* Source Name for Next tools */
      end
    end

    /* --------------------- Compilation processing ---------------------- */
    if ~exists("ram:EC30b") then address command 'copy EDEVICE:EC30b RAM:'
    if exists("ENV:ECOpt") then do
      ok=open(readhandle,"ENV:ECOpt","read")
      optec=readln(readhandle)
      ok=close(readhandle)
    end
    else optec=""
    errhdlr = 0                                /* Bool for Error processing */
    'REQUEST STATUS=" Compiling in process ..."'
    signal on error
    address command 'RAM:EC30b >T:Eerror 'optec' 'name''
    signal off error
    if optmodule then ext='.m'
    else ext=''
    if ''name''ext''~=''nameo''ext'' then do                     /* Name of final executable */
      if exists(''nameo''ext'') then address command 'Delete 'nameo''ext' QUIET'
      address command 'Rename 'name''ext' 'nameo''ext' QUIET'
    end
    'REQUEST STATUS=""'

    /* ----------------------- Version processing ------------------------ */
    if (modify==TRUE|notify~=0) then do
      'QUERY USER3'
      if (result==TRUE) then do
        'PING SLOT=0'                               /* save cursor position */
        'MARK HIDE'                                    /* no blocks, please */
        'QUERY FIND VAR SPAT'                          /* remember settings */
        'QUERY USECASE VAR USECASE'
        'FIND STRING="''$VER:" FIRST CASE=TRUE QUIET'  /* search version id */
        if (rc==0) then do                                      /* found ?? */
          'QUERY BUFFER'            /* what is the line we are over now ?  */
          parse var result '$VER: ' vername ' ' version '.' revision ' ('
          revision=revision+1
          if (revision<10) then revision='00'revision''
          else if (revision<100) then revision='0'revision''
          'NEXT'
          'NEXT'
          'DELETE WORD'                   /* delete old revision string */
          'DEL'
          'DELETE WORD'
          'DEL'
          'DELETE WORD'
          'DEL'
          'DELETE WORD'
          'DEL'
          'TEXT T="'version'.'revision' ('date()') "'                  /* insert new into the text */
        end
        else do
          'FIND STRING=main() CASE=TRUE FIRST QUIET'
          if (rc==0) then do
            'FOLD OPEN=TRUE'
            'FIND STRING=ENDPROC CASE=TRUE NEXT'
            'QUERY ABSLINE VAR LNE'
            'DOWN'
            'QUERY ABSLINE'
            if (result==lne) then do
              'GOTO EOL'
              'CR'
            end
            else do
              'FIRST'
              'QUERY WORD'
              if result='/*FEND*/' then do
                'QUERY ABSLINE VAR LNE'
                'DOWN'
                'QUERY ABSLINE'
                if (result==lne) then do
                  'GOTO EOL'
                  'CR'
                end
              end
            end
          end
          else do
            'GOTO BOTTOM'
            'GOTO EOL'
            'CR'
          end
          'QUERY FILE VAR FILE'
          file=left(file,length(file)-2)
          'TEXT T="CHAR ''$VER: 'file' 1.000 ('date()') © BURGHARD Eric | WANABOSO/AGOA''" CR'
          'FOLD ALL OPEN=FALSE'
        end
        'PONG SLOT=0'
        'FIND STRING="'spat'" CASE='usecase''
      end
    end

    /* ------------------- Warning Message processing -------------------- */
    'QUERY USER4'
    if result='TRUE' then do
      ok = open(filehandler,'T:Eerror','Read')
      if ok = 0 then 'REQUEST STATUS=" Could not read E Compiler error output"'
      else do
        reqmsg=''
        do until eof(filehandler)
          line  = readln(filehandler)
          pos=index(line,'UNREFERENCED')
          if pos~=0 then do
            reqmsg=substr(line,pos,length(line)-pos+1)
            do while ~eof(filehandler)
              line=readln(filehandler)
              pos=index(line,'WARNING')
              if pos~=0 then reqmsg=''reqmsg'|'substr(line,pos,length(line)-pos+1)''
            end
          end
          else do
            pos=index(line,'WARNING')
            if pos~=0 then reqmsg=substr(line,pos,length(line)-pos+1)
          end
        end
        if reqmsg~='' then do
           reqmsg=compress(reqmsg,'"')
          'REQUEST TITLE="ECompiler warning message..." BODY="'reqmsg'"'
        end
        ok = close(filehandler)
      end
    end
    cmd='REQUEST BODY="Compilation Done ! Run program ?" BUTTON="_run|_cancel"'

Execute:
    /* ---------------------------- Execute ------------------------------ */
    if optcdisk=='FALSE' then 'NAME NEW 'path''oldname''  /* restore old file name */
    'FIND STRING="OPT MODULE" FIRST QUIET'
    if (rc~=0) then do
      result=1
      if cmd~='' then cmd
      if (result == 1) then do
        'REQUEST STATUS=" 'nameo' is running"'
        if Exists('T:E/'oldname'.opt') then do
          optname=left(oldname,length(oldname)-2)
          ok = open(filehandle,'T:E/'optname'.opt',"read")
          runopt=readln(filehandle)
          ok = close(filehandle)
        end
        else runopt=""
        options failat 100
        address command ''nameo' 'runopt''
        options failat 10
      end
      'REQUEST STATUS=""'
    end
    else 'REQUEST STATUS=" Module correctly generated"'
    return

   /* ---------------------- Errors processing ------------------------ */
error:
  signal off error                              /* Avoid looping problems */
  'REQUEST STATUS=""'
  if optcdisk=='FALSE' then 'NAME NEW 'path''oldname''  /* restore old file name */
  ok = open(filehandler,'T:Eerror','Read')
select

  when errhdlr = 0 then do                          /* EC Error Handler      */
    if ok = 0 then 'REQUEST STATUS=" Could not read E Compiler error output"'
    else do
      linestring=''
      withstring=''
      errorstring=''
      errortext=''
      pointext=''
      line=readln(filehandler)
      do while ~eof(filehandler)
        line = readln(filehandler)
        select
        when index(line,'ERROR:')~=0 then do
         parse var line 'ERROR: ' errorstring
          errorstring=strip(errorstring)
          parse var errorstring left '"' right
        end
        when find(line,'WITH:')~=0 then do
          parse var line 'WITH: ' withstring
          withstring=strip(withstring)
          parse var withstring left '"' right
        end
        when find(line,'LINE ')~=0 then do
          parse var line 'LINE ' errorline ': ' linestring '/*'
          linestring=strip(linestring,L)
          linestring=left(linestring,64)
          linestring=strip(linestring)
          parse var linestring left '"' right
        end
        otherwise nop
        end
      end
      if linestring~='' then errortext=''linestring''
       errpos=index(errortext,'[')
       if errpos~=0 then do
         errortext=delstr(errortext,errpos,8)
         errortext=delstr(errortext,errpos+1,4)
         pointext=copies(' ',errpos)
         pointext=insert('-^-',pointext,errpos-2,3)
       end
      if pointext~='' then errortext=''errortext'|'pointext''
      if errorstring~='' then errortext=''errorstring'...|'errortext''
      if load=1 then 'OPEN NEW NAME="'name'.e"'
      'FOLD OPEN=TRUE ALL'
      'GOTO LINE='errorline''
      errortext=compress(errortext,'"')
      'REQUEST TITLE="ECompiler 3.0b error" BODY="'errortext'"'
    end
  end

  when errhdlr=1 then do                     /* MAC2E Error Handler */
    if ok = 0 then 'REQUEST STATUS=" Could not read Mac2E error output"'
    else do
      do 3                                   /* Jump Mac2E HeadLines     */
        line = readln(filehandler)
      end
      do while ~eof(filehandler)
        line = readln(filehandler)
        if index(line,'...')==0 then do
          parse var line line '!'
          errortext=compress(errortext,'"')
          'REQUEST TITLE="Mac2E 4.0 error" BODY="'line'"'
          ok = close(filehandler)
          'UNLOCK'
          exit
        end
      end
    end
  end

  otherwise nop

end

ok = close(filehandler)
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit


