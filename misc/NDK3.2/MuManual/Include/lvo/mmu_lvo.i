		IFND LIBRARIES_MMU_LVO_I
LIBRARIES_MMU_LVO_I	SET	1

		XDEF	_LVOAllocAligned
		XDEF	_LVOGetMapping
		XDEF	_LVOReleaseMapping
		XDEF	_LVOGetPageSize
		XDEF	_LVOGetMMUType
		XDEF	_LVOLockMMUContext
		XDEF	_LVOUnlockMMUContext
		XDEF	_LVOSetPropertiesA
		XDEF	_LVOGetPropertiesA
		XDEF	_LVORebuildTree
		XDEF	_LVOSetPagePropertiesA
		XDEF	_LVOGetPagePropertiesA
		XDEF	_LVOCreateMMUContextA
		XDEF	_LVODeleteMMUContext
		XDEF	_LVOAllocLineVec
		XDEF	_LVOPhysicalPageLocation
		XDEF	_LVOSuperContext
		XDEF	_LVODefaultContext
		XDEF	_LVOEnterMMUContext
		XDEF	_LVOLeaveMMUContext
		XDEF	_LVOAddContextHookA
		XDEF	_LVORemContextHook
		XDEF	_LVOAddMessageHookA
		XDEF	_LVORemMessageHook
		XDEF	_LVOActivateException
		XDEF	_LVODeactivateException
		XDEF	_LVOAttemptLockMMUContext
		XDEF	_LVOLockContextList
		XDEF	_LVOUnlockContextList
		XDEF	_LVOAttemptLockContextList
		XDEF	_LVOSetPropertyList
		XDEF	_LVOTouchPropertyList
		XDEF	_LVOCurrentContext
		XDEF	_LVODMAInitiate
		XDEF	_LVODMATerminate
		XDEF	_LVOPhysicalLocation
		XDEF	_LVORemapSize
		XDEF	_LVOWithoutMMU
		XDEF	_LVOSetBusError
		XDEF	_LVOGetMMUContextData
		XDEF	_LVOSetMMUContextDataA
		XDEF	_LVONewMapping
		XDEF	_LVOCopyMapping
		XDEF	_LVODupMapping
		XDEF	_LVOCopyContextRegion
		XDEF	_LVOSetPropertiesMapping
		XDEF	_LVOSetMappingPropertiesA
		XDEF	_LVOGetMappingPropertiesA
		XDEF	_LVOBuildIndirect
		XDEF	_LVOSetIndirect
		XDEF	_LVOGetIndirect
		XDEF	_LVORebuildTreesA
		XDEF	_LVORunOldConfig
		XDEF	_LVOSetIndirectArray
		XDEF	_LVOGetPageUsedModified
		XDEF	_LVOMapWindow
		XDEF	_LVOCreateContextWindowA
		XDEF	_LVOReleaseContextWindow
		XDEF	_LVORefreshContextWindow
		XDEF	_LVOMapWindowCached
		XDEF	_LVOLayoutContextWindow

_LVOAllocAligned            	EQU	-30
_LVOGetMapping              	EQU	-36
_LVOReleaseMapping          	EQU	-42
_LVOGetPageSize             	EQU	-48
_LVOGetMMUType              	EQU	-54
_LVOLockMMUContext          	EQU	-72
_LVOUnlockMMUContext        	EQU	-78
_LVOSetPropertiesA          	EQU	-84
_LVOGetPropertiesA          	EQU	-90
_LVORebuildTree             	EQU	-96
_LVOSetPagePropertiesA      	EQU	-102
_LVOGetPagePropertiesA      	EQU	-108
_LVOCreateMMUContextA       	EQU	-114
_LVODeleteMMUContext        	EQU	-120
_LVOAllocLineVec            	EQU	-132
_LVOPhysicalPageLocation    	EQU	-138
_LVOSuperContext            	EQU	-144
_LVODefaultContext          	EQU	-150
_LVOEnterMMUContext         	EQU	-156
_LVOLeaveMMUContext         	EQU	-162
_LVOAddContextHookA         	EQU	-168
_LVORemContextHook          	EQU	-174
_LVOAddMessageHookA         	EQU	-180
_LVORemMessageHook          	EQU	-186
_LVOActivateException       	EQU	-192
_LVODeactivateException     	EQU	-198
_LVOAttemptLockMMUContext   	EQU	-204
_LVOLockContextList         	EQU	-210
_LVOUnlockContextList       	EQU	-216
_LVOAttemptLockContextList  	EQU	-222
_LVOSetPropertyList         	EQU	-228
_LVOTouchPropertyList       	EQU	-234
_LVOCurrentContext          	EQU	-240
_LVODMAInitiate             	EQU	-246
_LVODMATerminate            	EQU	-252
_LVOPhysicalLocation        	EQU	-258
_LVORemapSize               	EQU	-264
_LVOWithoutMMU              	EQU	-270
_LVOSetBusError             	EQU	-276
_LVOGetMMUContextData       	EQU	-282
_LVOSetMMUContextDataA      	EQU	-288
_LVONewMapping              	EQU	-294
_LVOCopyMapping             	EQU	-300
_LVODupMapping              	EQU	-306
_LVOCopyContextRegion       	EQU	-312
_LVOSetPropertiesMapping    	EQU	-318
_LVOSetMappingPropertiesA   	EQU	-324
_LVOGetMappingPropertiesA   	EQU	-330
_LVOBuildIndirect           	EQU	-336
_LVOSetIndirect             	EQU	-342
_LVOGetIndirect             	EQU	-348
_LVORebuildTreesA           	EQU	-360
_LVORunOldConfig            	EQU	-366
_LVOSetIndirectArray        	EQU	-372
_LVOGetPageUsedModified     	EQU	-378
_LVOMapWindow               	EQU	-420
_LVOCreateContextWindowA    	EQU	-426
_LVOReleaseContextWindow    	EQU	-432
_LVORefreshContextWindow    	EQU	-438
_LVOMapWindowCached         	EQU	-444
_LVOLayoutContextWindow     	EQU	-450

		ENDC
