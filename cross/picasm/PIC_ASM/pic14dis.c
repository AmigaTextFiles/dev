/*
 * pic14dis.c
 *
 * Disassembler for 14-bit Microchip PIC chips
 * Reads IHX8M-format
 *
 * Timo Rossi <trossi@jyu.fi>, Feb 1995
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *fp;
int pc = 0;

static int hexnibble(int c)
{
  if(c >= '0' && c <= '9') return c - '0';
  if(c >= 'A' && c <= 'F') return c - ('A' - 10);
  if(c >= 'a' && c <= 'f') return c - ('a' - 10);

  fprintf(stderr, "Invalid hex digit '%c'\n", c);
  exit(EXIT_FAILURE);
}

static int hexbyte(char *s)
{
  return 16 * hexnibble(s[0]) + hexnibble(s[1]);
}

static int hexword(char *s)
{
  return 256 * hexbyte(s) + hexbyte(s + 2);
}

/*
 * Read one PIC instruction word from object file
 *
 * The object file is in intel-hex-style format
 *
 */
static int read_instr_word(FILE *fp)
{
  static char buf[256];
  static char *bp = NULL;
  static int cnt, check, b, c;

  if(bp == NULL)
    {
      do
	{
	  if(fgets(buf, sizeof(buf)-1, fp) == NULL)
	    {
	      fprintf(stderr, "Error: Premature EOF in object file\n");
	      exit(EXIT_FAILURE);
	    }
	  if(buf[0] != ':')
	    continue;

	  if(strlen(buf) < 10)
	    {
	      fprintf(stderr, "Error: hex format line too short\n");
	      exit(EXIT_FAILURE);
	    }

	  b = hexbyte(&buf[7]);

	} while(b != 0 && b != 1);

      if(b == 1)
	return -1; /* end of object file */

      cnt = hexbyte(&buf[1]);
      pc = hexword(&buf[3]);
      if((cnt & 1) != 0 || (pc & 1) != 0)
	{
	  fprintf(stderr, "Error: Odd length/address\n");
	  exit(EXIT_FAILURE);
	}

      check = cnt + (pc >> 8) + (pc & 0xff);

      cnt >>= 1;
      pc >>= 1;

      bp = &buf[9];
    }

  b = hexbyte(bp);
  check += b;
  bp += 2;

  c = hexbyte(bp);
  check += c;
  bp += 2;

  if(--cnt <= 0)
    {
      if(((0x100 - (check & 0xff)) & 0xff) != hexbyte(bp))
	{
	  fprintf(stderr, "Object file checksum error\n");
	  exit(EXIT_FAILURE);
	}
      bp = NULL;
    }

  return b | ((c & 0x3f) << 8);
}

static char *z00_instr_names[] = {
  "???",    "clrf",  "subwf", "decf",
  "iorwf", "andwf", "xorwf", "addwf",
  "movf",  "comf",  "incf",  "decfsz",
  "rrf",   "rlf",   "swapf", "incfsz"
};

static char *z01_instr_names[] = {
  "bcf", "bsf", "btfsc", "btfss"
};

static char *z11_instr_names[] = {
  "movlw", "movlw", "movlw", "movlw",
  "retlw", "retlw", "retlw", "retlw",
  "iorlw", "andlw", "xorlw", "???",
  "sublw", "sublw", "addlw", "addlw"
};

static char *oscs[] = {
  "LP", "XT", "HS", "RC"
};

/*
 * main program
 */
main(int argc, char *argv[])
{
  int c;

  if(argc != 2)
    {
      fprintf(stderr, "Usage: pic84dis <filename>\n");
      exit(EXIT_FAILURE);
    }

  if((fp = fopen(argv[1], "rb")) == NULL)
    {
      fprintf(stderr, "Can't open file '%s'\n", argv[1]);
      exit(EXIT_FAILURE);
    }

  while((c = read_instr_word(fp)) >= 0)
    {
      printf("%04x:  %04x\t", pc, c);

      if(pc >= 0x2000)
	{
	  if(pc < 0x2004)
	    {
	      c &= 0x7f;
	      if(c == 0x7f || c < 0x20)
		printf("ID\n");
	      else
		printf("ID '%c'\n", c);
	    }
	  else if(pc == 0x2007)
	    printf("Fuses (CP=%s, PWRTE=%s, WDTE=%s, OSC=%s)\n",
		   (c & 0x10 ? "Off" : "On"),
		   (c & 8 ? "Enabled" : "Disabled"),
		   (c & 4 ? "Enabled" : "Disabled"),
		   oscs[c&3]);
	  else
	    putchar('\n');

	  pc++;
	  continue;
	}

      switch(c >> 12)
	{
	  case 0:
	    if((c & 0x3f00) == 0)
	      {
		if(c & 0x80)
		  printf("movwf\t%02x\n", c & 0x7f);
		else
		  switch(c)
		    {
		      case 0x00: case 0x20: case 0x40: case 0x60:
		        printf("nop\n");
		        break;

		      case 0x08:
			printf("return\n");
			break;

		      case 0x09:
			printf("retfie\n");
			break;

		      case 0x62:
			printf("option\n");
			break;

		      case 0x63:
			printf("sleep\n");
			break;

		      case 0x64:
			printf("clrwdt\n");
			break;

		      case 0x65: case 0x66: case 0x67:
			printf("tris\t%02x\n", c & 7);
			break;

		      default:
			printf("???\n");
			break;
		    }
	      }
	    else
	      {
		if((c & 0x3f80) == 0x100)
		  printf("clrw\n");
		else
		  printf("%s\t%02x,%s\n",
			 z00_instr_names[(c >> 8) & 0xf],
			 c & 0x7f, (c & 0x80 ? "f" : "w"));
	      }
	    break;

	  case 1:
	    printf("%s\t%02x,%d\n",
		   z01_instr_names[(c >> 10) & 3], c & 0x7f, (c >> 7) & 7);
	    break;

	  case 2:
	    printf("%s\t%04x\n", (c & 0x800 ? "goto" : "call"), c & 0x7ff);
	    break;

	  case 3:
	    printf("%s\t%02x\n",
		   z11_instr_names[(c >> 8) & 0xf],
		   c & 0xff);
	    break;
	}

      pc++;
    }

  fclose(fp);
  exit(EXIT_SUCCESS);
}
