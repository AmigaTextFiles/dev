#include <exec/types.h>
#include <amigem/machine.h>

DLONG SDivMod32(LONG dividend,LONG divisor)
{
  RETURN_DLONG(dividend/divisor,dividend%divisor);
}

LONG SMult32(LONG arg1,LONG arg2)
{
  return arg1*arg2;
}

long long SMult64(LONG arg1,LONG arg2)
{
  return (long long)arg1*(long long)arg2;
}

DLONG UDivMod32(ULONG dividend,ULONG divisor)
{
  RETURN_DLONG(dividend/divisor,dividend%divisor);
}

ULONG UMult32(ULONG arg1,ULONG arg2)
{
  return arg1*arg2;
}

unsigned long long UMult64(ULONG arg1,ULONG arg2)
{
  return (unsigned long long)arg1*(unsigned long long)arg2;
}
