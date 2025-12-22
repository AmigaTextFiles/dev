/***************************************
*  FIELD REFRESH v1.45
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <graphics/text.h>
#include <intuition/intuition.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

int field_refresh( header, first, count, place )
  struct FieldHeader *header;
  struct Field *first;
  UINT   count;
  struct Field *place;
{
  void   DrawBorder();        /* intuition.lib */
  void   DrawImage();         /* intuition.lib */
  struct Field *field;        /* for stepping thru field list */
  int    i = 0;               /* number of fields refreshed */
  void   PrintIText();        /* intuition.lib */

  field = first;
  cursor_invisible( header->WriteReq );
  while (field && i < count) {
    field->Bottom = field->Top - 1 + header->Window->BorderBottom +
                    header->Window->IFont->tf_YSize;
    field->Right  = field->Left - 1 + header->Window->BorderRight +
                    field->MaxChars * header->Window->IFont->tf_XSize;
    if (field->FieldImage)
      DrawImage( header->Window->RPort, field->FieldImage, (long)(field->Left), (long)(field->Top) );
    if (field->FieldBorder)
      DrawBorder( header->Window->RPort, field->FieldBorder, (long)(field->Left), (long)(field->Top) );
    if (field->FieldTitle)
      PrintIText( header->Window->RPort, field->FieldTitle, (long)(field->Left), (long)(field->Top) );
    if (header->Window->Height > field->Bottom) {
      cursor_place( header->WriteReq, field->Left, field->Top );
      con_graphic_rend( header->WriteReq, field->Style, field->FrontPen, field->BackPen );
      con_line_length( header->WriteReq, field->MaxChars );
      con_put_string( header->WriteReq, field->Buffer );
    }
    field = field->NextField;
    i++;
  }
  if (place)
    field_goto( header, place );

  return (i);
}
