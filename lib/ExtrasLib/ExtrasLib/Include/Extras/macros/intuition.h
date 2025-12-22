#ifndef EXTRAS_MACROS_INTUITION_H
#define EXTRAS_MACROS_INTUITION_H

/* Window Stuff */
#define GetWinInnerWidth(w)  (w->Width  - ( w->BorderLeft + w->BorderRight) )
#define GetWinInnerHeight(w) (w->Height - ( w->BorderTop  + w->BorderBottom ) )

/* Gadget Stuff */
#define GetGadString( g )      ((( struct StringInfo * )g->SpecialInfo )->Buffer  )  
#define GetGadNumber( g )      ((( struct StringInfo * )g->SpecialInfo )->LongInt )  

#endif /* EXTRAS_MACROS_INTUITION_H */
