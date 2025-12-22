/*
**      $Filename: Globals.c $
**      $Release: 1.0 $
**      $Revision: 38.4 $
**
**      Global data.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard.
**/

#include "GenGTXSource.h"

/*
 *      Make these visible to all modules.
 */
Prototype struct GTXBase        *GTXBase;
Prototype struct IntuitionBase  *IntuitionBase;
Prototype struct Library        *NoFragBase;
Prototype struct Library        *GfxBase;
Prototype struct Library        *GadToolsBase;
Prototype struct Library        *UtilityBase;
Prototype struct Library        *LocaleBase;
Prototype struct RDArgs         *SArgs;
Prototype struct ShellArgs       Arguments;
Prototype BPTR                   MainSource, Header, Protos, Templates, Locale, stdOut;
Prototype struct GadToolsConfig  MainConfig;
Prototype struct GenC            SourceConfig;
Prototype struct WindowList      Windows;
Prototype GUIDATA                GuiInfo;
Prototype ULONG                  ValidBits;
Prototype struct MemoryChain    *Chain;
Prototype UBYTE                 *Template;
Prototype struct StringList      Strings;
Prototype struct ArrayList       Arrays;
Prototype struct Catalog        *Catalog;

/*
 *      Program libraries.
 */
struct GTXBase                  *GTXBase            =   NULL;
struct IntuitionBase            *IntuitionBase      =   NULL;
struct Library                  *NoFragBase         =   NULL;
struct Library                  *GfxBase            =   NULL;
struct Library                  *GadToolsBase       =   NULL;
struct Library                  *UtilityBase        =   NULL;
struct Library                  *LocaleBase         =   NULL;

/*
 *      Locale stuff.
 */
struct Catalog                  *Catalog            =   NULL;

/*
 *      Program startup via Shell.
 */
struct RDArgs                   *SArgs              =   NULL;
struct ShellArgs                 Arguments;

/*
 *      Source output streams.
 */
BPTR                             MainSource         =   NULL;
BPTR                             Header             =   NULL;
BPTR                             Protos             =   NULL;
BPTR                             Locale             =   NULL;
BPTR                             stdOut             =   NULL;

/*
 *      GUI file storage space.
 */
struct GadToolsConfig            MainConfig;
struct GenC                      SourceConfig;
struct WindowList                Windows;
GUIDATA                          GuiInfo;
ULONG                            ValidBits;

/*
 *      NoFrag memory chains.
 */
struct MemoryChain              *Chain              =   NULL;

/*
 *      Version string and ReadArgs() template.
 */
Local UBYTE                      VString[] = { "\0$VER: GenGTXSource 38.183 (18.1.93)" };
UBYTE                           *Template = "NAME/A,TO/A,BUILTIN/K,CATALOG/K/A,PREPEND/K,VERSION/K/N,QUIET/S";

/*
 *      For the "smart-string" system.
 */
struct StringList                Strings;
struct ArrayList                 Arrays;
