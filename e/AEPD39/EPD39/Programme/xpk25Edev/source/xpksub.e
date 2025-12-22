/*
**	$Filename: xpknuke.h $
**	$Release: 0.9 $
**
**	(C) Copyright 1991 U. Dominik Mueller & Christian Schneider
**	    All Rights Reserved
*/


OPT MODULE
OPT EXPORT


MODULE 'libraries/xpk'






/**************************************************************************
 *
 *                     The XpkInfo structure
 *
 */


-> Sublibs return this structure to xpkmaster when asked nicely
-> This is version 1 of XpkInfo.  It's not #define'd because we don't want
-> it changing automatically with recompiles - you've got to actually update
-> your code when it changes.
OBJECT xpkInfo
  xpkInfoVersion  :INT  -> (unsigned) Version number of this structure
  libVersion      :INT  -> (unsigned) The version of this sublibrary
  masterVersion   :INT  -> (unsigned) The required master lib version
  modesVersion    :INT  -> (unsigned) Version number of mode descriptors

  name        :PTR TO CHAR  -> Brief name of the packer, 20 char max
  longName    :PTR TO CHAR  -> Full name of the packer   30 char max
  description :PTR TO CHAR  -> Short packer desc., 70 char max

  id            :LONG -> ID the packer goes by (XPK format)
  flags         :LONG -> Defined below
  maxPkInChunk  :LONG -> Max input chunk size for packing
  minPkInChunk  :LONG -> Min input chunk size for packing
  defPkInChunk  :LONG -> Default packing chunk size

  packMsg     :PTR TO CHAR  -> Packing message, present tense
  unpackMsg   :PTR TO CHAR  -> Unpacking message, present tense
  packedMsg   :PTR TO CHAR  -> Packing message, past tense
  unpackedMsg :PTR TO CHAR  -> Unpacking message, past tense

  defMode       :INT  -> (unsigned) Default mode number
  pad           :INT  -> (unsigned) for future use

  modeDesc    :PTR TO xpkMode -> List of individual descriptors

  reserved[6] :ARRAY -> (unsigned) Future expansion - set to zero

-> LABEL xi_SIZEOF

ENDOBJECT






/**************************************************************************
 *
 *                     The XpkSubParams structure
 *
 */

OBJECT xpkSubParams
  inBuf     :LONG   -> (APTR) The input data
  inLen     :LONG   ->        The number of bytes to pack
  outBuf    :LONG		-> (APTR) The output buffer
  outBufLen :LONG	  ->        The length of the output buf
  outLen    :LONG   ->        Number of bytes written
  flags     :LONG   ->        Flags for master/sub comm.
  number    :LONG   ->        The number of this chunk
  mode      :LONG		->        The packing mode to use
  password  :LONG   -> (APTR) The password to use

  arg[4]  :ARRAY OF LONG  ->  Reserved; don't use
  sub[4]  :ARRAY OF LONG  ->  Sublib private data
ENDOBJECT

CONST XSF_STEPDOWN  = 1,  -> May reduce pack eff. to save mem
      XSF_PREVCHUNK = 2   -> Previous chunk available on unpack

