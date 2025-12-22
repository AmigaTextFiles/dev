-> BarDemo shows the usage of the bar-plugin

OPT OSVERSION=37

MODULE 'tools/EasyGUI','plugins/bar','utility/tagitem','tools/exceptions'

DEF   mp:PTR TO bar,mp2:PTR TO bar,mp3:PTR TO bar,mp4:PTR TO bar,
      mp5:PTR TO bar,mp6:PTR TO bar,mp7:PTR TO bar,mp8:PTR TO bar,mp9:PTR TO bar,
      mp10:PTR TO bar,mp11:PTR TO bar,mp12:PTR TO bar,mp13:PTR TO bar,mp14:PTR TO bar,
      mp15:PTR TO bar

PROC main() HANDLE

  easygui('Bar Plugin Demo',
         [EQROWS,
            [ROWS,
               [PLUGIN,0,NEW mp.bar([BAR_Text,'BAR-PLUGIN-DEMO',
                                     BAR_TextType,BARTXT_Shadow,
                                     BAR_BarPos,BARPOS_Below,
                                     TAG_DONE])],
               [BEVEL,
                  [EQCOLS,
                     [ROWS,
                        [PLUGIN,0,NEW mp2.bar([BAR_Text,'Left Aligned',
                                               BAR_Font,'topaz.font',
                                               BAR_FontHeight,11,
                                               BAR_TextType,BARTXT_Shadow,
                                               BAR_TextPos,BARTXT_Left,
                                               TAG_DONE])],
                        [BEVELR,
                           [SPACE]
                        ]
                     ],
                     [ROWS,
                        [PLUGIN,0,NEW mp3.bar([BAR_Text,'Centred',
                                               BAR_FontHeight,11,
                                               BAR_TextPos,BARTXT_Center,
                                               BAR_TextType,BARTXT_Shadow,
                                               TAG_DONE])],
                        [BEVELR,
                           [SPACE]
                        ]
                     ],
                     [ROWS,
                        [PLUGIN,0,NEW mp4.bar([BAR_Text,'Right Aligned',
                                               BAR_FontHeight,11,
                                               BAR_TextPos,BARTXT_Right,
                                               BAR_TextType,BARTXT_Shadow,
                                               TAG_DONE])],
                        [BEVELR,
                           [SPACE]
                        ]
                     ]
                  ]
               ],
               [BEVEL,
                  [EQROWS,
                     [PLUGIN,0,NEW mp5.bar([BAR_Text,'Different Bar Positions',
                                            BAR_BarPos,BARPOS_Below,
                                            TAG_DONE])],
                     [BEVELR,
                        [EQCOLS,
                           [PLUGIN,0,NEW mp6.bar([BAR_Text,'Below',
                                                  BAR_TextType,BARTXT_Shadow,
                                                  BAR_BarPos,BARPOS_Below,
                                                  TAG_DONE])],
                           [PLUGIN,0,NEW mp7.bar([BAR_Text,'Bottom',
                                                  BAR_TextType,BARTXT_Shadow,
                                                  BAR_BarPos,BARPOS_Bottom,
                                                  TAG_DONE])],
                           [PLUGIN,0,NEW mp8.bar([BAR_Text,'Baseline',
                                                  BAR_TextType,BARTXT_Shadow,
                                                  BAR_BarPos,BARPOS_BaseLine,
                                                  TAG_DONE])],
                           [PLUGIN,0,NEW mp9.bar([BAR_Text,'Center',
                                                  BAR_TextType,BARTXT_Shadow,
                                                  BAR_BarPos,BARPOS_Center,
                                                  TAG_DONE])],
                           [PLUGIN,0,NEW mp10.bar([BAR_Text,'Top',
                                                  BAR_TextType,BARTXT_Shadow,
                                                  BAR_BarPos,BARPOS_Top,
                                                  TAG_DONE])],
                           [PLUGIN,0,NEW mp11.bar([BAR_Text,'Above',
                                                  BAR_TextType,BARTXT_Shadow,
                                                  BAR_BarPos,BARPOS_Above,
                                                  TAG_DONE])]
                        ]
                     ]
                  ]
               ],
               [COLS,
                  [PLUGIN,0,NEW mp12.bar([BAR_Direction, BARDIR_Vertical,TAG_DONE])],
                  [ROWS,
                     [PLUGIN,0,NEW mp13.bar([BAR_Text,'Bar Plugin v1.0 (09-Jun-96)',
                                         BAR_TextType,BARTXT_Shadow,
                                         BAR_BarPos,BARPOS_Above,
                                         TAG_DONE])],
                     [PLUGIN,0,NEW mp14.bar([BAR_Text,'Copyright by Ralph Wermke of Digital Innovations',
                                         BAR_TextType,BARTXT_Shadow,
                                         BAR_BarPos,BARPOS_Below,
                                         TAG_DONE])]
                  ],
                  [PLUGIN,0,NEW mp15.bar([BAR_Direction, BARDIR_Vertical,TAG_DONE])]
               ]
            ]
         ])

END mp, mp2, mp3, mp4, mp5, mp6, mp7, mp8, mp9
EXCEPT
  report_exception()
ENDPROC


