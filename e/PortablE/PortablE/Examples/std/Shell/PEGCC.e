/* PEGCC.e 23.11.2022 by Christopher Steven Handley.
*/
/*
	This program calls PortablE followed by G++, to compile PE code with one command.
	Unless the SingleTargetFile switch is used, each module will be individually compiled.
	(But SingleTargetFile is always enabled when ClassicMode is enabled.)
*/

OPT PREPROCESS
MODULE '*DeleteModuleCache'
MODULE 'std/pShellParameters', 'std/pShell', 'std/cPath', 'std/pTime'
MODULE 'CSH/pFile', 'CSH/pGeneral', 'CSH/pString'

#define ClassicMode

/* Shell arguments definition */
STATIC shellArgs = 'Source/A, TargetDir/K, TargetOS=OS, OptOptimise/S, OptPointer/S, OptAmigaE/S, OptNoPtrToChar/S, NoOptInline/S, NoListOptim/S, RefreshCache/S, NoOptInlineVarargs/S, LeaveTargetFile=LeaveCppFile/S, NoStrip/S, Debug/S, GccOpts/F/K, Run/S, RunUsing=Using/K, RunParams=Params/F/K' #ifndef ClassicMode +
->index:            0         1            2            3              4             5            6                 7              8              9               10                    11                              12         13       14           15     16                17           
                 ', SingleTargetFile/S, OldGCC/S'
->                  18                  19
#endif

CONST DEBUG = FALSE

PROC main() RETURNS ret
	DEF hostSource:ARRAY OF CHAR, source:STRING, sourceName:ARRAY OF CHAR, baseSource:STRING, i
	DEF hostTargetDir:ARRAY OF CHAR, targetDir:STRING
	DEF targetOS:ARRAY OF CHAR
	DEF targetFile:STRING, hostTargetFile:STRING
	DEF parsedModulesList:STRING, hostParsedModulesList:STRING
	DEF    allModulesList:STRING,    hostAllModulesList:STRING
	DEF     exeFile:STRING,     exeFileUnstripped:STRING
	DEF hostExeFile:STRING, hostExeFileUnstripped:STRING
	DEF execute:STRING, binPath:ARRAY OF CHAR, cmdGCC:ARRAY OF CHAR, cmdStrip:ARRAY OF CHAR, peDirectOpts:STRING, peOpts:STRING
	DEF leaveTargetFile:BOOL, noStrip:BOOL, debug:BOOL, run:BOOL, runUsing:ARRAY OF CHAR, runParams:ARRAY OF CHAR, singleTargetFile:BOOL, oldGCC:BOOL, gccOpts:STRING, gccOptsOrig:ARRAY OF CHAR, stripOpts:ARRAY OF CHAR
	DEF temp:STRING, gccMode
	
	IF DEBUG THEN Print('WARNING: DEBUG mode is enabled.\n')
	
	->parse parameters
	IF ParseParams(shellArgs) = FALSE THEN Raise("ARGS")
	hostSource       := GetParam( 0)
	hostTargetDir    := GetParam( 1)
	targetOS         := GetParam( 2) ; IF targetOS = NILA THEN targetOS := pe_TargetOS
	leaveTargetFile  := GetParam(11) <> NILA
	noStrip          := GetParam(12) <> NILA
	debug            := GetParam(13) <> NILA
	gccOptsOrig      := GetParam(14)
	run              := GetParam(15) <> NILA
	runUsing         := GetParam(16)
	runParams        := GetParam(17)
	#ifndef ClassicMode
		singleTargetFile := GetParam(18) <> NILA
		oldGCC           := GetParam(19) <> NILA
		IF StrCmp(targetOS, pe_TargetOS) = FALSE THEN singleTargetFile := TRUE	->as supporting this will need extra work when cross-compiling
	#else
		singleTargetFile := TRUE
		oldGCC           := FALSE
	#endif
	IF gccOptsOrig = NILA        THEN gccOptsOrig := ''
	IF StrCmp(gccOptsOrig, '""') THEN gccOptsOrig := ''		->work-around a quirk of 'std/pShell' that means it adds quote marks for an empty string (which will confuse GCC)
	IF StrCmp(gccOptsOrig, '\'\'') THEN gccOptsOrig := ''	->not sure where single quote marks come from...
	gccOpts := CopyStr(gccOptsOrig)
	
	->handle debug mode
	IF debug
		noStrip := TRUE
		leaveTargetFile := TRUE
		
		IF singleTargetFile OR NOT StrCmp(targetOS, 'MorphOS')
			gccOpts := strAppend(PASS gccOpts, ' -g')
		ENDIF
	ENDIF
	
	->decide GCC mode to use
	IF oldGCC
		gccMode := 2
	ELSE
		gccMode := 0		->supported values: 0,1,2
		IF StrCmp(targetOS, 'Windows') THEN gccMode := 1
		IF StrCmp(targetOS, 'MorphOS') THEN gccMode := 2
	ENDIF
	
	->sanity check arguments
	IF StrLen(hostSource) = 0 THEN Throw("ARGS", 'Source parameter is empty')
	
	->extract base file path (no extension), after converting host file path into a portable one
	source := ImportFilePath(hostSource)
	IF hostTargetDir
		temp := ImportDirPath(hostTargetDir)
	ELSE
		temp := ExtractSubPath(source)
	ENDIF
	targetDir := ExpandPath(temp)		->GCC cannot handle some relative paths (e.g. to parent)
	END temp
	
	sourceName := FindName(source)
	baseSource := StrJoin(targetDir, sourceName)
	IF InStr(FindName(baseSource), '.') <> -1
		->(file name contains an extension) so find & strip extension
		FOR i := EstrLen(baseSource)-1 TO 0 STEP -1; ENDFOR IF baseSource[i] = "."
		SetStr(baseSource, i)
	ENDIF
	
	->generate paths
	targetFile := StrJoin(baseSource, '.cpp')
	hostTargetFile := ExportPath(targetFile)
	
	exeFile := StrJoin(baseSource, IF StrCmp(targetOS, 'Windows') THEN '.exe' ELSE NILA)
	hostExeFile := ExportPath(exeFile)
	
	IF noStrip
		exeFileUnstripped := StrJoin(exeFile)
	ELSE
		exeFileUnstripped := StrJoin(baseSource, '_UNSTRIPPED', IF StrCmp(targetOS, 'Windows') THEN '.exe' ELSE NILA)
	ENDIF
	hostExeFileUnstripped := ExportPath(exeFileUnstripped)
	
	->handle incremental compilation
	IF singleTargetFile = FALSE
		parsedModulesList := StrJoin(baseSource, '_parsed.list')
		   allModulesList := StrJoin(baseSource, '_all.list')
		hostParsedModulesList := ExportPath(parsedModulesList)
		   hostAllModulesList := ExportPath(   allModulesList)
		peOpts := StrJoin(' IndividualTargetModules ListParsedTargetModulesInFile "', hostParsedModulesList, '" ListAllTargetModulesInFile "', hostAllModulesList, '"')
	ENDIF
	
	->delete the files we will create
	IF ExistsPath(targetFile)
		IF NOT DeletePath(targetFile)	->this is required the for exists() check later, since we cannot check PortablE's return code
			Print('ERROR: Failed to delete "\s".\n', hostTargetFile)
			Raise("ERR")
		ENDIF
	ENDIF
	IF ExistsPath(exeFile)
		IF NOT DeletePath(exeFile)		->this is basically optional, but remember to disable the corresponding exists() check too
			Print('ERROR: Failed to delete "\s".\n', hostExeFile)
			Raise("ERR")
		ENDIF
	ENDIF
	
	->call PortablE (which must be in the command path)
	peDirectOpts := StrJoin(GetParam(3), ' ', GetParam(4), ' ', GetParam(5), ' ', GetParam(6), ' ', GetParam(7), ' ', GetParam(8), ' ', GetParam(9), ' ', GetParam(10))
	execute := StrJoin('PortablE "', hostSource, '" TargetFile "', hostTargetFile, '" TargetOS=', targetOS, ' ', peDirectOpts, peOpts)
->### TargetFile=" does not work for some reason, at least when target contains a space
	IF DEBUG THEN Print('> \s\n', execute)
	IF ExecuteCommand(execute) = FALSE THEN Throw("EXE", execute)
	IF ExistsPath(targetFile) = FALSE THEN Raise("ERR")
	END execute, peDirectOpts
	Print('\n')
	
	->add GCC options that are the same whether or not cross-compiling
	gccOpts := strAppend(PASS gccOpts, ' -Wno-trigraphs')
	IF StrCmp(targetOS, 'AmigaOS4')
		->prevent deprecation warnings
		gccOpts := strAppend(PASS gccOpts, ' -Wno-deprecated-declarations')
		
		->prevent old SDK from wrongly adding 64KB padding (for paged binaries that AmigaOS4 doesn't need)
		gccOpts := strAppend(PASS gccOpts, ' -N')
		
->	ELSE IF StrCmp(targetOS, 'AmigaOS3')
->	ELSE IF StrCmp(targetOS, 'AROS')
->	ELSE IF StrCmp(targetOS, 'MorphOS')
	ELSE IF StrCmp(targetOS, 'Linux')
		->prevent warnings about (1) printf() format codes like %s not expecting a 'long int' type, and (2) printf() having one too many arguments when Print() only has one parameter due to how Print() is implemented.
		gccOpts := strAppend(PASS gccOpts, ' -Wno-format')
		
->	ELSE IF StrCmp(targetOS, 'Windows')
	ENDIF
	
	->find the GCC & strip command to use
	stripOpts := '-s'
	IF StrCmp(targetOS, pe_TargetOS)
		->(not cross-compiling)
		binPath  := ''
		cmdGCC   := 'g++'
		cmdStrip := 'strip'
		
		IF StrCmp(targetOS, 'AmigaOS4')
			->work-around bug in SDK 54.16 where GCC >= v8 fail to compile C++ code
			IF ExistsPath('SDK:/gcc/ppc-amigaos/bin/6.4.0/ppc-amigaos-c++-6')
				cmdGCC := 'g++-6'
			ENDIF
			
		ELSE IF StrCmp(targetOS, 'Windows')
			IF ExistsPath('C:/MinGW/bin/g++.exe')
				binPath := 'C:\\MinGW\\bin\\'
				cmdGCC  := 'g++ -static-libgcc -static-libstdc++'
				
			ELSE IF ExistsPath('C:/CrossCompiler/AmiDevCpp/bin/g++.exe')
				binPath := 'C:\\CrossCompiler\\AmiDevCpp\\bin\\'
				cmdGCC  := 'g++ -I"C:/CrossCompiler/AmiDevCpp/lib/gcc/mingw32/3.4.2/include" -I"C:/CrossCompiler/AmiDevCpp/include/c++/3.4.2/backward" -I"C:/CrossCompiler/AmiDevCpp/include/c++/3.4.2/mingw32" -I"C:/CrossCompiler/AmiDevCpp/include/c++/3.4.2" -I"C:/CrossCompiler/AmiDevCpp/include" -I"C:/CrossCompiler/AmiDevCpp/" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/msw" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/generic" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/fl" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/gizmos" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/html" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/mmedia" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/net" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/ogl" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/plot" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/protocol" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/stc" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/svg" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/xml" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx/xrc" -I"C:/CrossCompiler/AmiDevCpp/include/common/wx" -I"C:/C" -L"C:/CrossCompiler/AmiDevCpp/lib"'
			ENDIF
			
		ELSE IF StrCmp(targetOS, 'AROS')
			stripOpts := '--strip-unneeded --remove-section=.comment'	->Replace -s with this work-around: https://aros.sourceforge.io/sv/documentation/developers/app-dev/introduction.php
			
		ELSE IF StrCmp(targetOS, 'MorphOS')
			cmdGCC := 'g++ -noixemul -Wno-write-strings'
		ENDIF
		
	ELSE IF StrCmp(pe_TargetOS, 'Linux')
		->(cross-compiling on Linux)
		IF StrCmp(targetOS, 'AmigaOS4')
			binPath  := ''
			gccOpts  := strAppend(PASS gccOpts, ' -lgcc_eh -mcrt=clib2')	->this needs to come AFTER the .cpp file
			cmdGCC   := 'ppc-amigaos-g++'		->OR 'ppc-amigaos-gcc -lstdc++' withOUT -lgcc_eh -mcrt=clib2
			cmdStrip := 'ppc-amigaos-strip'
			
		ELSE IF StrCmp(targetOS, 'AmigaOS3')
			binPath  := ''
			cmdGCC   := 'm68k-amigaos-g++'
			cmdStrip := 'm68k-amigaos-strip'
			
		ELSE IF StrCmp(targetOS, 'Windows')
			binPath  := ''
			cmdGCC   := 'i686-w64-mingw32-g++ -static-libgcc -static-libstdc++'
			cmdStrip := 'i686-w64-mingw32-strip'
			
		ELSE IF StrCmp(targetOS, 'AROS')
			binPath  := ''
			cmdGCC   := 'i386-aros-g++'
			cmdStrip := 'i386-aros-strip'
			stripOpts := '--strip-unneeded --remove-section=.comment'			->Replace -s with this work-around: https://aros.sourceforge.io/sv/documentation/developers/app-dev/introduction.php
			->An alternative work-around:
			->IF noStrip = FALSE THEN gccOpts := strAppend(PASS gccOpts, ' -s')
			->noStrip := TRUE		->So don't use the strip command
			
		ELSE IF StrCmp(targetOS, 'MorphOS')
			binPath  := ''
			cmdGCC   := 'ppc-morphos-g++ -noixemul -Wno-write-strings'
			cmdStrip := 'ppc-morphos-strip'
		ELSE
			Print('Cross-compilation is not supported for "\s".\n', targetOS)
			Raise("ERR")
		ENDIF
	ELSE
		Print('Cross-compilation is not supported on "\s".\n', pe_TargetOS)
		Raise("ERR")
	ENDIF
	
	->call GCC
	IF singleTargetFile
		/* old PEGCC behaviour (compile single C++ file for whole program) */
		execute := StrJoin(binPath, cmdGCC, ' "', hostTargetFile, '" -o "', hostExeFileUnstripped, '" ', gccOpts)		->NOTE: Can reduce AmigaOS4 executable size, but stops programs working on OS4.0, when use: , IF StrCmp(targetOS, 'AmigaOS4') THEN ' -use-dynld' ELSE NILA)
		IF DEBUG THEN Print('> \s\n', execute)
		IF ExecuteCommand(execute) = FALSE THEN Throw("EXE", execute)
		IF ExistsPath(exeFileUnstripped) = FALSE
			IF StrLen(gccOptsOrig) > 0
				Print('NOTE: GCC failed to compile the generated C++ code, so please try using no GccOpts or run DeleteModuleCache.\n')
			ELSE
				Print('NOTE: GCC failed to compile the generated C++ code, so deleting the module cache in case this might help next time...\n')
				DeleteModuleCache(temp := NEW 'PEmodules:/', FALSE) ; END temp		->clear module cache, incase of a bug causing modules compiled for different programs to not work together correctly
			ENDIF
			Raise("ERR")
		ENDIF
		END execute
	ELSE
		/* new PEGCC behaviour (incrementally compile each module) */
		incrementallyCompile(binPath, cmdGCC, gccMode, gccOpts, targetFile, exeFileUnstripped, parsedModulesList, allModulesList)
		->DeletePath(parsedModulesList)
		->DeletePath(   allModulesList)
	ENDIF
	
	->call Strip to reduce executable size
	IF noStrip
		IF RenamePath(exeFileUnstripped, exeFile) = FALSE THEN Print('Failed to rename executable.\n')
	ELSE
		IF StrCmp(targetOS, 'Windows')
			IF ExistsPath('C:/MinGW/bin/strip.exe')
				binPath := 'C:\\MinGW\\bin\\'
				
			ELSE IF ExistsPath('C:/CrossCompiler/AmiDevCpp/bin/strip.exe')
				binPath := 'C:\\CrossCompiler\\AmiDevCpp\\bin\\'
			ELSE
				binPath := ''
			ENDIF
		ELSE
			binPath := ''
		ENDIF
		
		execute := StrJoin(binPath, cmdStrip, ' ', stripOpts, ' "', hostExeFileUnstripped, '" -o "', hostExeFile, '"')
		
		IF DEBUG THEN Print('> \s\n', execute)
		IF ExecuteCommand(execute) = FALSE THEN Throw("EXE", execute)
		IF ExistsPath(exeFile) = FALSE
			Print('Failed to strip executable.\n')
			
		ELSE IF DeletePath(exeFileUnstripped) = FALSE
			->(failed to delete unstripped executable, perhaps due to Workbench/etc examining it a little while after it was created) so wait a little while & then try again
			delay(1+1)
			DeletePath(exeFileUnstripped)
		ENDIF
		END execute
	ENDIF
	
	IF leaveTargetFile = FALSE THEN DeletePath(targetFile)
	IF ExistsPath(exeFile)
		Print('Successfully compiled program.\n')
		
		IF run
			IF StrCmp(targetOS, pe_TargetOS) = FALSE
				Print('Cannot run a cross-compiled executable!\n')
			ELSE
				->(not cross-compiling)
				execute := StrJoin(runUsing, IF runUsing THEN ' ' ELSE NILA, '"', hostExeFile, '" ', runParams)
				Print('\n> \s\n', execute)
				ExecuteCommand(execute)
				END execute
			ENDIF
		ENDIF
	ENDIF
FINALLY
	SELECT exception
	CASE 0
		ret := 0
	CASE "ERR"
		->(error already reported) so finish gracefully
		ret := 10
	CASE "ARGS"
		->(error already reported) so finish gracefully
		IF exceptionInfo THEN Print('ERROR:  \s\n', exceptionInfo)
		ret := 10
	CASE "EXE"
		Print('ERROR: Failed to execute \s\n', exceptionInfo)
		ret := 10
	CASE "MEM"
		Print('Ran out of memory\n')
		ret := 20
	DEFAULT
		PrintException()
		ret := 20
	ENDSELECT
	
	IF parsedModulesList THEN IF DEBUG = FALSE THEN DeletePath(parsedModulesList)
	IF    allModulesList THEN IF DEBUG = FALSE THEN DeletePath(   allModulesList)
	
	END source, baseSource
	END targetDir
	END targetFile, hostTargetFile
	END     exeFile,     exeFileUnstripped
	END hostExeFile, hostExeFileUnstripped
	END parsedModulesList, hostParsedModulesList
	END    allModulesList,    hostAllModulesList
	END execute, peOpts, gccOpts
	END temp
ENDPROC

PROC strAppend(base:OWNS STRING, append:ARRAY OF CHAR) RETURNS new:OWNS STRING
	new := StrJoin(base, append)
FINALLY
	END base
ENDPROC

TYPE ARRAY_OF_CHAR IS ARRAY OF CHAR

PROC incrementallyCompile(binPath:ARRAY OF CHAR, cmdGCC:ARRAY OF CHAR, gccMode, gccOpts:STRING, targetFile:STRING, exeFileUnstripped:STRING, parsedModulesListPath:STRING, allModulesListPath:STRING)
	DEF gccOptsOld:STRING, gccOptsChanged:BOOL, gccOptsPath:STRING, gccOptsTime:BIGVALUE
	DEF parsedModulesList:STRING, allModulesList:STRING
	DEF parsedModule:STRING,      allModule:STRING
	DEF objectPath:STRING, same:BOOL, compile:BOOL
	DEF moduleName:STRING, cacheBase:STRING, pemodulesCacheBase:STRING, pos
	DEF hostObjectPath:STRING, execute:STRING
	DEF library:STRING, len, libNode:STRING
	DEF libPath:STRING, hostLibPath:STRING, libList:STRING, libListTail:STRING, temp:STRING
	DEF hostTargetFile:STRING, hostExeFileUnstripped:STRING
	
	->read last-used GccOpts, and update them if the new GccOpts are different
	gccOptsPath := StrJoin('PEmodules:/PE/cache/gccOpts_', pe_TargetOS)
	IF gccOptsOld := readLines(gccOptsPath)
		gccOptsChanged := NOT StrCmp(gccOpts, gccOptsOld)
	ELSE
		->(no file) so object files are in an unknown state
		gccOptsChanged := TRUE
	ENDIF
	IF gccOptsChanged THEN writeLines(gccOptsPath, gccOpts)
	
	->get time-stamp of the stored GccOpts, so that any object files older than it can be recompiled by GCC
	gccOptsTime := getFileTime(gccOptsPath)
	
	->paths required for recreating friendly module name
	temp := ExportPath('PEmodules:/PE/cache/')		->handle PortablE's writeOneTargetModule()'s ExportPath() expanding the path on Windows but not on the Amiga
	cacheBase := ImportDirPath(temp) ; END temp
	pemodulesCacheBase := StrJoin(cacheBase, 'PEmodules/')
	
	->read files
	parsedModulesList := readLines(parsedModulesListPath) ; IF DEBUG = FALSE THEN DeletePath(parsedModulesListPath)
	   allModulesList := readLines(   allModulesListPath) ; IF DEBUG = FALSE THEN DeletePath(   allModulesListPath)
	
	->loop through all modules, compiling parsed modules, AND those missing their object file, AND those older than gccOptsTime
	parsedModule := parsedModulesList
	   allModule :=    allModulesList
	REPEAT
		->make path of module's object file
		objectPath := ImportFilePath(allModule)

		SetStr( objectPath, EstrLen(objectPath) - StrLen('.cpp'))
		StrAdd( objectPath, '.o')
		
		->check if module needs to be (re)compiled
		same := IF parsedModule THEN StrCmp(allModule, parsedModule) ELSE FALSE
		IF same
			compile := TRUE
			
		ELSE IF ExistsPath(objectPath) = FALSE
			compile := TRUE
			
		ELSE IF getFileTime(objectPath) < gccOptsTime
			compile := TRUE
		ELSE
			compile := FALSE
		ENDIF
		
		->compile module
		IF compile
			->report compiling using friendly module name
			IF StrCmpPath(objectPath, pemodulesCacheBase, EstrLen(pemodulesCacheBase))
				->(object is in PEmodules part of cache) so it's module name is just it's path relative to that
				NEW moduleName[EstrLen(objectPath) - EstrLen(pemodulesCacheBase)]
				StrCopy(moduleName, objectPath, ALL, EstrLen(pemodulesCacheBase))
				SetStr(moduleName, EstrLen(moduleName) - StrLen('_CPP_') - StrLen(pe_TargetOS) - StrLen('.o'))
				
			ELSE IF StrCmpPath(objectPath, cacheBase, EstrLen(cacheBase))
				->(object is another part of cache) so it's module name is it's relative path to that, but with a colon after volume
				pos := InStr(objectPath, '/', EstrLen(cacheBase))
				IF pos >= 0
					pos := pos - EstrLen(cacheBase)
					IF pos <= 0 THEN Throw("BUG", 'incrementallyCompile(); pos<=0 for cacheBase')
					NEW moduleName[EstrLen(objectPath) - EstrLen(cacheBase) + 1]
					StrCopy(moduleName, objectPath, pos, EstrLen(cacheBase))
					StrAdd( moduleName, ':')
					StrAdd(moduleName, objectPath, ALL, EstrLen(cacheBase) + pos)
					SetStr(moduleName, EstrLen(moduleName) - StrLen('_CPP_') - StrLen(pe_TargetOS) - StrLen('.o'))
				ELSE
					->(not volume so this must be 'tempUncachedHeader' or another special module) so don't report it
				ENDIF
			ELSE
				Throw("BUG", 'incrementallyCompile(); unrecognised objectPath')
			ENDIF
			
			IF moduleName THEN Print('Compiling module \'\s\'.\n', moduleName)
			
			->compile target file
			hostObjectPath := ExportPath(objectPath)
			
			IF ExistsPath(objectPath)
				IF NOT DeletePath(objectPath)
					Print('ERROR: Failed to delete "\s".\n', hostObjectPath)
					Raise("ERR")
				ENDIF
			ENDIF
			
			execute := StrJoin(binPath, cmdGCC, ' -c "', allModule, '" -o "', hostObjectPath, '" ', gccOpts)
			IF DEBUG THEN Print('> \s\n\n', execute)
			IF ExecuteCommand(execute) = FALSE THEN Throw("EXE", execute)
			IF ExistsPath(objectPath) = FALSE THEN Raise("ERR")
			END execute, hostObjectPath, moduleName
		ENDIF
		END objectPath
		
		->move to next module
		allModule := Next(allModule)                    ; IF    allModule THEN IF EstrLen(   allModule) = 0 THEN    allModule := NILS	->handle empty line at end of file
		IF same THEN parsedModule := Next(parsedModule) ; IF parsedModule THEN IF EstrLen(parsedModule) = 0 THEN parsedModule := NILS	->ditto
	UNTIL allModule = NILS
	
	->make a 'library' listing all the object files to be used
	NEW libPath[EstrLen(targetFile) - StrLen('.cpp') + StrLen('_o.list')]
	StrCopy(libPath, targetFile, EstrLen(targetFile) - StrLen('.cpp'))
	IF gccMode = 0
		StrAdd(libPath, '_o.list')
		
	ELSE IF gccMode = 2
		StrAdd(libPath, '.a')
		DeletePath(libPath)
	ENDIF
	
	hostLibPath := ExportPath(libPath)
	
	->loop through all modules, listing them in a temporary 'library' (or a temporary real library if gccMode=2)
	libList     := NILS
	libListTail := NILS
	allModule := allModulesList
	REPEAT
		->make path of module's object file
		hostObjectPath := StrJoin('"', allModule)
		SetStr(hostObjectPath, EstrLen(hostObjectPath) - StrLen('.cpp'))
		StrAdd(hostObjectPath, '.o"')
		
		IF gccMode = 0
			->escape any backslashes (as seen in Windows paths)
			IF InStr(hostObjectPath, '\\') <> -1
				temp := translateStr(hostObjectPath, ['\\', '\\\\', NILA]:ARRAY_OF_CHAR)
				END hostObjectPath
				hostObjectPath := PASS temp
			ENDIF
		ENDIF
		
		IF (gccMode = 0) OR (gccMode = 1)
			->add module's object file to library
			IF libListTail = NILS
				libListTail := hostObjectPath
				libList     := PASS hostObjectPath
			ELSE
				temp := hostObjectPath
				Link(libListTail, PASS hostObjectPath)
				libListTail := temp
			ENDIF
			END hostObjectPath
			
		ELSE IF gccMode = 2
			->add module's object file to library
			execute := StrJoin(binPath, 'ar cq "', hostLibPath, '" ', hostObjectPath)
			IF DEBUG THEN Print('> \s\n', execute)
			IF ExecuteCommand(execute) = FALSE THEN Throw("EXE", execute)
			END execute, hostObjectPath
		ENDIF
		
		->move to next module
		allModule := Next(allModule) ; IF allModule THEN IF EstrLen(allModule) = 0 THEN allModule := NILS	->handle empty line at end of file
	UNTIL allModule = NILS
	
	IF gccMode = 0
		IF writeLines(libPath, libList)= FALSE
			Print('ERROR: Failed to write "\s".\n', hostLibPath)
			Raise("ERR")
		ENDIF
		END libList
		library := StrJoin('"@', hostLibPath, '"')
		
	ELSE IF gccMode = 1
		->find size required to concatenate all object parameters
		len := 0
		libNode := libList
		WHILE libNode
			len := len + 1 + EstrLen(libNode)
			libNode := Next(libNode)
		ENDWHILE
		
		->perform concatenation
		NEW library[len]
		libNode := libList
		WHILE libNode
			IF libNode <> libList THEN StrAdd(library, ' ')
			StrAdd(library, libNode)
			libNode := Next(libNode)
		ENDWHILE
		
	ELSE IF gccMode = 2
		library := StrJoin('"', hostLibPath, '"')
	ENDIF
	
	->finally compile main program
	hostTargetFile        := ExportPath(targetFile)
	hostExeFileUnstripped := ExportPath(exeFileUnstripped)
	
	execute := StrJoin(binPath, cmdGCC, ' "', hostTargetFile, '" ', library, ' -o "', hostExeFileUnstripped, '" ', gccOpts)
	IF DEBUG THEN Print('> \s\n', execute)
	IF ExecuteCommand(execute) = FALSE THEN Throw("EXE", execute)
	IF ExistsPath(exeFileUnstripped) = FALSE
		DeleteModuleCache(temp := NEW 'PEmodules:/', FALSE) ; END temp		->clear module cache, incase of a bug causing modules compiled for different programs to not work together correctly
		DeletePath(gccOptsPath)		->invalidate object files, incase they are corrupt (perhaps due to changing GCC version)
		Raise("ERR")
	ENDIF
	END execute
	
	DeletePath(libPath)
FINALLY
	END gccOptsOld, gccOptsPath
	END parsedModulesList, allModulesList
	END objectPath
	END moduleName, cacheBase, pemodulesCacheBase
	END hostObjectPath, execute
	END library, libNode
	END libPath, hostLibPath, libList
	END hostTargetFile, hostExeFileUnstripped
ENDPROC

PROC getFileTime(filePath:ARRAY OF CHAR) RETURNS time:BIGVALUE
	DEF file:OWNS PTR TO cHostFile
	
	time := 0
	
	NEW file.new()
	IF file.open(filePath, /*readOnly*/ TRUE)
		time := file.getTime()
		file.close()
	ENDIF
FINALLY
	END file
ENDPROC

->a portable but nasty & approximate way to wait (busy waiting)
->NOTE: 'std/pTime' needs to implement a proper delay function.
PROC delay(timeInSecs)
	DEF start:BIGVALUE
	start := CurrentTime(/*zone0local1utc2quick*/ 2)
	WHILE CurrentTime(/*zone0local1utc2quick*/ 2) < (start + timeInSecs) DO EMPTY
ENDPROC
