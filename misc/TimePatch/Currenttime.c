#include <exec/types.h>
#include <exec/memory.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>

void main(void)
{
    ULONG Seconds =0,Micro =0;
    
    CurrentTime(&Seconds,&Micro);
    Delay(2);
    
}