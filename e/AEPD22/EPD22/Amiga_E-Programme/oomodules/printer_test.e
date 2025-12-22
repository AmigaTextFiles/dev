/*
 * this tests the printer object. NOTE: those vars are only needed
 * for the graphic dump :)
 */

OPT OSVERSION=37

MODULE 'oomodules/device','exec/io','devices/printer',
       'oomodules/printer','devices/printer',
       'intuition/intuition', 'intuition/intuitionbase','graphics/gfxbase','graphics/view',
        'graphics/rastport'

PROC main()
DEF drucker:PTR TO printer,
    ibase:PTR TO intuitionbase,
    gbase:PTR TO gfxbase,
    vp:PTR TO viewport,
    rp:PTR TO rastport

  ibase:=intuitionbase
  gbase:=gfxbase
  rp := ibase.activewindow::window.rport
  vp := gbase.actiview::view.viewport

  NEW drucker

    drucker.graphicdump(        rp,
                                vp.colormap,
                                vp.modes,
                                0,0,100,100,100,100,0)

    drucker.rawwrite('Hallo', 5)
    drucker.xcommand(27) -> superscript on
    drucker.write('Hallo', 5)

    WriteF('Fehler:\d\n',drucker.io.error)


  END drucker
ENDPROC
