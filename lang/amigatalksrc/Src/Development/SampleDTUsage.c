
/***********************************************************************/
/**** METHOD 1: using AddDTObject() (parts were deleted to shorten)*****/
/**** Notice no DoDTMethod() is required. ******************************/

   Object *mypic = NULL;
   ULONG   w, h;

   if (mypic = NewDTObject( filename,

        DTA_SourceType, DTST_FILE,    /* source is a file */
        DTA_GroupID,    GID_PICTURE,  /* must be a picture */
        PDTA_Remap,     FALSE,
        TAG_DONE ))
      {

      /* get attributes we are interested in */
      GetDTAttrs( mypic, DTA_NominalHoriz, &w,
                         DTA_NominalVert,  &h,
                         TAG_DONE
                );

      /* set the attributes of our datatype object: */

      SetDTAttrs( mypic, NULL, NULL,
                  GA_Left,    0,
                  GA_Top,     0,
                  GA_Width,   w,
                  GA_Height,  h,
                  TAG_DONE
                );
      
      // Open window1 here!

      AddDTObject( window1, NULL, mypic, -1 );

         Delay( 20 );      /* Probably not the best way to wait. */

         RefreshDTObjectA( mypic, window1, NULL, NULL );

      RemoveDTObject( window1, mypic );

      DisposeDTObject( mypic );
      }

