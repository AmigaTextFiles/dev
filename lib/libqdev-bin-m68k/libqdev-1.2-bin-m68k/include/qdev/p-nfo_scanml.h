/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_scanml.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * Following  contents covered by the  BSIPM  license not to be used in
 * commercial products nor redistributed separately nor modified by the
 * 3-rd parties other than mentioned in the license and under the terms
 * prior to recipient status.
 *
 * A  copy  of  the  BSIPM  document  and/or  source  code  along  with
 * commented modifications and/or separate changelog should be included
 * in this archive.
 *
 * NO WARRANTY OF ANY KIND APPLIES. ALL THE RISK AS TO THE QUALITY  AND
 * PERFORMANCE  OF  THIS  SOFTWARE  IS  WITH  YOU. SEE THE 'BLACK SALLY
 * IMITABLE PACKAGE MARK' DOCUMENT FOR MORE DETAILS.
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: p-nfo_scanml.h 1.06 (31/03/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * T = Longest key name in the lookup table
 * E = Number of keywords in the lookup table
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___SCANML_H_INCLUDED___
#define ___SCANML_H_INCLUDED___

#define QDEV_NFO_PRV_ERRORAREA (((16 + 1) * 33) + 1)  /* ((T + 1) * E) + 1  */
#define QDEV_NFO_PRV_NAMELEN                     255  /* Buffer definition  */
#define QDEV_NFO_PRV_MDEVLEN                      32  /* Max dev. name len. */

/*
 * Keyword presence detection bit definitions(shifted 16 bits
 * left, to coexist with mountblock type).
*/
#define QDEV_NFO_SCANML_PB_HANDLER         0x00000000
#define QDEV_NFO_SCANML_PB_EHANDLER        0x00010000
#define QDEV_NFO_SCANML_PB_FILESYSTEM      0x00020000
#define QDEV_NFO_SCANML_PB_DEVICE          0x00030000
#define QDEV_NFO_SCANML_PB_UNIT            0x00040000
#define QDEV_NFO_SCANML_PB_FLAGS           0x00050000
#define QDEV_NFO_SCANML_PB_BLOCKSIZE       0x00060000
#define QDEV_NFO_SCANML_PB_SURFACES        0x00070000
#define QDEV_NFO_SCANML_PB_BLOCKSPERTRACK  0x00080000
#define QDEV_NFO_SCANML_PB_SECTORPERBLOCK  0x00090000
#define QDEV_NFO_SCANML_PB_RESERVED        0x000A0000
#define QDEV_NFO_SCANML_PB_PREALLOC        0x000B0000
#define QDEV_NFO_SCANML_PB_INTERLEAVE      0x000C0000
#define QDEV_NFO_SCANML_PB_LOWCYL          0x000D0000
#define QDEV_NFO_SCANML_PB_HIGHCYL         0x000E0000
#define QDEV_NFO_SCANML_PB_BUFFERS         0x000F0000
#define QDEV_NFO_SCANML_PB_BUFMEMTYPE      0x00100000
#define QDEV_NFO_SCANML_PB_MAXTRANSFER     0x00110000
#define QDEV_NFO_SCANML_PB_MASK            0x00120000
#define QDEV_NFO_SCANML_PB_BOOTPRI         0x00130000
#define QDEV_NFO_SCANML_PB_DOSTYPE         0x00140000
#define QDEV_NFO_SCANML_PB_BAUD            0x00150000
#define QDEV_NFO_SCANML_PB_CONTROL         0x00160000
#define QDEV_NFO_SCANML_PB_BOOTBLOCKS      0x00170000
#define QDEV_NFO_SCANML_PB_STACKSIZE       0x00180000
#define QDEV_NFO_SCANML_PB_PRIORITY        0x00190000
#define QDEV_NFO_SCANML_PB_GLOBVEC         0x001A0000
#define QDEV_NFO_SCANML_PB_STARTUP         0x001B0000
#define QDEV_NFO_SCANML_PB_ACTIVATE        0x001C0000
#define QDEV_NFO_SCANML_PB_FORCELOAD       0x001D0000



/*
 * I have packed everything here to save on stack space as much
 * as possible, so user can use it freely.
*/
struct nfo_int_data
{
  LONG                (*id_usercode)(struct nfo_sml_cb *);
                              /* Real usercode                              */
  struct DosEnvec      *id_defde;
                              /* Default Dos environment                    */
  struct nfo_sml_cb     id_sc;
                              /* Callback structure                         */
  struct nfo_che_data  *id_cd;
                              /* Keyword lookup table holder                */
  struct nfo_che_data  *id_cdp;
                              /* Keyword lookup table pointer               */
  UBYTE                *id_pattern;
                              /* Func. pattern                              */
  QDEV_TXT_INIPARSETYPE(id_ini);
                              /* Ml. Entry structure                        */
  QDEV_TXT_INIPARSETYPE(id_dev);
                              /* Ml. Dev + Entry kludge                     */
  LONG                  id_jumptocb;
                              /* Klugde trigger                             */
  UBYTE                *id_devptr;
                              /* Device/handler pointer                     */
  LONG                  id_rc;
                              /* Return code                                */
  UBYTE                 id_dosdevice[QDEV_NFO_PRV_NAMELEN];
                              /* Dos device name buf.                       */
  UBYTE                 id_handler[QDEV_NFO_PRV_NAMELEN];
                              /* Handler name buffer                        */
  UBYTE                 id_device[QDEV_NFO_PRV_NAMELEN];
                              /* Device name buffer                         */
  UBYTE                 id_unit[QDEV_NFO_PRV_NAMELEN];
                              /* Unit [0]=buf, [1-4]=num.                   */
  UBYTE                 id_flags[QDEV_NFO_PRV_NAMELEN]; 
                              /* Fl. [0]=buf, [1-4]=num.                    */
  UBYTE                 id_control[QDEV_NFO_PRV_NAMELEN];
                              /* Control flags buffer                       */
  UBYTE                 id_startup[QDEV_NFO_PRV_NAMELEN];
                              /* St. [0]=buf, [1-4]=num.                    */
  UBYTE                 id_errors[QDEV_NFO_PRV_ERRORAREA];
                              /* Keys who had broken data                   */
};

/*
 * Keyword lookup and extraction.
*/
struct nfo_che_data
{
  LONG   (*cd_func)(LONG *, LONG *, struct nfo_int_data *);
                              /* Extractor function address                 */
  void    *cd_dest;           /* Addr. of the dest. argument                */
  LONG     cd_type;           /* Ent. type(han, ehan, fs, 0)                */
  UBYTE   *cd_key;            /* Reference keyword                          */
};

#endif /* ___SCANML_H_INCLUDED___ */
