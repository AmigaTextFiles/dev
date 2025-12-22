
#ifndef _WORKBENCHLIBRARY_H
#define _WORKBENCHLIBRARY_H

#include <exec/types.h>
#include <dos/dos.h>
#include <workbench/workbench.h>
#include <intuition/intuition.h>
#include <utility/tagitem.h>

class WorkbenchLibrary
{
public:
	WorkbenchLibrary();
	~WorkbenchLibrary();

	static class WorkbenchLibrary Default;

	struct AppWindow * AddAppWindowA(ULONG id, ULONG userdata, struct Window * window, struct MsgPort * msgport, struct TagItem * taglist);
	BOOL RemoveAppWindow(struct AppWindow * appWindow);
	struct AppIcon * AddAppIconA(ULONG id, ULONG userdata, UBYTE * text, struct MsgPort * msgport, struct FileLock * lock, struct DiskObject * diskobj, struct TagItem * taglist);
	BOOL RemoveAppIcon(struct AppIcon * appIcon);
	struct AppMenuItem * AddAppMenuItemA(ULONG id, ULONG userdata, UBYTE * text, struct MsgPort * msgport, struct TagItem * taglist);
	BOOL RemoveAppMenuItem(struct AppMenuItem * appMenuItem);
	VOID WBInfo(BPTR lock, STRPTR name, struct Screen * screen);
	BOOL OpenWorkbenchObjectA(STRPTR name, struct TagItem * tags);
	BOOL CloseWorkbenchObjectA(STRPTR name, struct TagItem * tags);
	BOOL WorkbenchControlA(STRPTR name, struct TagItem * tags);
	struct AppWindowDropZone * AddAppWindowDropZoneA(struct AppWindow * aw, ULONG id, ULONG userdata, struct TagItem * tags);
	BOOL RemoveAppWindowDropZone(struct AppWindow * aw, struct AppWindowDropZone * dropZone);
	BOOL ChangeWorkbenchSelectionA(STRPTR name, struct Hook * hook, struct TagItem * tags);
	BOOL MakeWorkbenchObjectVisibleA(STRPTR name, struct TagItem * tags);

private:
	struct Library *Base;
};

WorkbenchLibrary WorkbenchLibrary::Default;

#endif

