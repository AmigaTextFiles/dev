#include <exec/types.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

extern struct WBStartup *WBenchMsg;
struct WBArg *arg;
int i;

void main()
{
 printf("WBenchMsg=$%lx\n",WBenchMsg);
 printf("ArgStr=$%lx\n",GetArgStr());
 if(WBenchMsg)
  {
   for(i=0,arg=WBenchMsg->sm_ArgList;i<WBenchMsg->sm_NumArgs;i++,arg++)
    {
     printf("%lx <%s>\n",arg->wa_Lock,arg->wa_Name);
    }
  }
 puts("Über CLI gestartet.");
}

