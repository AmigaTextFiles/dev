/* CleanModuleCache_shared.e 13.08.2022 by Christopher Steven Handley.
*/
/*
	This contains code used by both PortablE & CleanModuleCache.
*/
OPT PREPROCESS
MODULE 'std/pShell', 'std/cPath_Dir', 'std/cPath_shared'

PRIVATE
CONST DEBUG = FALSE
PUBLIC

PROC cleanModuleCacheCompletely(warningOrigin:ARRAY OF CHAR)
	DEF lastCleanedDirPath:OWNS STRING, cleanFilesNext:BOOL, cacheBasePath:OWNS STRING
	
	cacheBasePath := NEW 'PEmodules:/PE/cache/'
	
	lastCleanedDirPath := NILS
	cleanFilesNext     := FALSE
	REPEAT
		lastCleanedDirPath, cleanFilesNext := cleanModuleCacheFolder(PASS lastCleanedDirPath, cleanFilesNext, cacheBasePath, warningOrigin)
		IF lastCleanedDirPath THEN IF StrCmpPath(lastCleanedDirPath, cacheBasePath) THEN END lastCleanedDirPath
	UNTIL (lastCleanedDirPath = NILS) OR CtrlC()
FINALLY
	END lastCleanedDirPath, cacheBasePath
ENDPROC

PROC cleanModuleCacheFolder(lastCleanedDirPath:NULL OWNS STRING, cleanFilesNext:BOOL, cacheBasePath:STRING, warningOrigin:ARRAY OF CHAR) ->RETURNS lastCleanedDirPath:OWNS STRING, cleanFilesNext:BOOL
	DEF cacheBasePathLen, skipCleaningFiles
	DEF lastActualDirPath:OWNS STRING, pos
	DEF dir:OWNS PTR TO cDir, list:OWNS PTR TO cDirEntryList, entry:ARRAY OF CHAR
	DEF firstSubDir:ARRAY OF CHAR, actualPath:OWNS STRING, temp:OWNS STRING, temp2:OWNS STRING
	DEF lastSubDir:OWNS STRING, nextSubDir:ARRAY OF CHAR
	
	cacheBasePathLen := EstrLen(cacheBasePath)
	
	->convert loaded path to corresponding actual path (and sanity-checks it)
	IF lastCleanedDirPath
		IF StrCmpPath(lastCleanedDirPath, cacheBasePath, cacheBasePathLen) = FALSE
			->(lastCleanedDirPath is corrupt)
			IF DEBUG THEN Print('DEBUG NOTE\s: Saved state "\s" was not inside "\s".\n', warningOrigin, lastCleanedDirPath, cacheBasePath)
			END lastCleanedDirPath
		ELSE
			->(lastCleanedDirPath is inside cacheBasePath)
			pos := InStr(lastCleanedDirPath, '/', cacheBasePathLen)
			IF pos = -1
				->(lastCleanedDirPath is corrupt)
				IF DEBUG THEN Print('DEBUG NOTE\s: Saved state "\s" was missing (drive name and) slash after "\s".\n', warningOrigin, lastCleanedDirPath, cacheBasePath)
				END lastCleanedDirPath
			ELSE
				->(path appears valid) so convert to corresponding actual path
				NEW lastActualDirPath[EstrLen(lastCleanedDirPath) - cacheBasePathLen + 1]
				IF StrCmp(lastCleanedDirPath, '_/', STRLEN, cacheBasePathLen) = FALSE
					->(common case)
					StrCopy(lastActualDirPath, lastCleanedDirPath, pos-cacheBasePathLen, cacheBasePathLen)
				ELSE
					->(the drive name was stored as an underscore) so the real drive name was empty
					StrCopy(lastActualDirPath, '')
				ENDIF
				StrAdd(lastActualDirPath, ':')
				StrAdd(lastActualDirPath, lastCleanedDirPath, ALL, pos)
				IF DEBUG THEN Print('DEBUG NOTE\s: Converted saved state "\s" to lastActualDirPath="\s"\n', warningOrigin, lastCleanedDirPath, lastActualDirPath)
				
				->check actual path still exists (and delete all contained cached files if not)
				->optimisation: IF ExistsPath(lastActualDirPath) = FALSE THEN DeleteDirPath(lastCleanedDirPath)
			ENDIF
		ENDIF
		
		IF lastCleanedDirPath = NILS THEN Print('WARNING\s: Saved state was corrupt, so restarting cache cleaning from beginning.\n', warningOrigin)
	ENDIF
	
	->carry on cleaning from where left off
	IF lastCleanedDirPath = NILS
		->(no indication of where we last finished cleaning) so clean from beginning
		->CreateDirs(cacheBasePath)
		lastCleanedDirPath := StrJoin(cacheBasePath)
		cleanFilesNext := TRUE
	ENDIF
	skipCleaningFiles := IF StrCmpPath(lastCleanedDirPath, cacheBasePath) THEN 2 /*ignore any files in root folder*/ ELSE 0
	
	NEW dir.new()
	IF cleanFilesNext
		IF dir.open(lastCleanedDirPath) = FALSE
			cleanFilesNext := FALSE
			IF ExistsPath(lastCleanedDirPath, /*fileOrDir*/ TRUE) THEN Print('WARNING\s: Failed to open "\s" because \s in \s.\n', warningOrigin, lastCleanedDirPath, dir.infoFailureReason(), dir.infoFailureOrigin())
			IF DEBUG THEN Print('DEBUG NOTE\s: Failed to open lastCleanedDirPath="\s", so set cleanFilesNext=FALSE.\n', warningOrigin, lastCleanedDirPath)
		ENDIF
	ENDIF
	IF cleanFilesNext
		->(path is a new one to clean) so scan it's contents & clean any cache files that no-longer have a matching actual source file
		firstSubDir := NILA
		list := dir.makeEntryList() ; dir.close()
		IF list.gotoFirst(/*any0file1dir2*/ skipCleaningFiles)
			REPEAT
				entry := list.infoName()
				IF IsDir(entry)
					->(entry is dir) so store the first dir seen
					IF firstSubDir = NILA THEN firstSubDir := entry
				ELSE
					->(entry is file) so check there is a corresponding actual source file & delete it if not
					IF skipCleaningFiles<>0 THEN Throw("BUG", 'portablE.cleanModuleCache(); skipCleaningFiles<>0')
					
					->convert cache filename to actual source filepath (e.g. "dos_CPP_AmigaOS4.pem" to "dos.e")
					pos := StrLen(entry)
					WHILE pos-- > 0 ; ENDWHILE IF entry[pos] = "."
					WHILE pos-- > 0 ; ENDWHILE IF entry[pos] = "_"
					WHILE pos-- > 0 ; ENDWHILE IF entry[pos] = "_"
					IF pos <= 0
						Print('WARNING\s: Cleaner found invalid cache file "\s\s".\n', warningOrigin, temp:=ExportPath(temp2:=StrJoin(lastCleanedDirPath,entry)) ) ; END temp,temp2
					ELSE
						->convert to actual source filepath
						NEW actualPath[EstrLen(lastActualDirPath) + pos + 2]
						StrCopy(actualPath, lastActualDirPath)
						StrAdd( actualPath, entry, pos)
						StrAdd( actualPath, '.e')
						IF DEBUG THEN Print('DEBUG NOTE\s: Converted cache file "\s\s" to actualPath="\s"\n', warningOrigin, lastActualDirPath, entry, actualPath)
						
						->delete entry if source filepath no-longer exists
						IF ExistsPath(actualPath) = FALSE
							temp := StrJoin(lastCleanedDirPath, entry)
							IF DeletePath(temp) = FALSE THEN Print('WARNING\s: Failed to clear cache file "\s".\n', warningOrigin, temp2:=ExportPath(temp)) ; END temp2
							END temp
						ENDIF
						
						->delete .pem corresponding obsolete file (if any)
						IF StrCmpPath(entry, '.pem', ALL, StrLen(entry)-STRLEN)
							->(is a .pem cache file)
							NEW temp[EstrLen(lastActualDirPath) + StrLen(entry)]
							StrCopy(temp, lastActualDirPath)
							StrAdd( temp, entry)
							IF ExistsPath(temp)
								IF DeletePath(temp) = FALSE THEN Print('WARNING\s: Failed to clear obsolete cache file "\s".\n', warningOrigin, temp2:=ExportPath(temp)) ; END temp2
							ENDIF
							END temp
						ENDIF
						
						END actualPath
					ENDIF
				ENDIF
			UNTIL list.gotoNext(/*any0file1dir2*/ skipCleaningFiles) = FALSE
		ENDIF
		
		IF firstSubDir
			->(found a sub-folder) so scan that upon next call
			temp := StrJoin(lastCleanedDirPath, firstSubDir)
			END lastCleanedDirPath
			lastCleanedDirPath := PASS temp
			cleanFilesNext := TRUE
		ELSE
			->(no sub-folders)
			cleanFilesNext := FALSE
		ENDIF
		END list
	ELSE
		->(cleaned all files in folder) so find next sibling cache folder to scan
		IF lastCleanedDirPath
			IF lastActualDirPath = NILS
				->(lastCleanedDirPath was reset to cacheBasePath) so no valid lastActualDirPath to check
			ELSE IF ExistsPath(lastActualDirPath) = FALSE
				IF DeletePath(lastCleanedDirPath) = FALSE THEN Print('WARNING\s: Failed to clear cache dir "\s" (was probably not empty as expected).\n', warningOrigin, temp2:=ExportPath(lastCleanedDirPath)) ; END temp2
			ENDIF
		ENDIF
		->(cleanFilesNext = FALSE)
		->REPEAT
			REPEAT
				temp := ExtractSubPath(lastCleanedDirPath)
				IF dir.open(temp) = FALSE
					->(parent folder does not exist)
					END lastCleanedDirPath ; lastCleanedDirPath := PASS temp
				ENDIF
			UNTIL (temp <> NILA) OR (EstrLen(lastCleanedDirPath) <= cacheBasePathLen)
			
			IF temp = NILA
				Print('WARNING\s: Aborted cleaning as could not find cache folder "\s".\n', warningOrigin, temp:=ExportPath(cacheBasePath)) ; END temp
				cleanFilesNext := TRUE
			ELSE
				->(found parent folder) so look for next sibling folder
				lastSubDir := ExtractName(lastCleanedDirPath)
				END lastCleanedDirPath ; lastCleanedDirPath := PASS temp
				
				list := dir.makeEntryList() ; dir.close()
				IF list.gotoFirst(/*any0file1dir2*/ 2)
					WHILE nextSubDir = NILA
						entry := list.infoName()
						IF OstrCmpPath(lastSubDir, entry) > 0 THEN nextSubDir := entry
					ENDWHILE IF list.gotoNext(/*any0file1dir2*/ 2) = FALSE
				ENDIF
				END lastSubDir
				
				IF nextSubDir
					->(found next sibling folder) so use it
					temp := StrJoin(lastCleanedDirPath, nextSubDir)
					END lastCleanedDirPath ; lastCleanedDirPath := PASS temp
					cleanFilesNext := TRUE
				ELSE
					->(no sibling folder) so loop back around to check parent folder...
					IF StrCmpPath(lastCleanedDirPath, cacheBasePath)
						->(...except reached root folder) so restart from beginning to avoid error
						END lastCleanedDirPath
					ENDIF
				ENDIF
				END list	->owns string pointed to by nextSubDir
			ENDIF
		->UNTIL cleanFilesNext	->optional
	ENDIF
FINALLY
	IF exception THEN END lastCleanedDirPath
	END lastActualDirPath
	END dir, list
	END actualPath, temp, temp2
	END lastSubDir
ENDPROC lastCleanedDirPath, cleanFilesNext
