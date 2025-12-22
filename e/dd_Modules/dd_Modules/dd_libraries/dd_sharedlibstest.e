MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'lowlevel'

MODULE '*dd_sharedlibs'

DEF libs:sharedlibs

PROC main()
  NEW libs.new([DDA_LIB_LibraryList,
                  [
                   ['utility.library',37,{utilitybase}]:libentry,
                   ['lowlevel.library',39,{lowlevelbase}]:libentry
                  ],
                TAG_DONE])
->     libs.do(DDM_LIB_OpenLibrary,{lowlevelbase})

  -> PrintF('Libraries opened\n')
  END libs
ENDPROC
