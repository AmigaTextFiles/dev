/* Install_shared.e
	This contains code shared by all versions of the installer.
*/

OPT PREPROCESS, NATIVE
MODULE 'std/pShell', 'std/cPath', 'CSH/pFileList', 'CSH/pString', 'CSH/pGeneral'
MODULE 'CSH/cMegaList_STRING'
MODULE '*DeleteModuleCache'

#ifdef pe_TargetOS_Windows
	#define pe_TargetOS_POSIX
#endif
#ifdef pe_TargetOS_Linux
	#define pe_TargetOS_POSIX
#endif
#ifndef pe_TargetOS_POSIX
	#define pe_TargetOS_Amiga
#endif

CONST BUFSIZE = 256

DEF testMode=FALSE:BOOL

PROC install()
	DEF newModulesFolder:OWNS STRING, newSettingsPath:OWNS STRING, newExeFolder:OWNS STRING
	DEF simpleMode:BOOL, testModeIgnore:BOOL
	DEF file:OWNS PTR TO cMegaList_STRING, cursor:OWNS PTR TO cMegaCursor_STRING
	DEF yes:BOOL, tempPath:ARRAY OF CHAR, tempString:OWNS STRING, tempString2:OWNS STRING, tempString3:OWNS STRING
	DEF previousExecutables:BOOL, previousPEmodules:BOOL, badPEmodules:BOOL
	DEF prevExeFolder:OWNS STRING, changedExeFolder:BOOL, parentOfModulesFolder:OWNS STRING
	DEF mustBeInCmdPath:ARRAY OF CHAR, line:OWNS STRING
	DEF success:BOOL, successExecutables:BOOL, successPEmodules:BOOL
	
	#ifdef pe_TargetOS_Amiga
		DEF gccIncludePath:ARRAY OF CHAR, srcIncludePath:ARRAY OF CHAR, unarcPath:ARRAY OF CHAR, successIncludes:BOOL
	#endif
	
	Print('Welcome to PortablE\'s basic installer.\n')
	
	->check source folders exist
	IF ExistsPath('Executables/') = FALSE THEN Throw("ERR", 'The source "Executables" folder does not exist')
	IF ExistsPath('PEmodules/')   = FALSE THEN Throw("ERR", 'The source "PEmodules" folder does not exist')
	
	IF ExistsPath('PEmodules/PE/') = FALSE
		testMode := TRUE
		Print('\nWARNING: Test mode enabled!\n\n')
		
		testModeIgnore := getYesNoAnswer('TEST MODE\nDo you want to ignore the existing installation')
	ELSE
		testModeIgnore := FALSE
	ENDIF
	
	->determine location of installation settings
	#ifdef pe_TargetOS_Windows
		IF ExistsPath(tempPath := 'C:/ProgramData/')
		ELSE IF ExistsPath(tempPath := 'C:/Users/All Users/')
		ELSE IF ExistsPath(tempPath := 'C:/Documents and Settings/All Users/')
		ELSE
			tempPath := 'C:/'
		ENDIF
	#endif
	#ifdef pe_TargetOS_Linux
		tempPath := 'HOME:/.config/'
		IF NOT ExistsPath(tempPath) THEN CreateDirs(tempPath)
	#endif
	#ifdef pe_TargetOS_Amiga
		tempPath := 'EnvArc:/'
	#endif
	
	newSettingsPath := StrJoin(tempPath, 'PortablE_Installation')
	
	->read any previous installation settings
	IF file := readLines(newSettingsPath, /*returnNILforNoFile*/ TRUE)
		cursor := file.infoStart().clone()
		newExeFolder := readLine(file, cursor)
		END file, cursor
		
	#ifdef pe_TargetOS_AROS
		IF InvalidDirPath(newExeFolder)
			->work-around Icaros v1.4.0 having a corrupt settings file
			tempString := PASS newExeFolder
			newExeFolder := ImportDirPath(tempString)
			END tempString
		ENDIF
	ENDIF
	IF NOT ExistsPath(newSettingsPath)
		->work around Icaros v1.3.? & earlier missing the installation settings for the pre-installed PortablE
		 IF ExistsPath('PEmodules:/')
		 	newExeFolder := NEW 'Extras:/Development/PortablE/'
		 	IF NOT ExistsPath(newExeFolder) THEN END newExeFolder
		 ENDIF
	#endif
	ENDIF
	
	->ask about Simple mode
	simpleMode := getYesNoAnswer('Do you want to use Simple Installation mode')
	
	->determine sensible default paths
	IF testModeIgnore THEN END newExeFolder
	IF newExeFolder = NILS
		->(no previous installation settings)
		#ifdef pe_TargetOS_Windows
			newExeFolder := NEW 'C:/PortablE/bin/'
		#endif
		#ifdef pe_TargetOS_Linux
			newExeFolder := NEW 'HOME:/.local/bin/'
			IF NOT ExistsPath(newExeFolder) THEN CreateDirs(newExeFolder)
		#endif
		#ifdef pe_TargetOS_Amiga
			newExeFolder := NEW 'C:/'
		#endif
		
		previousExecutables := FALSE
	ELSE
		prevExeFolder := StrJoin(newExeFolder)
		
		previousExecutables := TRUE
	ENDIF
	
	previousPEmodules := ExistsPath('PEmodules:/')
	IF testModeIgnore THEN previousPEmodules := FALSE
	badPEmodules := FALSE
	IF previousPEmodules
		->check for a previous bad installation (as we did not always enforce a PEmodules folder)
		tempString := ExpandPath('PEmodules:/')
		IF StrCmpPath(FindName(tempString), 'PEmodules/') = FALSE
			badPEmodules := TRUE
			showInfo('Your OLD installation did not store modules in a PEmodules folder, so they will be moved.')
		ENDIF
		END tempString
	ENDIF
	IF previousPEmodules
		->extract existing assignment
		newModulesFolder := ExpandPath('PEmodules:/')
	ELSE
		->(no previous installation)
		END newModulesFolder
		#ifdef pe_TargetOS_Windows
			newModulesFolder := NEW 'C:/PortablE/PEmodules/'
		#endif
		#ifdef pe_TargetOS_Linux
			newModulesFolder := NEW 'HOME:/.portable/PEmodules/'
		#endif
		#ifdef pe_TargetOS_Amiga
			IF ExistsPath(tempPath := 'Work:/')
			ELSE IF ExistsPath(tempPath := 'Data:/')
			ELSE IF ExistsPath(tempPath := 'HD1:/')
			ELSE IF ExistsPath(tempPath := 'HD2:/')
			ELSE IF ExistsPath(tempPath := 'HD0:/')
			ELSE IF ExistsPath(tempPath := 'Sys:/')
			ELSE
				tempPath := 'RAM:/'
			ENDIF
			
			newModulesFolder := StrJoin(tempPath, IF simpleMode THEN 'PortablE/' ELSE NILA, 'PEmodules/')
		#endif
	ENDIF
	
	->query user about destination paths
	#ifdef pe_TargetOS_POSIX
		mustBeInCmdPath := ''
	#else
		mustBeInCmdPath := IF simpleMode THEN '' ELSE ' (must be in command path)'
	#endif
	
	parentOfModulesFolder := ExtractSubPath(newModulesFolder)
	IF previousPEmodules = FALSE ->AND NOT badPEmodules
		->(no previous PEmodules installed)
		yes := getYesNoAnswer('Destination for PEmodules folder is "\s".\nIs this destination OK', [tempString := ExportPath(parentOfModulesFolder)]) ; END tempString
		IF NOT yes
			tempString := getFolder('Which folder do you want to put PEmodules in?', parentOfModulesFolder)
			IF tempString = NILS THEN Raise("BRK")
			END parentOfModulesFolder
			parentOfModulesFolder := PASS tempString
		ENDIF
	ELSE
		->(PEmodules already exists)
		IF badPEmodules
			yes := FALSE
			
		ELSE IF simpleMode
			yes := TRUE
		ELSE
			yes := getYesNoAnswer('PEmodules is currently inside folder "\s".\nIs this location OK', [tempString := ExportPath(parentOfModulesFolder)]) ; END tempString
		ENDIF
		
		IF yes = FALSE
			IF badPEmodules = FALSE
				REPEAT
					END tempString
					
					tempString := getFolder('Which folder do you want to move PEmodules to?', parentOfModulesFolder)
					IF tempString = NILS THEN Raise("BRK")
				UNTIL StrCmpPath(tempString, parentOfModulesFolder) = FALSE	->reject the user not changing the folder
			ELSE
				tempString := getFolder('Which folder do you want to put PEmodules in?', newModulesFolder)
				IF tempString = NILS THEN Raise("BRK")
			ENDIF
			END parentOfModulesFolder
			parentOfModulesFolder := PASS tempString
			
			tempString := StrJoin(parentOfModulesFolder, 'PEmodules/')
			yes := getYesNoAnswer('OK to move PEmodules from "\s" to "\s"', [tempString2 := ExportPath(newModulesFolder), tempString3 := ExportPath(tempString)]) ; END tempString2, tempString3
			IF NOT yes THEN Raise("BRK")
			
			Print('Moving modules, please wait...\n')
			IF testMode = FALSE
				DeleteModuleCache(newModulesFolder, FALSE)	->verbose=FALSE
			ELSE
				Print('TEST MODE skipped DeleteModuleCache("\s", \d)\n', newModulesFolder, FALSE)
			ENDIF
			#ifdef pe_TargetOS_Amiga
				->remove existing assignment, so folder can be deleted if necessary
				IF testMode = FALSE
					executeCommand('Assign PEmodules:')
				ELSE
					Print('TEST MODE skipped executeCommand("Assign PEmodules:")\n')
				ENDIF
			#endif
			IF testMode = FALSE
				IF moveDir(tempString, newModulesFolder, /*safe*/ badPEmodules) = FALSE
					showInfo('Moving failed, so aborting installation.\n')
					Raise("BRK")
				ENDIF
				#ifdef pe_TargetOS_AROS
					->work-around Icaros's PEmodules folder assignment not being in S:User-StartUp, such that it will still (briefly) try to assign to the old PEmodules folder & print an error message if it is not there
					createDir(newModulesFolder)
				#endif
			ELSE
				Print('TEST MODE skipped moveDir("\s", "\s", \d)\n', tempString, newModulesFolder, badPEmodules)
			ENDIF
			
			->change assignment
			IF testMode = FALSE
				IF addOrChangeAssignment(tempString) = FALSE
					showInfo('Changing assignment failed, so aborting installation.\n')
					Raise("BRK")
				ENDIF
			ELSE
				Print('TEST MODE skipped addOrChangeAssignment("\s")\n', tempString)
			ENDIF
			END tempString
		ENDIF
	ENDIF
	END newModulesFolder
	newModulesFolder := StrJoin(parentOfModulesFolder, 'PEmodules/')
	
	IF simpleMode = FALSE
		REPEAT
			yes := getYesNoAnswer('Destination for executables is "\s"\s.\nIs this destination folder OK', [tempString := ExportPath(newExeFolder), mustBeInCmdPath]) ; END tempString
			IF NOT yes
				tempString := getFolder('Where should the executables be put?', newExeFolder) ; END newExeFolder
				newExeFolder := PASS tempString
				IF newExeFolder = NILS THEN Raise("BRK")
			ENDIF
		UNTIL yes
	ENDIF
	
	yes := getYesNoAnswer('' + 
		'Your installation choices are:\n' +
		'Destination for modules is "\s".\n' +
		'Destination for executables is "\s"\s.\n' +
		'\n' +
		'Is it OK to proceed with installation', [tempString := ExportPath(newModulesFolder), tempString2 := ExportPath(newExeFolder), mustBeInCmdPath]) ; END tempString, tempString2
	IF NOT yes THEN Raise("BRK")
	
	->record installation settings
	DeletePath(newSettingsPath)
	NEW file.new()
	file.infoPastEnd().beforeInsert(file.makeNode(StrJoin(newExeFolder)))
	writeLines(newSettingsPath, file)
	END file
	
	
	->perform installation
	Print('\n')
	success := TRUE
	
	tempPath := NILA
	#ifdef pe_TargetOS_Windows
		tempPath := 'Executables/Windows/'
	#endif
	#ifdef pe_TargetOS_Linux
		tempPath := 'Executables/Linux/'
	#endif
	#ifdef pe_TargetOS_AmigaOS3
		tempPath := 'Executables/AmigaOS3/'
	#endif
	#ifdef pe_TargetOS_AmigaOS4
		tempPath := 'Executables/AmigaOS4/'
	#endif
	#ifdef pe_TargetOS_AROS
		tempPath := 'Executables/AROS/'
	#endif
	#ifdef pe_TargetOS_MorphOS
		tempPath := 'Executables/MorphOS/'
	#endif
	IF tempPath = NILA THEN Throw("ERR", 'Unknown TargetOS for executables')
	
	Print('Copying executables...\n')
	success := success AND (successExecutables := copyDir(newExeFolder, tempPath))

	IF prevExeFolder
		changedExeFolder := NOT StrCmpPath(prevExeFolder, newExeFolder)
	ELSE
		changedExeFolder := TRUE
	ENDIF
	
	#ifdef pe_TargetOS_POSIX
		success := updateCmdPath(success, successExecutables, changedExeFolder, newExeFolder, prevExeFolder)
	#else
		setFlagsInDir(newExeFolder, FIBF_EXECUTE)
		
		tempString := StrJoin(newExeFolder, 'PE-EC')	->only exists for OS3 & OS4
		setFlagsOnFile(tempString, FIBF_SCRIPT) ; END tempString
	#endif
	
	IF ExistsPath(newModulesFolder)
		Print('Deleting module cache, please wait...\n')
		IF testMode = FALSE
			DeleteModuleCache(newModulesFolder, FALSE)	->verbose=FALSE
		ELSE
			Print('TEST MODE skipped DeleteModuleCache("\s", \d)\n', newModulesFolder, FALSE)
		ENDIF
	ENDIF
	
	Print('Copying PEmodules, please wait...\n')
	success := success AND (successPEmodules := copyDir(newModulesFolder, 'PEmodules/'))
	
	IF previousPEmodules = FALSE
		->(no previous PEmodules installed)
		IF successPEmodules = FALSE
			Print('No PEmodules: assignment was attempted, due to the above PEmodule problems.\n')
			
		ELSE IF testMode
			Print('TEST MODE skipped making a PEmodules: assignment.\n')
		ELSE
			IF addOrChangeAssignment(newModulesFolder) = FALSE THEN success := FALSE
		ENDIF
	ENDIF
	
	->IF previousPEmodules
		Print('Checking for obsolete modules, please wait...\n')
		obsoleteModulesCheck(newModulesFolder, 'PEmodules/')
	->ENDIF
	
	#ifdef pe_TargetOS_Amiga
		->(not Windows or Linux, therefore must be AmigaOS4, OS3, AROS, or MorphOS)
		#ifdef pe_TargetOS_AmigaOS4
			srcIncludePath := 'useful_C_stuff/GCC_includes_AmigaOS4.lha'
			gccIncludePath := 'SDK:'
		#endif
		#ifdef pe_TargetOS_AmigaOS3
			srcIncludePath := 'useful_C_stuff/GCC_includes_AmigaOS3.lha'
			gccIncludePath := 'gg:usr/include'
		#endif
		#ifdef pe_TargetOS_AROS
			srcIncludePath := 'useful_C_stuff/GCC_includes_AROS.lha'
			gccIncludePath := 'Development:C/include'
		#endif
		#ifdef pe_TargetOS_MorphOS
			srcIncludePath := 'useful_C_stuff/GCC_includes_MorphOS.lha'
			gccIncludePath := 'SDK:gg'
		#endif
		
		tempString  := ImportDirPath(gccIncludePath)
		tempString2 := ExtractDevice(tempString)
		IF successIncludes := ExistsPath(tempString2) THEN createDir(tempString)
		END tempString, tempString2
		
		IF successIncludes
			successIncludes := getYesNoAnswer('About to install the necessary C header files to "\s/".\nIs this OK', [gccIncludePath])
			IF successIncludes
				#ifdef pe_TargetOS_AmigaOS4
					IF ExistsPath('Sys:/Utilities/UnArc')
						unarcPath := 'Sys:Utilities/UnArc'
					ELSE
						unarcPath := 'AppDir:UnArc'
					ENDIF
					line := StrJoin(unarcPath, ' ', srcIncludePath,' TO "', gccIncludePath, '" AUTO')
				#endif
				#ifdef pe_TargetOS_AmigaOS3
					unarcPath := 'Executables/LhA_68k'
					line := StrJoin(unarcPath, ' -a -F -n -N x ', srcIncludePath,' "', gccIncludePath, '/"')
				#endif
				#ifdef pe_TargetOS_AROS
					unarcPath := 'LhA'
					line := StrJoin(unarcPath, ' xfw=', gccIncludePath, '/ ', srcIncludePath)
				#endif
				#ifdef pe_TargetOS_MorphOS
					unarcPath := 'LhA'
					line := StrJoin(unarcPath, ' -a -F -n -N x ', srcIncludePath,'  "', gccIncludePath, '/"')
				#endif
				
				IF successIncludes := executeCommand(line)
					Print('Installed the necessary C header files.\n')
				ELSE
					Print('WARNING: Could not install the necessary C header files.\n')
				ENDIF
				END line
			ENDIF
		ELSE
			Print('\nGCC does not seem to be installed, so the necessary C header files could not be installed.\n')
		ENDIF
		
		IF successIncludes = FALSE
			Print('\nNOTE: To install the necessary C header files, you will need to extract "\s" to "\s".\n', srcIncludePath, gccIncludePath)
		ENDIF
	#endif
	
	->ensure Script flag set, whether we copy Examples or leave it to the user
	#ifdef pe_TargetOS_Amiga
		IF setFlagsOnFile(tempPath := 'Examples/Amiga/JasonHulance/JH_5_Recursion.run', FIBF_SCRIPT) = FALSE THEN Print('WARNING: Failed to set Script flag on "\s".\n', tempString := ExportPath(tempPath)) ; END tempString
		->'Examples/Amiga_DEMO/Compile_demo', FIBF_SCRIPT
		->'Examples/Amiga_DEMO/demo_OUTPUT',  FIBF_EXECUTE
	#endif
	
	->offer to copy documentation & examples
	#ifdef pe_TargetOS_Linux
		IF InStr(parentOfModulesFolder, '/.')
			->(folder is hidden) which may prevent Flatpak & Snap web browsers from opening the HTML documentation, etc
			END parentOfModulesFolder
			parentOfModulesFolder := NEW 'HOME:/Documents/PortablE/'
		ENDIF
	#endif
	yes := getYesNoAnswer('Do you want to copy the Docs & Examples folders to "\s"', [tempString := ExportPath(parentOfModulesFolder)]) ; END tempString
	IF yes
		tempString := StrJoin(parentOfModulesFolder, 'Docs/')
		createDir(tempString, /*forceIcon*/ TRUE)
		copyDir(  tempString, 'Docs/' #ifdef pe_TargetOS_POSIX , '.info', TRUE #endif) ; END tempString
		
		tempString := StrJoin(parentOfModulesFolder, 'Examples/')
		/*
		yes := getYesNoAnswer('Do you want to delete any obsolete Examples from the folder "\s"', [tempString2 := ExportPath(parentOfModulesFolder)]) ; END tempString2
		IF yes THEN DeleteDirPath(tempString)
		*/
		createDir(tempString, /*forceIcon*/ TRUE)
		copyDir(  tempString, 'Examples/' #ifdef pe_TargetOS_POSIX , '.info', TRUE #endif) ; END tempString
	ELSE
		Print('\nDon\'t forget to copy "Docs" & "Examples" somewhere!\n')
	ENDIF
	
	->print final line(s) without a blank line at the bottom
	IF success = FALSE
		Print('\nWARNING: Installation was not entirely successful.\nPlease try again.')
	ELSE
		Print('\nInstallation successful!')
	ENDIF
	PrintFlush()
FINALLY
	END newModulesFolder, newSettingsPath, newExeFolder
	END file, cursor, tempString, tempString2, tempString3
	END prevExeFolder, parentOfModulesFolder
	END line
ENDPROC

#ifdef pe_TargetOS_Linux
PROC updateCmdPath(success:BOOL, successExecutables:BOOL, changedExeFolder:BOOL, newExeFolder:STRING, prevExeFolder:NULL STRING)
	DEF hostNewExePath:OWNS STRING, hostPrevExePath:OWNS STRING
	DEF envPathStr:OWNS STRING, envPathList:OWNS PTR TO cMegaList_STRING, cursor:OWNS PTR TO cMegaCursor_STRING
	DEF exportCmd:OWNS STRING, appendCmd:OWNS STRING
	
	hostNewExePath  := ExportPath( newExeFolder)
	hostPrevExePath := ExportPath(prevExeFolder)	-># this is not currently used, but could be used to find & remove the previously-added 'export' line
	
	->read current env path
	envPathStr := readEnvPath()
	
	->parse env path into list, excluding duplicates
	envPathList, cursor := parsePathIntoList(envPathStr)
	
	->check if executable folder is already in the env path
	IF envPathStr
		changedExeFolder := NOT findInEnvPathList(envPathList, cursor, hostNewExePath)
	ELSE
		->(use supplied changedExeFolder as 'best guess')
	ENDIF
	
	IF changedExeFolder
		IF successExecutables = FALSE
			Print('Did not try adding executables folder to command path, due to the above executable problems.\n')
		ELSE
			exportCmd := StrJoin('export PATH="', hostNewExePath, ':$PATH"')
			appendCmd := StrJoin('echo \'', exportCmd, '\' >>~/.bashrc')
			
			IF executeCommand(appendCmd)
				Print('Added executables folder to command path.\n')
				executeCommand(exportCmd)
			ELSE
				success := FALSE
				Print('WARNING: Could not add executables folder to command path.\n')
			ENDIF
		ENDIF
	ENDIF
FINALLY
	END hostNewExePath, hostPrevExePath
	END envPathStr, envPathList, cursor
	END exportCmd, appendCmd
ENDPROC success
#endif
#ifdef pe_TargetOS_Windows
PROC updateCmdPath(success:BOOL, successExecutables:BOOL, changedExeFolder:BOOL, newExeFolder:STRING, prevExeFolder:NULL STRING)
	DEF hostNewExePath:OWNS STRING, hostPrevExePath:OWNS STRING
	DEF line:OWNS STRING, fileList:OWNS PTR TO cMegaList_STRING, envPathStr:OWNS STRING
	DEF envPathList:OWNS PTR TO cMegaList_STRING, cursor:OWNS PTR TO cMegaCursor_STRING, newLen
	DEF setxPath:ARRAY OF CHAR, tempString:OWNS STRING
	
	hostNewExePath  := ExportPath( newExeFolder)
	hostPrevExePath := ExportPath(prevExeFolder)
	
	->read current env path
	envPathStr := readEnvPath()
	
	->parse env path into list, excluding duplicates (which should help keep it below the 1024 character limit of SETX)
	envPathList, cursor, newLen := parsePathIntoList(envPathStr)
	
	->check if executable folder is already in the env path
	IF envPathStr
		changedExeFolder := NOT findInEnvPathList(envPathList, cursor, hostNewExePath)
	ELSE
		->(use supplied changedExeFolder as 'best guess')
	ENDIF
	
	IF changedExeFolder
		IF successExecutables = FALSE
			Print('Did not try adding executables folder to command path, due to the above executable problems.\n')
		ELSE
			->save backup copy of old env path, just in case we screw up
			setxPath := 'BackupOfEnvPath.txt'	->reusing variable
			IF NOT ExistsPath(setxPath)
				IF testMode = FALSE
					NEW fileList.new()
					fileList.infoPastEnd().beforeInsert(fileList.makeNode(StrJoin(envPathStr)))
					writeLines(setxPath, fileList)
					END fileList
				ELSE
					Print('TEST MODE skipped creating "\s".\n', setxPath)
				ENDIF
			ENDIF
			
			->remove old executable path
			IF (envPathStr <> NILS) AND (prevExeFolder <> NILS)
				->remove old executable folder
				IF findInEnvPathList(envPathList, cursor, hostPrevExePath)
					newLen := newLen - EstrLen(cursor.read()) - StrLen(';')
					cursor.destroy()
				ENDIF
			ENDIF
			
			->add new executable path to end
			envPathList.infoPastEnd().beforeInsert(envPathList.makeNode(StrJoin(hostNewExePath)))
			newLen := newLen + EstrLen(hostNewExePath) + StrLen(';')
			
			->recombine modified list into new string
			newLen := newLen - StrLen(';')
			NEW tempString[Max(1,newLen)]
			IF envPathList.infoIsEmpty() = FALSE
				cursor.goto(envPathList.infoStart())
				REPEAT
					StrAdd(tempString, cursor.read())
					StrAdd(tempString, ';')
				UNTIL cursor.next()
			ENDIF
			END envPathStr
			envPathStr := PASS tempString
			
			->update env path
			IF EstrLen(envPathStr) <= 1024
				->(path length is below SETX's 1024 character limitation, so it won't be truncated badly)
				IF ExistsPath('C:/Windows/System32/setx.exe')
					setxPath := 'SETX'
				ELSE
					setxPath := 'Executables\\SETX'
				ENDIF
				line := StrJoin('Executables\\Elevate ', setxPath, ' PATH "', envPathStr, '" /m')
				IF executeCommand(line)
					Print('Added executables folder to command path.\n')
				ELSE
					success := FALSE
					Print('WARNING: Could not add executables folder to command path.\n')
				ENDIF
				END line
				
				->we cannot check to see if env path was updated, as it doesn't affect us :(
			ENDIF
		ENDIF
	ENDIF
FINALLY
	END hostNewExePath, hostPrevExePath
	END line, fileList, envPathStr
	END envPathList, cursor
	END tempString
ENDPROC success
#endif

#ifdef pe_TargetOS_POSIX
PROC findInEnvPathList(envPathList:PTR TO cMegaList_STRING, cursor:PTR TO cMegaCursor_STRING, needle:STRING) RETURNS found:BOOL
	found := FALSE
	IF envPathList.infoIsEmpty() = FALSE
		cursor.goto(envPathList.infoStart())
		REPEAT
			IF StrCmpPath(cursor.read(), needle) THEN RETURN TRUE
		UNTIL cursor.next()
	ENDIF
ENDPROC

PROC getenv(name:ARRAY OF CHAR) IS NATIVE {getenv(} name {)} ENDNATIVE !!ARRAY OF CHAR

->NOTE: Returns NIL if fails to read the env path
PROC readEnvPath() RETURNS envPathStr:OWNS STRING IS CopyStr(getenv('PATH'))	->PATH needed for Linux, but it also works on Windows
/* OBSOLETE:
PROC readEnvPath() RETURNS envPathStr:OWNS STRING
	DEF tempPath:OWNS STRING, line:OWNS STRING, fileList:OWNS PTR TO cMegaList_STRING
	
	tempPath := MakeUniquePath(/*file1dir2*/ 1, /*dirPath*/ '', /*base*/ 'temp')
	line := StrJoin('Echo \%path\%>', tempPath)
	ExecuteCommand(line)
	IF fileList := readLines(tempPath, /*returnNILforNoFile*/ TRUE) THEN envPathStr := fileList.infoStart().write(NILS, /*returnOldData*/ TRUE)
	DeletePath(tempPath)
FINALLY
	IF exception THEN END envPathStr
	END tempPath, line, fileList
ENDPROC
*/

->parse env path into list, excluding duplicates (which should help keep it below the 1024 character limit of SETX)
PROC parsePathIntoList(envPathStr:NULL STRING) RETURNS envPathList:OWNS PTR TO cMegaList_STRING, cursor:OWNS PTR TO cMegaCursor_STRING, newLen
	DEF pos, nextPos, separator:ARRAY OF CHAR, singlePath:OWNS STRING, tempString:OWNS STRING, alreadyPresent:BOOL
	
	separator := #ifdef pe_TargetOS_Windows ';' #else ':' #endif
	
	NEW envPathList.new()
	cursor := envPathList.infoStart().clone()
	IF envPathStr
		newLen := 0
		pos := 0
		WHILE pos < EstrLen(envPathStr)
			->extract next path
			nextPos := InStr(envPathStr, separator, pos)
			IF nextPos = -1 THEN nextPos := EstrLen(envPathStr)
			NEW singlePath[Max(1,nextPos-pos)]
			StrCopy(singlePath, envPathStr, nextPos-pos, pos)
			
			#ifdef pe_TargetOS_Windows
				->try cleaning-up path, by removing any spurious '%' (happened several times to me, seemingly due to Windows Live Messenger)
				IF tempString := translateStr(singlePath, ['\%','', NILA]:ARRAY_OF_CHAR, EstrLen(singlePath), /*noChangeReturnNILS*/ TRUE)
					END singlePath
					singlePath := PASS tempString
				ENDIF
			#endif
			
			->see if path already present in list
			alreadyPresent := FALSE
			IF envPathList.infoIsEmpty() = FALSE
				cursor.goto(envPathList.infoStart())
				WHILE alreadyPresent = FALSE
					IF StrCmpPath(singlePath, cursor.read()) THEN alreadyPresent := TRUE
				ENDWHILE IF cursor.next()
			ENDIF
			
			->add path to list (if not already present)
			IF alreadyPresent = FALSE
				newLen := newLen + EstrLen(singlePath) + StrLen(separator)
				envPathList.infoPastEnd().beforeInsert(envPathList.makeNode(PASS singlePath))
			ENDIF
			
			pos := nextPos + 1
		ENDWHILE
	ELSE
		->(safe fall-back)
		envPathList.infoPastEnd().beforeInsert(envPathList.makeNode(NEW '\%path\%'))
		newLen := EstrLen(envPathList.infoStart().read()) + StrLen(separator)
	ENDIF
FINALLY
	IF exception THEN END envPathList, cursor
	END singlePath, tempString
ENDPROC
PRIVATE
TYPE ARRAY_OF_CHAR IS ARRAY OF CHAR
PUBLIC
#endif


PROC waitForEnter()
	DEF input[1]:STRING
	ReadStr(stdin, input)
ENDPROC

PROC getFolder(request:ARRAY OF CHAR, defaultFolder=NILA:ARRAY OF CHAR) RETURNS folder:OWNS STRING PROTOTYPE IS EMPTY

PROC getYesNoAnswer(question:ARRAY OF CHAR, questionParams=NILL:ILIST) RETURNS yes:BOOL PROTOTYPE IS EMPTY

PROC showInfo(info:ARRAY OF CHAR, infoParams=NILL:ILIST) PROTOTYPE IS EMPTY


PROC getAnswer(question:ARRAY OF CHAR, validAnswers:ARRAY OF CHAR, questionParams=NILL:ILIST) RETURNS answer:CHAR
	DEF input[10]:STRING, chara[2]:ARRAY OF CHAR, upperValidAnswers:STRING
	
	->ensure all valid answers are uppercase
	upperValidAnswers := StrJoin(validAnswers)
	UpperStr(upperValidAnswers)
	
	->loop until answer is valid
	REPEAT
		->loop until answer is not empty
		REPEAT
			PrintL(question, questionParams)
			PrintFlush()
			ReadStr(stdin, input)
			SetStr(input, Max(0, EstrLen(input) - 1))	->strip LF
		UNTIL EstrLen(input) > 0
		
		->get first character of answer & ensure it is uppercase
		answer := input[0]
		IF (answer >= "a") AND (answer <= "z") THEN answer := answer + "A" - "a"
		
		->compare answer to the valid ones
		chara[0] := answer
		chara[1] := 0
	UNTIL InStr(validAnswers, chara) <> -1
FINALLY
	END upperValidAnswers
ENDPROC

/*****************************/

PROC readLine(fileList:PTR TO cMegaList_STRING, cursor:PTR TO cMegaCursor_STRING) RETURNS line:OWNS STRING
	IF cursor.isOnSameNodeAs(fileList.infoPastEnd()) = FALSE
		line := StrJoin(cursor.read())
		cursor.next()
	ELSE
		line := NILS
	ENDIF
ENDPROC

PROC appendLine(fileList:PTR TO cMegaList_STRING, line:OWNS STRING)
	fileList.infoPastEnd().beforeInsert(fileList.makeNode(PASS line))
ENDPROC

->searches forward from the current cursor position, halting at the end of the list if no match is found
PROC find(needle:ARRAY OF CHAR, fileList:PTR TO cMegaList_STRING, cursor:PTR TO cMegaCursor_STRING, onlyCompareStartOfString=FALSE:BOOL) RETURNS found:BOOL
	DEF stop:BOOL, len
	
	len := IF onlyCompareStartOfString THEN StrLen(needle) ELSE ALL
	
	found := FALSE
	IF fileList.infoIsEmpty() = FALSE
		stop := FALSE
		REPEAT
			IF StrCmpPath(needle, cursor.read(), len)	-># technically this isn't always a path comparison, but it's probably fine...
				found := TRUE
			ELSE
				stop := cursor.next()
			ENDIF
		UNTIL found OR stop
	ENDIF
ENDPROC

/*****************************/

PROC executeCommand(command:ARRAY OF CHAR) RETURNS executed:BOOL
	IF testMode
		Print('TEST MODE skipped executeCommand("\s")\n', command)
		RETURN TRUE
	ENDIF
	
	executed := ExecuteCommand(command)
ENDPROC

PROC copyFile(toPath:ARRAY OF CHAR, fromPath:ARRAY OF CHAR) RETURNS success:BOOL
	DEF from:OWNS PTR TO cFile, to:OWNS PTR TO cFile
	NEW from.new()
	
	IF testMode
		Print('TEST MODE skipped copyFile("\s", "\s")\n', toPath, fromPath)
		RETURN TRUE
	ENDIF
	
	IF success := from.open(fromPath, TRUE)	->readOnly=TRUE
		IF to := from.makeCopy(toPath)
			to.close()
		ELSE
			success := FALSE
		ENDIF
		from.close()
	ENDIF
FINALLY
	END from, to
ENDPROC

->create directory, with any number of non-existant parent directories
PROC createDir(dirPath:ARRAY OF CHAR, forceIcon=FALSE:BOOL) RETURNS success:BOOL
	DEF subPath:OWNS STRING, dir:OWNS PTR TO cHostDir
	#ifdef pe_TargetOS_Amiga
	DEF info:OWNS STRING, createIcon:BOOL
	#endif
	
	IF testMode
		Print('TEST MODE skipped createDir("\s")\n', dirPath)
		RETURN TRUE
	ENDIF
	
	subPath := ExtractSubPath(dirPath)
	IF EstrLen(subPath) > 0
		IF ExistsPath(subPath) = FALSE
			createDir(subPath, /*forceIcon*/ FALSE)
		ENDIF
	ENDIF
	END subPath
	
	NEW dir.new()
	IF success := dir.open(dirPath) THEN dir.close()
	
	#ifdef pe_TargetOS_Amiga
		IF success
			->see if should add an icon to the new folder
			IF forceIcon
				createIcon := TRUE
			ELSE
				subPath := ExtractSubPath(dirPath)
				IF EstrLen(subPath) <= 1
					->(dirPath is a volume or assignment) so giving it an icon makes no sense
					createIcon := FALSE
				ELSE
					SetStr(subPath, EstrLen(subPath) - 1)	->strip trailing /
					IF subPath[EstrLen(subPath)-1] = ":"
						->(dirPath is immediately inside a volume) so it should have an icon, as it will be user-visible
						createIcon := TRUE
					ELSE
						->(dirPath is inside a folder) so if parent folder has an icon, then give this folder an icon too
						info := StrJoin(subPath, '.info')
						createIcon := ExistsPath(info)
						END info
					ENDIF
				ENDIF
				END subPath
			ENDIF
			
			->add icon to the folder
			IF createIcon
				->give this folder an icon
				NEW info[StrLen(dirPath) - 1 + StrLen('.info')]
				StrCopy(info, dirPath, StrLen(dirPath) - 1)		->strip trailing /
				IF EstrLen(info) <= 1
					Print('NOTE: Prevented installer createIcon bug for createDir(dirPath="\s", forceIcon=\d).  Please report this!\n', dirPath, forceIcon)
					
				ELSE IF info[EstrLen(info)-1] = ":"
					Print('NOTE: Prevented installer createIcon bug for createDir(dirPath="\s", forceIcon=\d).  Please report this!\n', dirPath, forceIcon)
				ELSE
					StrAdd( info, '.info')
					copyFile(info, 'Env:/Sys/def_drawer.info')
				ENDIF
				END info
			ENDIF
		ENDIF
	#endif
	forceIcon := forceIcon	->dummy
FINALLY
	END subPath, dir
	#ifdef pe_TargetOS_Amiga
	END info
	#endif
ENDPROC

/*****************************/

PROC moveDir(toPath:ARRAY OF CHAR, fromPath:ARRAY OF CHAR, safe:BOOL) RETURNS success:BOOL
	DEF dir:OWNS PTR TO cDir, toSubPath:OWNS STRING, fromInfo:OWNS STRING
	DEF toIsInsideFrom:BOOL, path:STRING, deleteCursor:OWNS PTR TO cMegaCursor_STRING
	
	success := FALSE
	
	toIsInsideFrom := StrCmpPath(toPath, fromPath, StrLen(fromPath))
	IF safe = FALSE
		->prevent trying to move folder inside itself
		IF toIsInsideFrom THEN RETURN
	ENDIF
	
	->try to move the folder
	IF toIsInsideFrom = FALSE
		NEW dir.new()
		IF dir.open(fromPath)
			toSubPath := ExtractSubPath(toPath)
			IF dir.setSubPath(toSubPath)
				IF dir.setName(FindName(toPath))
					success := TRUE
				ELSE
					->undo partial change
					END toSubPath
					toSubPath := ExtractSubPath(fromPath)
					dir.setSubPath(toSubPath)
				ENDIF
			ENDIF
			dir.close()
		ENDIF
	ENDIF
	
	->if moving failed then try copying
	IF success = FALSE
		IF success := copyDir(toPath, fromPath, IF safe THEN '.e' ELSE NILA)
			->(copying succeeded) so delete originals
			IF safe = FALSE
				DeleteDirPath(fromPath)
			ELSE
				->recursively delete all files ending in .e (since they were all copied successfully)
				deleteFileExtension := '.e' ; deleteFileExtensionLen := StrLen(deleteFileExtension)
				deleteAvoidDir := toPath    ; deleteAvoidDirLen := StrLen(deleteAvoidDir)
				NEW deleteDirList.new()
				RecurseDir(fromPath, funcDeleteFile, funcDeleteDir)
				
				->now try to (reverse) delete all dirs (which will only be deleted if they are truely empty)
				deleteCursor := deleteDirList.infoPastEnd().clone(MC_PREV)
				deleteCursor.prev()
				WHILE deleteDirList.infoIsEmpty() = FALSE
					path := deleteCursor.read()
					DeletePath(path)
					
					deleteCursor.destroy()
				ENDWHILE
			ENDIF
		ENDIF
	ENDIF
	
	->delete old folder's icon
	IF ExistsPath(fromPath) = FALSE
		->(moving was successful) so delete it's icon too
		NEW fromInfo[StrLen(fromPath) - 1 + StrLen('.info')]
		StrCopy(fromInfo, fromPath, StrLen(fromPath) - 1)		->strip trailing /
		StrAdd( fromInfo, '.info')
		IF ExistsPath(fromInfo)
			DeletePath(fromInfo)
			createDir(toPath, /*forceIcon*/ TRUE)	->create an icon for the new folder
		ENDIF
	ENDIF
FINALLY
	IF exception = "BRK" THEN exception := 0	->user pressed Ctrl-C
	END deleteDirList
	
	END dir, toSubPath, fromInfo
ENDPROC

DEF deleteFileExtension:ARRAY OF CHAR, deleteFileExtensionLen
DEF deleteAvoidDir:ARRAY OF CHAR, deleteAvoidDirLen
DEF deleteDirList:OWNS PTR TO cMegaList_STRING

FUNC funcDeleteFile(path:STRING) OF funcRecurseFile
	IF StrCmpPath(path, deleteFileExtension, ALL, EstrLen(path) - deleteFileExtensionLen)
		DeletePath(path)
	ENDIF
ENDFUNC

FUNC funcDeleteDir(path:STRING) OF funcRecurseDir RETURNS scanDir:BOOL
	scanDir := TRUE
	
	IF deleteAvoidDir
		->avoid deleting files inside the given folder
		IF StrCmpPath(path, deleteAvoidDir, deleteAvoidDirLen) THEN scanDir := FALSE
	ENDIF
	
	IF scanDir
		->(files in dir will be deleted) so add dir to deletion list
		deleteDirList.infoPastEnd().beforeInsert(deleteDirList.makeNode(StrJoin(path)))
	ENDIF
ENDFUNC

/*****************************/

->NOTE: Does not copy *directory* attributes or extra.
->NOTE: Automatically handles copying a folder inside itself.
PROC copyDir(toPath:ARRAY OF CHAR, fromPath:ARRAY OF CHAR, withFileExtension=NILA:ARRAY OF CHAR, avoidFileExtension=FALSE:BOOL) RETURNS success:BOOL
	success := TRUE
	
	IF testMode
		Print('TEST MODE skipped copyDir("\s", "\s", "\s")\n', toPath, fromPath, withFileExtension)
		RETURN
	ENDIF
	
	->ensure the destination exists
	createDir(toPath)
	
	->perform recursive copy
	copyFromBase    := fromPath
	copyToBase      :=   toPath
	copyWithFileExt := withFileExtension
	copyAvoidFileExt:= avoidFileExtension
	copyFromBaseLen    := StrLen(copyFromBase)
	copyToBaseLen      := StrLen(copyToBase)
	copyWithFileExtLen := IF copyWithFileExt THEN StrLen(copyWithFileExt) ELSE 0
	copyAvoidLoop := StrCmpPath(toPath, fromPath, StrLen(fromPath))	->check if the target is inside the source
	
	NEW copyDir.new()
	copySuccess := TRUE
	RecurseDir(fromPath, funcCopyFileDir, funcCopyFileDir)
	success := copySuccess
FINALLY
	END copyDir
ENDPROC

DEF copyFromBase:ARRAY OF CHAR, copyToBase:ARRAY OF CHAR, copyWithFileExt:ARRAY OF CHAR, copyAvoidFileExt:BOOL
DEF copyFromBaseLen,            copyToBaseLen,            copyWithFileExtLen
DEF copyAvoidLoop:BOOL
DEF copyDir:OWNS PTR TO cHostDir
DEF copySuccess:BOOL

FUNC funcCopyFileDir(fromPath:STRING) OF funcRecurseDir RETURNS scanDir:BOOL
	DEF toPath:OWNS STRING, copyFile:BOOL
	
	->construct toPath using fromPath
	NEW toPath[EstrLen(fromPath) - copyFromBaseLen + copyToBaseLen]
	StrCopy(toPath, copyToBase)
	StrAdd( toPath, fromPath, ALL, copyFromBaseLen)
	
	->do action relevant to file/dir
	scanDir := TRUE
	IF FastIsDir(fromPath)
		IF copyAvoidLoop
			->don't scan folder if it is inside the target
			scanDir := NOT StrCmpPath(fromPath, copyToBase, copyToBaseLen)
		ENDIF
		IF scanDir
			IF copyDir.open(toPath) THEN copyDir.close() ELSE copySuccess := FALSE
		ENDIF
	ELSE
		IF copyWithFileExt = NILA
			copyFile := TRUE
		ELSE
			copyFile := StrCmpPath(fromPath, copyWithFileExt, ALL, EstrLen(fromPath) - StrLen(copyWithFileExt))
			IF copyAvoidFileExt THEN copyFile := NOT copyFile
		ENDIF
		
		IF copyFile
			DeletePath(toPath)
			IF copyFile(toPath, fromPath) = FALSE
				Print('WARNING: Failed to copy "\s" to "\s".\n', fromPath, toPath)
				copySuccess := FALSE
			ENDIF
		ENDIF
	ENDIF
FINALLY
	END toPath
ENDFUNC

/*****************************/

#ifdef pe_TargetOS_Amiga
ENUM FIBB_DELETE=0, FIBB_EXECUTE, FIBB_WRITE, FIBB_READ, FIBB_ARCHIVE, FIBB_PURE, FIBB_SCRIPT ->, FIBB_HOLD
->CONST FIBF_HOLD    = 1 SHL FIBB_HOLD
CONST FIBF_SCRIPT  = 1 SHL FIBB_SCRIPT
CONST FIBF_PURE    = 1 SHL FIBB_PURE
CONST FIBF_ARCHIVE = 1 SHL FIBB_ARCHIVE
CONST FIBF_READ    = 1 SHL FIBB_READ
CONST FIBF_WRITE   = 1 SHL FIBB_WRITE
CONST FIBF_EXECUTE = 1 SHL FIBB_EXECUTE
CONST FIBF_DELETE  = 1 SHL FIBB_DELETE

CONST FIBF_INVERTED = FIBF_READ OR FIBF_WRITE OR FIBF_EXECUTE OR FIBF_DELETE

->Set specified Amiga flags on given file
PROC setFlagsOnFile(path:ARRAY OF CHAR, flags) RETURNS success:BOOL
	DEF file:OWNS PTR TO cHostFile, attr
	NEW file.new()
	IF file.open(path) = FALSE THEN RETURN FALSE
	attr := file.queryExtra("ATTR")
	success := file.changeExtra("ATTR", attr XOR FIBF_INVERTED OR flags XOR FIBF_INVERTED)
	file.close()
FINALLY
	END file
ENDPROC

->Set specified Amiga flags on all files in a folder (recursively)
PROC setFlagsInDir(path:ARRAY OF CHAR, flags) RETURNS success:BOOL
	success := TRUE
	
	IF testMode
		Print('TEST MODE skipped setFlagsInDir("\s", \d)\n', path, flags)
		RETURN
	ENDIF
	
	setFlags := flags
	
	NEW setFlagsFile.new()
	setFlagsSuccess := TRUE
	RecurseDir(path, funcSetAttrFile)
	success := setFlagsSuccess
FINALLY
	END setFlagsFile
ENDPROC

DEF setFlags
DEF setFlagsFile:OWNS PTR TO cHostFile
DEF setFlagsSuccess:BOOL

FUNC funcSetAttrFile(path:STRING) OF funcRecurseFile
	DEF attr
	
	IF setFlagsFile.open(path) = FALSE
		setFlagsSuccess := FALSE
		RETURN
	ENDIF
	
	attr := setFlagsFile.queryExtra("ATTR")
	IF setFlagsFile.changeExtra("ATTR", attr XOR FIBF_INVERTED OR setFlags XOR FIBF_INVERTED) = FALSE THEN setFlagsSuccess := FALSE
	setFlagsFile.close()
ENDFUNC
#endif

/*****************************/

PROC addOrChangeAssignment(newModulesFolder:STRING) RETURNS success:BOOL
	DEF tempPath:ARRAY OF CHAR, tempString:OWNS STRING
	DEF file:OWNS PTR TO cMegaList_STRING, cursor:OWNS PTR TO cMegaCursor_STRING, cursor2:OWNS PTR TO cMegaCursor_STRING
	DEF line:OWNS STRING
	
	success := TRUE
	
	#ifdef pe_TargetOS_POSIX
		->(OS is Windows/Linux) so append PEmodules: assigment to assignment file
		#ifdef pe_TargetOS_Windows
			IF ExistsPath(tempPath := 'C:/Assignments.txt') AND NOT ExistsPath('C:/PortablE/Assignments.txt')
				->(very old location exists) so use that, to avoid confusion
			ELSE IF ExistsPath(tempPath := 'C:/PortablE/Assignments.txt') AND NOT ExistsPath('HOME:/Assignments.txt')
				->(old location exists) so use that, to avoid confusion
				
			ELSE IF ExistsPath(tempPath := 'HOME:/Assignments.txt')
				->(default new location)
			ELSE IF ExistsPath(tempPath := 'C:/PortablE/Assignments.txt')
				->(default old location)
			ELSE IF ExistsPath(tempPath := 'C:/Assignments.txt')
				->(fall-back location, since C:/PortablE/ does not seem to exist)
			ELSE
				->(no suitable file exists) so create one
				->tempPath := NILA
				IF ExistsPath('HOME:/')
					tempPath := 'HOME:/Assignments.txt'
				ELSE IF CreateDirs('C:/PortablE/')
					tempPath := 'C:/PortablE/Assignments.txt'
				ELSE
					tempPath := 'C:/Assignments.txt'
				ENDIF
			ENDIF
		#else
			tempPath := 'HOME:/.portable/Assignments.txt'
			CreateDirs(tempPath, /*ignoreName*/ TRUE)
		#endif
		IF tempPath = NILA THEN Throw("BUG", 'addOrChangeAssignment(); tempPath=NILA')
		
		file := readLines(tempPath)
		cursor := file.infoStart().clone()
		
		line := StrJoin('PEmodules:  ', tempString := ExportPath(newModulesFolder)) ; END tempString
		
		IF find('PEmodules:', file, cursor, /*onlyCompareStartOfString*/ TRUE) = FALSE
			->(no existing assignment) so add it
			appendLine(file, PASS line)
		ELSE
			->(assignment already exists) so replace it
			cursor.write(PASS line)
		ENDIF
		
		IF writeLines(tempPath, file)
			Print('Added PEmodules: assignment to "\s".\n', tempString := ExportPath(tempPath)) ; END tempString
		ELSE
			Print('WARNING: Could not add PEmodules: assignment to "\s".\n', tempString := ExportPath(tempPath)) ; END tempString
			success := FALSE
		ENDIF
		END file, cursor
	#else
		->(OS is Amiga) so append/modify PEmodules: assignment in User-Startup
		tempPath := 'S:/User-Startup'
		file := readLines(tempPath, /*returnNILforNoFile*/ TRUE)
		IF file = NIL THEN NEW file.new()
		cursor := file.infoStart().clone()
		
		line := StrJoin('Assign PEmodules: "', tempString := ExportPath(newModulesFolder), '"') ; END tempString
		executeCommand(line)	->also perform assignment
		
		IF find(';BEGIN PortablE', file, cursor) = FALSE
			->(no PE assignments) so add them
			appendLine(file, NEW '')
			appendLine(file, NEW '')
			appendLine(file, NEW ';BEGIN PortablE')
			appendLine(file, PASS line)
			appendLine(file, NEW ';END PortablE')
		ELSE
			->(PE assignments already exist) so modify them
			cursor2 := cursor.clone()
			IF find(';END PortablE', file, cursor2)
				->remove existing assignments, leaving cursor2 after where should insert
				cursor.next()
				cursor.destroy(cursor2)
			ELSE
				->handle illegal statement as best can, by leaving cursor2 after (best guess) where should insert
				cursor2.next()
				Print('WARNING: ";END PortablE" is missing from "\s".', tempString := ExportPath(tempPath)) ; END tempString
			ENDIF
			->(cursor2 after where should insert)
			cursor2.beforeInsert(file.makeNode(PASS line))
			END cursor2
		ENDIF
		
		IF writeLines(tempPath, file)
			Print('Added PEmodules: assignment to "\s".\n', tempString := ExportPath(tempPath)) ; END tempString
		ELSE
			Print('WARNING: Could not add PEmodules: assignment to "\s".\n', tempString := ExportPath(tempPath)) ; END tempString
			success := FALSE
		ENDIF
		END file, cursor
	#endif
FINALLY
	END tempString
	END file, cursor, cursor2
	END line
ENDPROC

/*****************************/

PROC obsoleteModulesCheck(targetPEmodules:ARRAY OF CHAR, sourcePEmodules:ARRAY OF CHAR)
	DEF file:OWNS PTR TO cMegaList_STRING, cursor:OWNS PTR TO cMegaCursor_STRING, listOfOldModules:ARRAY OF CHAR
	DEF oldPath:OWNS STRING, sourcePath:OWNS STRING, targetPath:OWNS STRING, hostTargetPath:OWNS STRING
	DEF dirsToDelete:OWNS STRING
	
	IF testMode
		Print('TEST MODE skipped obsoleteModulesCheck("\s", "\s")\n', targetPEmodules, sourcePEmodules)
		RETURN
	ENDIF
	
	listOfOldModules := 'Installer_ListOfOldFiles'
	
	IF ExistsPath(listOfOldModules) = FALSE
		Print('ERROR: Unable to delete obsolete modules, as "\s" did not exist.\n', listOfOldModules)
		RETURN
	ENDIF
	file := readLines(listOfOldModules, /*returnNILforNoFile*/ TRUE)
	IF file = NIL THEN NEW file.new()
	
	->delete all obsolete files, but delay deletion of obsolete dirs until later
	cursor := file.infoStart().clone()
	WHILE oldPath := readLine(file, cursor)
		sourcePath := StrJoin(sourcePEmodules, oldPath)
		targetPath := StrJoin(targetPEmodules, oldPath)
		
		IF ExistsPath(targetPath) AND NOT ExistsPath(sourcePath)
			->(old file/dir exist in target but not source) so file/dir is obsolete & should be deleted
			IF FastIsFile(targetPath)
				->(obsolete path is a file) so delete file immediately
				hostTargetPath := ExportPath(targetPath)
				IF DeletePath(targetPath) THEN Print('Deleted  obsolete file "\s".\n', hostTargetPath) ELSE Print('Deleting obsolete file "\s" FAILED.\n', hostTargetPath)
				END hostTargetPath
			ELSE
				->(obsolete path is a dir) where deletion must be delayed until all it's old contents has been deleted
				Link(targetPath, PASS dirsToDelete)
				dirsToDelete := PASS targetPath
			ENDIF
		ENDIF
		
		END oldPath, sourcePath, targetPath
	ENDWHILE
	
	->delete obsolete dirs
	WHILE dirsToDelete
		targetPath := PASS dirsToDelete
		dirsToDelete := Next(targetPath)
		
		hostTargetPath := ExportPath(targetPath)
		IF DeletePath(targetPath) THEN Print('Deleted  obsolete dir "\s".\n', hostTargetPath) ELSE Print('Deleting obsolete dir "\s" FAILED.\n', hostTargetPath)
		END hostTargetPath
	ENDWHILE
FINALLY
	END file, cursor
	END oldPath, sourcePath, targetPath, hostTargetPath
	END dirsToDelete
ENDPROC

/*****************************/
