/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_xxxconscreen.h
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
 * $VER: a-ctl_xxxconscreen.h 1.36 (18/08/2014)
 * AUTH: megacz 
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXCONSCREEN_H_INCLUDED___
#define ___XXXCONSCREEN_H_INCLUDED___

#define QDEV_CTL_PRV_COMMOXFACT    8
#define QDEV_CTL_PRV_COMMOYFACT    7
#define QDEV_CTL_PRV_MAXDEPTH      8
#define QDEV_CTL_PRV_MINWINDIMX   32
#define QDEV_CTL_PRV_MINWINDIMY   32
#define QDEV_CTL_PRV_REPOSLIM     64
#define QDEV_CTL_PRV_MAXLINELEN  256
#define QDEV_CTL_PRV_DEFHANDLER "CON:"

/*
 * This is obsolete as of 1.33, but will stay here in case you
 * need it for some reason.
*/
#define QDEV_CTL_PRV_CWEXECUTE(cc, cw)        \
({                                            \
  struct ctl_csn_wrap *_cw = cw;              \
  if (_cw->cw_wrapcode)                       \
  {                                           \
    _cw->cw_wrapcode(cc, _cw->cw_wrapdata);   \
  }                                           \
})



/*
 * This is wrapper structure that you can use to wrap existing
 * handlers, so they wont be locked out if you decide to attach
 * your handler.
*/
struct ctl_csn_wrap
{
  void               (*cw_wrapcode)(
                       struct ctl_csn_cwin *, void *);
                                    /* IDCMP code to be executed            */
  void                *cw_wrapdata;
                                    /* IDCMP user data to be passed         */
  void                *cw_userdata;
                                    /* IDCMP new user data                  */
};

/*
 * This is custom backfill message that gets delivered each time
 * background needs to be refreshed.
*/
struct ctl_csn_bmsg
{
  struct Layer     *cb_lay;         /* Layer that generated backfill        */
  struct Rectangle  cb_rect;        /* Area in the layer to be fixed        */
  LONG              cb_offx;        /* Offset at which start in X           */
  LONG              cb_offy;        /* Offset at which start in Y           */
};

#endif /* ___XXXCONSCREEN_H_INCLUDED___ */
