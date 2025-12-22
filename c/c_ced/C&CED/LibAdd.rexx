/*
 * LibAdd
 *
 * SYNOPSIS: 
 *    add support libraries
 *
 */

   if ~show('L','rexxarplib.library') then
      call addlib 'rexxarplib.library',0,-30,0
   if ~show('L','rexxsupport.library') then
      call addlib 'rexxsupport.library',0,-30,0
   exit 0
