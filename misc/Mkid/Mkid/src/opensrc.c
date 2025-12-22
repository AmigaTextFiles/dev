/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)opensrc.c	1.1 86/10/09";

#include	<stdio.h>
#include	"string.h"
#ifdef UNIX
#include	<sys/types.h>
#include	<sys/stat.h>
#endif

FILE *openSrcFILE();
char *getSCCS();
char *coRCS();

FILE *
openSrcFILE(path, sccsDir, rcsDir)
	char		*path;
	char		*sccsDir;
	char		*rcsDir;
{
	char		*command = NULL;
	char		*what = NULL;
	char		*get = "get SCCS file";
	char		*checkout = "checkout RCS file";
	char		*dirName;
	char		*baseName;
	FILE		*srcFILE;

	if ((srcFILE = fopen(path, "r")) != NULL)
		return srcFILE;

#ifdef UNIX
	if ((baseName = strrchr(path, '/')) == NULL) {
		dirName = ".";
		baseName = path;
	} else {
		dirName = path;
		*baseName++ = '\0';
	}

	if (rcsDir && (command = coRCS(dirName, baseName, rcsDir)))
		what = checkout;
	else if (sccsDir && (command = getSCCS(dirName, baseName, sccsDir)))
		what = get;
	else if ((command = coRCS(dirName, baseName, "RCS"))
	     ||  (command = coRCS(dirName, baseName, ".")))
		what = checkout;
	else if ((command = getSCCS(dirName, baseName, "SCCS"))
	     ||  (command = getSCCS(dirName, baseName, "sccs"))
	     ||  (command = getSCCS(dirName, baseName, ".")))
		what = get;

	if (dirName == path)
		*--baseName = '/';

	if (!command) {
		filerr("open", path);
		return NULL;
	}

	system(command);
	if ((srcFILE = fopen(path, "r")) == NULL) {
		filerr("open", path);
		return NULL;
	}

	fprintf(stderr, "%s\n", command);
	return srcFILE;
#endif
#ifdef AMIGA
	filerr("open", path);
	return NULL;
#endif
}

char *
getSCCS(dir, base, sccsDir)
	char		*dir;
	char		*base;
	char		*sccsDir;
{
#ifdef UNIX
	static char	cmdBuf[BUFSIZ];
	char		fileBuf[BUFSIZ];
	struct stat	statBuf;

	if (!*sccsDir)
		sccsDir = ".";

	sprintf(fileBuf, "%s/%s/s.%s", dir, sccsDir, base);
	if (stat(fileBuf, &statBuf) < 0)
		return NULL;
	sprintf(cmdBuf, "cd %s; get -s %s/s.%s", dir, sccsDir, base);

	return cmdBuf;
#endif
#ifdef AMIGA
	return NULL;
#endif
}

char *
coRCS(dir, base, rcsDir)
	char		*dir;
	char		*base;
	char		*rcsDir;
{
#ifdef UNIX
	static char	cmdBuf[BUFSIZ];
	char		fileBuf[BUFSIZ];
	struct stat	statBuf;

	if (!*rcsDir)
		rcsDir = ".";

	sprintf(fileBuf, "%s/%s/%s,v", dir, rcsDir, base);
	if (stat(fileBuf, &statBuf) < 0)
		return NULL;
	sprintf(cmdBuf, "cd %s; co -q %s/%s,v", dir, rcsDir, base);

	return cmdBuf;
#endif
#ifdef AMIGA
	return NULL;
#endif
}
