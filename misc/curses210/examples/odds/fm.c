/*
   
   f m . c
   
   - curses-based binary file modifier
   - default for terminfo curses
   - compile with -DM_TERMCAP for termcap curses (an after-thought...)
   - seems to work on files, devices, and directories(read only)
   - developed for AT&T Unix 3.2.2 and  Xenix 2.3.2  (System V/386)
   
   Copyright (c) Tony Field  April-1990
   
   Permission is given to distribute the source and documentation files
   and/or compiled binaries associated with fm as long as no monies are
   exchanged for their use or distribution.
   
   No responsibility is taken for any errors on inaccuracies inherent
   either to the comments or the code of this program, but, if reported
   to me, an attempt will be made to fix them.
   
   Author:  Tony Field
   tony@ajfcal
*/


#ifdef AMIGA
#define M_TERMCAP
#endif /* AMIGA */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <ctype.h>
#include <curses.h>

#ifndef AMIGA
#define min(x,y) (((x) < (y)) ? (x) : (y))
#define max(x,y) (((x) > (y)) ? (x) : (y))
#endif /* AMIGA */

#define BSIZE 256      /* size of window onto file */
#define FIRSTL 3      /*  first screen line    */
#define FIRSTH 6      /* first hex column   */
#define FIRSTA 58      /* first alpha column   */

#define FWD  ('F' & 0x1f)   /* next page     */
#define BAK  ('B' & 0x1f)   /*  previous page    */

#define DON  ('d' & 0x1f)   /* done/quit     */
#define ASC  ('a' & 0x1f)   /* ascii side     */
#define HEX  ('h' & 0x1f)   /* hex side     */
#define UND  ('u' & 0x1f)   /* undo current changes  */
#define JMP  ('g' & 0x1f)   /* goto address    */
#define STX  ('t' & 0x1f)   /* text (ascii) search   */
#define SHX  ('x' & 0x1f)   /* number (hex) search   */
#define PRI  ('p' & 0x1f)   /* print to file    */

char hex[] = "0123456789abcdef";
int  byte_pos;     /* current byte editing in buffer */
int  maybe_dirty;    /* user may have changed data  */

main (argc, argv)
     int  argc;
     char *argv[];
{
  int  fp;
  char fname[200];
  char fbuf[BSIZE];  /* file i/o buffer   */
  char wbuf[BSIZE];  /* work buffer copy of fbuf*/
  long fpos, fsearch;  /* current file position */
  long max_fpos;   /* end of file byte  */
  int  nbytes;    /* number of bytes read */
  int  key, yesno;
  char resp[100];   /* user response   */
  char stext[100];   /* last ascii search string*/
  char shex[100];   /* last hex search string */
  char hexstring[50];
  long search ();   /* search function   */
  int  nn;
  struct stat statbuf;
  int  rwmode;    /* file r/w or r/o mode */
  FILE *pfile = NULL;  /* print file    */
  
  if (argc == 1)
    usage ();
  
  /* determine size - for directories or regular files.  */
  
  strcpy (fname, argv[1]);
  stat (fname, &statbuf);
  if ((statbuf.st_mode & S_IFMT) == S_IFDIR
      ||  (statbuf.st_mode & S_IFMT) == S_IFREG)
    max_fpos = (long) statbuf.st_size;
  else
    max_fpos = 1999999999;  /* infinity??? */
  
  if ((fp = open (fname, O_RDWR)) == -1)
    { if ((fp = open (fname, O_RDONLY)) == -1)
	{ printf ("file %s is unavailable\n", fname);
	  exit (1);
	}
      rwmode = 0;     /* read only */
    }
  else
    rwmode = 1;     /* read/write */
  
  initscr ();
  erase ();
  noecho ();
#ifdef M_TERMCAP
  raw ();
  nl();
#endif
  keypad (stdscr, TRUE);
  key = 0;
  fpos = 0;
  byte_pos = 0;
  stext[0] = '\0';
  shex[0] = '\0';
  
  while (key != DON)
    {
      switch (key)
	{
	case FWD:        /* next screen load  */
	  if (fpos + BSIZE < max_fpos)
	    { fpos += BSIZE;
	    }
	  break;
	  
	case BAK:        /* previous screen load */
	  fpos -= BSIZE;
	  if (fpos < 0L)
	    { fpos = 0L;
	      byte_pos = 0;
	    }
	  break;
	  
	case JMP:        /* goto byte address  */
	  echo ();
	  mvwaddstr (stdscr, 1, 20, "jump address = ");
	  wclrtoeol (stdscr);
#ifdef M_TERMCAP
	  wrefresh (stdscr);
#endif
	  wgetstr (stdscr, resp);
	  sscanf (resp, "%lx", &fpos);
	  if (fpos < 0)
	    fpos = 0;
	  else if (fpos > max_fpos)
	    fpos = max_fpos;
	  byte_pos = fpos & 0x0ff;
	  fpos &= ~((long) BSIZE - 1);
	  noecho ();
	  break;
	  
	case STX:        /* search ascii text  */
	  echo ();
	  if (*stext)
	    mvwprintw (stdscr, 2, 20, "( / = use '%s')", stext);
	  mvwaddstr (stdscr, 1, 20, "ascii search = ");
	  wclrtoeol (stdscr);
#ifdef M_TERMCAP
	  wrefresh (stdscr);
#endif
	  wgetstr (stdscr, resp);
	  noecho ();
	  if (resp[0] == '/'  &&  resp[1] == '\0')
	    strcpy (resp, stext);
	  else
	    if (*resp)
	      strcpy (stext, resp);
	  if ((fsearch = search (fp, resp, strlen (resp), fpos + byte_pos + 1)) != -1)
	    { fpos = fsearch;
	      byte_pos = fpos & 0x0ff;
	      fpos &= ~((long) BSIZE - 1);
	    }
	  break;
	  
	case SHX:        /* search hex string  */
	  echo ();
	  if (*shex)
	    mvwprintw (stdscr, 2, 20, "( / = use '%s')", shex);
	  mvwaddstr (stdscr, 1, 20, "hex search = ");
	  wclrtoeol (stdscr);
#ifdef M_TERMCAP
	  wrefresh (stdscr);
#endif
	  wgetstr (stdscr, resp);
	  if (resp[0] == '/'  &&  resp[1] == '\0')
	    strcpy (resp, shex);
	  else
	    if (*resp)
	      strcpy (shex, resp);
	  nn = cvthex (resp, hexstring);
	  noecho ();
	  if ((fsearch = search (fp, hexstring, nn, fpos + byte_pos + 1)) != -1)
	    { fpos = fsearch;
	      byte_pos = fpos & 0x0ff;
	      fpos &= ~((long) BSIZE - 1);
	    }
	  break;
	  
	case PRI:
	  if (pfile == NULL)
	    {
	      echo ();
	      mvwaddstr (stdscr, 1, 20, "print file = ");
	      wclrtoeol (stdscr);
#ifdef M_TERMCAP
	      wrefresh (stdscr);
#endif
	      wgetstr (stdscr, resp);
	      if (resp[0] == '\0')
		{ noecho ();
		  break;
		}
	      if ((pfile = fopen (resp, "a+")) == NULL)
		{ noecho ();
		  break;
		}
	    }
	  else
	    echo ();
	  
	  mvwaddstr (stdscr, 1, 20, "print comment = ");
	  wclrtoeol (stdscr);
#ifdef M_TERMCAP
	  wrefresh (stdscr);
#endif
	  wgetstr (stdscr, resp);
	  noecho ();
	  printit (pfile, resp, fname, fpos + byte_pos, wbuf, nbytes, rwmode);
	  break;  
	  
	case UND:        /* undo current changes */
	  break;
	  
	default: ;
	}
      
      /* get a 256 byte block of file.  copy to a working buffer (wbuf) */
      
      lseek (fp, fpos, 0);
      nbytes = read (fp, fbuf, BSIZE);
      memcpy (wbuf, fbuf, nbytes);
      maybe_dirty = 0;
      display (fname, fpos, wbuf, nbytes, rwmode);
      wrefresh (stdscr);
      
      /* allow user to modify file  */
      
      if ((key = edit (wbuf, nbytes, fpos, rwmode)) != UND)
	{ if (rwmode  &&  maybe_dirty  &&  memcmp (fbuf, wbuf, BSIZE))
	    {
	      echo ();
	      mvwaddstr (stdscr, 1, 20, "apply changes (y/n): ");
#ifdef M_TERMCAP
	      wrefresh (stdscr);
#endif
	      yesno = wgetch (stdscr);
	      noecho ();
	      if (tolower (yesno) == 'y')
		{ lseek (fp, fpos, 0);
		  write (fp, wbuf, nbytes);
		}
	      else
		memcpy (wbuf, fbuf, nbytes);  /* in case PRInt */
	    }
	}
    }
#ifdef M_TERMCAP
  wrefresh (stdscr);
#endif
  if (pfile)
    fclose (pfile);
  close (fp);
  wmove (stdscr, LINES-1, 0);
  wclrtobot (stdscr);
  refresh ();
  noraw ();
  echo ();
  endwin ();
  exit (0);
}

/************************************************************************
 * display ()               *
 * display a 256 byte block of file with hex on left and alpha   *
 * on right side.              *
 ************************************************************************/

display (fname, fpos, wbuf, nbytes, rwmode)
     char *fname;    /* file name        */
     long fpos;    /* byte # within the file     */
     char wbuf[];    /* working data buffer      */
     int  nbytes;    /* number of bytes in wbuf     */
     int  rwmode;    /* read/write or readonly     */
{ int  i, j, k, m;
  char hbuf[2];  /* working buf to convert byte to hex  */
  
  erase ();
  wmove (stdscr, 0,0);
  wprintw (stdscr, "File: %s    %s\nByte: %lx", 
	   fname, rwmode ? "\0" : "(read only)", fpos);
  
  for (i = 0, j = FIRSTL;  i < nbytes;  i += 16, j++)
    {
      /* display hex side  */
      
      wmove (stdscr, j, 0);
      wprintw (stdscr, "%02x", i);
      wmove (stdscr, j, FIRSTH);
      for (k = 0, m = i; k < 48  &&  m < nbytes;  k += 3, m++)
	{ ttox (hbuf, wbuf[m]);
	  waddch (stdscr, hbuf[0]);
	  waddch (stdscr, hbuf[1]);
	  waddch (stdscr, ' ');
	}
      
      /* display ascii side */
      
      wmove (stdscr, j, FIRSTA);
      for (k = 0, m = i;  k < 16 &&  m < nbytes;  k++, m++)
	waddch (stdscr, ttoa (wbuf[m]));
      
    }
  
  /* bottom annotation */
  
  for (i = 0;  i < 16;  i++)
    { wmove (stdscr, j + 1, i * 3 + FIRSTH);
      waddch (stdscr, hex[i]);
    }
  wmove (stdscr, j + 1, FIRSTA);
  waddstr (stdscr, "0123456789abcdef");
  wmove (stdscr, 22, 0);
  waddstr (stdscr, " ^f/pgdn=forward   ^h/f1=hex    ^x/f3=find hex    ^u/f5=undo   ^g/f7 =goto");
  wmove (stdscr, 23, 0);
  waddstr (stdscr, " ^b/pgup=backward  ^a/f2=ascii  ^t/f4=find ascii  ^p/f6=print  ^d/f10=done");
}


/************************************************************************
 * printit ()               *
 * display a 256 byte block of file with hex on left and alpha   *
 * on right side to a print file.          *
 ************************************************************************/

printit (pfile, comment, fname, fpos, wbuf, nbytes, rwmode)
     FILE *pfile;    /* print file        */
     char *comment;   /* comment note       */
     char *fname;    /* file name        */
     long fpos;    /* byte # within the file     */
     char wbuf[];    /* working data buffer      */
     int  nbytes;    /* number of bytes in wbuf     */
     int  rwmode;    /* read/write or readonly     */
{ int  i, j, k, m;
  char hbuf[2];  /* working buf to convert byte to hex  */
  
  fprintf (pfile, "File: %s    %s\nByte: %lx      %s\n", 
	   fname, rwmode ? "\0" : "(read only)", fpos, comment);
  
  for (i = 0, j = FIRSTL;  i < nbytes;  i += 16, j++)
    {
      /* display hex side  */
      
      fprintf (pfile, "%02x    ", i);
      for (k = 0, m = i; k < 48  &&  m < nbytes;  k += 3, m++)
	{ ttox (hbuf, wbuf[m]);
	  fputc (hbuf[0], pfile);
	  fputc (hbuf[1], pfile);
	  fputc (' ', pfile);
	}
      /* display ascii side */
      
      fprintf (pfile, "   ");
      for (k = 0, m = i;  k < 16 &&  m < nbytes;  k++, m++)
	fputc (ttoa (wbuf[m]), pfile);
      
      fprintf (pfile, "\n");
    }
  /* bottom annotation */
  
  fprintf (pfile, "      "); 
  for (i = 0;  i < 16;  i++)
    fprintf (pfile, "%c  ", hex[i]);
  fprintf (pfile, "   0123456789abcdef\n\n");
}


/************************************************************************
 * edit ()                *
 * allow user to modify the 256 byte block of text.     *
 ************************************************************************/

edit (wbuf, nbytes, fpos, rwmode)
     char *wbuf;    /* working data buffer      */
     int  nbytes;    /* number of bytes in wbuf     */
     long fpos;    /* byte # in file       */
     int  rwmode;    /* 1 = r/w  0 = read only     */
{
  int key;     /* user entered this key    */
  static int vmode = HEX;  /* remember hex/ascii side of screen */
  int  x, y;    /* screen coords.      */
  int  hexa, hexb, cbyte; 
  int  reflected;   /* was a change really done   */
  
  if (byte_pos >= nbytes)  
    byte_pos = nbytes - 1;
  if (byte_pos < 0)
    byte_pos = 0;
  
  while (1)
    {
      mvwprintw (stdscr, 1, 6, "%lx     ",  fpos + byte_pos);
      whereis (byte_pos, vmode, &x, &y);
#ifdef M_TERMCAP
      wmove (stdscr, y, x);
      wrefresh (stdscr);
#endif
      key = mvwgetch (stdscr, y, x);
      
      switch (key)   /* any user keys or function keys */
	{
	case FWD:
	case KEY_NPAGE:
	  return (FWD);
	  break;
	  
	case BAK:
	case KEY_PPAGE:
	  return (BAK);
	  break;
	  
	case KEY_UP:
	  if (byte_pos - 16 >= 0)
	    { byte_pos -= 16;
	    }
	  break;
	  
	case KEY_DOWN:
	  if (byte_pos + 16 < nbytes)
	    { byte_pos += 16;
	    }
	  break;
	  
	case KEY_LEFT:
	  if (byte_pos - 1 >= 0)
	    { byte_pos -= 1;
	    }
	  break;
	  
	case '\n':
	case KEY_RIGHT:
	  if (byte_pos + 1 < nbytes)
	    { byte_pos += 1;
	    }
	  break;
	  
	case HEX:
	case KEY_F(1):
	  vmode = HEX;
	  break;
	  
	case ASC:
	case KEY_F(2):
	  vmode = ASC;
	  break;
	  
	case SHX:
	case KEY_F(3):
	  vmode = HEX;
	  return (SHX);
	  break;
	  
	case STX:
	case KEY_F(4):
	  vmode = ASC;
	  return (STX);
	  break;
	  
	case UND:
	case KEY_F(5):
	case KEY_UNDO:
	  return (UND);
	  break;
	  
	case PRI:
	case KEY_F(6):
	  return (PRI);
	  break;
	  
	case JMP:
	case KEY_F(7):
	  return (JMP);
	  break;
	  
	case DON:
#ifdef M_XENIX
	case KEY_F(0):
#else
	case KEY_F(10):
#endif
	  return (DON);
	  break;
	  
	default: 
	  if (rwmode == 0)
	    break;
	  
	  /* user typed a key.   If in the ascii side,
	     allow the overstrike of the ascii value
	     If in the hex side, ensure user types
	     valid hex digits.
	     
	     reflect changes on both sides of the
	     display.
	     */
	  
	  reflected = 0;
	  if (vmode == ASC)
	    { if (isvalid (key))
		{ wattrset (stdscr, A_STANDOUT);
		  waddch (stdscr, key);
#ifdef M_TERMCAP
		  wrefresh (stdscr);
#endif
		  maybe_dirty = 1;
		  wbuf[byte_pos] = key;
		  reflect_change (byte_pos, HEX, wbuf);
		  reflected = 1;
		}
	    }
	  else
	    { hexa = hexb = 0;
	      if (isxdigit (key))     /* 1st nibble  */
		{ wattrset (stdscr, A_STANDOUT);
		  waddch (stdscr, key);
#ifdef M_TERMCAP
		  wrefresh (stdscr);
#endif
		  hexa = key;
		  maybe_dirty = 1;
		  key = wgetch (stdscr);   /* 2nd nibble */
		  if (isxdigit (key))
		    { waddch (stdscr, key);
#ifdef M_TERMCAP
		      wrefresh (stdscr);
#endif
		      hexb = key;
		    }
		  reflected = 1;
		}
	      if (hexa)
		{ wbuf[byte_pos] &= 0x0f;
		  wbuf[byte_pos] |= hexval (hexa) << 4;
		}
	      if (hexb)
		{ wbuf[byte_pos] &= 0x0f0;
		  wbuf[byte_pos] |= hexval (hexb);
		}
	      if (hexa || hexb)
		reflect_change (byte_pos, ASC, wbuf);
	    }
	  if (byte_pos < BSIZE - 1  &&  (reflected || key == ' '))
	    { byte_pos++;
	    }
	  wattrset (stdscr, 0);
	  if (key == UND  ||  key == KEY_F(5))
	    return (UND);
	  break;
	}
    }
}


/************************************************************************
 * reflect_changes ()             *
 * ensure the byte is placed on the screen in the appropriate panel. *
 ************************************************************************/

reflect_change (byte, vmode, wbuf)
     int  byte;    /* relative byte number of wbuf to use  */
     int  vmode;    /* HEX or ASC side.      */
     char *wbuf;    /* working data buffer.     */
{ int  x,y;
  char hbuf[2];
  
  whereis (byte, vmode, &x, &y);
  wmove (stdscr, y, x);
  if (vmode == ASC)
    { waddch (stdscr, ttoa (wbuf[byte]));
    }
  else
    { ttox (hbuf, wbuf[byte]);
      waddch (stdscr, hbuf[0]);
      waddch (stdscr, hbuf[1]);
    }
#ifdef M_TERMCAP
  wrefresh (stdscr);
#endif
}

/************************************************************************
 * hexval ()               *
 * what is the 4-bit hex value of the letter provided?     *
 ************************************************************************/

hexval (c)
     int c;     /* 0123456789abcdef expected     */
{
  if (c >= '0'  &&  c <= '9')
    return (c - '0');
  else
    return ((tolower (c) - 'a' + 10) & 0x0f);
}


/************************************************************************
 * whereis ()               *
 * given the relative byte position of a byte within the 256 byte  *
 * buffer, compute the screen coordinates to be used.     *
 ************************************************************************/

whereis (pos, which, x, y)
     int  pos;    /* relative byte position in wbuf   */
     int  which;    /* HEX or ASC side of display    */
     int  *x, *y;    /* returned x,y coordinate on display  */
{
  if (which == ASC)
    {
      *x = pos % 16 + FIRSTA;
      *y = pos / 16 + FIRSTL;
    }
  else
    {
      *x = (pos % 16) * 3 + FIRSTH;
      *y = pos / 16 + FIRSTL;
    }
}

/************************************************************************
 * ttox ()                *
 * for a given character, return the 2 character hex equivalent.  *
 ************************************************************************/

ttox (x, c)
     char x[], c;
{
  x[1] = hex[c & 0x0f];
  x[0] = hex[(c >> 4) & 0x0f];
}

/************************************************************************
 * ttoa ()                *
 * return useful display equivalents for a character on the ASC side. *
 ************************************************************************/

int ttoa (c)
     char c;
{
  if (isvalid (c))
    return ((int) c);
  else
    return ((int) '.');
}

isvalid (c)
     int  c;
{
  if (c >= ' '  &&  c < 127)
    return (1);
  else
    return (0);
}


/************************************************************************
 * search ()               *
 * search the file for a string of bytes.  return the byte pointer  *
 * if found.  If not found, return -1         *
 ************************************************************************/

long search (fp, s, n, here)
     int  fp;     /* file to search   */
     char *s;     /* look for this string */
     int  n;     /* length of s    */
     long here;    /* current byte position */
{
  char buf[1000];
  int  nn, i, j;
  long ptr;
  
  ptr = here;
  lseek (fp, ptr, 0);   /* position to current byte  */
  
  while ((nn = read (fp, buf, 1000)) != -1  &&  nn >= n)
    { for (i = 0;  i < nn - n + 1;  i++)
	{ for (j = 0;  j < n;  j++)   /* test string match  */
	    if (s[j] != buf[i+j])
	      break;
	  if (j == n)
	    { return (ptr + i);    /* valid match found */
	    }
	}
      ptr += 1000L + (long) (1 - n);   /* with n-1 overlap */
      lseek (fp, ptr, 0);
    }
  return (-1L);        /* no match found  */
}


/************************************************************************
 * cvthex ()               *
 * convert a string of hex 'characters' into bytes.     *
 * attempt to allow blanks or not as user sees fit.     *
 ************************************************************************/

cvthex (s, sx)
     char *s;    /* input string eg:  c524fe     */
     char *sx;   /* returned packed bytes.      */
{
  int  i, n;
  int   c1, c2;
  
  n = 0;
  while (*s)
    { if (*s == ' ')
	{ s++;
	  continue;
	}
      c1 = hexval (*s++);
      if (*s == ' ')
	sx[n++] = c1;
      else
	{ c2 = hexval (*s++);
	  sx[n++] = (c1 << 4) | c2;
	}
    }
  
  return (n);
}


usage ()
{
  printf ("Usage:      fm  file.name\n");
  exit (0);
}
