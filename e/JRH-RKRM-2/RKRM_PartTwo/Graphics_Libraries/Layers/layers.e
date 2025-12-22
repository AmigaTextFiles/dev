-> Layers.e

->>> Header (globals)
OPT PREPROCESS

MODULE 'layers',
       'graphics/clip',
       'graphics/layers',
       'graphics/gfx',
       'graphics/gfxbase',
       'graphics/rastport',
       'graphics/view'

ENUM ERR_NONE, ERR_BLYR, ERR_CMAP, ERR_LIB, ERR_LYR

RAISE ERR_BLYR IF CreateBehindLayer()=NIL,
      ERR_CMAP IF GetColorMap()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_LYR  IF NewLayerInfo()=NIL

CONST L_DELAY=100, S_DELAY=50, DUMMY=0

ENUM RED_PEN=1, GREEN_PEN, BLUE_PEN

CONST SCREEN_D=2, SCREEN_W=320, SCREEN_H=200

-> The starting size of example layers, offsets are used for placement.
CONST W_H=50, W_T=5, W_W=80
CONST W_B=W_T+W_H-1
CONST SWH=SCREEN_W/2, WWH=W_W/2
CONST W_L=SWH-WWH
CONST W_R=W_L+W_W-1

-> Size of the superbitmap.
CONST SUPER_H=SCREEN_H, SUPER_W=SCREEN_W

-> Starting size of the message layer.
CONST M_H=10, M_W=SCREEN_W, M_L=0
CONST M_T=SCREEN_H-M_H
CONST M_B=M_T+M_H-1
CONST M_R=M_L+M_W-1

DEF theLayerFlags:PTR TO LONG, colourtable:PTR TO INT
->>>

->>> PROC myLabelLayer(layer:PTR TO layer, colour, string)
-> Clear the layer THEN draw in a text string.
PROC myLabelLayer(layer:PTR TO layer, colour, string)
  -> Fill layer with colour
  SetRast(layer.rp, colour)

  -> Set up for writing text into layer
  SetDrMd(layer.rp, RP_JAM1)
  SetAPen(layer.rp, 0)
  Move(layer.rp, 5, 7)

  -> Write into layer
  Text(layer.rp, string, StrLen(string))
ENDPROC
->>>

->>> PROC pMessage(layer, string)
-> Write a message into a layer with a delay.
PROC pMessage(layer, string)
  Delay(S_DELAY)
  myLabelLayer(layer, GREEN_PEN, string)
ENDPROC
->>>

->>> PROC error(layer, string)
-> Write an error message into a layer with a delay.
PROC error(layer, string)
  myLabelLayer(layer, RED_PEN, string)
  Delay(L_DELAY)
ENDPROC
->>>

->>> PROC doLayers(msgLayer, layer_array:PTR TO LONG)
-> Do some layers manipulations to demonstrate their abilities.
PROC doLayers(msgLayer, layer_array:PTR TO LONG)
  DEF ktr, ktr_2, tlayer:PTR TO layer

  pMessage(msgLayer, 'Label all Layers')
  myLabelLayer(layer_array[0], RED_PEN,   'SUPER')
  myLabelLayer(layer_array[1], GREEN_PEN, 'Smart')
  myLabelLayer(layer_array[2], BLUE_PEN,  'Simple')

  pMessage(msgLayer, 'MoveLayer 1 InFrontOf 0')
  IF FALSE=MoveLayerInFrontOf(layer_array[1], layer_array[0])
    error(msgLayer, 'MoveLayerInFrontOf() failed.')
  ENDIF

  pMessage(msgLayer, 'MoveLayer 2 InFrontOf 1')
  IF FALSE=MoveLayerInFrontOf(layer_array[2], layer_array[1])
    error(msgLayer, 'MoveLayerInFrontOf() failed.')
  ENDIF

  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN, 'Simple')

  pMessage(msgLayer, 'Incrementally MoveLayers...')
  FOR ktr:=0 TO 29
    IF FALSE=MoveLayer(DUMMY, layer_array[1], -1, 0)
      error(msgLayer, 'MoveLayer() failed.')
    ENDIF
    IF FALSE=MoveLayer(DUMMY, layer_array[2], -2, 0)
      error(msgLayer, 'MoveLayer() failed.')
    ENDIF
  ENDFOR

  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN, 'Simple')

  pMessage(msgLayer, 'Make Layer 0 the UpfrontLayer')
  IF FALSE=UpfrontLayer(DUMMY, layer_array[0])
    error(msgLayer, 'UpfrontLayer() failed.')
  ENDIF

  pMessage(msgLayer, 'Make Layer 2 the BehindLayer')
  IF FALSE=BehindLayer(DUMMY, layer_array[2])
    error(msgLayer, 'BehindLayer() failed.')
  ENDIF

  pMessage(msgLayer, 'Incrementally MoveLayers again...')
  FOR ktr:=0 TO 29
    IF FALSE=MoveLayer(DUMMY, layer_array[1], 0, 1)
      error(msgLayer, 'MoveLayer() failed.')
    ENDIF
    IF FALSE=MoveLayer(DUMMY, layer_array[2], 0, 2)
      error(msgLayer, 'MoveLayer() failed.')
    ENDIF
  ENDFOR

  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN, 'Simple')

  pMessage(msgLayer, 'Big MoveLayer')
  FOR ktr:=0 TO 2
    tlayer:=layer_array[ktr]
    IF FALSE=MoveLayer(DUMMY, tlayer, -tlayer.minx, 0)
      error(msgLayer, 'MoveLayer() failed.')
    ENDIF
  ENDFOR

  pMessage(msgLayer, 'Incrementally increase size')
  FOR ktr:=0 TO 4
    FOR ktr_2:=0 TO 2
      IF FALSE=SizeLayer(DUMMY, layer_array[ktr_2], 1, 1)
        error(msgLayer, 'SizeLayer() failed.')
      ENDIF
    ENDFOR
  ENDFOR

  pMessage(msgLayer, 'Refresh Smart Refresh Layer')
  myLabelLayer(layer_array[1], GREEN_PEN, 'Smart')
  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN,  'Simple')

  pMessage(msgLayer, 'Big SizeLayer')
  FOR ktr:=0 TO 2
    tlayer:=layer_array[ktr]
    IF FALSE=SizeLayer(DUMMY, tlayer, SCREEN_W-tlayer.maxx-1, 0)
      error(msgLayer, 'SizeLayer() failed.')
    ENDIF
  ENDFOR

  pMessage(msgLayer, 'Refresh Smart Refresh Layer')
  myLabelLayer(layer_array[1], GREEN_PEN, 'Smart')
  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN,  'Simple')

  pMessage(msgLayer, 'ScrollLayer down')
  FOR ktr:=0 TO 29
    FOR ktr_2:=0 TO 2
      ScrollLayer(DUMMY, layer_array[ktr_2], 0, -1)
    ENDFOR
  ENDFOR

  pMessage(msgLayer, 'Refresh Smart Refresh Layer')
  myLabelLayer(layer_array[1], GREEN_PEN, 'Smart')
  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN,  'Simple')

  pMessage(msgLayer, 'ScrollLayer up')
  FOR ktr:=0 TO 29
    FOR ktr_2:=0 TO 2
      ScrollLayer(DUMMY, layer_array[ktr_2], 0, 1)
    ENDFOR
  ENDFOR

  pMessage(msgLayer, 'Refresh Smart Refresh Layer')
  myLabelLayer(layer_array[1], GREEN_PEN, 'Smart')
  pMessage(msgLayer, 'Refresh Simple Refresh Layer')
  myLabelLayer(layer_array[2], BLUE_PEN,  'Simple')

  Delay(L_DELAY)
ENDPROC
->>>

->>> PROC disposeLayers(msgLayer, layer_array:PTR TO LONG)
-> Delete the layer array created by allocLayers().
PROC disposeLayers(msgLayer, layer_array:PTR TO LONG)
  DEF ktr
  FOR ktr:=0 TO 2
    IF layer_array[ktr]
      IF FALSE=DeleteLayer(DUMMY, layer_array[ktr])
        error(msgLayer, 'Error deleting layer')
      ENDIF
    ENDIF
  ENDFOR
ENDPROC
->>>

->>> PROC allocLayers(msgLayer,layer_array,super_bitmap,theLayerInfo,theBitMap)
-> Create some hard-coded layers.  The first must be SUPER-bitmap, with the
-> bitmap passed as an argument.  The others must not be super-bitmap. The
-> pointers to the created layers are returned in layer_array.
->
-> Return FALSE on failure.  On a FALSE return, the layers are properly
-> cleaned up.
PROC allocLayers(msgLayer, layer_array:PTR TO LONG, super_bitmap,
                 theLayerInfo, theBitMap) HANDLE
  DEF ktr, tlayer:PTR TO layer
  FOR ktr:=0 TO 2
    pMessage(msgLayer, 'Create BehindLayer')
    IF ktr=0
      tlayer:=CreateBehindLayer(theLayerInfo, theBitMap,
                  W_L+(ktr*30), W_T+(ktr*30), W_R+(ktr*30), W_B+(ktr*30),
                  theLayerFlags[ktr], super_bitmap)
    ELSE
      tlayer:=CreateBehindLayer(theLayerInfo, theBitMap,
                  W_L+(ktr*30), W_T+(ktr*30), W_R+(ktr*30), W_B+(ktr*30),
                  theLayerFlags[ktr], NIL)
    ENDIF

    pMessage(msgLayer, 'Fill the RastPort')
    SetRast(tlayer.rp, ktr+1)
    layer_array[ktr]:=tlayer
  ENDFOR
EXCEPT
  disposeLayers(msgLayer, layer_array)
  ReThrow()
ENDPROC
->>>

->>> PROC disposeBitMap(bitmap:PTR TO bitmap, depth, width, height)
-> Free the bitmap and all bitplanes created by allocBitMap().
PROC disposeBitMap(bitmap:PTR TO bitmap, depth, width, height)
  DEF ktr
  IF bitmap
    FOR ktr:=0 TO depth-1
      IF bitmap.planes[ktr] THEN FreeRaster(bitmap.planes[ktr], width, height)
    ENDFOR
    Dispose(bitmap)
  ENDIF
ENDPROC
->>>

->>> PROC allocBitMap(depth, width, height)
-> Allocate and initialize a bitmap structure.
PROC allocBitMap(depth, width, height) HANDLE
  DEF ktr, bitmap=NIL:PTR TO bitmap
  NEW bitmap
  InitBitMap(bitmap, depth, width, height)

  FOR ktr:=0 TO depth-1
    bitmap.planes[ktr]:=AllocRaster(width, height)
    BltClear(bitmap.planes[ktr], RASSIZE(width, height), 1)
  ENDFOR
EXCEPT
  disposeBitMap(bitmap, depth, width, height)
  ReThrow()
ENDPROC bitmap
->>>

->>> PROC startLayers(theLayerInfo, theBitMap)
-> Set up to run the layers example, doLayers(). Clean up when done.
PROC startLayers(theLayerInfo, theBitMap) HANDLE
  DEF msgLayer=NIL, theSuperBitMap=NIL, theLayers=NIL
  theLayers:=[NIL, NIL, NIL]:LONG
  IF msgLayer:=CreateUpfrontLayer(theLayerInfo, theBitMap,
                                  M_L, M_T, M_R, M_B, LAYERSMART, NIL)
    pMessage(msgLayer, 'Setting up Layers')
    theSuperBitMap:=allocBitMap(SCREEN_D, SUPER_W, SUPER_H)
    allocLayers(msgLayer, theLayers, theSuperBitMap, theLayerInfo, theBitMap)
    doLayers(msgLayer, theLayers)
  ENDIF
EXCEPT DO
  disposeLayers(msgLayer, theLayers)
  disposeBitMap(theSuperBitMap, SCREEN_D, SUPER_W, SUPER_H)
  IF msgLayer
    IF FALSE=DeleteLayer(DUMMY, msgLayer)
      error(msgLayer, 'Error deleting layer')
    ENDIF
  ENDIF
ENDPROC
->>>

->>> PROC runNewView()
-> Set up a low-level graphics display for layers to work on.  Layers should
-> not be built directly on Intuition screens, use a low-level graphics view. 
-> If you need mouse or other events for the layers display, you have to get
-> them directly from the input device.  The only supported method of using
-> layers library calls with Intuition (other than the InstallClipRegion()
-> call) is through Intuition windows.
->
-> See graphics primitives chapter for details on creating and using the
-> low-level graphics calls.
PROC runNewView() HANDLE
  DEF theView:view, oldview:PTR TO view, theViewPort:viewport,
      theRasInfo, theColourMap=NIL:PTR TO colormap,
      theLayerInfo=NIL:PTR TO layer_info, theBitMap=NIL:PTR TO bitmap,
      colourpalette:PTR TO INT, ktr, gfx:PTR TO gfxbase

  -> E-Note: get the right type...
  gfx:=gfxbase
  -> Save current view, to be restored when done
  IF oldview:=gfx.actiview
    -> Get a LayerInfo structure
    theLayerInfo:=NewLayerInfo()
    theColourMap:=GetColorMap(4)
    colourpalette:=theColourMap.colortable;
    FOR ktr:=0 TO 3 DO colourpalette[]++:=colourtable[ktr]

    theBitMap:=allocBitMap(SCREEN_D, SCREEN_W, SCREEN_H)
    InitView(theView)
    InitVPort(theViewPort)

    theView.viewport:=theViewPort

    theRasInfo:=[NIL, theBitMap, 0, 0]:rasinfo

    theViewPort.dwidth:=SCREEN_W; theViewPort.dheight:=SCREEN_H
    theViewPort.rasinfo:=theRasInfo; theViewPort.colormap:=theColourMap

    MakeVPort(theView, theViewPort); MrgCop(theView); LoadView(theView)
    WaitTOF()

    startLayers(theLayerInfo, theBitMap)

    -> Put back the old view, wait for it to become active before freeing any
    -> of our display
    LoadView(oldview)
    WaitTOF()

    -> Free dynamically created structures
    FreeVPortCopLists(theViewPort)
    FreeCprList(theView.lofcprlist)
  ENDIF
EXCEPT DO
  IF theBitMap THEN disposeBitMap(theBitMap, SCREEN_D, SCREEN_W, SCREEN_H)
  IF theColourMap THEN FreeColorMap(theColourMap)
  IF theLayerInfo THEN DisposeLayerInfo(theLayerInfo)
  ReThrow()
ENDPROC
->>>

->>> PROC main()
-> Open the libraries used by the example.  Clean up when done.
PROC main() HANDLE
  -> Global constant data for initialising the layers.
  theLayerFlags:=[LAYERSUPER, LAYERSMART, LAYERSIMPLE]:LONG
  colourtable:=[$000, $F44, $4F4, $44F]:INT

  layersbase:=OpenLibrary('layers.library', 33)
  runNewView()
EXCEPT DO
  IF layersbase THEN CloseLibrary(layersbase)
ENDPROC
->>>

