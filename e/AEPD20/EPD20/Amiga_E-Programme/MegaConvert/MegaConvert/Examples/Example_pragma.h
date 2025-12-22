
/******************************************************************************

This file is part of the MegaConvert distribution. It may not be changed and/or
(re-)distributed under any means that do not preserve the MegaConvert license.

******************************************************************************/

/* We define the library base name and some public functions .. */
#pragma libcall ExampleBase ExampleFunction1 1e 9802
#pragma libcall ExampleBase ExampleFunction2 24 09803

/* It's easy to enclose some private/reserved/obsolete with »/*« and »*/« .. */
/* #pragma libcall ExampleBase ExampleFunction3 2a 9802 */
/* #pragma libcall ExampleBase ExampleFunction4 30 09803 */

/* .. but for AmigaE you shouldn't (better prefix them »Private_« or so) ! */
#pragma libcall ExampleBase Private_ExampleFunction3 2a 9802
#pragma libcall ExampleBase Private_ExampleFunction4 30 09803

