/*
// Permission to use, copy, modify, and distribute this software and its
// documentation for any purpose and without fee is hereby granted, provided
// that the above copyright notice appear in all copies and that both that
// copyright notice and this permission notice appear in supporting
// documentation, and that the name of I.B.M. not be used in advertising
// or publicity pertaining to distribution of the software without specific,
// written prior permission. I.B.M. makes no representations about the
// suitability of this software for any purpose.  It is provided "as is"
// without express or implied warranty.
//
// I.B.M. DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL I.B.M.
// BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
// OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
// CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//
// DB Murrell
// * 6/15/93
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/errno.h>

#define VERSION		"CONVERT Version 1.0 (6/15/93)"
#define ERROR_OUT	stderr
#define END_OF_TEXT  	"### EOT ###"
#define FLAGS		"hH?bBaAvVmMpPoOcC"
#define N_POLY_TYPES	3
#ifndef TRUE
  #define TRUE 1
#endif
#ifndef FALSE
  #define FALSE 0
#endif

typedef int int32;              /* 32 bit integer */
typedef unsigned int uint32;    /* 32 bit unsigned integer */
typedef float float32;          /* 32 bit single precision float */
typedef enum {False = 0, True}			Boolean;
typedef enum {INFORMATION, WARNING, FATAL}	Severity;
typedef enum {BINARY, ASCII}			Output_Mode;
typedef enum {MESH, POLYGON}			Input_Type;
typedef enum {COORDINATES = 0, ELEMENTS, NORMS}	Poly_Type;

static char	*self_name = NULL;

/*
 * Polygon information table
 */
static struct {
    Poly_Type	type;
    char 	*ext;
    char	*desc;
} poly_table[] = {
    { COORDINATES, ".coor",  "Coordinate Data" },
    { ELEMENTS,    ".elem",  "Element Data"    },
    { NORMS,       ".vnorm", "Vector Normals"  }
};

/*
 * Help text
 */
static char *help_text[] = {
    "Converts viewperf polygon and mesh files to and from binary",
    "and ASCII formats",
    "",
    "USAGE:   convert [options] <input_file> <output_file>",
    "",
    "options:",
    "   -[hH?]     Display this message",
    "",
    "   -[bB]      Convert to binary (assumes ASCII input)",
    "",
    "   -[aA]      Convert to ASCII  (assumes binary input)",
    "",
    "   -[vV]      Verbose mode",
    "",
    "   -[mM]      Input file is full path to viewperf mesh data",
    "",
    "   -[pPoO]    Input file is path prefix to viewperf polygon data",
    "              (suffixes .coor, .elem, and .vnorm are added by convert)",
    "",
    "   -[cC]      Add comments to ASCII output files",
    "",
    "Input and output files default to stdin, and stdout (respectively) if",
    "left unspecified",
    END_OF_TEXT
};

/*
 ********************************************************************
 *
 * Swap32 -- Byte swap a 32 bit datum to convert between big
 *           and little endian formats.
 *
 ********************************************************************
 */
static void Swap32(void *src_void, void *dst_void, size_t length)
{
  register uint32 tmp;
  uint32 *src = (uint32 *) src_void;
  uint32 *dst = (uint32 *) dst_void;
  size_t i;

  for (i = 0; i < length; i++) {
    tmp = src[i];
    tmp &= 0xffffffff;
    tmp = ((tmp >> 24) | (tmp << 24) | 
           ((tmp >> 8) & 0xff00) | ((tmp << 8) & 0xff0000));
    dst[i] = tmp;
  }
}

/*
 ********************************************************************
 *
 * Error -- Error reporting
 *
 ********************************************************************
 */
static void Error(Severity sev, char *file, unsigned line, 
	   char *procedure, char *format, ...)
{
    char        level[16];
    va_list     args;

    /*
     * Sanity check
     */
    if (file == NULL || self_name == NULL || procedure == NULL)
        return;

    va_start(args, format);

    switch (sev)
    {
    case INFORMATION:
        strcpy(level, "NOTE");
        break;
    case WARNING:
        strcpy(level, "*** WARNING");
        break;
    default:
        strcpy(level, ">>> FATAL");
        break;
    }

    fprintf(ERROR_OUT, "%s ('%s'@%d, %s::%s) -\n\t", 
	    level, file, line, self_name, procedure);
/*
    if (format == NULL)
        fprintf(ERROR_OUT, "%s", strerror(errno));
    else
        vfprintf(ERROR_OUT, format, args);
*/
    fprintf(ERROR_OUT, "\n");
    fflush(ERROR_OUT);

    va_end(args);

    if (sev == FATAL)
        exit(1);
} /* Error */

/*
 ********************************************************************
 *
 * Expand -- Stretch a storage area to at least size (bytes) given
 *
 ********************************************************************
 */
static void Expand(char **store, size_t size)
{
    /*
     * Sanity check
     */
    if (store == NULL || size == 0)
	return;

    if ((*store) == NULL)
    {
        if (((*store) = (char *)malloc(size)) == NULL)
            Error(FATAL, __FILE__, __LINE__, "Expand", NULL);
    }
    else if (((*store) = (char *)realloc(*store, size)) == NULL)
        Error(FATAL, __FILE__, __LINE__, "Expand", NULL);
} /* Expand */

/*
 ********************************************************************
 *
 * Str_Dup -- Generate copy of string argument
 *
 ********************************************************************
 */
static void Str_Dup(char **dest, char *src)
{
    if (src == NULL)
    {
        if (*dest != NULL)
            free(*dest);
        *dest = NULL;
        return;
    } /* if */

    else if (*dest == NULL)
    {
        if ((*dest = (char *)malloc(strlen(src) + 1)) == NULL)
	    Error(FATAL, __FILE__, __LINE__, "Str_Dup", NULL);
    } /* else if */

    else if ((*dest = (char *)realloc(*dest, strlen(src) + 1)) == NULL)
	Error(FATAL, __FILE__, __LINE__, "Str_Dup", NULL);

    strcpy(*dest, src);
} /* Str_Dup */

/*
 ********************************************************************
 *
 * Str_Append -- Tack a list of strings onto the end of the first,
 *		 expanding the first if necessary.
 *
 ********************************************************************
 */
static void Str_Append(char **dest, ...)
{
    va_list     args;
    char        *src;

    /*
     * Sanity checks
     */
    if (dest == NULL)
        return;

    va_start(args, dest);
    while ((src = (char *)va_arg(args, char*)) != NULL)
    {
        if ((*dest) == NULL)
        {
	    Expand(dest, (strlen(src) + 1) * sizeof(char));
            strcpy(*dest, src);
        } /* if */
        else
        {
	    Expand(dest, (strlen(*dest) + strlen(src) + 1) * sizeof(char));
            strcat(*dest, src);
        } /* else */
    } /* while */
    va_end(args);
} /* Str_Append */

/*
 ********************************************************************
 *
 * Show_Help_Text -- Text for help message
 *
 ********************************************************************
 */
static void Show_Help_Text(void)
{
    register unsigned i = 0;

    fprintf(stderr, "\t\t\t%s\n\n", VERSION);
    while (strcmp(help_text[i], END_OF_TEXT) != 0)
        fprintf(stderr, "%s\n", help_text[i++]);
} /* Show_Help_Text */

/*
 ********************************************************************
 *
 * Scan -- scan past comments and white space
 *
 ********************************************************************
 */
static void Scan(FILE *fp)
{
    int c;

    /*
     * Sanity check
     */
    if (fp == NULL)
        return;

    while (!feof(fp))
    {
	c = fgetc(fp);

        if (isspace(c))
	    continue;

	else if (c == '#')
	{
	    while (((c = fgetc(fp)) != EOF) && (c != '\n'))
		;
	    continue;
	} /* else if */

	else if (c != EOF)
	{
	    ungetc(c, fp);
	    break;
	} /* else */
    } /* while */

} /* Scan */

/*
 ********************************************************************
 *
 * M A I N
 *
 ********************************************************************
 */
void main(int argc, char *argv[])
{
    Output_Mode	output_mode = ASCII;
    Input_Type	input_type = MESH;
    Boolean	verbose = False;
    Boolean	help = False;
    Boolean	comments = False;

    int		option;
    char	*input_file_path = NULL;
    char	*output_file_path = NULL;

    FILE	*fp_input = NULL;
    FILE	*fp_output = NULL;

    time_t	now = time(NULL);
    char	time_string[256];
    void       *ptr;
    union {
      int32	testWord;
      char	testByte[4];
    } endianTest;
    int swapFlag;

    /*
     * Determine if we are running on a big endian or a
     * little endian machine. The binary data files are
     * always stored in big endian format, so if this is
     * a little endian machine we may have to swap bytes.
     */
    endianTest.testWord = 1;
    if (endianTest.testByte[0] == 1)
    {
      swapFlag = TRUE;
    } else {
      swapFlag = FALSE;
    }

    /*
     * Obtain program name
     */
    Str_Dup(&self_name, argv[0]);

    /*
     * Format time string
     */
    strftime(&time_string[0], sizeof(time_string), "%A, %B %d, %Y (%r %Z)", localtime(&now));

    /*
     * Scan command line options
     */
    while ((option = getopt(argc, argv, FLAGS)) != EOF)
    {
        switch (option)
        {
	case 'b':	/* Binary output (ASCII input) */
	case 'B':
	    output_mode = BINARY;
	    break;

	case 'a':	/* ASCII output (binary input) */
	case 'A':
	    output_mode = ASCII;
	    break;

	case 'v':	/* Verbose mode */
	case 'V':
	    verbose = True;
	    break;

	case 'm':	/* Mesh input file type */
	case 'M':
	    input_type = MESH;
	    break;

	case 'o':	/* Polygon (object) input file type */
	case 'O':
	case 'p':
	case 'P':
	    input_type = POLYGON;
	    break;

	case 'c':	/* Add comments to ASCII output */
	case 'C':
	    comments = True;
	    break;

	case '?':	/* On-line help */
	case 'h':
	case 'H':
	default:
	    Show_Help_Text();
	    exit(0);
	} /* switch */
    } /* while */

    /*
     * Obtain input and output file paths 
     */
    if (optind < argc)
    {
	Str_Dup(&input_file_path, argv[optind]);

	if (++optind < argc)
	    Str_Dup(&output_file_path, argv[optind]);
    }

    if (verbose)
    {
	fprintf(stderr, "Converting %s files to %s...\n",
			(input_type == MESH ? "mesh" : "polygon"),
			(output_mode == BINARY ? "binary" : "ASCII"));

        if (input_file_path == NULL               ||
	    *input_file_path == '\0'              ||
            strcmp(input_file_path, "stdin") == 0 || 
	    strcmp(input_file_path, "STDIN") == 0)
	    fprintf(stderr, "\tInput: standard tty input\n");

	else if (input_type == MESH)
	    fprintf(stderr, "\tInput: %s\n", input_file_path);

        else
	{
	    register uint32 i;

	    fprintf(stderr, "\tInput:\n");
	    for (i = 0; i < N_POLY_TYPES; i++)
		fprintf(stderr, "\t\t%s%s (%s)\n", input_file_path, poly_table[i].ext, poly_table[i].desc);
	} /* else */

        if (output_file_path == NULL                ||
	    *output_file_path == '\0'               ||
            strcmp(output_file_path, "stdout") == 0 || 
	    strcmp(output_file_path, "STDOUT") == 0)
	    fprintf(stderr, "\tOutput: standard tty output\n");

	else if (input_type == MESH)
	    fprintf(stderr, "\tOutput: %s\n", output_file_path);

        else
	{
	    register uint32 i;

	    fprintf(stderr, "\tOutput:\n");
	    for (i = 0; i < N_POLY_TYPES; i++)
		fprintf(stderr, "\t\t%s%s (%s)\n", output_file_path, poly_table[i].ext, poly_table[i].desc);
	} /* else */

	if (output_mode == ASCII && comments)
	    fprintf(stderr, "\tComments will be inserted in output\n");
	fprintf(stderr, "\n");
        if (swapFlag)
        	fprintf(stderr, "Running on a little endian machine, binary data will be byte swapped\n");
        else
        	fprintf(stderr, "Running on a big endian machine, binary data will not be byte swapped\n");
    } /* if */

    /*
     * Process the files
     */
    switch (input_type)
    {
    case MESH:
        /*
         * Open input and output files
         */
        if (input_file_path == NULL               ||
	    *input_file_path == '\0'              ||
            strcmp(input_file_path, "stdin") == 0 || 
	    strcmp(input_file_path, "STDIN") == 0)
        {
	    if (verbose)
                fprintf(stderr, "%s: Reading MESH data from standard input...\n", self_name);
            fp_input = stdin;
        } /* if */
	
        else if ((fp_input = fopen(input_file_path, "r")) == NULL)
	    Error(FATAL, __FILE__, __LINE__, "main", 
		    "Cannot open MESH file '%s' for input", input_file_path);
	
        if (output_file_path == NULL                ||
	    *output_file_path == '\0'               ||
            strcmp(output_file_path, "stdout") == 0 ||
	    strcmp(output_file_path, "STDOUT") == 0)
        {
	    if (verbose)
                fprintf(stderr, "%s: Output MESH data to standard output...\n", self_name);
            fp_output = stdout;
        } /* if */

        else if ((fp_output = fopen(output_file_path, "w")) == NULL)
	    Error(FATAL, __FILE__, __LINE__, "main", 
		    "Cannot open MESH file '%s' for output", output_file_path);

	/*
	 * MESH conversion
	 */
	{
	    uint32 		count, count_swap, section = 1;
	    register uint 	i;
	    float32		vector[3], vector_swap[3];

	    /*
	     * Write output header
	     */
	    if ((output_mode == ASCII) && comments)
	    {
		fprintf(fp_output, "#\n");
		fprintf(fp_output, "# Mesh output file generated from input\n");
		fprintf(fp_output, "# file \"%s\"\n", input_file_path);
		fprintf(fp_output, "# %s\n", time_string);
		fprintf(fp_output, "#\n");
	    } /* if */

	    while (!feof(fp_input))
	    {
		if (verbose)
		    fprintf(stderr, "Converting section %d...\n", section);

		/*
		 * Read / write vector count
		 */
		switch (output_mode)
		{
		case ASCII:
	            if (fread(&count, sizeof(count), 1, fp_input) == 1)
		    {
                        if (swapFlag) Swap32((void *) &count, (void *) &count, 1);
		        if (comments)
		            fprintf(fp_output, "%u # SECTION %d COUNT\n", count, section);
		        else
		            fprintf(fp_output, "%u\n", count);
		    } /* if */
		    else
			continue;
		    break;
		case BINARY:
		    Scan(fp_input);
		    if (fscanf(fp_input, "%u", &count) > 0)
		    {
                        if (swapFlag)
                        {
                          Swap32((void *) &count, (void *) &count_swap, 1);
                          ptr = (void *) &count_swap;
                        } else {
                          ptr = (void *) &count;
                        }
		        if (fwrite(ptr, sizeof(count), 1, fp_output) != 1)
			    Error(FATAL, __FILE__, __LINE__, "main", NULL);
		    }
		    else
			continue;
		    break;
		} /* switch */

		/*
		 * Read / write vectors
		 */
		switch (output_mode)
		{
		case ASCII:
		    if (comments)
			fprintf(fp_output, "# SECTION %d VECTORS\n", section);

		    for (i = 0; i < count; i++)
		    {
	                if (fread(vector, sizeof(float32), 3, fp_input) != 3)
			    Error(FATAL, __FILE__, __LINE__, "main", NULL);
                        if (swapFlag) Swap32((void *) vector, (void *) vector, 3);

			if (comments)
			    fprintf(fp_output, "\t%f %f %f # vector[%d of %d]\n",
				    vector[0], vector[1], vector[2], i + 1, count);
			else
			    fprintf(fp_output, "%f %f %f\n", vector[0], vector[1], vector[2]);
		    }
		    break;
		case BINARY:
		    for (i = 0; i < count; i++)
		    {
			Scan(fp_input);
		        if (fscanf(fp_input, "%f %f %f", &vector[0], &vector[1], &vector[2]) < 0)
			    Error(FATAL, __FILE__, __LINE__, "main", 
				    "Found EOF while reading vector %d in file '%s'", i + 1, input_file_path);

                        if (swapFlag) Swap32((void *) vector, (void *) vector, 3);
		        if (fwrite(vector, sizeof(float32), 3, fp_output) != 3)
			    Error(FATAL, __FILE__, __LINE__, "main", NULL);
		    }
		    break;
		} /* switch */

		if (verbose)
		    fprintf(stderr, "\tWrote %d vectors\n", count);
		fflush(fp_output);

		/*
		 * Read / write normals
		 */
		switch (output_mode)
		{
		case ASCII:
		    if (comments)
			fprintf(fp_output, "# SECTION %d NORMALS\n", section);

		    for (i = 0; i < count; i++)
		    {
	                if (fread(vector, sizeof(float32), 3, fp_input) != 3)
			    Error(FATAL, __FILE__, __LINE__, "main", NULL);
                        if (swapFlag) Swap32((void *) vector, (void *) vector, 3);

			if (comments)
			    fprintf(fp_output, "\t%f %f %f # normal[%d of %d]\n",
				    vector[0], vector[1], vector[2], i + 1, count);
			else
			    fprintf(fp_output, "%f %f %f\n", vector[0], vector[1], vector[2]);
		    }
		    break;
		case BINARY:
		    for (i = 0; i < count; i++)
		    {
			Scan(fp_input);
		        if (fscanf(fp_input, "%f %f %f", &vector[0], &vector[1], &vector[2]) < 0)
			    Error(FATAL, __FILE__, __LINE__, "main", 
				    "Found EOF while reading normal %d in file '%s'", i + 1, input_file_path);

                        if (swapFlag) Swap32((void *) vector, (void *) vector, 3);
		        if (fwrite(vector, sizeof(float32), 3, fp_output) != 3)
			    Error(FATAL, __FILE__, __LINE__, "main", NULL);
		    }
		    break;
		} /* switch */

		if (verbose)
		    fprintf(stderr, "\tWrote %d normals\n", count);
		fflush(fp_output);

		++section;
	    } /* while */

	    if (verbose)
		fprintf(stderr, "EOF reached on MESH file\n", count);
	} /* case MESH */

	if (fp_input != stdin)
	    fclose(fp_input);
	if (fp_output != stdout)
	    fclose(fp_output);
	break;

    case POLYGON:
	{
	    register uint32 	poly_i;
	    char		*save_input_path = NULL;
	    char		*save_output_path = NULL;

	    /*
 	     * Retain file path prefixes
	     */
	    Str_Dup(&save_input_path, input_file_path);
	    Str_Dup(&save_output_path, output_file_path);

	    for (poly_i = 0; poly_i < N_POLY_TYPES; poly_i++)
	    {
		/*
		 * Restore file path prefixes
		 */
		Str_Dup(&input_file_path, save_input_path);
		Str_Dup(&output_file_path, save_output_path);

        	/*
         	 * Open input and output files
         	 */
        	if (input_file_path == NULL               ||
	    	    *input_file_path == '\0'              ||
            	    strcmp(input_file_path, "stdin") == 0 || 
	    	    strcmp(input_file_path, "STDIN") == 0)
        	{
	    	    if (verbose)
                	fprintf(stderr, "%s: Reading POLYGON %s from standard input...\n",
				self_name, poly_table[poly_i].desc);
            	    fp_input = stdin;
        	} /* if */
	
        	else 
		{
		    Str_Append(&input_file_path, poly_table[poly_i].ext, NULL);

		    if ((fp_input = fopen(input_file_path, "r")) == NULL)
	    	        Error(FATAL, __FILE__, __LINE__, "main", 
		    	      "Cannot open POLYGON %s file '%s' for input", 
			      poly_table[poly_i].desc, input_file_path);
		} /* else */
		
        	if (output_file_path == NULL                ||
	    	    *output_file_path == '\0'               ||
            	    strcmp(output_file_path, "stdout") == 0 ||
	    	    strcmp(output_file_path, "STDOUT") == 0)
        	{
	    	    if (verbose)
                	fprintf(stderr, "%s: Output POLYGON %s to standard output...\n",
				self_name, poly_table[poly_i].desc);
            	    fp_output = stdout;
        	} /* if */

        	else
		{
		    Str_Append(&output_file_path, poly_table[poly_i].ext, NULL);

		    if ((fp_output = fopen(output_file_path, "w")) == NULL)
	    	        Error(FATAL, __FILE__, __LINE__, "main", 
		    	      "Cannot open POLYGON %s file '%s' for output", 
			      poly_table[poly_i].desc, output_file_path);
		} /* else */
	
		/*
	 	 * POLYGON conversion
	 	 */
		if (verbose)
		    fprintf(stderr, "Processing Polygon %s file...\n", poly_table[poly_i].desc);

	    	/*
	     	 * Write output header
	     	 */
	    	if ((output_mode == ASCII) && comments)
		{
		    fprintf(fp_output, "#\n");
		    fprintf(fp_output, "# Polygon %s file generated from input\n", poly_table[poly_i].desc);
		    fprintf(fp_output, "# file \"%s\"\n", input_file_path);
		    fprintf(fp_output, "# %s\n", time_string);
		    fprintf(fp_output, "#\n");
	    	} /* if */

		switch (poly_table[poly_i].type)
		{
		case COORDINATES:
		    {
		    	uint32		count = 0;
		    	uint32		vertex_number;
		    	float32		vector[3];

	    		while (!feof(fp_input))
	    		{
			    /*
		 	     * Read / write coordinates
		 	     */
			    switch (output_mode)
			    {
			    case ASCII:
	            	        if (fread(vector, sizeof(float32), 3, fp_input) == 3)
				{
                                    if (swapFlag) Swap32((void *) vector, (void *) vector, 3);

		    		    if (comments)
		        	        fprintf(fp_output, "%u,%f,%f,%f # coordinate[%d]\n",
					        count + 1, vector[0], vector[1], vector[2], count + 1);
		    		    else
		        	        fprintf(fp_output, "%u,%f,%f,%f\n",
					        count + 1, vector[0], vector[1], vector[2]);
			    	    ++count;
				} /* if */
		    		break;

			    case BINARY:
				Scan(fp_input);
		    		if (fscanf(fp_input, "%u,%f,%f,%f", &vertex_number, &vector[0], &vector[1], &vector[2]) > 0)
				{

                                    if (swapFlag) Swap32((void *) vector, (void *) vector, 3);
		    		    if (fwrite(vector, sizeof(float32), 3, fp_output) != 3)
				        Error(FATAL, __FILE__, __LINE__, "main", NULL);
			    	    ++count;
				} /* if */
		    		break;
			    } /* switch */
			} /* while */

			if (verbose)
			    fprintf(stderr, "\tConverted %d coordinates\n", count);
		    } /* case COORDINATES */
		    break;

		case ELEMENTS:
		    {
		    	uint32		count = 0, n_lines = 0, n_lines_swap;
		    	uint32		tag_len, tag_len_swap;
		    	uint32		n_vertices, n_vertices_swap;
		    	char		*tag = NULL, *prev_tag = NULL, *store = NULL;
			fpos_t		fpos_prev;

	    		while (!feof(fp_input))
	    		{
			    /*
		 	     * Read / write elements
		 	     */
			    switch (output_mode)
			    {
			    case ASCII:
				/*
			 	 * Read header
			 	 */
			        if (fread(&tag_len, sizeof(tag_len), 1, fp_input) == 1)
				{
				    register uint32 	line;

                                    if (swapFlag) Swap32((void *) &tag_len, (void *) &tag_len, 1);

			            Expand(&tag, tag_len * sizeof(char));
			            if (fread(tag, sizeof(char), tag_len, fp_input) != tag_len)
				        Error(FATAL, __FILE__, __LINE__, "main", NULL);

                                    /* tag is string data, so no byte swapping is necessary */

			            if (fread(&n_lines, sizeof(n_lines), 1, fp_input) != 1)
				        Error(FATAL, __FILE__, __LINE__, "main", NULL);
                                    if (swapFlag) Swap32((void *) &n_lines, (void *) &n_lines, 1);

				    for (line = 0; line < n_lines; line++)
				    {
					register uint32 i;

					if (fread(&n_vertices, sizeof(n_vertices), 1, fp_input) != 1)
				            Error(FATAL, __FILE__, __LINE__, "main", NULL);
                                        if (swapFlag) Swap32((void *) &n_vertices, (void *) &n_vertices, 1);

				        Expand(&store, n_vertices * sizeof(int32));
				        if (fread(store, sizeof(int32), n_vertices, fp_input) != n_vertices)
				            Error(FATAL, __FILE__, __LINE__, "main", NULL);
                                        if (swapFlag) Swap32((void *) store, (void *) store, n_vertices);

				        fprintf(fp_output, "%s ", tag);
				        for (i = 0; i < n_vertices; i++)
					    fprintf(fp_output, "%d ", ((int32 *)store)[i]);
				        if (comments)
					    fprintf(fp_output, "# line %d, (%s line %d, %d elements)\n",
						    count + 1, tag, line + 1, n_vertices);
				        else
					    fprintf(fp_output, "\n");
			                ++count;
				    }
				} /* if */
				break;

			    case BINARY:
				/*
				 * If starting out, make some space for the line tags
				 */
				if (count == 0)
				    Expand(&tag, 128 * sizeof(char));

				Scan(fp_input);
				if (fscanf(fp_input, "%s", tag) > 0)
				{
		    		    int32		element;

				    /*
				     * Create a header line and save the line count position
				     */
				    if ((count == 0) || (strcmp(tag, prev_tag) != 0))
				    {
					/*
					 * Fill in prior line count
					 */
					if (count != 0)
					{
					    fpos_t	fpos_curr;

					    fgetpos(fp_output, &fpos_curr);
					    fsetpos(fp_output, &fpos_prev);
                                            if (swapFlag)
                                            {
                                              Swap32((void *) &n_lines, (void *) &n_lines_swap, 1);
                                              ptr = (void *) &n_lines_swap;
                                            } else {
                                              ptr = (void *) &n_lines;
                                            }
				            if (fwrite(ptr, sizeof(n_lines), 1, fp_output) != 1)
				                Error(FATAL, __FILE__, __LINE__, "main", NULL);
					    fsetpos(fp_output, &fpos_curr);
					} /* if */

				        tag_len = strlen(tag) + 1;
                                        if (swapFlag)
                                        {
                                          Swap32((void *) &tag_len, (void *) &tag_len_swap, 1);
                                          ptr = (void *) &tag_len_swap;
                                        } else {
                                          ptr = (void *) &tag_len;
                                        }
				        if (fwrite(ptr, sizeof(tag_len), 1, fp_output) != 1)
				            Error(FATAL, __FILE__, __LINE__, "main", NULL);

                                        /* No need to swap string data */

				        if (fwrite(tag, sizeof(char), tag_len, fp_output) != tag_len)
				            Error(FATAL, __FILE__, __LINE__, "main", NULL);

					n_lines = 0;
					fgetpos(fp_output, &fpos_prev);
                                        if (swapFlag)
                                        {
                                          Swap32((void *) &n_lines, (void *) &n_lines_swap, 1);
                                          ptr = (void *) &n_lines_swap;
                                        } else {
                                          ptr = (void *) &n_lines;
                                        }
				        if (fwrite(ptr, sizeof(n_lines), 1, fp_output) != 1)
				            Error(FATAL, __FILE__, __LINE__, "main", NULL);

					Str_Dup(&prev_tag, tag);
				    } /* if */

				    n_vertices = 0;
				    Scan(fp_input);
				    while (fscanf(fp_input, "%d", &element) > 0)
				    {
				        Expand(&store, (n_vertices + 1) * sizeof(int32));
				        ((int32 *)store)[n_vertices] = element;
				        ++n_vertices;
				        Scan(fp_input);
				    } /* while */

                                    if (swapFlag)
                                    {
                                      Swap32((void *) &n_vertices, (void *) &n_vertices_swap, 1);
                                      ptr = (void *) &n_vertices_swap;
                                    } else {
                                      ptr = (void *) &n_vertices;
                                    }
				    if (fwrite(ptr, sizeof(n_vertices), 1, fp_output) != 1)
				        Error(FATAL, __FILE__, __LINE__, "main", NULL);

                                    if (swapFlag) Swap32((void *) store, (void *) store, n_vertices);
				    if (fwrite(store, sizeof(int32), n_vertices, fp_output) != n_vertices)
				        Error(FATAL, __FILE__, __LINE__, "main", NULL);

			            ++count;
				    ++n_lines;
				} /* if */
				break;
			    } /* switch */
			} /* while */

			/*
			 * Fill in outstanding prior line count, if in BINARY output mode
			 */
			if ((output_mode == BINARY) && (n_lines != 0))
			{
			    fpos_t	fpos_curr;

			    fgetpos(fp_output, &fpos_curr);
			    fsetpos(fp_output, &fpos_prev);
                            if (swapFlag)
                            {
                              Swap32((void *) &n_lines, (void *) &n_lines_swap, 1);
                              ptr = (void *) &n_lines_swap;
                            } else {
                              ptr = (void *) &n_lines;
                            }
			    if (fwrite(ptr, sizeof(n_lines), 1, fp_output) != 1)
				Error(FATAL, __FILE__, __LINE__, "main", NULL);
			    fsetpos(fp_output, &fpos_curr);
			} /* if */

			if (verbose)
			    fprintf(stderr, "\tConverted %d element records\n", count);
		    } /* ELEMENTS */
		    break;

		case NORMS:
		    {
			uint32	 	count = 0;
			float32		vector[3];

	    		while (!feof(fp_input))
	    		{
			    /*
		 	     * Read / write vector normals
		 	     */
			    switch (output_mode)
			    {
			    case ASCII:
	            	        if (fread(vector, sizeof(float32), 3, fp_input) == 3)
				{
                                    if (swapFlag) Swap32((void *) vector, (void *) vector, 3);
		    		    if (comments)
		        	        fprintf(fp_output, "%f %f %f # normal[%d]\n", vector[0], vector[1], vector[2], count + 1);
		    		    else
		        	        fprintf(fp_output, "%f %f %f\n", vector[0], vector[1], vector[2]);
			    	    ++count;
				} /* if */
				break;

			    case BINARY:
				Scan(fp_input);
		    		if (fscanf(fp_input, "%f %f %f", &vector[0], &vector[1], &vector[2]) > 0)
				{
                                    if (swapFlag) Swap32((void *) vector, (void *) vector, 3);
		    		    if (fwrite(vector, sizeof(float32), 3, fp_output) != 3)
				        Error(FATAL, __FILE__, __LINE__, "main", NULL);
			    	    ++count;
				} /* if */
		    		break;
			    } /* switch */
			} /* while */

			if (verbose)
			    fprintf(stderr, "\tConverted %d normals\n", count);
		    } /* NORMS */
		    break;
		} /* switch */

		fflush(fp_output);

		if (fp_input != stdin)
	    	    fclose(fp_input);
		if (fp_output != stdout)
	    	    fclose(fp_output);
	    } /* for */
	} /* case POLYGON */
	break;

    } /* switch */
} /* main */
