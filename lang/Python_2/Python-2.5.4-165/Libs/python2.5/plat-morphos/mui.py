import _muimaster

##############
## Constants
##

# Append all MUIO_xxxx types
globals().update([ (x, getattr(_muimaster, x)) for x in dir(_muimaster) if x.startswith('MUIO_') ])
del x

MUIA_Parent                         = 0x8042e35f

MUIA_Window_ID                      = 0x804201bd
MUIA_Window_RootObject              = 0x8042cba5
MUIA_Window_Open                    = 0x80428aa0
MUIA_Window_Title                   = 0x8042ad3d

MUIA_Application_Window             = 0x8042bfe0
MUIA_Application_Author             = 0x80424842
MUIA_Application_Base               = 0x8042e07a
MUIA_Application_Copyright          = 0x8042ef4d
MUIA_Application_Description        = 0x80421fc6
MUIA_Application_Title              = 0x804281b8
MUIA_Application_Version            = 0x8042b33f

MUIA_Font                           = 0x8042be50
MUIA_Frame                          = 0x8042ac64
MUIA_ControlChar                    = 0x8042120b
MUIA_InputMode                      = 0x8042fb04
MUIA_Background                     = 0x8042545b

MUIA_Text_Contents                  = 0x8042f8dc
MUIA_Text_HiChar                    = 0x804218ff
MUIA_Text_PreParse                  = 0x8042566d
MUIA_Text_SetMax                    = 0x80424d0a
MUIA_Text_SetMin                    = 0x80424e10
MUIA_Text_SetVMax                   = 0x80420d8b

MUIV_Frame_Button = 1
MUIV_Font_Button = -7
MUIV_InputMode_RelVerify = 1

MUII_ButtonBack      = 2


##############
## Classes
##

class MUIObject(_muimaster.MUIObject):
    def __init__(self, **kw):
        _id = kw.get('id', -1)

        if _id >= 0:
            self.id = _id
        else:
            self.id = id(self)

        return []

    def __del__(self):
        try:
            del self._obj
        except:
            pass
        del self


class Button(MUIObject):
    def __init__(self, label, key=None, *args, **kw):
        tags = MUIObject.__init__(self, *args, **kw)

        tags += ( MUIA_Frame        , MUIV_Frame_Button,
                  MUIA_Font         , MUIV_Font_Button,
                  MUIA_Text_Contents, label,
                  MUIA_Text_PreParse, "\33c",
                  MUIA_InputMode    , MUIV_InputMode_RelVerify,
                  MUIA_Background   , MUII_ButtonBack )
        if key:
            key = ord(key)
            tags += ( MUIA_Text_HiChar, key,
                      MUIA_ControlChar, key )

        self._init("Text.mui", tuple(tags))


class Window(MUIObject):
    def __init__(self, title='', root=None, *args, **kw):
        tags = MUIObject.__init__(self, *args, **kw)

        tags += ( MUIA_Window_ID, self.id,
                  MUIA_Window_RootObject, root,
                  MUIA_Window_Title, title )

        self.root = root
        self._init("Window.mui", tuple(tags))


class Application(MUIObject):
    def __init__(self, window, *args, **kw):
        tags = MUIObject.__init__(self, *args, **kw)
        
        self.window = window

        tags += ( MUIA_Application_Window, window )

        if kw.has_key("title"): tags += (MUIA_Application_Title, kw["title"])
        if kw.has_key("version"): tags += (MUIA_Application_Version, kw["version"])
        if kw.has_key("copyright"): tags += (MUIA_Application_Copyright, kw["copyright"])
        if kw.has_key("author"): tags += (MUIA_Application_Author, kw["author"])
        if kw.has_key("description"): tags += (MUIA_Application_Description, kw["description"])
        if kw.has_key("base"): tags += (MUIA_Application_Base, kw["base"])

        self._init("Application.mui", tuple(tags))


mainloop = _muimaster.mainloop
del _muimaster
