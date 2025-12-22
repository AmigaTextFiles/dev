//
//    © 1996 Thomas Wilhelmi
//
// Address : Taunusstrasse 14
//           61138 Niederdorfelden
//           Germany
//
//  E-Mail : willi@twi.rhein-main.de
//
//   Phone : +49 (0)6101 531060
//   Fax   : +49 (0)6101 531061
//

//
// Dieses Demo-Programm öfnnet ein kleines Fenster
// mit drei Buttons. Wenn das Close-Gadget gedrückt
// wird, wird es wieder geschloßen.
//

#include <iostream.h>
#include <twiclasses/twimui/application.h>
#include "Class.h"


#ifdef __STORM__
#include <storm/libbase.h>
LibBaseC MUIMasterBase(MUIMASTER_NAME,MUIMASTER_VMIN,FALSE);
#endif

#ifdef __MAXON__
#include <classes/exec/libraries.h>
LibraryBaseC UtilityBase(UTILITYNAME,40);
LibraryBaseC MUIMasterBase(MUIMASTER_NAME,MUIMASTER_VMIN);
#endif


void main()
    {
#ifdef __STORM__
    if (LibBaseC::areAllOpen())
#endif
#ifdef __MAXON__
    if (LibraryBaseC::areAllOpen())
#endif
        {
        try
            {
            TWiWin Win();
            MUIApplication App(
                MUIA_Application_Title,       "TWiDemo1",
                MUIA_Application_Version,     "$VER: TWiDemo1 1.0 (22.05.96)",
                MUIA_Application_Copyright,   "c1996, Thomas Wilhelmi",
                MUIA_Application_Author,      "Thomas Wilhelmi",
                MUIA_Application_Description, "Little Demo for MUI-C++",
                MUIA_Application_Base,        "TWIDEM",
                MUIA_Application_SingleTask,  TRUE,
                SubWindow,                    (Object *)Win,
                TAG_DONE);
            Win.Notify(MUIA_Window_CloseRequest, TRUE, App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);
            App.Notify(MUIA_Application_DoubleStart, TRUE, App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);
            Win.Open(TRUE);
            App.Loop();
            Win.Open(FALSE);
            }
        catch (MUIErrorX(m))
            {
            cout << "MUIErrorX typ: " << m.typ() << endl;
            }
        catch (TWiMemX(x))
            {
            cout << "TWiMemX size: " << x.size() << endl;
            }
        catch (...)
            {
            cout << "unbekannte Exception" << endl;
            }
        }
      else
        cout << "Problem mit Library" << endl;
    };
