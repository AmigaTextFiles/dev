/* Copyright (c) 1986, Greg McGary */
/* @(#)extern.h	1.1 86/10/09 */

/* miscellaneous external declarations */

extern FILE *initID();
extern FILE *openSrcFILE();
extern char *(*getScanner())();
extern char *basename();
extern char *bsearch();
extern char *calloc();
extern char *coRCS();
extern char *dirname();
extern char *getAsmId();
extern char *getCId();
extern char *getDirToName();
extern char *getLanguage();
extern char *getSCCS();
extern char *getenv();
extern char *hashSearch();
extern char *intToStr();
extern char *malloc();
extern char *regcmp();
extern char *regex();
extern char *rootName();
extern char *skipJunk();
extern char *spanPath();
extern char *suffName();
extern char *uerror();
extern int bitCount();
extern int bitsCount();
extern int bitsToVec();
extern int canCrunch();
extern int dtoi();
extern int fgets0();
extern int getsFF();
extern int h1str();
extern int h2str();
extern int strToInt();
extern int otoi();
extern int radix();
extern int stoi();
extern int vecToBits();
extern int wordMatch();
extern int xtoi();
extern void bzero();
extern void document();
extern void filerr();
extern void setAsmArgs();
extern void setCArgs();
extern void setScanArgs();
extern void skipFF();

extern char *MyName;
extern int errno;
