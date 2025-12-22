/* dirwalker.h
 */
#ifndef DIRWALKER_H
#define DIRWALKER_H

typedef int(*fpnt)(char *);

int dirwalker(char *basedir,char *dpatt,char *fpatt,fpnt dirin, fpnt dirout, fpnt file);

#endif
