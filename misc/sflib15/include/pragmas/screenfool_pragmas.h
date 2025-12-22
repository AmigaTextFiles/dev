/* "screenfool.library" */
/* Screen tracking functions */
#pragma libcall ScreenFoolBase OpenPublicScreenA 1E 9802
#pragma tagcall ScreenFoolBase OpenPublicScreen 1E 9802
#pragma libcall ScreenFoolBase ClosePublicScreen 24 801
/* Screen manager functions */
#pragma libcall ScreenFoolBase ClearPubScreenList 2A 801
#pragma libcall ScreenFoolBase NewPubScreenList 30 801
#pragma libcall ScreenFoolBase FindScreenInList 36 0802
/* Display manager functions */
#pragma libcall ScreenFoolBase ClearDisplayList 3C 801
#pragma libcall ScreenFoolBase NewDisplayList 42 0802
#pragma libcall ScreenFoolBase FindDMInList 48 0802
#pragma libcall ScreenFoolBase FindDisplayID 4E 0802
#pragma libcall ScreenFoolBase FindDisplayMode 54 9802
/* Display utility functions */
#pragma libcall ScreenFoolBase StandardizeDisplayID 5A 001
/* Allocation/deallocation of SFList structure*/
#pragma libcall ScreenFoolBase AllocSFList 60 001
#pragma libcall ScreenFoolBase DeallocSFList 66 801
/* End of public jump list */
