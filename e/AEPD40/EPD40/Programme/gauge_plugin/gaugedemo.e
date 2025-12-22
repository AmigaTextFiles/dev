/*
      Discription: Demo for the gauge plugin module.
      Author     : Ralph Wermke of Digital Innovations
      EMail      : wermke@gryps1.rz.uni-greifswald.de
      Date       : 02-Apr-96
*/

OPT OSVERSION=37

MODULE  'tools/EasyGUI', 'tools/exceptions','///sources/e/modules/gauge',
        'utility/tagitem'

DEF mp:PTR TO gauge,mp2:PTR TO gauge,mp3:PTR TO gauge,mp4:PTR TO gauge,
    mp5:PTR TO gauge

PROC main() HANDLE

  easygui('GaugeDemo',
    [EQROWS,
      [COLS,
        [EQROWS,
          [PLUGIN,0,NEW mp.gauge([
                              GAUGE_BorderX,10,
                              GAUGE_BorderY,5,
                              GAUGE_Units,1000,
                              GAUGE_BorderType,GTYP_DOUBLE,
                              GAUGE_InitState,750,
                              GAUGE_BackPen,4,
                              GAUGE_BorderPen,3,
                              GAUGE_Border,GTYP_XEN,
                              GAUGE_Bar,GTYP_2D,
                              TAG_DONE])],
          [PLUGIN,0,NEW mp2.gauge([
                              GAUGE_Units,1000,
                              GAUGE_BorderType,GTYP_DOUBLE,
                              GAUGE_InitState,500,
                              GAUGE_FillPen,3,
                              GAUGE_BorderX,15,
                              GAUGE_BorderPen,4,
                              GAUGE_Height,15,
                              GAUGE_Border,GTYP_XEN,
                              GAUGE_BarRecessed,TRUE,
                              TAG_DONE])],
          [EQCOLS,
            [PLUGIN,0,NEW mp3.gauge([
                              GAUGE_Units,1000,
                              GAUGE_BorderType,GTYP_SINGLE,
                              GAUGE_InitState,500,
                              GAUGE_BackPen,0,
                              GAUGE_FillPen,3,
                              GAUGE_Border,GTYP_XEN,
                              GAUGE_Bar,GTYP_XEN,
                              GAUGE_BarRecessed,FALSE,
                              GAUGE_BorderRecessed,FALSE,
                              TAG_DONE])],
            [PLUGIN,0,NEW mp4.gauge([
                              GAUGE_Units,1000,
                              GAUGE_BorderType,GTYP_NONE,
                              GAUGE_InitState,500,
                              GAUGE_BackPen,5,
                              GAUGE_FillPen,4,
                              GAUGE_Width,GAUGE_FREE,
                              GAUGE_Height,GAUGE_FREE,
                              GAUGE_BorderX,5,
                              GAUGE_BorderY,5,
                              GAUGE_Bar,GTYP_3D,
                              GAUGE_BarRecessed,FALSE,
                              TAG_DONE])]
          ]
        ],
        [PLUGIN,0,NEW mp5.gauge([
                              GAUGE_Units,1000,
                              GAUGE_BorderType,GTYP_DOUBLE,
                              GAUGE_InitState,500,
                              GAUGE_BorderPen,2,
                              GAUGE_BackPen,5,
                              GAUGE_FillPen,4,
                              GAUGE_Width,GAUGE_FREE,
                              GAUGE_Height,GAUGE_FREE,
                              GAUGE_BorderX,5,
                              GAUGE_BorderY,5,
                              GAUGE_Bar,GTYP_2D,
                              GAUGE_BarRecessed,TRUE,
                              GAUGE_BorderRecessed,FALSE,
                              TAG_DONE])]
      ],
      [SLIDE,{slide},NIL,FALSE,0,1000,3,0,NIL]
    ]
    )
EXCEPT
  report_exception()
ENDPROC

PROC slide(info,x)
mp.set(x)
mp2.set(x)
mp3.set(x)
mp4.set(x)
mp5.set(x)
ENDPROC
/*EE folds
-1
94 5 
EE folds*/
