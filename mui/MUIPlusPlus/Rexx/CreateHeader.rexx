/* Creates C++ header form inheritance file and muidefs files */

/* The following settings adjust the output of the header file */

parse arg outputDir

headerName = outputDir'MUI.hpp'         /* Name of file generated */
libName = outputDir'MUI.cpp'            /* Link lib source file name */
linkLibName = outputDir'libMUIPlusPlus.a'
inlinesFileName = 't:inline'
obsoleteDeclarationsFileName = 't:ObsoleteDeclarations'
obsoleteInlinesFileName = 't:ObsoleteInlines'
debugName = 'MUIPP_DEBUG'               /* #define needed to turn on debugging */
obsoleteName = 'MUI_OBSOLETE'           /* #define needed to include
                                           obsolete methods and attributes */
inlineName = 'MUIPP_NOINLINES'          /* #define needed to not make methods
                                           and attributes inline */
classPrefix = 'CMUI_'                   /* Prefix before each class name */
startVarArgs = 'StartVarArgs'           /* Class name for first argument of
                                           a variable arguments method */
tab = '09'x
nl = '0a'x             /* New line character */
indent = tab           /* Character used for indenting */
commentLineLength = 74 /* Set this to the width of comment before each class */

startCommentline = '/*'
endCommentLine = ''
do i = 1 to commentlinelength
    startCommentline = startCommentline'*'
    endCommentLine = endCommentLine'*'
end
endCommentLine = endCommentLine'*/'

if ~open(inheritance,"inheritance",'read') then do
    call Error("Could not open inheritance file")
end

if ~open(output,headerName,'write') then do
    call Error("Could not create header file: "headerName)
end

if ~open(lib,libName,'write') then do
    call Error("Could not create library source file: "libName)
end

if ~open(inlinesFile,inlinesFileName,'write') then do
    call Error("Could not create temporary inline file: "inlinesFileName)
end

if ~open(obsoleteInlinesFile,obsoleteInlinesFileName,'write') then do
    call Error("Could not create temporary obsolete inline file: "obsoleteinlinesFileName)
end

headerEnd = ''

call AppendFile(lib,"LibStart")

/* Scan Inheritance file and create class definitions */

do while ~eof(inheritance)

    line = readln(inheritance)

    /* Check if line is a command to include another file or comment
       file */

    action = strip(word(line,1))

    if action = 'include' then do
        call AppendFile(output,strip(word(line,2)))
        iterate
    end

    else if action = 'comment' then do
        call AppendFileCommented(output,strip(word(line,2)))
        iterate
    end

    else if action = 'end' then do
        headerEnd = strip(word(line,2))
        iterate
    end

    if action = 'abstract' then do
        line = substr(line,wordindex(line,2))
        abstractClass = 'y'
    end

    else abstractClass = 'n'

    /* Ignore comments */

    if substr(line,1,1) = ';' then iterate

    /* Line is a class name and inheritence list so generate constructors
       and member functions for class */

    className = strip(word(line,1))

    if className = '' then iterate

    cppClassName = classPrefix || className

    /* Get all classes that this inherits from */

    bases.0 = words(line) - 1    /* Number of classes to inherit from */

    do i = 1 to bases.0
        bases.i = strip(word(line,i + 1))
    end

    call writech(stdout,"Writing" cppClassName "class definition...")

    /* Write comment that preceeds each class */

    call writeln(output,startCommentLine)
    call writeln(output,'**'center(cppClassName 'class definition',commentlinelength))
    call writeln(output,endCommentLine || nl)

    call writech(output,"class" cppClassName)

    /* Write the primary class that it inherits from */

    if bases.0 ~= 0 then do
        call writech(output," : public" classPrefix || bases.1)
    end

    call writeln(output,nl"{"nl"public:")

    /* Find out what tags must be specified when constructing the object */

    required.0 = 0

    if exists(className'.required') then do
        if ~open(requiredFile,className'.required','read') then do
            say "Could not open" className".required"
            return
        end

        i = 0

        do while ~eof(requiredFile)
            tagRequired = strip(readln(requiredFile))
            if tagRequired = '' then iterate
            i = i + 1
            required.i = tagRequired
        end

        required.0 = i
        call close(requiredFile)
    end

    /* Write the constructors if not an abstract class */

    if abstractClass = 'n' then do

        /* Constructor that declares a NULL object */

        call writeln(output,indent || cppClassName '(void)')
        if bases.0 ~= 0 then do
            call writeln(output,indent":" classPrefix || bases.1 "()")
        end
        call writeln(output,indent'{')
        call writeln(output,indent'}'nl)

        /* Constructors that use tags. We first check to ensure that some
           tags do exist for this class as the details are held in a
           .muidefs file. If this file does not exist then there are no
           tags for this class defined. The .muidefs file can be generated
           from the autodocs using DocToDef.rexx */

        if exists(className'.muidefs') then do

            /* Constructor that use "struct TagItem *" */

            call writeln(output,indent || cppClassName '(struct TagItem *tags)')

            if bases.0 ~= 0 then do
                call writeln(output,indent":" classPrefix || bases.1 "()")
            end

            call writeln(output,indent'{')

            if required.0 ~= 0 then do
                call writeln(output,"#ifdef "debugName)
                call writech(output,indent || indent'_CheckTagsSpecified ("'cppClassName'", tags')
                do i = 1 to required.0
                    call writech(output, ', 'required.i', "'required.i'"')
                end
                call writeln(output,", TAG_DONE);")
                call writeln(output,"#endif")
            end

            call writeln(output,indent || indent'object = MUI_NewObjectA (MUIC_'className', tags);')

            call writeln(output,"#ifdef "debugName)
            call writeln(output,indent || indent'if (object == NULL)')
            call writeln(output,indent || indent || indent'_MUIPPWarning ("Could not create a 'cppClassName 'object\n");')
            call writeln(output,"#endif")

            call writeln(output,indent'}'nl)

            /* Constructor that uses Tags */

            call writeln(output,indent || cppClassName '(Tag tag1, ...)')

            if bases.0 ~= 0 then do
                call writeln(output,indent":" classPrefix || bases.1 "()")
            end

            call writeln(output,indent'{')

            if required.0 ~= 0 then do
                call writeln(output,"#ifdef "debugName)
                call writech(output,indent || indent'_CheckTagsSpecified ("'cppClassName'", (struct TagItem *)&tag1')
                do i = 1 to required.0
                    call writech(output, ', 'required.i', "'required.i'"')
                end
                call writeln(output,", TAG_DONE);")
                call writeln(output,"#endif")
            end

            call writeln(output,indent || indent'object = MUI_NewObjectA (MUIC_'className', (struct TagItem *)&tag1);')

            call writeln(output,"#ifdef "debugName)
            call writeln(output,indent || indent'if (object == NULL)')
            call writeln(output,indent || indent || indent'_MUIPPWarning ("Could not create a 'cppClassName 'object\n");')
            call writeln(output,"#endif")

            call writeln(output,indent'}'nl)

        end

        /* Constructor that uses a BOOPSI object pointer */

        call writeln(output,indent || cppClassName '(Object * obj)')

        if bases.0 ~= 0 then do
            call writeln(output,indent":" classPrefix || bases.1 "()")
        end

        call writeln(output,indent'{')
        call writeln(output,indent || indent'object = obj;')
        call writeln(output,indent'}'nl)

        /* Constructor that uses MUI_MakeObject */

        call WriteMakeObjectConstructor(className,bases.1)

        /* Overload operator = */

        call writeln(output,indent || cppClassName '& operator = (Object * obj)')
        call writeln(output,indent'{')
        call writeln(output,indent || indent'object = obj;')
        call writeln(output,indent || indent'return *this;')
        call writeln(output,indent'}'nl)

    end

    /* Include other public stuff related to this class if present */

    if exists(className'.public') then do
        call AppendFileIndented(output,className'.public')
    end

    /* Create file to store obsolete declarations for this class */

    if ~open(obsoleteDeclarationsFile,obsoleteDeclarationsFileName,'write') then do
        call Error("Could not create temporary obsolete inline file: "obsoleteDeclarationsFileName)
    end

    obsoleteDeclarationsExist = 'n'

    /* Write attributes and methods for classes this inherits from other
       than the first one */

    do i = 2 to bases.0
        call WriteAttributesAndMethods(className,bases.i)
    end

    /* Write this class's specific attribs. and methods */

    call WriteAttributesAndMethods(className,'')

    call close(obsoleteDeclarationsFile)

    /* Write the obsolete declarations */

    if obsoleteDeclarationsExist = 'y' then do
        call writeln(output,'#ifdef' obsoleteName)
        call AppendFile(output,obsoleteDeclarationsFileName)
        call writeln(output,'#endif /*' obsoleteName '*/')
    end

    if abstractClass = 'y' then do
        writeln(output,'protected:')

        /* Constructor that declares a NULL object */

        call writeln(output,indent || cppClassName '(void)')

        if bases.0 ~= 0 then do
            call writeln(output,indent":" classPrefix || bases.1 "()")
        end

        call writeln(output,indent'{')
        call writeln(output,indent'}'nl)
    end

    call writeln(output,"};"nl)
    call writeln(stdout,"done")
end

/* Add inline function definitions */

call writech(stdout,"Writing inline functions....")
call writeln(output,'#ifndef' inlineName || nl)
call close(inlinesFile)
call close(obsoleteInlinesFile)
call AppendFile(output,inlinesFileName)
call writeln(output,'#ifdef' obsoleteName || nl)
call AppendFile(output,obsoleteInlinesFileName)
call writeln(output,nl'#endif     /* 'obsoleteName'*/')
call writeln(output,nl'#endif     /* 'inlineName' */')
say "done"

/* Add end of header file if one has been specified */

if headerEnd ~= '' then call AppendFile(output,"HeaderEnd")

address command 'delete' inlinesFileName obsoleteInlinesFileName

call close(output)
call close(lib)

say "All completed!"
say "Header file:" headerName
say "Link library source:" libName

exit

/* Display an error message and quit */

Error: PROCEDURE
    parse arg message
    say message
    exit
return

AppendFile: PROCEDURE
    parse arg file , fileName

    if ~open(file2,fileName,'read') then do
        call Error("Could not open file: " fileName)
    end

    do while ~eof(file2)
        call writeln(file,readln(file2))
    end

    call close(file2)
return

AppendFileCommented: PROCEDURE expose startCommentLine endCommentLine
    parse arg file, fileName

    if ~open(file2,fileName,'read') then do
        call Error("Could not open file: " fileName)
    end

    call writeln(file, startCommentLine)

    do while ~eof(file2)
        line = readln(file2)
        if substr(line,1,1) = '*' then call writeln(file,'***'line)
        else call writeln(file,'** 'line)
    end

    call writeln(file, endCommentLine)

    call close(file2)
return

AppendFileIndented: PROCEDURE expose indent
    parse arg file , fileName

    if ~open(file2,fileName,'read') then do
        call Error("Could not open file: " fileName)
    end

    do while ~eof(file2)
        call writeln(file,indent || readln(file2))
    end

    call close(file2)
return


/* This function will create the constructor that uses MUI_MakeObject().
   It will look to see if a file called className.makeobj exists. If it does
   then it will read in the specification from the file and write the
   constructor. */

WriteMakeObjectConstructor: PROCEDURE expose output indent nl classPrefix
    parse arg className , superClassName

    cppClassName = classPrefix || className

    if exists(className'.makeobj') then do

        if ~open(makeObjFile,className'.makeobj','read') then do
            Error "Could not open" className".makeobj"
        end

        /* Get object type */

        objectType = strip(readln(makeObjFile))

        params = readln(makeObjFile)
        i = 0

        do forever
            parse var params firstparam ',' params

           if firstparam = '' then break
           i = i + 1

           names.i = word(firstparam,words(firstparam))
           types.i = left(firstparam,wordindex(firstparam,words(firstparam)) - 1)

           if substr(names.i,1,1) = '*' then do
               names.i = strip(names.i,'l','*')
               types.i = types.i'*'
           end

           names.i = strip(names.i)
           types.i = strip(types.i)
        end

        call close(makeObjFile)

        call writech(output,indent || cppClassName '(')

        do j = 1 to i
            call writech(output,types.j names.j)

            if j ~= i then writech(output,', ')
            else writeln(output,')')
        end

        call writeln(output,indent":" classPrefix || superClassName "()")
        call writeln(output,indent'{')
        call writech(output,indent || indent'object = MUI_MakeObject ('objectType', ')

        do j = 1 to i
            call writech(output,names.j)

            if j ~= i then writech(output,', ')
            else writeln(output,');')
        end

        call writeln(output,indent'}'nl)
    end

return

/* This function writes the attribute access functions and member functions
   for a given class name */

WriteAttributesAndMethods: PROCEDURE expose output indent nl obsoleteName inlinesFile classPrefix obsoleteInlinesFile obsoleteDeclarationsFile obsoleteDeclarationsExist startVarArgs
    parse arg className , superClassName

    getPrefix = ''      /* String used before get attribute method */
    setPrefix = 'Set'   /* String used before set attribute method */

    /* Open muidefs file */

    if superClassName ~= '' then do
        if ~open(defs,superClassName'.muidefs','read') then do
            say "Could not open" superClassName'.muidefs'
            return
        end
    end

    else if ~open(defs,className'.muidefs','read') then do
        say "Could not open" className'.muidefs'
        return
    end

    cppClassName = classPrefix || className

    do while ~eof(defs)
        line = readln(defs)

        /* Write attribute member functions */

        if word(line,1) = 'attribute' then do
            parse var line _ tag name obsolete usage type
            type = strip(type)

            if obsolete = 'O' then do
                fileForDeclarations = obsoleteDeclarationsFile
                fileForInlines = obsoleteInlinesFile
                obsoleteDeclarationsExist = 'y'
            end

            else do
                fileForDeclarations = output
                fileForInlines = inlinesFile
            end

            /* If getable write the get attribute method */

            if substr(usage,3,1) = 'G' then do
                name = getPrefix || name

                call writeln(fileForDeclarations,indent || type name '(void) const;')

                call writeln(fileForInlines,'inline' type cppClassName'::'name '(void) const'nl'{')
                call writeln(fileForInlines,indent "return ("type")GetAttr ("tag");")
                call writeln(fileForInlines,'}'nl)

                call writeln(lib,type cppClassName'::'name '(void) const'nl'{')
                call writeln(lib,indent "return ("type")GetAttr ("tag");")
                call writeln(lib,'}'nl)
            end

            /* If setable write the set attribute method */

            if substr(usage,2,1) = 'S' then do
                name = setPrefix || name

                call writeln(fileForDeclarations,indent || 'void 'name '('type 'value);')

                call writeln(fileForInlines,'inline void' cppClassName'::'name '('type 'value)'nl'{')
                call writeln(fileForInlines,indent "SetAttr ("tag", (ULONG)value);")
                call writeln(fileForInlines,'}'nl)

                call writeln(lib,'void' cppClassName'::'name '('type 'value)'nl'{')
                call writeln(lib,indent "SetAttr ("tag", (ULONG)value);")
                call writeln(lib,'}'nl)
            end
        end

        /* Write member functions (methods) */

        else if word(line,1) = 'method' then do
            parse var line _ tag name obsolete params

            if obsolete = 'O' then do
                fileForDeclarations = obsoleteDeclarationsFile
                fileForInlines = obsoleteInlinesFile
                obsoleteDeclarationsExist = 'y'
            end

            else do
                fileForDeclarations = output
                fileForInlines = inlinesFile
            end

            /* Create array of param types and names */

            i = 0
            variableArgs = 'n'

            do forever
                parse var params firstparam ',' params

                if firstparam = '' then break
                if strip(firstparam) = '/* ... */' then break
                i = i + 1

                names.i = word(firstparam,words(firstparam))
                types.i = left(firstparam,wordindex(firstparam,words(firstparam)) - 1)

                if substr(names.i,1,1) = '*' then do
                    names.i = strip(names.i,'l','*')
                    types.i = types.i'*'
                end

                names.i = strip(names.i)
                types.i = strip(types.i)
            end

            if strip(firstparam) = '/* ... */' then variableArgs = 'y'

            if right(strip(names.i),3) = '[1]' then do
                variableArgs = 'y'
                parse var names.i names.i '[1]'
            end

            paramlist = ''
            arglist = ''

            if i = 0 then paramlist = 'void'

            else do
                do j = 1 to i
                    paramlist = paramlist types.j names.j','
                    arglist = arglist',' names.j
                end

                paramlist = strip(paramlist)
                paramlist = strip(paramlist,'t',',')
            end

            if variableArgs = 'n' then do
                call writeln(fileForDeclarations,indent"ULONG" name '('paramlist');')

                call writeln(fileForInlines,'inline ULONG' cppClassName'::'name '('paramlist')'nl'{')
                call writeln(fileForInlines,indent'return DoMethod ('tag || arglist');')
                call writeln(fileForInlines,'}'nl)

                call writeln(lib,'ULONG' cppClassName'::'name '('paramlist')'nl'{')
                call writeln(lib,indent'return DoMethod ('tag || arglist');')
                call writeln(lib,'}'nl)
            end

            else do
                paramlist = startVarArgs 'sva, 'paramlist', ...'

                call writeln(fileForDeclarations,indent"ULONG" name '('paramlist');')

                call writeln(fileForInlines,'inline ULONG' cppClassName'::'name '('paramlist')'nl'{')
                call writeln(fileForInlines,indent'sva.methodID = 'tag';')
                call writeln(fileForInlines,indent'return DoMethodA ((Msg)&sva);')
                call writeln(fileForInlines,'}'nl)

                call writeln(lib,'ULONG' cppClassName'::'name '('paramlist')'nl'{')
                call writeln(lib,indent'sva.methodID = 'tag';')
                call writeln(lib,indent'return DoMethodA ((Msg)&sva);')
                call writeln(lib,'}'nl)
            end
        end
    end

    call close(defs)

return

