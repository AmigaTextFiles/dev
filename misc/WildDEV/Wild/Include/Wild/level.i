
	IFND	WILDLEVEL
WILDLEVEL	SET	1

***************************************************************************************
***	Wild LEVEL definitions.							*******
***************************************************************************************

; The LEVEL struct contains all the fields used to initialize a scene, and also
; some Game-specific fields. In the future, will be loaded from files by a Loader
; (may be also more file formats)

		STRUCTURE	WildLevel,0
			LONG	wl_Flags		; some needed flags.
			LONG	wl_LevelID		; an ID for the level (file-search!)
			APTR	wl_RootDir		; a lock to the root dir (all file-refs are relative!)			
			APTR	wl_Scene		; The scene pointer.
			LABEL	wl_SIZEOF

	ENDC