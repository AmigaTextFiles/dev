//
//  $VER: Semaphore.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_SEMAPHORE_H
#define CPP_TWIMUI_SEMAPHORE_H

#ifndef CPP_TWIMUI_NOTIFY_H
#include <classes/twimui/notify.h>
#endif

class MUISemaphore : public MUINotify
	{
	protected:
		MUISemaphore(const STRPTR cl) : MUINotify(cl) { };
	public:
		MUISemaphore(const struct TagItem *t) : MUINotify(MUIC_Semaphore) { init(t); };
		MUISemaphore(const Tag, ...);
		MUISemaphore() : MUINotify(MUIC_Semaphore) { };
		MUISemaphore(MUISemaphore &p) : MUINotify(p) { };
		virtual ~MUISemaphore();
		MUISemaphore &operator= (MUISemaphore &p);
		void Attempt() { dom(MUIM_Semaphore_Attempt); };
		void AttemptShared() { dom(MUIM_Semaphore_AttemptShared); };
		void Obtain() { dom(MUIM_Semaphore_Obtain); };
		void ObtainShared() { dom(MUIM_Semaphore_ObtainShared); };
		void Release() { dom(MUIM_Semaphore_Release); };
	};

#endif
