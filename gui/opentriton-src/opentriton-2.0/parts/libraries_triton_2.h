
/***********************************************************************************************************/
/******************************************************************* Public parts of the Project structure */
/***********************************************************************************************************/

#ifndef TR_THIS_IS_TRITON

typedef struct TR_Project
{
  struct TROD_Object            tro_SC_Object;                  /* PRIVATE! */
  struct TR_App *               trp_App;                        /* Our application */
  VOID *                        trp_MemPool;                    /* The memory pool */
  ULONG                         trp_ID;                         /* The project's ID */
  ULONG                         trp_IDCMPFlags;                 /* The IDCMP flags */
  struct Window *               trp_Window;                     /* The default window */
  UWORD                         trp_AspectFixing;               /* Pixel aspect correction factor */
} TR_Project;

#endif


/***********************************************************************************************************/
/************************************************************************************************* The End */
/***********************************************************************************************************/

#endif /* LIBRARIES_TRITON_H */
