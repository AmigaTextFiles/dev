#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "revbump.h"
#include "revbump_rev.h"

#define DATESIZE 100
#define TEMPSIZE 1000
#define FILENAMESIZE 1024

#if defined (__amigaos__) || defined (__MORPHOS__) || defined (__AROS__)
static const char versiontag[] __attribute__ ((used)) = VERSTAG;
#endif

int main(int argc, char **argv)
{
	char temp[TEMPSIZE] = { 0, }, file[FILENAMESIZE] = { 0, }, date[DATESIZE] = { 0, }, *p;
	FILE *fp;
	long currentversion = 0, currentrevision = 0, currentsubrevision = 0, version = 0, revision = 0, subrevision = 0;
	time_t t;
	struct tm *tmp;

	if((argc < 2) || (argc > 5))
	{
		printf("Usage: revbump <name> [sub] [<version>] [<revision>] [<subrevision>]\n");
	}
	else
	{
		strncpy(file, argv[1], FILENAMESIZE);
		strncat(file, "_rev.h", FILENAMESIZE);

		if((fp = fopen(file, "r")))
		{
			if(fgets(temp, TEMPSIZE, fp))
			{
				p = temp;
				while(*p != '\t')
				{
					p++;
				}
				p++;
				currentversion = strtol(p, NULL, 10);
			}
			if(fgets(temp, TEMPSIZE, fp))
			{
				p = temp;
				while(*p != '\t')
				{
					p++;
				}
				p++;
				currentrevision = strtol(p, NULL, 10);
			}
			if(fgets(temp, TEMPSIZE, fp))
			{
				p = temp;
				while(*p != '\t')
				{
					p++;
				}
				p++;
				currentsubrevision = strtol(p, NULL, 10);
			}
			fclose(fp);
		}
		if(argc >= 3)
		{
			version = strtol(argv[2], NULL, 10);
		}
		if(argc >= 4)
		{
			revision = strtol(argv[3], NULL, 10);
		}
		if(argc == 5)
		{
			subrevision = strtol(argv[4], NULL, 10);
		}
	}

	if(argc == 2)
	{
		version = currentversion;
		revision = currentrevision + 1;
		subrevision = 0;
	}
	else if(argc == 3)
	{
		if(strncmp(argv[2], "sub", 3) == 0)
		{
			version = currentversion;
			revision = currentrevision;
			subrevision = currentsubrevision + 1;
		}
		else if(strncmp(argv[2], "rev", 3) == 0)
		{
			version = currentversion;
			revision = currentrevision + 1;
			subrevision = 0;
		}
		else if(strncmp(argv[2], "ver", 3) == 0)
		{
			version = currentversion + 1;
			revision = 0;
			subrevision = 0;
		}
		else if(strncmp(argv[2], "touch", 3) == 0)
		{
			version = currentversion;
			revision = currentrevision;
			subrevision = currentsubrevision;
		}
		else
		{
			revision = 0;
			subrevision = 0;
		}
	}
	else if(argc == 4)
	{
		subrevision = 0;
	}

	t = time(NULL);
	tmp = localtime(&t);
	if(tmp)
	{
		if(strftime(date, DATESIZE, "%d.%m.%Y", tmp) == 0)
		{
			printf("ERROR: Can't get current date!\n");
		}
	}

	/* Writing file */
	if((fp = fopen(file, "w+")))
	{
		fprintf(fp, "%s%ld\n", VERSIONTEXT, version);
		fprintf(fp, "%s%ld\n", REVISIONTEXT, revision);
		fprintf(fp, "%s%ld\n", SUBREVISIONTEXT, subrevision);

		fprintf(fp, "\n");
		fprintf(fp, "%s\"%s\"\n", DATETEXT, date);
		fprintf(fp, "%s\"%s %ld.%ld\"\n", VERSTEXT, argv[1], version, revision);
		fprintf(fp, "%s\"%s %ld.%ld (%s)\\r\\n\"\n", VSTRINGTEXT, argv[1], version, revision, date);
		fprintf(fp, "%s\"\\0$VER: %s %ld.%ld (%s)\"\n", VERSTAGTEXT, argv[1], version, revision, date);

		fprintf(fp, "\n");
		fprintf(fp, "%s\"%ld\"\n", VERSION_STRTEXT, version);
		fprintf(fp, "%s\"%ld\"\n", REVISION_STRTEXT, revision);
		fprintf(fp, "%s\"%ld\"\n", SUBREVISION_STRTEXT, subrevision);

		fprintf(fp, "\n");
		if(subrevision != 0)
		{
			fprintf(fp, "%s\"%s %ld.%ld.%ld\"\n", NEW_VERSTEXT, argv[1], version, revision, subrevision);
			fprintf(fp, "%s\"%s %ld.%ld.%ld (%s)\\r\\n\"\n", NEW_VSTRINGTEXT, argv[1], version, revision, subrevision, date);
			fprintf(fp, "%s\"\\0$VER: %s %ld.%ld.%ld (%s)\"\n", NEW_VERSTAGTEXT, argv[1], version, revision, subrevision, date);
		}
		else
		{
			fprintf(fp, "%s\"%s %ld.%ld\"\n", NEW_VERSTEXT, argv[1], version, revision);
			fprintf(fp, "%s\"%s %ld.%ld (%s)\\r\\n\"\n", NEW_VSTRINGTEXT, argv[1], version, revision, date);
			fprintf(fp, "%s\"\\0$VER: %s %ld.%ld (%s)\"\n", NEW_VERSTAGTEXT, argv[1], version, revision, date);
		}
		fclose(fp);
	}
	return 0;
}
