#include "avra.h"
#include <stdio.h>
#include <string.h>
#include "args.h"

char *Space(char *n);

void write_map_file(struct prog_info *pi)
	{
	FILE *fp;
	struct label *label;
	char File[200],*P;

	strcpy(File,(char *)pi->args->first_data->data);
	P = strstr(File,".");
	if( P ) *P = 0;
	strcat(File,".map");
	fp = fopen(File,"w");
	if( fp == NULL ) {
		fprintf(stderr,"Error: cannot write map file\n");
		return;
	}
	for(label = pi->first_constant; label; label = label->next)
		fprintf(fp,"%s%sC\t%04x\t%d\n",label->name,Space(label->name),label->value,label->value);

	for(label = pi->first_variable; label; label = label->next)
		fprintf(fp,"%s%sV\t%04x\t%d\n",label->name,Space(label->name),label->value,label->value);

	for(label = pi->first_label; label; label = label->next)
		fprintf(fp,"%s%sL\t%04x\t%d\n",label->name,Space(label->name),label->value,label->value);

	fprintf(fp,"\n");
	fclose(fp);
	return;
	}

char *Space(char *n) {
	int i;

	i = strlen(n);
	if( i < 1) return "\t\t\t";
	if( i < 8 ) return "\t\t";
	return "\t";
}

