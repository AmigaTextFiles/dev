//===============================================//
// Layout manager classes                        //
// Gadget header file                            //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_GADGET_H
#define LAYOUT_GADGET_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

#ifndef LAYOUT_QUEUE_H
#include "layout_queue.h"
#endif


class gadget;

	class GadgetQueue : public Queue
	{
	protected:
		virtual void Optimize ();

	public:
		GadgetQueue (gadget* par) : Queue ((primitive*)par) { }
		~GadgetQueue () { }

		void QuRefreshGadget () { AddQO (QORefreshGadget); }
		void QuSetGadgetAttr (long attr, int arg)
		{
			QueueCmd* q = AddQO (QOSetGadgetAttr);
			q->a1.p = NULL;
			q->a2.l = attr;
			q->a3.i = arg;
		}
		void QuSetImageAttr (struct Image* i, long attr, int arg)
		{
			QueueCmd* q = AddQO (QOSetImageAttr);
			q->a1.p = (void*)i;
			q->a2.l = attr;
			q->a3.i = arg;
		}
		void Play (gadget* gad);
	};


class gadget : public primitive
{
	friend class GadgetQueue;
	int GadgetInList;

protected:
	GadgetQueue q;
	struct Gadget* g;

	virtual ResourceType GetResourceType (YtResource r);
	virtual void SetResource (YtResource r, ResourceVal& v);

public:
	gadget (Shell* shell, char* name, composite* parent = NULL);
	virtual ~gadget ();

	virtual prefered_width () = 0;	// This is an abstract data class
	virtual prefered_height () = 0;

	virtual void ClearQueue () { q.Clear (); }
	virtual void PlayQueue () { q.Play (this); }

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
};

#endif
