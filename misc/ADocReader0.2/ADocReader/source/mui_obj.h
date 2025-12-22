
#define PopStringDrawer(name,id)      Child, PopaslObject,\
                                        MUIA_Popasl_Type, 0,\
                                        MUIA_Popstring_String, (name) = StringObject,\
                                          StringFrame,\
                                          MUIA_ExportID, (id),\
                                        End,\
                                        MUIA_Popstring_Button, PopButton(MUII_PopDrawer),\
                                        ASLFR_DrawersOnly, TRUE,\
                                      End

#define PopStringFile(name,id)        Child, PopaslObject,\
                                        MUIA_Popasl_Type, 0,\
                                        MUIA_Popstring_String, (name) = StringObject,\
                                          StringFrame,\
                                          MUIA_ExportID, (id),\
                                        End,\
                                        MUIA_Popstring_Button, PopButton(MUII_PopFile),\
                                      End

