
/* BinToObj -- Version 1.0 -- Copyright (C) 1991 by Ray Burr
   Converts a raw binary file to an Amiga Hunk format object file. */

/*
  Copyright Notice (I'd use the GNU GPL but it's bigger than this
  source file):

  This program may be freely copied and redistributed under the condition
  that the source code and documentation is distributed with it.  Modified
  versions may be distributed if this notice is left here unchanged and
  the history, including credit to the original author, is clearly
  documented.
*/

/*
  HISTORY:

  (911201 ryb) Created.

*/

#include <stddef.h>	/* Needed for size_t in Lattice C Version 5.04 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Hacks to make perfect :-) ANSI C code work under Lattice C. */

#ifndef EXIT_SUCCESS
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 20
#endif

#ifndef SEEK_END
#define SEEK_END 2
#endif

/* More space efficient than isdigit() in some C library implemintations. */
#define CHAR_DIGIT_P(c) ((c) >= '0' && (c) <= '9')

#define HUNK_UNIT    0x03e7
#define HUNK_DATA    0x03ea
#define HUNK_EXT     0x03ef
#define HUNK_END     0x03f2

#define EXT_DEF      0x01
#define EXT_ABS      0x02

#define HUNK_FAST (1 << 31)
#define HUNK_CHIP (1 << 30)

#define TRUE 1
#define FALSE 0

#define BUFFER_SIZE 4096

char *program_name = "BinToHunk";

/* Common error messages. */
char *write_error_msg = "Error writing output file";
char *length_error_msg = "Couldn't determine input file's length";

/* Define `BOOTSTRAP' if you don't already have a working BinToHunk
   executable to convert usage.txt to usage.o. */
#ifndef BOOTSTRAP
/* Usage message in file usage.o which was created by BinToHunk.
   (Couldn't resist it.) */
extern char usage_message[];
#else
/* Temporary definition to make linker happy. */
char *usage_message = "*** BOOTSTRAP Version ***\n";
#endif

/* Print an error message after in I/O error and exit with error status. */

static void
pfail (const char *message)
{
  fprintf (stderr, "%s: ", program_name);
  perror (message);
  exit (EXIT_FAILURE);
}

/* Print an error message and exit with error status. */

static void
fail (const char *message)
{
  fprintf (stderr, "%s: %s", program_name, message);
  exit (EXIT_FAILURE);
}

/* Allocate memory and handle failure. */

static void *
xmalloc (size_t size)
{
  void *block;
  block = malloc (size);
  if (!block)
    fail ("Couldn't allocate memory");
  return block;
}

/* Write the 32-bit value LONGWORD to the stream STREAM in big-endian byte
   order and handle errors. */

#ifdef __GNUC__
__inline__
#endif
static void
putl (FILE *stream, long longword)
{
  long lw = longword;
  /* This assumes big endian byte order. */
  if (fwrite (&lw, sizeof (long), 1, stream) < 1)
    pfail (write_error_msg);
}

/* Write LENGTH bytes of VALUE to OUTFILE. */

#ifdef __GNUC__
__inline__
#endif
static void
write_pad (FILE *outfile, int value, size_t length)
{
  while (length-- > 0)
    if (fputc (value, outfile) == EOF)
      pfail (write_error_msg);
}

/* Write LENGTH bytes to OUTFILE representing TERMINATOR in big-endian byte
   order.  TERMINATOR is a two's-compliment signed value and will be sign
   extended. */

#ifdef __GNUC__
__inline__
#endif
static void
write_terminator (FILE *outfile, int terminator, int length)
{
  if (length == 0)
    return;
  if (length > sizeof (int))
    {
      write_pad (outfile, (terminator < 0 ? -1 : 0), length - sizeof (int));
      length = 4;
    }
  /* This assumes big endian byte order. */
  if (fwrite (&terminator + 4 - length, 1, length, outfile) < length)
    pfail (write_error_msg);
}

/* Determine length of file STREAM was opened with.  Moves file position
   to the begining.  Exits with a message if it is unsuccessful. */

static size_t
file_length (FILE *stream)
{
  long length;

  if (fseek (stream, 0, SEEK_END))
    pfail (length_error_msg);
  length = ftell (stream);
  if (length < 0)
    pfail (length_error_msg);
  rewind (stream);
  return (size_t) length;
}

/* Copy INFILE to OUTFILE until INFILE reaches end-of-file.  This function
   allocates a buffer who's size is determined by the BUFFER_SIZE macro
   symbol.  I/O errors cause a call to pfail(). */

static void
copy_data (FILE *infile, FILE *outfile)
{
  void *buffer;
  size_t bytes_read;

  buffer = xmalloc (BUFFER_SIZE);
  while (!feof (infile))
    {
      bytes_read = fread (buffer, 1, BUFFER_SIZE, infile);
      if (ferror (infile))
        pfail ("Error reading input file");
      if (bytes_read <= 0)
        continue;
      fwrite (buffer, 1, bytes_read, outfile);
      if (ferror (outfile))
        pfail (write_error_msg);
    }
  free (buffer);
}

/* Write NAME to OUTFILE as a name in the format used in Amiga Hunk object
   files; a longword of length in longwords, and a name padded to a longword
   boundry with zeros.  EXT_TYPE is a value that will be put in the first
   (most significant) byte of the length longword. */

static void
write_name (FILE *outfile, const char *name, int ext_type)
{
  size_t name_length, pad_length;

  name_length = strlen (name);
  pad_length = 3 - (name_length + 3) % 4;
  putl (outfile, ((name_length + 3) / 4) | (ext_type << 24));
  if (fwrite (name, 1, name_length, outfile) < name_length)
    pfail (write_error_msg);
  write_pad (outfile, 0, pad_length);
}

/* Display a usage message and exit with success status. */

static void
usage (void)
{
  fputs (usage_message, stderr);
  exit (EXIT_SUCCESS);
}

/* Displays MESSAGE, if it is non-NULL, and a message saying how to get
   usage information.  Exits with failure status. */

static void
fail_with_usage (const char *message)
{
  if (message)
    fprintf (stderr, "%s: %s\n", program_name, message);
  fprintf (stderr, "Type `%s -?' for usage.\n", program_name);
  exit (EXIT_FAILURE);
}

/* Point of entry. */

void
main (int argc, char *argv[])
{
  FILE *infile, *outfile;	/* Streams for the input and output files. */
  char *infile_name;		/* Name of the input file. */
  char *outfile_name;		/* Name of the output file. */
  char *block_ident;		/* Name of the indentifier for the array. */
  char *block_length_ident;	/* Name of the indentifier specifying the
				   length of the array. */
  long terminator;		/* The value of the terminator object. */
  long term_length;		/* Number of bytes in the terminator.  Zero
                                   means no terminator. */
  long memory_mode;		/* Tells the loader where to load the hunk. */
  int nolength_flag;		/* Flag: Don't define a length symbol. */
  int absolute_flag;		/* Flag: Use an absolute symbol definition for
				   the length. */
  char *base;			/* Base of input filename. (dir/base.txt) */
  size_t base_length;		/* Length of base input filename. */
  int i, arg_count;		/* Counters for arg processing. */
  size_t pad_length;		/* Number of bytes to make data an even number
				   of longwords. */
  size_t length;		/* The length of the input file in bytes. */
  size_t object_size;		/* The size of one item in the array. */
  size_t num_objects;		/* Number of objects read in. */
  size_t total_length;		/* Length of data before longword padding. */
  int object_pad_length;	/* Number of bytes to pad data to an
				   even number of objects. */
  int data_lw_length;		/* Total number of longwords in data. */

  /* Set some defaults. */
  nolength_flag = FALSE;
  absolute_flag = FALSE;
  term_length = 0;
  terminator = 0;
  object_size = 1;
  memory_mode = 0;

  infile_name = NULL;
  outfile_name = NULL;
  block_ident = NULL;
  block_length_ident = NULL;

  /* Format users hard disk if no arguments are given. */
  if (argc <= 1)
    usage ();

  /* Parse argument line. */
  arg_count = 0;
  for (i = 1; i < argc; ++i)
    {
      if (!strcmp (argv[i], "?"))
        usage ();
      if (argv[i][0] == '-')
	{
	  /* Deal with options. */
	  switch (argv[i][1])
	    {
	    case 'c':
	    case 'C':
	      memory_mode |= HUNK_CHIP;
	      goto no_arg;
	    case 'f':
	    case 'F':
	      memory_mode |= HUNK_FAST;
	      goto no_arg;
	    case 'l':
	    case 'L':
	      nolength_flag = TRUE;
	      goto no_arg;
	    case 'a':
	    case 'A':
	      absolute_flag = TRUE;
	      goto no_arg;
	    case 't':
	    case 'T':
	      term_length = -1;	/* Turns into the length of one object. */
	      terminator = 0;	/* The default. */
              if (argv[i][2] == '\0')
		break;
	      if (!CHAR_DIGIT_P (argv[i][2])
                  && !(argv[i][2] == '-' && CHAR_DIGIT_P (argv[i][3])))
		fail_with_usage ("Invalid argument to -t");
	      terminator = atoi (argv[i] + 2);
	      break;
	    case 's':
	    case 'S':
	      if (!CHAR_DIGIT_P (argv[i][2]))
		fail_with_usage ("Invalid argument to -s");
	      object_size = atoi (argv[i] + 2);
	      if (object_size <= 0)
		fail_with_usage ("Bad value for -s option");
	      break;
	    case '?':
	      usage ();
	      break;
	    no_arg:
	      /* Verify that no argument to the option was given. */
	      if (argv[i][2] != 0)
		{
		  fprintf (stderr,
			   "%s: Option `-%c' does not take an argument\n",
			   program_name, argv[i][1]);
		  fail_with_usage (NULL);
		}
	      break;
	    case '\0':
	    default:
	      fprintf (stderr, "%s: Bad option `%s'\n",
                       program_name, argv[i]);
	      fail_with_usage (NULL);
	      break;
	    }
	}
      else
	{
	  /* Assign non-option arguments to variables. */
	  switch (arg_count)
            {
	    case 0:
	      infile_name = argv[i];
	      break;
	    case 1:
	      outfile_name = argv[i];
	      break;
	    case 2:
	      block_ident = argv[i];
	      break;
	    case 3:
	      block_length_ident = argv[i];
	      break;
	    default:
	      fail_with_usage ("Too many arguments");
	      break;
            }
          ++arg_count;
	}
    }

  if (arg_count == 0)
    fail_with_usage ("No output filename");

  /* A negative TERM_LENGTH means use units of object_size bytes. */
  if (term_length < 0)
    term_length = object_size * -term_length;

  /* Find the base name of INFILE_NAME. */
  base = strrchr (infile_name, '/');
  if (base == NULL)
    base = strrchr (infile_name, ':');
  if (base == NULL)
    base = infile_name;

  /* Find the length of the base name of INFILE_NAME. */
  {
    char *dot;
    dot = strrchr (infile_name, '.');
    if (dot == NULL)
      base_length = strlen (base);
    else
      base_length = dot - base;
  }

  /* Default output filename is BASE with ".o" appened. */
  if (outfile_name == NULL)
    {
      outfile_name = xmalloc (base_length + 3);
      memcpy (outfile_name, base, base_length);
      strcpy (outfile_name + base_length, ".o");
    }

  /* Default BLOCK_IDENT is BASE with "_" prepended. */
  if (block_ident == NULL)
    {
      block_ident = xmalloc (base_length + 2);
      block_ident[0] = '_';
      memcpy (block_ident + 1, base, base_length);
      block_ident[base_length + 1] = '\0';
    }

  /* Default BLOCK_LENGTH_IDENT is BASE with "_" prepended and "_length"
     appended. */
  if (block_length_ident == NULL && !nolength_flag)
    {
      block_length_ident = xmalloc (strlen (block_ident) + 8);
      strcpy (block_length_ident, block_ident);
      strcat (block_length_ident, "_length");
    }

  /* Open output file in binary mode. */
  outfile = fopen (outfile_name, "wb");
  if (outfile == NULL)
    pfail ("Can't open output file");

  /* Start un-named program unit. */
  putl (outfile, HUNK_UNIT);
  putl (outfile, 0);

  /* Start data block. */
  putl (outfile, HUNK_DATA);

  /* Open input file in binary mode. */
  infile = fopen (infile_name, "rb");
  if (infile == NULL)
    pfail ("Can't open input file");

  /* Find length of input file. */
  length = file_length (infile);

  /* Calculate the number of objects.  Any bytes left over are counted as
     an object. */
  num_objects = (length + object_size - 1) / object_size;

  /* Calculate the number of bytes needed to make the array's length an
     even multiple of OBJECT_SIZE. */
  object_pad_length = num_objects * object_size - length;

  /* Find the total length of all the data used in the data block. */
  total_length = length + object_pad_length + term_length;

  /* Find the total number of longwords in the data block. */
  data_lw_length = (total_length + 3) / 4;

  /* Find the number of bytes needed to make the data block an even number
     of longwords. */
  pad_length = data_lw_length * 4 - total_length;

  /* Account for length variable. */
  if (block_length_ident != NULL && !absolute_flag)
    data_lw_length += 1;

  /* Output the length of the data block and attach memory attribute flags. */
  putl (outfile, data_lw_length | memory_mode);

  /* If needed, output the length of the array in objects as the first
     longword of the data block. */
  if (block_length_ident && !absolute_flag)
    putl (outfile, num_objects);

  /* Copy the array from the input file. */
  copy_data (infile, outfile);

  /* Close the input file. */
  if (fclose (infile))
    pfail ("Error closing input file");

  /* Align to object size. */
  write_pad (outfile, 0, object_pad_length);

  /* Write the (possibly zero length) terminator. */
  write_terminator (outfile, terminator, term_length);

  /* Align to longword. */
  write_pad (outfile, 0, pad_length);

  /* Now start the external symbol block. */
  putl (outfile, HUNK_EXT);

  /* Write a symbol data unit defining BLOCK_IDENT as a symbol
     relative to the start of the data block. */
  write_name (outfile, block_ident, EXT_DEF);
  putl (outfile, (block_length_ident && !absolute_flag) ? 4 : 0);

  /* If an array length symbol is wanted... */
  if (block_length_ident)
    {
      if (absolute_flag)
	{
          /* Write a symbol data unit defining BLOCK_LENGTH_IDENT as an
	     absolute symbol defining the number of objects. */
	  write_name (outfile, block_length_ident, EXT_ABS);
	  putl (outfile, num_objects);
	}
      else
	{
          /* Write a symbol data unit defining BLOCK_LENGTH_IDENT as a
	     symbol relative to the start of the data block. */
          write_name (outfile, block_length_ident, EXT_DEF);
	  putl (outfile, 0);
	}
    }

  /* End the external symbol block. */
  putl (outfile, 0);

  /* End the hunk and the program unit. */
  putl (outfile, HUNK_END);

  /* Close the output file. */
  if (fclose (outfile))
    pfail ("Error closing output file");

  /* Later. */
  exit (EXIT_SUCCESS);
}
