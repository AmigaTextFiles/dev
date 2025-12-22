// An example of how to read the attribute data
// into your program Just call LoadATR() function
// with the appropriate filename and BlockATR array

// Types for ReadValue()
#define COMMA   1
#define BRACKET 2

// Block attribute settings
// You can allocate an array of these large enough
// to hold attributes for each of your blocks.
// This makes reading the attributes easy (atr[ID])
struct BlockATR
{
	int trans;  	// Transparency enabled for this block
	int coltype;    // Collision detection value
	int frames; 	// # of animation frames
};

/// LoadATR()
// Restore saved attributes
int LoadATR(char *filename, struct BlockATR *atr)
{
	FILE *atrfile;
	int done = FALSE;
	int command;
	int id=1;

	// Open the file for reading
	atrfile = fopen(filename,"r");

	if (atrfile == NULL)
	{
		return(0); // Failed to open
	}


	// Load in all data needed to restore attributes
	// read in and proccess commands
	while(done==FALSE)
	{
		command=0;
		command=fgetc(atrfile); // read in the command

		switch(command) // check to see what command was found
		{
			case 'I': // New BlockID
				SkipLead(atrfile); // skip leading space

				// Read the current index
				ReadValue(atrfile,&id);
	        break;

			case 'T': // Transparent
				SkipLead(atrfile);
				ReadValue(atrfile,&atr[id].trans);
	        break;

			case 'C': // Collision
				SkipLead(atrfile);
				ReadValue(atrfile,&atr[id].coltype);
	        break;

			case 'F': // AnimFrames
				SkipLead(atrfile);
				ReadValue(atrfile,&atr[id].frames);
	        break;

			case 'Q': // End of script
				done = TRUE;
			break;
		}
	}

	// Close the file
	fclose(atrfile);

	return(1); // success
}
///

/// ReadValue() Functions to help reading from atr file
void ReadValue(FILE *sectionfile, int *value)
{
	char buffer[100];
	int type = 0;

	fgets(buffer,(BreakDistance(sectionfile,&type)+1),sectionfile);
	*value = atoi(buffer);
	fgetc(sectionfile); // skip comma

    // skip eol when bracket is found
	if (type == BRACKET)
	{
		fgetc(sectionfile);
	}
}

void ReadText(FILE *sectionfile, char *value)
{
	int type = 0;

	fgets(value,(BreakDistance(sectionfile,&type)+1),sectionfile);
	fgetc(sectionfile); // skip comma or bracket

    // skip eol when bracket is found
	if (type == BRACKET)
	{
		fgetc(sectionfile);
	}

}

void SkipLead(FILE *file)
{
	fgetc(file); // skip leading space
	fgetc(file); // skip leftbracket
}

int BreakDistance(FILE *file, int *type)
{
	fpos_t fileposition;
	int index=0;
	int character=0;

	/* store current fileposition */
	fgetpos(file,&fileposition);

	while((character != ')') && (character != ',') )
	{
		character=fgetc(file);
		if((character != ')') && (character != ',') ) index++;
	}

	/* restore to stored file position */
	fsetpos(file,&fileposition);

	if (character == ')')
	{
		*type = BRACKET;
	}
	else if (character == ',')
	{
		*type = COMMA;
	}


	return(index);
}

int BracketDistance(FILE *file)
{
	fpos_t fileposition;
	int index=0;
	int character=0;

	/* store current fileposition */
	fgetpos(file,&fileposition);

	while(character!=')')
	{
		character=fgetc(file);
		if(character != ')') index++;
	}

	/* restore to stored file position */
	fsetpos(file,&fileposition);

	return(index);
}

int CommaDistance(FILE *file)
{
	fpos_t fileposition;
	int index=0;
	int character=0;

	/* store current fileposition */
	fgetpos(file,&fileposition);

	while(character!=',')
	{
		character=fgetc(file);
		if(character != ',') index++;
	}

	/* restore to stored file position */
	fsetpos(file,&fileposition);

	return(index);
}
///

