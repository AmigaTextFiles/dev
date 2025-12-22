/*
** $VER: config_protos.h 1.0 (7.9.96)
**
** Prototypes for config.library
**
** Copyright (C) 1996, Adam Dawes.
*/

#ifndef CLIB_CONFIG_PROTOS_H
#define CLIB_CONFIG_PROTOS_H

#include <libraries/config.h>

int WriteConfig(char *filename, char *section, char *item, char *data);
int WriteConfigNumber(char *filename, char *section, char *item, long data);
int ReadConfig(char *filename, char *section, char *item, char *buffer, int bufsize, char *def);
long ReadConfigNumber(char *filename, char *section, char *item, long def);

#endif /* CLIB_CONFIG_PROTOS_H */
