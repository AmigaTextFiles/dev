/*
 *	File:					Text.h
 *	Description:	Writes a project as floating text.
 *
 *	(C) 1993, Ketil Hunn
 *
 */

#include "CalcField.h"

void WriteTextLines(FILE *fp, struct List *list, struct EventNode *event)
{
	struct Node *node;
	char text[FNSIZE];

	for(every_node)
	{
		strcpy(text, node->ln_Name);
		fprintf(fp, "%s\n", CalcField(event, text));
	}
}

BOOL WriteText(struct List *list, char *destination)
{
	struct Node				*node;
	struct EventNode	*event;
	FILE	*fp;

	if(fp=fopen(destination, "w"))
	{
		fprintf(fp, "***************************************\n");
		fprintf(fp, "** Exported as Text from " PROGNAME " V" VERSION " **\n");
		fprintf(fp, "***************************************\n\n");
		for(every_node)
		{
			event=(struct EventNode *)node;
			fprintf(fp, "%s\n", node->ln_Name);
			if(event->days)
				fprintf(fp, "%d Days ", event->days);
			if(event->whendate)
				fprintf(fp, "%s", (event->whendate==1 ? "Before " : "After "));
			fprintf(fp, "%02d.%02d.%04d ", event->day, event->month, event->year);
			if(event->whentime)
				fprintf(fp, "%s", (event->whentime==1 ? " Before " : " After "));
			fprintf(fp, "%02d:%02d ", event->hour, event->minutes);
			if(event->repeat)
				fprintf(fp, "Every %d. day", event->repeat);
			fprintf(fp, "\n");
			WriteTextLines(fp, event->textlist, event);
			fprintf(fp, "\n");
		}
		fclose(fp);
	}
	return TRUE;
}
