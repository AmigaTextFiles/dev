//
//  $VER: Dataspace.h   1.0 (16 Jun 1996)
//
//    c 1996 Thomas Wilhelmi
//
//
// Address : Taunusstrasse 14
//           61138 Niederdorfelden
//           Germany
//
//  E-Mail : willi@twi.rhein-main.de
//
//   Phone : +49 (0)6101 531060
//   Fax   : +49 (0)6101 531061
//
//
//  $HISTORY:
//
//  16 Jun 1996 :   1.0 : first public Release
//

#ifndef CPP_TWIMUI_DATASPACE_H
#define CPP_TWIMUI_DATASPACE_H

#ifndef CPP_TWIMUI_SEMAPHORE_H
#include <classes/twimui/semaphore.h>
#endif

class MUIDataspace : public MUISemaphore
	{
	public:
		MUIDataspace(const struct TagItem *t) : MUISemaphore(MUIC_Dataspace) { init(t); };
		MUIDataspace(const Tag, ...);
		MUIDataspace() : MUISemaphore(MUIC_Dataspace) { };
		MUIDataspace(MUIDataspace &p) : MUISemaphore(p) { };
		virtual ~MUIDataspace();
		MUIDataspace &operator= (MUIDataspace &p);
		ULONG Add(APTR p1, LONG p2, ULONG p3) { return(dom(MUIM_Dataspace_Add,(ULONG)p1,(ULONG)p2,p3)); };
		void Clear() { dom(MUIM_Dataspace_Clear); };
		APTR Find(ULONG p) { return((APTR)dom(MUIM_Dataspace_Find,(ULONG)p)); };
		LONG Merge(Object *p) { return((LONG)dom(MUIM_Dataspace_Merge,(ULONG)p)); };
		ULONG ReadIFF(struct IFFHandle *p) { return(dom(MUIM_Dataspace_ReadIFF,(ULONG)p)); };
		ULONG Remove(ULONG p) { return(dom(MUIM_Dataspace_Remove,p)); };
		ULONG WriteIFF(struct IFFHandle *p1, ULONG p2, ULONG p3) { return(dom(MUIM_Dataspace_WriteIFF,(ULONG)p1,p2,p3)); };
	};

#endif
