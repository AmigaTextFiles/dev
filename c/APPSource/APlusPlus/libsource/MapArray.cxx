/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/MapArray.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/08/27 13:22:03 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/

extern "C"
{
#include <string.h>
}
#include <APlusPlus/environment/MapArray.h>

#define MAPARRAY_MINSIZE 4
#define MAPARRAY_GROWSIZE 2

MapArray::Pair MapArray::empty = {0,0};


static const char rcs_id[] = "$Id: MapArray.cxx,v 1.7 1994/08/27 13:22:03 Armin_Vogt Exp Armin_Vogt $";


MapArray::MapArray()
{
   pairs = &empty;
   arraySize = 0;
}

MapArray::~MapArray()
{
   if (arraySize)
   delete[] pairs;
}

MA_T& MapArray::operator [] (MapKey searchKey)
{
   if (pairs==NULL)
   {
      pairs = new Pair[MAPARRAY_MINSIZE];
      arraySize = MAPARRAY_MINSIZE;
      pairs->key = searchKey;
      (pairs+1)->key = 0;
      return pairs->entry;
   }
   else
   {
      int n = arraySize;
      for (Pair *pair = pairs; pair->key!=0 && n>0; pair++,n--)
         if (pair->key == searchKey) return pair->entry;

      n = arraySize-n;  // n is array index of first unused Pair
      if (n >= arraySize-1)
      {
         Pair *_newPair = new Pair[arraySize+MAPARRAY_GROWSIZE];
         memcpy(_newPair,pairs,arraySize*sizeof(Pair));
         pairs = _newPair;
         arraySize += MAPARRAY_GROWSIZE;
      }

      pairs[n+1].key = 0;
      pairs[n].key = searchKey;
      return pairs[n].entry;
   }
}

MA_T MapArray::find(MapKey searchKey, MapArray_comp cf)
{
   int n = arraySize;
   if (cf==NULL)
   {
      for (Pair *pair = pairs; n>0 && pair->key!=0; pair++,n--)
         if (pair->key == searchKey) return pair->entry;
   }
   else  // a comparator function has been given
   {
      for (Pair *pair = pairs; n>0 && pair->key!=0; pair++,n--)
         if ((*cf)(pair->key,searchKey)) return pair->entry;
   }

   return NULL;
}
