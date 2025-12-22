unit defs;

interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility;

type
  pwindownode = ^twindownode;         { type definition for the node   }
  twindownode = record                { in a seperate unit so it can   }
    ln_succ   : pwindownode;          { be used in the produced unit   }
    ln_pred   : pwindownode;          { enabling an extra parameter    }
    pwin      : pwindow;              { to be passed allowing multiple }
    pwinglist : pgadget;              { windows to work                }
    pwingads  : array [0..10] of pgadget;
    pwinvisualinfo : pointer;
    pwindrawinfo : pdrawinfo;
   end;

implementation
end.