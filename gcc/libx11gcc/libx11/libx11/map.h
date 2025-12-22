/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     map
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Aug 25, 1997: Created.
***/

#ifndef MAP
#define MAP

typedef enum {
  MAP_IMAP = 1,
  MAP_BMAP,
  MAP_PMAP,
} ;

typedef struct {
  int vType;
  int nEntries;
  int nMaxEntries;
  int nTopEntry;
  int* pData;
} IMap_t;

typedef IMap_t* IMap_p;

typedef struct {
  int vType;
  int nEntries;
  int nMaxEntries;
  int nTopEntry;
  unsigned char* pData;
} BMap_t;

typedef BMap_t* BMap_p;

typedef struct {
  int vType;
  int nEntries;
  int nMaxEntries;
  int nTopEntry;
  int** pData;
} PMap_t;

typedef PMap_t* PMap_p;

unsigned char Map_NewBEntry( void );
void Map_FreeBEntry( int n );
void Map_ExpandBMap( void );
void Map_ExitBMap( void );

IMap_p Map_Init( int nMax );
void Map_Exit( IMap_p pMap );
int Map_NewIEntry( IMap_p pMap, int n );
void Map_FreeIEntry( IMap_p pMap, int n );
void Map_ExpandIMap( IMap_p pMap );
void Map_ExitIMap( IMap_p pMap );
int Map_GetIEntry( IMap_p pMap, int n );
int Map_GetNumEntries( IMap_p pMap );

unsigned char Map_NewPEntry( void );
void Map_FreePEntry( int n );
void Map_ExpandPMap( void );
void Map_ExitPMap( void );

#endif /* MAP */
