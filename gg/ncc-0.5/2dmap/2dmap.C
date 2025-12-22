/***********************************************************************

	specially adapted version of the general purpose tool 2dmap.
	first written : Tue Jun  5 03:32:16 EEST 2001

***********************************************************************/
#include <curses.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

#include "dbstree.h"
#include "dLIST.h"

enum state {
	NORM, PARENT, CHILD, THIS
};

struct location
{
	char *str;
	int len;
	int e;
};

struct coords
{
	int x, y;
};

class TDmap
{
	bool valid (int, int);
   public:
	int npages, page;
	int tx, ty, nx;
	location *Points;
	int nPoints;
	int cx, cy;
	int vspace;
	coords locate (int);
	int at (int, int);
   public:
	TDmap (int, int, char**, int);
	void highlight (int *, int, int);
	void highlight (int, int, int);
	void highlight (int, int);
	void reset ();
	void draw ();
	void arrow (int);
	int enter();
	void GoTo (int);
};

char *StrDup (char *c)
{
	return strcpy (new char [strlen (c) + 1], c);
}

TDmap::TDmap (int termx, int termy, char **strs, int n)
{
	int i, MAX_SPACE=0;

	Points = new location [nPoints = n];
	for (i = 0; i < n; i++) {
		Points [i].str = strs [i];
		Points [i].len = strlen (strs [i]);
		if (MAX_SPACE<Points[i].len)
			MAX_SPACE = Points [i].len;
		Points [i].e = NORM;
	}
	MAX_SPACE += 2;

	tx = termx, ty = termy;
	for (nx = 1; nx * MAX_SPACE < tx; nx++)
		;
	--nx;
	vspace = termx / nx;

	npages = 1 + (n/nx) / ty;

	cx = cy = page = 0;
}

coords TDmap::locate (int i)
{
	coords r;

	i = i % (nx*ty);
	r.y = i / nx;
	r.x = i % nx;

	return r;
}

void TDmap::GoTo (int i)
{
	page = i / (nx*ty);
	i = i % (nx*ty);
	cy = i / nx;
	cx = i % nx;
}

int TDmap::at (int x, int y)
{
	int l = page*nx*ty + y*nx + x;
	return (l < nPoints) ? l : -1;
}

int TDmap::enter ()
{
	return at (cx, cy);
}

void TDmap::reset ()
{
	int i;

	for (i = 0; i < nPoints; i++)
		Points [i].e = NORM;
}

void TDmap::highlight (int *a, int n, int S)
{
	int i;

	for (i = 0; i < n; i++)
		Points [a [i]].e = S;
}

void TDmap::highlight (int f, int t, int S)
{
	int i;

	for (i = f; i < t; i++)
		Points [i].e = S;
}

void TDmap::highlight (int t, int S)
{
	Points [t].e = S;
}

void TDmap::draw ()
{
	int i, j;
	coords c;

	for (i = 0; i < nx*ty && i < nPoints; i++) {
		j = i + page * nx * ty;
		if (j >= nPoints) break;
		c = locate (j);
		if (c.x == cx && c.y == cy) {
			attrset (COLOR_PAIR(NORM) | A_BOLD);
			c.x *= vspace;
			move (c.y, c.x);
			printw ("%s", Points [j].str);
		} else	{
			attrset (Points [j].e);
			c.x *= vspace;
			move (c.y, c.x);
			printw ("%s", Points [j].str);
		}
	}
	refresh ();
}

bool TDmap::valid (int x, int y)
{
	int l = page*nx*ty + y*nx + x;
	return y < ty && l < nPoints;
}

void TDmap::arrow (int a)
{
	if (a == KEY_UP) {
		if (cy > 0) --cy;
		else if (page > 0) {
			clear();
			page--;
			cy = ty;
		} else return;
		draw();
	}
	if (a == KEY_LEFT) {
		if (cx > 0)
			--cx;
		else if (cy > 0) {
			--cy;
			cx = nx - 1;
		}
		draw ();
		return;
	}
	if (a == KEY_RIGHT) {
		int nex, ney;
		if (cx == nx - 1) {
			nex = 0;
			ney = cy + 1;
		} else {
			nex = cx + 1;
			ney = cy;
		}
		if (valid (nex, ney)) {
			cx = nex;
			cy = ney;
			draw();
		} return;
	}
	if (a == KEY_DOWN) {
		if (cy < ty - 1 && valid (cx, cy+1)) {
			++cy;
			draw();
			return;
		}
		if (cy == ty - 1 && page+1 < npages) {
			page++;
			if (!valid (cx, 0)) page--;
			else {
				cy = 0;
				clear();
				draw ();
			}
			return;
		} return;
	}
	if (a == KEY_NPAGE) {
		if (page+1 < npages) {
			page++;
			while (!valid (cx, cy)) cy--;
			clear();
			draw();
		} else {
			while (valid (cx, cy+1)) cy++;
			draw();
		} return;
	}
	if (a == KEY_PPAGE) {
		if (page > 0) {
			page--;
			clear();
			draw();
		} else {
			cy = 0;
			draw();
		}
		return;
	}
}

class func : public dbsNodeStr
{
   public:
	int ID;
	dlistAuto<func*> Child, Parent;
	bool hascode;
	func (char*,bool);
};

dbsTree funcs;

func *Findfuncs (char *f)
{
	DBS_STRQUERY = f;
	return (func*) funcs.dbsFind ();
}

func::func (char* n, bool h) :dbsNodeStr (&funcs)
{
	Name = StrDup (n);
	hascode = h;
}

char **strings;
func **FuncID;
int *externs, nexterns;
int *orphans, norphans;
int cur_recur;
int nfilez = 0;

void enter_array (dbsNode *d)
{
	func *f = (func*) d;
	f->ID = cur_recur++;
	FuncID [f->ID] = f;
	strings [f->ID] = f->Name;
	if (!f->hascode) externs [nexterns++] = f->ID;
	if (!f->Parent.cnt) orphans [norphans++] = f->ID;
}

#define DLX (dlistNodeX<func*>*)

void read_map (char *fl)
{
	FILE *f;
	char b [1024], *c;
	bool bo;
	func *F, *CF = NULL;
	int *allo, *ollo;
	dlistNodeX<func*> *dl;

	if (!(f = fopen (fl, "r"))) {
		fprintf (stderr, "Can't open [%s]\n", fl);
		exit (1);
	}

	while (fgets (b, sizeof b, f))
	if (b[0] != 0 && b[0]!='\n' && !(b[0]=='\t'&&b[1]==0) && b[0]!='#') {
		b [strlen (b) - 1] = 0;
		if (b [0] != '\t') {
fprintf (stderr, "[%s]\n", b);
			if (strchr (b, ' ')) *strchr (b, ' ') = 0;
			if (b[0] == '.' || b [0] == '/') ++nfilez;
			if ((CF = Findfuncs (b)))
				CF->hascode = true;
			else CF = new func (b, true);
		} else if (CF) {
			c = b + 1;
fprintf (stderr, " [%s]\n", c);
			if (!(F = Findfuncs(c)))
				F = new func (c, false);
			bo = true;
			for (dl = DLX CF->Child.Start; dl;
			dl = DLX CF->Child.Next (DLX dl))
				if (dl->x == F) { bo = false; break; }
			if (bo) {
				F->Parent.add (CF);
				CF->Child.add (F);
			}
		}
	}

	if (funcs.nnodes) {
		strings = new char* [funcs.nnodes];
		FuncID = new func* [funcs.nnodes];
		allo = externs = (int*) alloca (funcs.nnodes * sizeof (int));
		ollo = orphans = (int*) alloca (funcs.nnodes * sizeof (int));
		nexterns = norphans = cur_recur = 0;
		funcs.foreach (enter_array);
		externs = new int [nexterns];
		orphans = new int [norphans];
		memcpy  (externs, allo, nexterns * sizeof (int));
		memcpy  (orphans, ollo, norphans * sizeof (int));
	}

	fclose (f);
}

class FOOO {};

void othermode (int i)
{
	char *spec [4096];
	bool cpbool [4096];
	int j, k, key;
	func *F = FuncID [i];
	dlistNodeX<func*> *dl;

	k = 0;
	for (dl = DLX F->Parent.Start; dl;
	dl = DLX F->Parent.Next (DLX dl))
		spec [k++] = strings [dl->x->ID];
	key = k;
	spec [k++] = strings [i];
	for (dl = DLX F->Child.Start; dl;
	dl = DLX F->Child.Next (DLX dl)) {
		cpbool [k - key] = dl->x->Child.cnt > 0;
		spec [k++] = strings [dl->x->ID];
	}

	TDmap M (COLS, LINES-1, spec, k);

	clear();
	M.highlight (0, key, COLOR_PAIR(PARENT));
	if (k > key) M.highlight (key+1, k, COLOR_PAIR(CHILD));

	for (j = key + 1; j < k; j++)
		if (!cpbool [j - key]) M.highlight (j, A_DIM);

	M.GoTo (key);
	M.draw();
	k = key;

	while (1) {
		key = getch ();
		if (key == 'q') throw FOOO();	// GOOD ONE!
		if (key == '\n') 
			if (M.enter() == k) return;
			else {
				func *f = Findfuncs
					(spec [M.enter()]);
				if (f) {
					othermode (f->ID);
					clear ();
					M.draw();
				}
			}
		M.arrow (key);
	}
}

int main (int argc, char **argv)
{
	int i, key;

	read_map((argc == 1) ? (char*)"code.map" : argv [1]);

	initscr();
	leaveok(stdscr, true);
	start_color();
	init_pair (NORM, COLOR_WHITE, COLOR_BLACK);
	init_pair (PARENT, COLOR_BLUE, COLOR_BLACK);
	init_pair (CHILD, COLOR_YELLOW, COLOR_BLACK);
	init_pair (THIS, COLOR_GREEN, COLOR_BLACK);
	crmode();
	keypad (stdscr, TRUE);
	noecho ();

	TDmap M (COLS, LINES-1, strings, cur_recur);

	M.highlight (externs, nexterns, A_DIM);
	M.draw ();

	while (1) {
		key = getch ();
		if (key == 'q') break;
		if (key == '2') {
			M.reset();
			M.highlight (externs, nexterns, A_DIM);
			M.highlight (i, COLOR_PAIR(THIS));
			M.draw();
		} else if (key == '1') {
			M.reset();
			M.highlight (orphans, norphans, COLOR_PAIR(THIS));
			M.highlight (externs, nexterns, A_DIM);
			M.highlight (externs, nexterns, A_DIM);
			M.draw();
		} else if (key == ' ') {
			dlistNodeX<func*> *dl;
			i = M.enter();
			M.reset();
			M.highlight (externs, nexterns, A_DIM);
			M.highlight (i, COLOR_PAIR(THIS));
			for (dl = DLX FuncID [i]->Child.Start; dl;
			dl = DLX FuncID [i]->Child.Next (DLX dl))
				M.highlight (dl->x->ID, COLOR_PAIR(CHILD));
			for (dl = DLX FuncID [i]->Parent.Start; dl;
			dl = DLX FuncID [i]->Parent.Next (DLX dl))
				M.highlight (dl->x->ID, COLOR_PAIR(PARENT));
			M.draw();
		} else if (isalpha (key)) {
			i = M.enter();
			if (strings [FuncID [i]->ID] [0] < key)
				while (i < funcs.nnodes
				 && strings [FuncID [i]->ID] [0] < key)
					++i;
			else
				while (i > 0
				 && strings [FuncID [i]->ID] [0] > key)
					--i;
			if (i == funcs.nnodes) --i;
			clear ();
			M.GoTo (i);
			M.highlight (externs, nexterns, A_DIM);
			M.draw ();
		} else if (key == '\n') {
			try {
				othermode (M.enter());
			} catch (FOOO) {}
			clear ();
			M.reset();
			M.highlight (externs, nexterns, A_DIM);
			M.draw();
		}else M.arrow (key);
	}

	flash();
	endwin ();

	printf ("%i functions %i filez\n", funcs.nnodes-nfilez, nfilez);
}
