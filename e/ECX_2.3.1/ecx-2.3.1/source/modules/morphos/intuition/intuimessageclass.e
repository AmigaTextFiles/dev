OPT MODULE, EXPORT
MODULE 'utility/tagitem'

/*
** Introduced in intuition.library 51. All attributes are *G*. Pointers valid
** until the message is replied.
** Every struct IntuiMessage * can be treated as an Object *
*/

CONST IMSGA_Dummy             = (TAG_USER + $60000)
CONST IMSGA_Class             = (IMSGA_Dummy + 1) /* ULONG */
CONST IMSGA_Code              = (IMSGA_Dummy + 3) /* ULONG */
CONST IMSGA_Qualifier         = (IMSGA_Dummy + 4) /* ULONG */
CONST IMSGA_IAddress          = (IMSGA_Dummy + 5) /* ULONG */
CONST IMSGA_MouseX            = (IMSGA_Dummy + 6) /* LONG */
CONST IMSGA_MouseY            = (IMSGA_Dummy + 7) /* LONG */
CONST IMSGA_Seconds           = (IMSGA_Dummy + 8) /* ULONG */
CONST IMSGA_Micros            = (IMSGA_Dummy + 9) /* ULONG */
CONST IMSGA_IDCMPWindow       = (IMSGA_Dummy + 10) /* struct Window * */
CONST IMSGA_RawMouseX         = (IMSGA_Dummy + 11) /* LONG, raw, unaccelerated delta */
CONST IMSGA_RawMouseY         = (IMSGA_Dummy + 12) /* LONG */
CONST IMSGA_UCS4              = (IMSGA_Dummy + 13) /* ULONG, UCS4 */