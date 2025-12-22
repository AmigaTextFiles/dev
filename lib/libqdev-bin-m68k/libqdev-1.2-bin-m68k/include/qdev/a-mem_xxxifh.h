/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_xxxifh.h
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
 * $VER: a-mem_xxxifh.h 1.07 (18/09/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXIFH_H_INCLUDED___
#define ___XXXIFH_H_INCLUDED___

#define QDEV_MEM_PRV_GETPKT(id)               \
({                                            \
  struct mem_ifh_data *_id = id;              \
  _id->id_me = GetMsg(&_id->id_mp);           \
  (struct DosPacket *)((_id->id_me) ?         \
  _id->id_me->mn_Node.ln_Name : NULL);        \
})

#define QDEV_MEM_PRV_REPLYPKT(id, r1, r2)     \
({                                            \
  struct mem_ifh_data *_id = id;              \
  _id->id_mpp = _id->id_dp->dp_Port;          \
  _id->id_dp->dp_Port = &_id->id_mp;          \
  _id->id_dp->dp_Link->mn_Node.ln_Name =      \
  (UBYTE *)_id->id_dp;                        \
  _id->id_dp->dp_Res1 = r1;                   \
  _id->id_dp->dp_Res2 = r2;                   \
  PutMsg(_id->id_mpp, _id->id_dp->dp_Link);   \
})



struct mem_ifh_data
{
  struct Message    *id_me;         /* Message pointer, used in handler     */
  struct DosPacket  *id_dp;         /* DosPacket pointer, used in handler   */
  struct FileHandle *id_fh;         /* Our very special filehandle          */
  struct MsgPort     id_mp;         /* MsgPort causing exception            */
  struct MsgPort    *id_mpp;        /* MsgPort swapper pointer              */
  void              *id_dataptr;    /* User data pointer(binary data)       */
  LONG               id_datalen;    /* User data length(binary data)        */
  LONG               id_datapos;    /* Positioning variable                 */
  LONG               id_datatrk;    /* Tracking variable                    */
  LONG               id_readlen;    /* Max read length right now            */
  LONG               id_readpos;    /* Positioning variable                 */
  LONG              *id_datappos;   /* Positioning variable ptr             */
  LONG              *id_dataptrk;   /* Tracking variable ptr                */
  LONG              *id_readplen;   /* Max read length ptr                  */
  LONG              *id_readppos;   /* Positioning variable ptr             */
  LONG               id_fd;         /* Real file descriptor                 */
  LONG               id_res1;       /* Handler result 1                     */
  LONG               id_res2;       /* Handler result 2                     */
};

#endif /* ___XXXIFH_H_INCLUDED___ */
