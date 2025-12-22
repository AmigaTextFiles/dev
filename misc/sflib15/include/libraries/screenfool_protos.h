/* Prototypes for functions defined in
screenfool.library 1.3 (29.8.93)
 */

#include <libraries/screenfool.h>

/* Public screen open/close functions with tracking */
struct Screen *OpenPublicScreenA(STRPTR, struct TagItem *);
struct Screen *OpenPublicScreen(STRPTR, ULONG, ...);
BOOL ClosePublicScreen(STRPTR);
/* Public screen list functions */
void ClearPubScreenList(struct ScreenFoolList *);
BOOL NewPubScreenList(struct ScreenFoolList *);
struct PublicScreenInfo *FindScreenInList(struct ScreenFoolList *, ULONG);
/* Display list functions */
void ClearDisplayList(struct ScreenFoolList *);
BOOL NewDisplayList(struct ScreenFoolList *, ULONG);
struct DisplayModeInfo *FindDMInList(struct ScreenFoolList *, ULONG);
struct DisplayModeInfo *FindDisplayID(struct ScreenFoolList *, ULONG);
ULONG FindDisplayMode(struct ScreenFoolList *, struct DisplayModeInfo *);
/* List utility function */
ULONG StandardizeDisplayID( ULONG );
/* Allocation/deallocation functions */
struct ScreenFoolList *AllocSFList(UBYTE);
BOOL DeallocSFList(struct ScreenFoolList *);
