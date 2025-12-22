/* "stc.library"*/
/*------ crunch data --------------------------------------------------*/
#pragma libcall StcBase stcCrunchData 1E 801
/*------ decrunch data ------------------------------------------------*/
#pragma libcall StcBase stcDeCrunchData 24 9802
/*------ buffer allocation and misc -----------------------------------*/
#pragma libcall StcBase stcAllocBuffer 2A 001
#pragma libcall StcBase stcFreeBuffer 30 901
#pragma libcall StcBase stcQuickSort 36 8002
#pragma libcall StcBase stcAllocFileBuffer 3C 801
#pragma libcall StcBase stcFreeFileBuffer 42 901
#pragma libcall StcBase stcLoadFileBuffer 48 801
/*------ internal functions -------------------------------------------*/
#pragma libcall StcBase stcProcessHunks 4E 8002
#pragma libcall StcBase stcSaveExec 54 A9821006
#pragma libcall StcBase stcLibDeCrunchPExec 5A CB02
/*------ new functions ------------------------------------------------*/
#pragma libcall StcBase stcCrunchDataTags 60 801
#pragma libcall StcBase stcSaveExecTags 66 801
#pragma libcall StcBase stcNewAllocFileBuffer 6C 8002
#pragma libcall StcBase stcAllocMemBuffer 72 1002
#pragma libcall StcBase stcFileIs 78 801
