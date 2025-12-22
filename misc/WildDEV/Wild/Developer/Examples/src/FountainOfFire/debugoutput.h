
#define DebugOut(mz) 	\
({			\
 if (debugfh)		\
  {			\
   FPuts(debugfh,mz);	\
  }			\
})				
   