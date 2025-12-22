/*
** encrypt.h - API to 56 bit DES encryption
**
** Copyright (C) 1991 Jochen Obalek
** Revision  (C) 2014 RhoSigma, Roland Heyder
**
** Changes done by RhoSigma, Roland Heyder:
**   (1) general cleanup (bad tab usage, function/variable names were
**       mixed half english half german)
**   (2) complete rework of typing, only using common types defined 
**       below to make the source easier portable to another hardware
**       platform
**   (3) function crypt() renamed -> cryptpass()
**   (4) some low-level functions added:
**       - makekey()    - conversion Password -> Key Bits
**       - splitbytes() - conversion Data(byte)chunk -> Data Bits
**       - joinbytes()  - conversion Data Bits -> Data(byte)chunk
**   (5) some high-level functions added:
**       - encryptfile() - encrypt a file with given password of
**                         unlimited length
**       - decryptfile() - decrypt a file with given password of
**                         unlimited length
**   (6) added defines for error numbers and special values used by
**       encryptfile() and decryptfile()
**   (7) added complete documentation for all functions
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2, or (at your option)
** any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
*/

#ifndef ENCRYPT_H
#define ENCRYPT_H

/************************************************************/
/* Some common Types (you may be required to change these   */
/* depending by your compiler and/or used hardware platform */
/************************************************************/

typedef signed char         INT8;  /*  8-Bit integer entities */
typedef unsigned char      UINT8;
typedef signed short        INT16; /* 16-Bit integer entities */
typedef unsigned short     UINT16;
typedef signed long         INT32; /* 32-Bit integer entities */
typedef unsigned long      UINT32;
typedef signed long long    INT64; /* 64-Bit integer entities */
typedef unsigned long long UINT64;

/***********************************************************/
/* Error Codes returned by encryptfile() and decryptfile() */
/***********************************************************/

#define WARN_USERBREAK  -2 /* the function got an external */
                           /* break request via a supplied */
                           /* progress display function    */

#define WARN_NOTCRYPTED -1 /* returned by decryptfile() only, */
                           /* given file is not encrypted, at */
                           /* least not with encryptfile() of */
                           /* this API                        */

#define ERROR_NONE       0 /* no error, file was successfully */
                           /* encrypted or decrypted          */

#define ERROR_NOACCESS   1 /* specified file could not be opened */
                           /* either not found or not accessible */

#define ERROR_NOPASS     2 /* pointer to password was 0, or the */
                           /* password is empty (zero length)   */

#define ERROR_BADCHUNK   3 /* returned by decryptfile() only, */
                           /* expected data chunk not found,  */
                           /* either encrypted by a diff. API */
                           /* version or file is truncated    */

#define ERROR_TRUNCATED  4 /* returned by decryptfile() only, */
                           /* file is certainly truncated     */

#define ERROR_WRONGCRC   5 /* returned by decryptfile() only, */
                           /* wrong checksum indicates either */
                           /* file damage, file manipulation  */
                           /* or (most probably case) wrong   */
                           /* password for decryption         */

#define ERROR_FILEOP     6 /* error during common file operation */
                           /* like fseek(), ftell() etc.         */

#define ERROR_FILEREAD   7 /* error while reading data from file */
#define ERROR_FILEWRITE  8 /* error while writing data to file   */

#define ERROR_LOWMEM     9 /* running out of memory during */
                           /* file buffering               */

/************************************************************/
/* Special Codes which are sent to a given progress display */
/* function by encryptfile() and decryptfile()              */
/************************************************************/

#define PROGRESS_INIT -1 /* the very first code sent, a function   */
                         /* could use this to determine when it is */
                         /* time to open a progressbar window etc. */

/* NOTE: In between here only percentage values 0-100 are sent. In  */
/*       the case your function does not need the INIT/DONE values, */
/*       then you should at least exclude these values from display */
/*       by any suitable condition (e.g. if (percent >= 0) etc.)    */

#define PROGRESS_DONE -2 /* the very last code sent, a function     */
                         /* could use this to determine when it is  */
                         /* time to close a progressbar window etc. */

/**********************************************************/
/* Normal Level Functions (user API to DES-56 encryption) */
/**********************************************************/

/*------------------------------------------------------------*/
/* Injects the key derived from the given password to DES-56. */
/*------------------------------------------------------------*/
/* key: a pointer to a 64 bytes long chain of 0x00 and 0x01   */
/*      bytes, which represents the bit pattern of an 1-8     */
/*      characters long password (use makekey() to generate   */
/*      such a chain from your given password)                */
/*------------------------------------------------------------*/
extern void setkey(INT8 *key);

/*---------------------------------------------------------------*/
/* After injecting a key you may use this function to encrypt or */
/* decrypt a given block of data.                                */
/*---------------------------------------------------------------*/
/*  block: a pointer to a 64 bytes long chain of 0x00 and 0x01   */
/*         bytes, which represents the bit pattern of an 8 bytes */
/*         long chunk of your data buffer (use splitbytes() to   */
/*         generate the chain from your data chunk)              */
/*                                                               */
/* edflag: FALSE (zero) to encrypt the given chain of bytes      */
/*         TRUE (non-zero) to decrypt the given chain of bytes   */
/*                                                               */
/* RESULT: the passed through pointer to your data "block",      */
/*         containing the 64 bytes of 0x00 and 0x01 in its       */
/*         en-/decrypted order, these must be reassembled to get */
/*         back the regular 8 bytes (use joinbytes() for this)   */
/*---------------------------------------------------------------*/
extern INT8 *encrypt(INT8 *block, INT16 edflag);

/*************************************************************************/
/* Normal Level Functions (user API support for Byte <-> Bit conversion) */
/*************************************************************************/

/*-------------------------------------------------------------*/
/* Generates a 64 bytes long chain of 0x00 and 0x01 bytes from */
/* a given 1-8 characters long password.                       */
/*-------------------------------------------------------------*/
/*  passw: a pointer to the password to use (1-8 characters    */
/*         terminated by a byte of zero (0x00))                */
/*                                                             */
/* RESULT: a pointer to a 64 bytes long chain of 0x00 and 0x01 */
/*         bytes, which represents the bit pattern of the      */
/*         given password (suitable for setkey() call)         */
/*                                                             */
/*   NOTE: the result is static, means it will be overwritten  */
/*         at the next time this function is called, so any    */
/*         processing of the chain should be done first, or    */
/*         you must create a copy of it for later use          */
/*                                                             */
/* WARNING: this function seems to be similar to splitbytes(), */
/*          but is NOT, use it only for passwords and use the  */
/*          result only for setkey() calls                     */
/*-------------------------------------------------------------*/
extern INT8 *makekey(const INT8 *passw);

/*-------------------------------------------------------------*/
/* Generates a 64 bytes long chain of 0x00 and 0x01 bytes from */
/* a given 8 bytes long chunk of data.                         */
/*-------------------------------------------------------------*/
/*  block: a pointer to the data chunk (must be 8 bytes long,  */
/*         fill with zero bytes (0x00) if required)            */
/*                                                             */
/* RESULT: a pointer to a 64 bytes long chain of 0x00 and 0x01 */
/*         bytes, which represents the bit pattern of the      */
/*         given data chunk (suitable for encrypt() call)      */
/*                                                             */
/*   NOTE: the result is static, means it will be overwritten  */
/*         at the next time this function is called, so any    */
/*         processing of the chain should be done first, or    */
/*         you must create a copy of it for later use          */
/*                                                             */
/* WARNING: this function seems to be similar to makekey(),    */
/*          but is NOT, use it only for data chunk and use the */
/*          result only for encrypt() calls                    */
/*-------------------------------------------------------------*/
extern INT8 *splitbytes(INT8 *block);

/*-------------------------------------------------------------*/
/* Generates an 8 bytes long data chunk from a given 64 bytes  */
/* long chain of 0x00 and 0x01 bytes.                          */
/*-------------------------------------------------------------*/
/*  block: a pointer to a 64 bytes long chain of 0x00 and 0x01 */
/*         bytes, which contains the bit pattern for the new   */
/*         data chunk (as returned by encrypt() call)          */
/*                                                             */
/* RESULT: a pointer to the 8 bytes long data chunk (if this   */
/*         was an encryption, then you must save all 8 bytes,  */
/*         even if you've filled the original data with zeros, */
/*         because all bytes are needed to properly decrypt    */
/*         the data chunk again)                               */
/*                                                             */
/*   NOTE: the result is static, means it will be overwritten  */
/*         at the next time this function is called, so any    */
/*         processing of the data chunk should be done first,  */
/*         or you must create a copy of it for later use       */
/*-------------------------------------------------------------*/
extern INT8 *joinbytes(INT8 *block);

/****************************************************************/
/* Higher Level Functions (user API support for specific tasks) */
/****************************************************************/

/*------------------------------------------------------------*/
/* One way encryption of a given user password (e.g. for      */
/* .htaccess based Web-Site protection). This encryption is   */
/* non-reversible.                                            */
/*------------------------------------------------------------*/
/*  passw: a pointer to the password to use (1-8 characters   */
/*         terminated by a byte of zero (0x00))               */
/*                                                            */
/*   salt: a pointer to an 1-2 characters long salt string,   */
/*         which randomizes the encryption (for Web-Passwords */
/*         this string must match the string prescribed by    */
/*         the webspace provider for that particular Web-Site */
/*         (you have to ask for it, if required))             */
/*                                                            */
/* RESULT: a pointer to the encrypted password for .htaccess  */
/*         based protection (13 characters terminated by 0)   */
/*                                                            */
/*   NOTE: the result is static, means it will be overwritten */
/*         at the next time this function is called, so any   */
/*         processing of the data chunk should be done first, */
/*         or you must create a copy of it for later use      */
/*------------------------------------------------------------*/
extern INT8 *cryptpass(const INT8 *passw, const INT8 *salt);

/*-------------------------------------------------------------------*/
/* This function will encrypt a whole file using the given password. */
/*-------------------------------------------------------------------*/
/*    fname: a pointer to the full filename (if required with path), */
/*           which is terminated by a byte of zero (0x00)            */
/*                                                                   */
/*    passw: a pointer to the password to use (unlimited number of   */
/*           characters terminated by zero)(see also notes(1))       */
/*                                                                   */
/* progress: a pointer to a progress display function, or 0 pointer, */
/*           if you don't need this feature (see also notes(2))      */
/*                                                                   */
/*   RESULT: 0 for success, else any of the errors defined above     */
/*                                                                   */
/* NOTE: (1) if the password is longer than 8 characters, then auto- */
/*           maticly a multi pass encryption is done, i.e. the pw is */
/*           cutted in pieces of 8 chars and every pass will use one */
/*           of the pieces for encryption, this way you really must  */
/*           provide the very same password for decryption, even if  */
/*           the algorithm only use 8 char passwords                 */
/*       (2) you may provide a progress display function for encrypt */
/*           or decrypt functions which will get the percentage of   */
/*           the work already done, additionally this function may   */
/*           pass back a flag value, if the value is TRUE (non-zero) */
/*           (e.g. by pressing an Abort button in the progress win)  */
/*           then en-/decryptfile() will abort its operation and     */
/*           return immediately (of course, cleanup is done first)   */
/*-------------------------------------------------------------------*/
extern INT16 encryptfile(const INT8 *fname, const INT8 *passw, INT16 (*progress)(INT16 percent));

/*-------------------------------------------------------------------*/
/* This function will decrypt a whole file using the given password. */
/*-------------------------------------------------------------------*/
/* Synopsis of this function is equal to encryptfile(), see there... */
/*-------------------------------------------------------------------*/
extern INT16 decryptfile(const INT8 *fname, const INT8 *passw, INT16 (*progress)(INT16 percent));

#endif /* ENCRYPT_H */

