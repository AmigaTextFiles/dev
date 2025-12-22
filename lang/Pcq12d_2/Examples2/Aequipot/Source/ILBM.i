{ILBM.i}

{Sorry, but I only found time to include this single function}
{(and I only needed this one)}
{written by J.Matern}

{$I "Include:dos.i" }

Var
   ILBMBase : Address;

Function SaveWindowToIFF(w : WindowPtr; a : Address) : INTEGER;
   External;
