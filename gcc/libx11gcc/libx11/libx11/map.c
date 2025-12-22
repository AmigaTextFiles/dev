/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     map
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Aug 25, 1997: Created.
***/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>


#include "map.h"
#include "funcount.h"

#define GROW 10

void*
allocfailed( int vSize )
{
  /* try to free something?..*/
  printf("Alloc of %d failed..\n",vSize);
  exit(-1);

  return NULL;
}

IMap_p
Map_Init( int nMax )
{
  IMap_p pIMap;

  pIMap = (IMap_p)malloc( sizeof( IMap_t ) );

  if( !pIMap ){
    pIMap = (IMap_p)allocfailed( sizeof( IMap_t ) );
  }
  
  pIMap->pData = (int*)malloc( sizeof( int )*nMax );
  if( !pIMap->pData ){
    pIMap->pData = (int*)allocfailed( sizeof( int )*nMax );
  }

  pIMap->nMaxEntries = nMax;
  pIMap->nTopEntry = 0;
  pIMap->nEntries = 0;
  pIMap->vType = MAP_IMAP;

  return pIMap;

}

void
Map_Exit( IMap_p pMap )
{
  assert( pMap );

  free( pMap->pData );
  free( pMap );
}  


int
Map_NewIEntry( IMap_p pMap, int n )
{
  int vUse;
  int i;
  assert( pMap );

  vUse = pMap->nTopEntry;

  pMap->pData[vUse] = n;
  pMap->nTopEntry++;
  if( pMap->nTopEntry == pMap->nMaxEntries )
    Map_ExpandIMap( pMap );

  return(vUse);
}

void
Map_FreeIEntry( IMap_p pMap, int n )
{
  int i;
  int vDelete = -1;
  assert( pMap );

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( FREEIENTRY, 0 );
#endif
  for(i=0; i<pMap->nTopEntry; i++ )
    if( pMap->pData[i] == n ){
      vDelete  = i;
      break;
    }
  if( vDelete == -1 ){
    assert( vDelete != -1 );
  }
  pMap->nTopEntry--;
  pMap->pData[vDelete] = pMap->pData[pMap->nTopEntry];

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( FREEIENTRY, 0 );
#endif
}

void
Map_ExpandIMap( IMap_p pMap )
{
  int* pNewData;

  assert( pMap );


  pNewData = (int*)malloc( sizeof( int )*(pMap->nMaxEntries+GROW) );
  if( !pNewData ){
    pNewData = (int*)allocfailed( sizeof( int )*(pMap->nMaxEntries+GROW) );
  }
  memcpy( pNewData, pMap->pData, sizeof( int )*pMap->nMaxEntries );
  free( pMap->pData );
  pMap->pData = pNewData;
  pMap->nMaxEntries = pMap->nMaxEntries+GROW;
}
