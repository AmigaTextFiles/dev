/* Erstellt mit GadEd V2.0 */
/* Geschrieben von Michael Neumann und Thomas Patschinski */

#include <exec/lists.h>
#include <intuition/screens.h>
#include <intuition/intuition.h>


/* Proc00-Requester */
/* Gadget Lables */

#define Proc00GadEdGadget000               0
#define Proc00GadEdGadget001               1
#define Proc00GadEdGadget002               2
#define Proc00GadEdGadget003               3
#define Proc00GadEdGadget004               4
#define Proc00GadEdGadget005               5
#define Proc00GadEdGadget006               6
#define Proc00GadEdGadget007               7
#define Proc00GadEdGadget008               8
#define Proc00GadEdGadget009               9
#define Proc00GadEdGadget010               10
#define Proc00GadEdGadget011               11
#define Proc00GadEdGadget012               12
#define Proc00GadEdGadget013               13
#define Proc00GadEdGadget014               14
#define Proc00GadEdGadget015               15
#define Proc00GadEdGadget016               16
#define Proc00GadEdGadget017               17
#define Proc00GadEdGadget018               18
#define Proc00GadEdGadget019               19
#define Proc00GadEdGadget020               20
#define Proc00GadEdGadget021               21
#define Proc00GadEdGadget022               22
#define Proc00GadEdGadget023               23
#define Proc00GadEdGadget024               24
#define Proc00GadEdGadget025               25
#define Proc00GadEdGadget026               26
#define Proc00GadEdGadget027               27

/* Menü Lables */

#define Proc00GadEdTitel000                0
#define Proc00GadEdItem000                 0
#define Proc00GadEdItem001                 2
#define Proc00GadEdItem002                 3
#define Proc00GadEdItem003                 5
#define Proc00GadEdTitel001                1
#define Proc00GadEdItem004                 0
#define Proc00GadEdItem005                 1
#define Proc00GadEdItem006                 2
#define Proc00GadEdTitel002                2
#define Proc00GadEdItem007                 0
#define Proc00GadEdSub000                  0
#define Proc00GadEdSub001                  2
#define Proc00GadEdItem008                 1
#define Proc00GadEdItem009                 2
#define Proc00GadEdItem010                 3
#define Proc00GadEdItem011                 5
#define Proc00GadEdItem012                 6
#define Proc00GadEdTitel003                3
#define Proc00GadEdItem013                 0
#define Proc00GadEdItem014                 1
#define Proc00GadEdItem015                 3
#define Proc00GadEdSub002                  0
#define Proc00GadEdSub003                  1

/* Proc01-Requester */
/* Gadget Lables */

#define Proc01GadEdGadget000               0
#define Proc01GadEdGadget001               1
#define Proc01GadEdGadget002               2
#define Proc01GadEdGadget003               3
#define Proc01GadEdGadget004               4
#define Proc01GadEdGadget005               5
#define Proc01GadEdGadget006               6
#define Proc01GadEdGadget007               7
#define Proc01GadEdGadget008               8
#define Proc01GadEdGadget009               9
#define Proc01GadEdGadget010               10
#define Proc01GadEdGadget011               11
#define Proc01GadEdGadget012               12
#define Proc01GadEdGadget013               13
#define Proc01GadEdGadget014               14
#define Proc01GadEdGadget015               15
#define Proc01GadEdGadget016               16
#define Proc01GadEdGadget017               17
#define Proc01GadEdGadget018               18
#define Proc01GadEdGadget019               19
#define Proc01GadEdGadget020               20
#define Proc01GadEdGadget021               21
#define Proc01GadEdGadget022               22
#define Proc01GadEdGadget023               23
#define Proc01GadEdGadget024               24
#define Proc01GadEdGadget025               25
#define Proc01GadEdGadget026               26
#define Proc01GadEdGadget027               27

/* Menü Lables */

#define Proc01GadEdTitel000                0
#define Proc01GadEdItem000                 0
#define Proc01GadEdItem001                 2
#define Proc01GadEdItem002                 3
#define Proc01GadEdItem003                 5
#define Proc01GadEdTitel001                1
#define Proc01GadEdItem004                 0
#define Proc01GadEdItem005                 1
#define Proc01GadEdItem006                 2
#define Proc01GadEdTitel002                2
#define Proc01GadEdItem007                 0
#define Proc01GadEdSub000                  0
#define Proc01GadEdSub001                  2
#define Proc01GadEdItem008                 1
#define Proc01GadEdItem009                 2
#define Proc01GadEdItem010                 3
#define Proc01GadEdItem011                 5
#define Proc01GadEdItem012                 6
#define Proc01GadEdTitel003                3
#define Proc01GadEdItem013                 0
#define Proc01GadEdItem014                 1
#define Proc01GadEdItem015                 3
#define Proc01GadEdSub002                  0
#define Proc01GadEdSub003                  1

extern struct List    Liste[2];
extern struct List    ListViewList00[2];
extern struct Menu   *Men;
extern struct Menu   *Menu00;
extern struct Gadget *G0[28];
extern struct Gadget *GPtrs00[28];


extern BOOL InitUnbekannt(struct Screen *,struct TagItem *UserTags);

extern void RefreshProc00(void);
extern struct Window *InitProc00Mask(struct TagItem *UserTags);
extern struct Gadget *GetProc00GPtr(int);
extern void CloseProc00Mask(void);
extern void RefreshProc01(void);
extern struct Window *InitProc01Mask(struct TagItem *UserTags);
extern struct Gadget *GetProc01GPtr(int);
extern void CloseProc01Mask(void);

extern void FreeUnbekannt(void);
