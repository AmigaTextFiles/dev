/*
 * worb-i.c
 * Interpreter for the language "noit 'o mnain worb"
 *
 * Created by Prfnoff
 *
 * Started in a rush on Frijun 21, 2000
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <aes.h>

struct WorbLocation;
typedef struct WorbLocation WorbLocation;

struct WorbBobule;
typedef struct WorbBobule WorbBobule;

struct WorbList;
typedef struct WorbList WorbList;

struct WorbLocation
{
	char botCh; /* background terrain */
	char topCh; /* allowing for bobules */
	short row;
	short col;
	short numExits;
	WorbBobule **bobulePtr;
	WorbLocation *exitLoc[8];
};

int absoluteMaxRow;
int absoluteMaxCol;
int realMaxRow;
int realMaxCol;
WorbLocation **playfield;

struct WorbBobule
{
	WorbLocation *bobLoc;
	int pressure;
	WorbBobule *nextBob; /* linked list */
};

WorbBobule *bobuleList, **bobuleListEnd;

struct WorbList
{
	WorbLocation *itemLoc;
	WorbList *nextItem;
};

WorbList *sourceList, **sourceListEnd;
WorbList *sinkList, **sinkListEnd;
WorbList *bellList, **bellListEnd;

int bells;

int stupidBobules;
int updateScreen;
int maxTurns;

#define BOB_CH_4 '@'
#define BOB_CH_3 '0'
#define BOB_CH_2 'O'
#define BOB_CH_1 'o'
#define BOB_CH_0 '.'

#define BOB_PR_4 11
#define BOB_PR_3 7
#define BOB_PR_2 4
#define BOB_PR_1 2
#define BOB_PR_0 1

static void UnlinkBobule(WorbBobule **bobPtr)
{
	WorbBobule *nextBob;

	nextBob = (*bobPtr)->nextBob;

	(*bobPtr)->bobLoc->bobulePtr = (WorbBobule **)NULL;

	free((void *)(*bobPtr));

	*bobPtr = nextBob;
}

static void InitWorb(void)
{
	int row, col;

	playfield = (WorbLocation **)malloc(absoluteMaxRow * sizeof(WorbLocation *));
	if (playfield == (WorbLocation **)NULL) exit(1);

	for (row = 0; row < absoluteMaxRow; row++)
	{
		playfield[row] = (WorbLocation *)malloc(absoluteMaxCol * sizeof(WorbLocation));
		if (playfield[row] == (WorbLocation *)NULL) exit(1);

		for (col = 0; col < absoluteMaxCol; col++)
		{
			playfield[row][col].botCh = ' ';
			playfield[row][col].topCh = ' ';
			playfield[row][col].bobulePtr = (WorbBobule **)NULL;
			playfield[row][col].row = row;
			playfield[row][col].col = col;
			playfield[row][col].numExits = 0;
		}
	}

	bobuleList = (WorbBobule *)NULL;
	bobuleListEnd = &bobuleList;

	sourceList = (WorbList *)NULL;
	sourceListEnd = &sourceList;

	sinkList = (WorbList *)NULL;
	sinkListEnd = &sinkList;

	bellList = (WorbList *)NULL;
	bellListEnd = &bellList;

	srand(time(NULL));
}

static void DestroyWorb(void)
{
	int row;
	WorbList *nxtItem;

	for (row = 0; row < absoluteMaxRow; row++)
	{
		free((void *)playfield[row]);
	}

	free((void *)playfield);

	while (bobuleList != (WorbBobule *)NULL)
	{
		UnlinkBobule(&bobuleList);
	}

	while (sourceList != (WorbList *)NULL)
	{
		nxtItem = sourceList->nextItem;
		free((void *)sourceList);
		sourceList = nxtItem;
	}

	while (sinkList != (WorbList *)NULL)
	{
		nxtItem = sinkList->nextItem;
		free((void *)sinkList);
		sinkList = nxtItem;
	}

	while (bellList != (WorbList *)NULL)
	{
		nxtItem = bellList->nextItem;
		free((void *)sourceList);
		bellList = nxtItem;
	}
}

static void DrawPlayfield(void)
{
	int row;
	int col;

	if (updateScreen)
	{
		fputs("\033[1;1H", stdout);
	}
	for (row = 0; row < realMaxRow; row++)
	{
		for (col = 0; col < realMaxCol; col++)
		{
			putchar(playfield[row][col].topCh);
		}
		putchar('\n');
	}
	if (!updateScreen)
	{
		if (bells > 0)
		{
			putchar('(');
			while (bells-- > 0) putchar('!');
			bells = 0;
			putchar(')');
		}
		putchar('\n');
		putchar('\n');
	}
}

static void UpdateLoc(WorbLocation *loc)
{
	printf("\033[%d;%dH%c", (int)(loc->row + 1), (int)(loc->col + 1), (int)loc->topCh);
}

static void NewBobule(WorbLocation *loc)
{
	WorbBobule *newBobule;

	newBobule = (WorbBobule *)malloc(sizeof(WorbBobule));

	if (newBobule == (WorbBobule *)NULL) exit(1);

	newBobule->bobLoc = loc;
	newBobule->pressure = BOB_PR_0;
	newBobule->nextBob = (WorbBobule *)NULL;

	*bobuleListEnd = newBobule;

	loc->bobulePtr = bobuleListEnd;
	loc->topCh = BOB_CH_0;

	bobuleListEnd = &newBobule->nextBob;
}

static void HandleEvents(void)
{
	WorbLocation *loc;
	WorbList *list;

	for (list = sourceList; list != (WorbList *)NULL; list = list->nextItem)
	{
		loc = list->itemLoc;

		if (loc->bobulePtr == (WorbBobule **)NULL)
		{
			if ((rand() >> 4) % 10 == 0)
			{
				NewBobule(loc);
				if (updateScreen) UpdateLoc(loc);
			}
		}
	}

	for (list = sinkList; list != (WorbList *)NULL; list = list->nextItem)
	{
		loc = list->itemLoc;

		if (loc->bobulePtr != (WorbBobule **)NULL)
		{
			if ((rand() >> 4) % 10 == 0)
			{
				UnlinkBobule(loc->bobulePtr);
			}
		}
	}

	for (list = bellList; list != (WorbList *)NULL; list = list->nextItem)
	{
		loc = list->itemLoc;

		if (loc->bobulePtr != (WorbBobule **)NULL &&
		    (*loc->bobulePtr)->pressure == BOB_PR_0)
		{
			if (updateScreen)
			{
				putchar('\a');
			}
			else
			{
				++bells;
			}
		}
	}
}

static void IncreasePressure(WorbBobule *bobule)
{
	WorbLocation *loc = bobule->bobLoc;

	if (bobule->pressure == (BOB_PR_4 - 1))
	{
		loc->topCh = BOB_CH_4;
		bobule->pressure = BOB_PR_4;
		if (updateScreen) UpdateLoc(loc);
	}
	else if (bobule->pressure == (BOB_PR_3 - 1))
	{
		loc->topCh = BOB_CH_3;
		bobule->pressure = BOB_PR_3;
		if (updateScreen) UpdateLoc(loc);
	}
	else if (bobule->pressure == (BOB_PR_2 - 1))
	{
		loc->topCh = BOB_CH_2;
		bobule->pressure = BOB_PR_2;
		if (updateScreen) UpdateLoc(loc);
	}
	else if (bobule->pressure == (BOB_PR_1 - 1))
	{
		loc->topCh = BOB_CH_1;
		bobule->pressure = BOB_PR_1;
		if (updateScreen) UpdateLoc(loc);
	}
	else
	{
		++bobule->pressure;
	}
}

static void HandleBobule(WorbBobule **bobPtr)
{
	WorbLocation *oldLoc, *newLoc;
	int locIndex;

	oldLoc = (*bobPtr)->bobLoc;

	if (stupidBobules)
	{
		locIndex = (rand() >> 4) % 9;
		if (locIndex >= oldLoc->numExits)
		{
			IncreasePressure(*bobPtr);
			return;
		}
	}
	else
	{
		locIndex = (rand() >> 4) % oldLoc->numExits;
	}

	newLoc = oldLoc->exitLoc[locIndex];

	if (newLoc->bobulePtr != (WorbBobule **)NULL)
	{
		IncreasePressure(*bobPtr);
		return;
	}

	oldLoc->topCh = oldLoc->botCh;
	oldLoc->bobulePtr = (WorbBobule **)NULL;
	newLoc->topCh = BOB_CH_0;
	newLoc->bobulePtr = bobPtr;
	(*bobPtr)->pressure = BOB_PR_0;
	(*bobPtr)->bobLoc = newLoc;
	if (updateScreen)
	{
		UpdateLoc(oldLoc);
		UpdateLoc(newLoc);
	}
}

static void HandleBobules(void)
{
	WorbBobule **bobPtr;

	for (bobPtr = &bobuleList; *bobPtr != (WorbBobule *)NULL; bobPtr = &(*bobPtr)->nextBob)
	{
		HandleBobule(bobPtr);
	}
}

static void ParsePlayfield(FILE *input)
{
	int row;
	int col;
	int ch;
	WorbList *newItem;

	row = 0;
	col = 0;
	realMaxRow = 1;
	realMaxCol = 1;
	while ((ch = getc(input)) != EOF)
	{
		if (ch == '\n')
		{
			col = 0;
			if (++row >= absoluteMaxRow) break; 
			if (row >= realMaxRow) realMaxRow = row + 1;
		}
		else
		{
			if (ch == ' ')
			{
				/* do nothing */
			}
			else if (ch == '.')
			{
				NewBobule(&playfield[row][col]);
			}
			else
			{
				if (ch == '+')
				{
					newItem = (WorbList *)malloc(sizeof(WorbList));

					if (newItem == (WorbList *)NULL) exit(1);

					newItem->itemLoc = &playfield[row][col];
					newItem->nextItem = (WorbList *)NULL;

					*sourceListEnd = newItem;
					sourceListEnd = &newItem->nextItem;
				}
				else if (ch == '-')
				{
					newItem = (WorbList *)malloc(sizeof(WorbList));

					if (newItem == (WorbList *)NULL) exit(1);

					newItem->itemLoc = &playfield[row][col];
					newItem->nextItem = (WorbList *)NULL;

					*sinkListEnd = newItem;
					sinkListEnd = &newItem->nextItem;
				}
				else if (ch == '!')
				{
					newItem = (WorbList *)malloc(sizeof(WorbList));

					if (newItem == (WorbList *)NULL) exit(1);

					newItem->itemLoc = &playfield[row][col];
					newItem->nextItem = (WorbList *)NULL;

					*bellListEnd = newItem;
					bellListEnd = &newItem->nextItem;
				}

				playfield[row][col].botCh = ch;
			}
			playfield[row][col].topCh = ch;
			if (++col >= absoluteMaxCol) break;
			if (col >= realMaxCol) realMaxCol = col + 1;
		}
	}
}

static void ProcessPlayfield(void)
{
	int row;
	int col;
	WorbLocation *fromLoc, *toLoc;

	for (row = 0; row < absoluteMaxRow; row++)
	{
		for (col = 0; col < absoluteMaxCol; col++)
		{
			fromLoc = &playfield[row][col];

			/* This is inefficient but good optimizers will make it better */
			if (row >= 1 && col >= 1)
			{
				toLoc = &playfield[row - 1][col - 1];
				if (toLoc->botCh != '>' && toLoc->botCh != 'v' &&
				    toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (row >= 1)
			{
				toLoc = &playfield[row - 1][col];
				if (toLoc->botCh != 'v' && toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (row >= 1 && col < absoluteMaxCol - 1)
			{
				toLoc = &playfield[row - 1][col + 1];
				if (toLoc->botCh != '<' && toLoc->botCh != 'v' &&
				    toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (col >= 1)
			{
				toLoc = &playfield[row][col - 1];
				if (toLoc->botCh != '>' && toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (col < absoluteMaxCol - 1)
			{
				toLoc = &playfield[row][col + 1];
				if (toLoc->botCh != '<' && toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (row < absoluteMaxRow - 1 && col >= 1)
			{
				toLoc = &playfield[row + 1][col - 1];
				if (toLoc->botCh != '>' && toLoc->botCh != '^' &&
				    toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (row < absoluteMaxRow - 1)
			{
				toLoc = &playfield[row + 1][col];
				if (toLoc->botCh != '^' && toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
			if (row < absoluteMaxRow - 1 && col < absoluteMaxCol - 1)
			{
				toLoc = &playfield[row + 1][col + 1];
				if (toLoc->botCh != '<' && toLoc->botCh != '^' &&
				    toLoc->botCh != '#')
				{
					fromLoc->exitLoc[fromLoc->numExits++] = toLoc;
				}
			}
		}
	}
}

int main(int argc, char **argv)
{
	int turn;
	FILE *input, *openedFile = (FILE *)NULL;

#ifdef __MWERKS__
	argc = ccommand(&argv);
#endif /* __MWERKS__ */

	stupidBobules = 0;
	updateScreen = 0;
	absoluteMaxRow = 24;
	absoluteMaxCol = 80;
	maxTurns = 1000;

	for (; argc > 1 && *argv[1] == '-'; argc--, argv++)
	{
		switch (argv[1][1])
		{
			case 'r':
			{
				absoluteMaxRow = strtoul(&argv[1][2], (char **)NULL, 0);
				break;
			}

			case 'c':
			{
				absoluteMaxCol = strtoul(&argv[1][2], (char **)NULL, 0);
				break;
			}

			case 't':
			{
				maxTurns = strtoul(&argv[1][2], (char **)NULL, 0);
				break;
			}

			case 's':
			{
				stupidBobules = 1;
				break;
			}

			case 'S':
			{
				stupidBobules = 0;
				break;
			}

			case 'u':
			{
				updateScreen = 1;
				break;
			}

			case 'w':
			{
				updateScreen = 0;
				break;
			}
		}
	}

	if (argc < 2 || (openedFile = fopen(argv[1], "r")) == (FILE *)NULL)
	{
		input = stdin;
	}
	else
	{
		input = openedFile;
	}

	InitWorb();

	ParsePlayfield(input);

	if (openedFile != (FILE *)NULL)
	{
		fclose(openedFile);
	}

	ProcessPlayfield();

	turn = 0;
	if (updateScreen)
	{
		fputs("\033[2J", stdout);
	}
	DrawPlayfield();

	while (turn < maxTurns)
	{
		HandleBobules();
		HandleEvents();
		if (!updateScreen)
		{
			DrawPlayfield();
		}
		turn++;
	}

	DestroyWorb();
	exit(0);
	return (0);
}
