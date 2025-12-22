/*********************************************************************************************\
*                                                                                             *
* TextField.c - A simple example source that demonstrates how to implement custom             *
*     images in EAGUI. This source should be included in another source, since it             *
*     does not contain headers and needs some support routines, that are usually              *
*     supplied by a parent environment.                                                       *
*                                                                                             *
* This source is placed in the public domain.                                                 *
*                                                                                             *
* Use a tab size of 5, and a right border of 95 if possible.                                  *
*                                                                                             *
\*********************************************************************************************/

/* Alternative alignment flags. If these aren't specified, the default is to
 * center the textfield both horizontally and vertically.
 */
#define CITF_ALIGNLEFT	0x00000001
#define CITF_ALIGNRIGHT	0x00000002
#define CITF_ALIGNTOP	0x00000004
#define CITF_ALIGNBOTTOM	0x00000008

/* Information that is needed by this object, but that isn't maintained by EAGUI itself. */
typedef struct ci_TextField
{
	STRPTR			tf_string_ptr;		/* string that is displayed */
	struct TextAttr *	tf_textattr_ptr;	/* font that is used */
	ULONG			tf_flags;			/* different flags */
	UBYTE			tf_frontpen;		/* front pen to use */
};

STATIC struct IntuiText itext = {
	1, 0,	/* frontpen, backpen */
	JAM1,	/* drawmode */
	0, 0,	/* left, top offset */
	NULL,	/* textattr */
	NULL,	/* text */
	NULL};	/* next intuitext */

/*********************************************************************************************\
*                                                                                             *
* MinSize Method                                                                              *
*                                                                                             *
\*********************************************************************************************/
ULONG meth_MinSize_TextField(struct Hook *hook_ptr, struct ea_Object *obj_ptr, APTR msg_ptr)
{
	ULONG				minwidth, minheight;
	struct ci_TextField *	tf_ptr;

	/* get a pointer to our structure, and check if we actually got it */
	if (tf_ptr = (struct ci_TextField *)ea_GetAttr(obj_ptr, EA_UserData))
	{
		/* now, we use the library to determine the dimensions of the string */
		minwidth = ea_TextLength(tf_ptr->tf_textattr_ptr, tf_ptr->tf_string_ptr, 0);
		minheight = ea_TextHeight(tf_ptr->tf_textattr_ptr);

		/* and finally, we set these values */
		ea_SetAttr(obj_ptr, EA_MinWidth, minwidth);
		ea_SetAttr(obj_ptr, EA_MinHeight, minheight);
	}

	/* we always return success */
	return(0);
}

/*********************************************************************************************\
*                                                                                             *
* Render Method                                                                               *
*                                                                                             *
\*********************************************************************************************/
ULONG meth_Render_TextField(struct Hook *hook_ptr, struct ea_Object *obj_ptr, struct ea_RenderMessage *rm_ptr)
{
	struct ci_TextField *	tf_ptr;
	ULONG				minwidth, minheight, width, height;
	ULONG				left, top;

	/* get a pointer to our structure, and check if we actually got it */
	if (tf_ptr = (struct ci_TextField *)ea_GetAttr(obj_ptr, EA_UserData))
	{
		/* get sizes of the object */
		ea_GetAttrs(obj_ptr,
			EA_MinWidth,		&minwidth,
			EA_MinHeight,		&minheight,
			EA_Width,			&width,
			EA_Height,		&height,
			TAG_DONE);

		/* get offsets of object relative to root (window) */
		left = ea_GetObjectLeft(rm_ptr->root_ptr, obj_ptr);
		top = ea_GetObjectTop(rm_ptr->root_ptr, obj_ptr);

		/* now align the object */
		if (tf_ptr->tf_flags & CITF_ALIGNRIGHT)
		{
			left += (width - minwidth);
		}
		else if (!(tf_ptr->tf_flags & CITF_ALIGNLEFT))
		{
			left += (width - minwidth) / 2;
		}
		if (tf_ptr->tf_flags & CITF_ALIGNBOTTOM)
		{
			top += (height - minheight);
		}
		else if (!(tf_ptr->tf_flags & CITF_ALIGNTOP))
		{
			top += (height - minheight) / 2;
		}

		/* and finally render it */
		itext.ITextFont = tf_ptr->tf_textattr_ptr;
		itext.IText = tf_ptr->tf_string_ptr;
		itext.FrontPen = tf_ptr->tf_frontpen;
		PrintIText(rm_ptr->rastport_ptr, &itext, left, top);
	}
	/* return success */
	return(0);
}

/*********************************************************************************************\
*                                                                                             *
* The end!                                                                                    *
*                                                                                             *
\*********************************************************************************************/
