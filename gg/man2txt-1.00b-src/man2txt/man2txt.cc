/* Unix Manpage to Text converter */

/***********************************************************************
 * This distribution is freeware but WITHOUT ANY WARRANTY; without     *
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A       *
 * PARTICULAR PURPOSE.                                                 *
 *                                                                     *
 * These utilities come with no warranty either expressed or implied.  *
 * They are not guaranteed to be free of error. They are also not      *
 * guaranteed NOT to do damage to your system.  You use these programs *
 * at your own risk!                                                   *
 *                                                                     *
 * These programs and their associated documentation (if any) are all  *
 * Copyright (C)1993-1998 by Jason Pell.  All Rights Reserved.         *
 * You are free to use them, but you must not claim them for your own. *
 *                                                                     *
 * Email: jasonpell@hotmail.com                                        *
 * URL: http://www.geocities.com/SiliconValley/Haven/9778              *
 ***********************************************************************/


#include <iostream.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

#define NAME "man2txt"
#define VERSION "1.00b"
#define YEAR "1997"

#define DID_NOT_COPY 0
#define SUCCESS 1

void do_convert(FILE *, FILE *);
void do_copy(void);
void do_help(void);
int copy(FILE *in_file, FILE* out_file, int *error);

main(int argc, char *argv[])
{
	FILE *in, *out, *tmp;
	int error, dosame = 0;

	if (argc < 2)
	{
		cout << "\n\nUsage: " << NAME << " <infile> [outfile]\n" << endl;
		do_copy();
		return 1;
	}
	else if (!strcmp(argv[1], "/?")) /* argv[1] == "/?" ! */
	{
		do_help();
		do_copy();
		return 0;
	}

	in = fopen(argv[1], "r");

	if (in == NULL)
	{
		cout << "\nCould not open " << argv[1] << endl;
		do_copy();
		return 2;
	}

	if (argc < 3 || (argc >= 3 && !strcmp(argv[1], argv[2]))) /* same filename! */
	{
		tmp = tmpfile();

		if (tmp == NULL)
		{
			cout << "\nCould not open temp file!" << endl;
			do_copy();
			return 3;
		}

		if(!copy(in, tmp, &error))
		{
			cout << "\nCould not make temp file backup!: " << strerror(error) << endl;
			fclose(in);
			fclose(tmp);	
		
			do_copy();
			return 4;
		}

		else
		{
			rewind(tmp);
			fclose(in);

			out = fopen(argv[1], "w");

			dosame = 1;
		}
	}

	else
	{
		tmp = fopen(argv[2], "r");

		if (tmp != NULL)
		{
			cout << "\nOutfile exists: " << argv[2] << endl;
			fclose(tmp);
			fclose(in);
			do_copy();
			return 5;
		}

		fclose(tmp);

		out = fopen(argv[2], "w");
	}

	if (out == NULL)
	{
		cout << "\nCould not open ";
		if (argc > 2)
			cout << argv[2];
		else
			cout << argv[1];

		cout << endl;

		do_copy();
		return 6;
	}

	/* convert begins! */

	if (dosame == 1)
	{
		cout << "\nConverting " << argv[1] << " => " << argv[1] << " (Overwriting)" << endl;
		do_convert(tmp, out);
	}
	else
	{
		cout << "\nConverting " << argv[1] << " => " << argv[2] << endl;
		do_convert(in, out);
	}

	fclose(in);
	fclose(out);
	fclose(tmp);

	do_copy();
	return 0;
}

void do_copy(void)
{
	cout << "\n" << NAME << " Version " << VERSION << ". Copyright (C)" << YEAR << " by Jason Pell." << endl;
}

int copy(FILE *in_file, FILE* out_file, int *error)
{
	char buffer[4096];
	int read_chk, write_chk;

	read_chk = fread(buffer, 1, 4096, in_file);

	while (read_chk > 0)
	{
		write_chk = fwrite(buffer, 1, read_chk, out_file);

		if (write_chk != read_chk) /* error */
		{
			*error = errno;
			return(DID_NOT_COPY);
		}

		else
		{
			read_chk = fread(buffer, 1, 4096, in_file);
		}
	}

	return SUCCESS;
}

typedef struct
{
	int store;
	int status;
} hold;

void do_convert(FILE *in, FILE *out)
{
	hold one, two;

	one.status = 0;
	two.status = 0;

	while(!feof(in))
	{
		if (one.status == 0)
		{
			one.store = fgetc(in);
			one.status = 1;
		}
		
		if (two.status == 0 && !feof(in))
		{
			two.store = fgetc(in);	
			two.status = 1;
		}

		if (two.store == 8) /* discard both! */
		{
			one.status = 0;
			two.status = 0;
		}
		else
		{
			fputc(one.store, out);
			
			one.store = two.store;
			two.status = 0;
		}
	}
}

void do_help(void)
{
	cout 	<< "Usage: " << NAME << " <infile> [outfile]\n\n\n"	
	 	<< "Where <infile> is the file that is to be converted.\n"
		<< "And [outfile] is the file that is to contain the converted\n"
		<< "<infile>.\n\n"
		<< "** Be aware that if [outfile] is absent from the command line\n"
		<< "** then <infile> will be overwritten with [outfile].\n\n"
		<< "## If the <infile> is overwritten and you need it, you can undelete\n"
		<< "## the temp file, ( which contains a copy of the original <infile> )\n"
		<< "## The temporary file will have the form \"TMP??.$$$\".\n"
		<< "-#\treplace \"??\" with the relevant number.\n"
		<< "-#\tLarger numbers for later files.\n"
		<< endl;
}

