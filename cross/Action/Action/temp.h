#ifndef TEMP__H
#define TEMP__H

extern int GetTemp(int size,int *Indx);
extern void GenTempName(value *v);
extern void MakeTempName(char *s,int idex);
extern value *CreateTemp(link *t,int size);
extern void ReleaseTemp(value *v);
extern void GenTempStuff(FILE *out);

#endif