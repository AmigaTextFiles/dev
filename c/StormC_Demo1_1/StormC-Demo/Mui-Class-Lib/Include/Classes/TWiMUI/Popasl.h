//
//  $VER: Popasl.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_POPASL_H
#define CPP_TWIMUI_POPASL_H

#ifndef CPP_TWIMUI_POPSTRING_H
#include <classes/twimui/popstring.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

class MUIPopaslStartHook
	{
	private:
		struct Hook starthook;
		static BOOL StartHookEntry(register __a0 struct Hook *, register __a2 Object *, register __a1 struct Tagitem *);
		virtual BOOL StartHookFunc(struct Hook *, Object *, struct Tagitem *);
	protected:
		MUIPopaslStartHook();
		MUIPopaslStartHook(const MUIPopaslStartHook &p);
		~MUIPopaslStartHook();
		MUIPopaslStartHook &operator= (const MUIPopaslStartHook &);
	public:
		struct Hook *start() { return(&starthook); };
	};

class MUIPopaslStopHook
	{
	private:
		struct Hook stophookFile;
		struct Hook stophookFont;
		struct Hook stophookScreenMode;
		static void StopHookEntryFile(register __a0 struct Hook *, register __a2 Object *, register __a1 struct FileRequester *);
		static void StopHookEntryFont(register __a0 struct Hook *, register __a2 Object *, register __a1 struct FontRequester *);
		static void StopHookEntryScreenMode(register __a0 struct Hook *, register __a2 Object *, register __a1 struct ScreenModeRequester *);
		virtual void StopHookFunc(struct Hook *, Object *, struct FileRequester *);
		virtual void StopHookFunc(struct Hook *, Object *, struct FontRequester *);
		virtual void StopHookFunc(struct Hook *, Object *, struct ScreenModeRequester *);
	protected:
		MUIPopaslStopHook();
		MUIPopaslStopHook(const MUIPopaslStopHook &p);
		~MUIPopaslStopHook();
		MUIPopaslStopHook &operator= (const MUIPopaslStopHook &);
	public:
		struct Hook *stopFile() { return(&stophookFile); };
		struct Hook *stopFont() { return(&stophookFont); };
		struct Hook *stopScreenMode() { return(&stophookScreenMode); };
	};

class MUIPopasl
	:   public MUIPopstring,
		public MUIPopaslStartHook,
		public MUIPopaslStopHook
	{
	public:
		MUIPopasl(const struct TagItem *t)
			:   MUIPopstring(MUIC_Popasl),
				MUIPopaslStartHook(),
				MUIPopaslStopHook()
			{
			init(t);
			};
		MUIPopasl(const Tag, ...);
		MUIPopasl()
			:   MUIPopstring(MUIC_Popasl),
				MUIPopaslStartHook(),
				MUIPopaslStopHook()
			{ };
		MUIPopasl(MUIPopasl &p)
			:   MUIPopstring(p),
				MUIPopaslStartHook(p),
				MUIPopaslStopHook(p)
			{ };
		virtual ~MUIPopasl();
		MUIPopasl &operator= (MUIPopasl &);
		BOOL Active() const { return((BOOL)get(MUIA_Popasl_Active,FALSE)); };
		void StartHook(const struct Hook *p) { set(MUIA_Popasl_StartHook,(ULONG)p); };
		struct Hook *StartHook() const { return((struct Hook *)get(MUIA_Popasl_StartHook)); };
		void StopHook(const struct Hook *p) { set(MUIA_Popasl_StopHook,(ULONG)p); };
		struct Hook *StopHook() const { return((struct Hook *)get(MUIA_Popasl_StopHook)); };
		ULONG Type() const { return(get(MUIA_Popasl_Type,0UL)); };
	};

#endif
