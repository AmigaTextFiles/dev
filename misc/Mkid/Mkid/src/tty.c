#ifdef TERMIO
#include	<sys/termio.h>

struct termio linemode, charmode, savemode;

savetty()
{
	ioctl(0, TCGETA, &savemode);
	charmode = linemode = savemode;

	charmode.c_lflag &= ~(ECHO|ICANON|ISIG);
	charmode.c_cc[VMIN] = 1;
	charmode.c_cc[VTIME] = 0;

	linemode.c_lflag |= (ECHO|ICANON|ISIG);
	linemode.c_cc[VEOF] = 'd'&037;
	linemode.c_cc[VEOL] = 0377;
}

restoretty()
{
	ioctl(0, TCSETA, &savemode);
}

linetty()
{
	ioctl(0, TCSETA, &linemode);
}

chartty()
{
	ioctl(0, TCSETA, &charmode);
}

#else
#ifdef LATTICE
/* send raw mode packet for raw mode - LATTICE is defined in dos.h */
/* see raw.c by cmcmanis */

#include <stdio.h>

extern void raw(FILE *),cooked(FILE *);

static char savestate,state = 0;	

void
savetty()
{
	savestate = state;
}

void
chartty()
{
	state = 1;
	raw(stdin);
}

void
linetty()
{
	state = 0;
	cooked(stdin);
}

void
restoretty()
{
	if (state != savestate)
		if (savestate)
			raw(stdin);
		else
			cooked(stdin);
}
/* aztec has sgtty */
#else

#include	<sgtty.h>

struct sgttyb linemode, charmode, savemode;

savetty()
{
#ifdef TIOCGETP
	ioctl(0, TIOCGETP, &savemode);
#else
	gtty(0, &savemode);
#endif
	charmode = linemode = savemode;

	charmode.sg_flags &= ~ECHO;
	charmode.sg_flags |= RAW;

	linemode.sg_flags |= ECHO;
	linemode.sg_flags &= ~RAW;
}

restoretty()
{
#ifdef TIOCSETP
	ioctl(0, TIOCSETP, &savemode);
#else
	stty(0, &savemode);
#endif
}

linetty()
{
#ifdef TIOCSETP
	ioctl(0, TIOCSETP, &linemode);
#else
	stty(0, &savemode);
#endif
}

chartty()
{
#ifdef TIOCSETP
	ioctl(0, TIOCSETP, &charmode);
#else
	stty(0, &savemode);
#endif
}
#endif LATTICE
#endif
