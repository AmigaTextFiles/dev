/************************************************************************/
/*                                                                      */
/*  OMF_Diff.h : Header pour le Diff en format Text des fichiers OMF.   */
/*                                                                      */
/************************************************************************/
/*  Auteur : Olivier ZARDINI  *  Brutal Deluxe Software  *  Avril 2013  */
/************************************************************************/

int CreateDiffFile(struct omf_file *,struct omf_file *,char *);
int CreateDiffBinaryFile(int,unsigned char *,int,unsigned char *,char *);

/************************************************************************/
