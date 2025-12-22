(*
(*	$VER: cybergl.h 1.1 (09.04.97) (39.9)
**	
**	Copyright © 1996-1997 by phase5 digital products
** All Rights reserved.
**
********
**
** OberonVersion by T.Igracki@Jana.berlinet.de (01.04.97)
** 12.04.97: Added v39.9 changes
** 19.04.97: Fix: error in UnProjectAPI(), obj(xyz) was "booleanPtr" should be "doublePtr";
**           Fix: All ..API() routines were defined false, are now a real procedures!
*)
*)
MODULE CyberGL;
IMPORT
  y: SYSTEM, e: Exec, u: Utility, I: Intuition, G: Graphics;

CONST
  name * = "cybergl.library"; minversion * = 39;

CONST
  accumBuffer    * =  0; (* accumulation buffer mask *)
  colorBuffer    * =  1; (* color buffer mask *)
  current        * =  2; (* current values mask *)
  depthBuffer    * =  3; (* depth buffer mask *)
  enable         * =  4; (* enable mask *)
  eval           * =  5; (* evaluator mask *)
  fog            * =  6; (* fog mask *)
  hint           * =  7; (* hint mask *)
  lighting       * =  8; (* lighting mask *)
  line           * =  9; (* line mask *)
  list           * = 10; (* display list mask *)
  pixelMode      * = 11; (* pixel mode mask *)
  point          * = 12; (* point mask *)
  polygon        * = 13; (* polygon mask *)
  polygonStipple * = 14; (* polygon stipple mask *)
  scissor        * = 15; (* scissor mask *)
  stencilBuffer  * = 16; (* stencil buffer mask *)
  texture        * = 17; (* texture mask *)
  transform      * = 18; (* transformation mask *)
  viewport       * = 19; (* viewport mask *)
  allAttrib      * = LONGSET{accumBuffer,    colorBuffer,
                             current,        depthBuffer,
                             enable,         eval,
                             fog,            hint,
                             lighting,       line,
                             list,           pixelMode,
                             point,          polygon,
                             polygonStipple, scissor,
                             stencilBuffer,  texture,
                             transform,      viewport};
                                         (* all attrib bits at once *)

(*----------------------Types--------------------------------*)
TYPE
  void        * = e.APTR;   (* C: void, Oberon: ?*)
  voidPtr     * = UNTRACED POINTER TO void;   

  bitfield    * = LONGSET;  (* C: unsigned long  *)
  bitfieldPtr * = UNTRACED POINTER TO bitfield;

  byte        * = SHORTINT; (* C: signed char    *)
  bytePtr     * = UNTRACED POINTER TO byte;

  short       * = SHORTINT; (* C: short          *)
  shortPtr    * = UNTRACED POINTER TO short;

  int         * = LONGINT;  (* C: long           *)
  intPtr      * = UNTRACED POINTER TO int;

  sizei       * = LONGINT;  (* C: unsigned long  *)
  sizeiPtr    * = UNTRACED POINTER TO sizei;

  ubyte       * = CHAR;     (* C: unsigned char  *)
  ubytePtr    * = UNTRACED POINTER TO ubyte;

  ushort      * = y.BYTE;   (* C: unsigned short *)
  ushortPtr   * = UNTRACED POINTER TO ushort;

  uint        * = LONGINT;  (* C: unsigned long  *)
  uintPtr     * = UNTRACED POINTER TO uint;

  float       * = REAL;     (* C: float          *)
  floatPtr    * = UNTRACED POINTER TO float;

  clampf      * = REAL;     (* C: float          *)
  clampfPtr   * = UNTRACED POINTER TO clampf;

  double      * = LONGREAL; (* C: double         *)
  doublePtr   * = UNTRACED POINTER TO double;
  
  clampd      * = LONGREAL; (* C: double         *)
  clampdPtr   * = UNTRACED POINTER TO clampd;
  
CONST
  false     * = 0; (* for type "boolean" *)
  true      * = 1; (* for type "boolean" *)
TYPE
  boolean    * = SHORTINT; (* the above defined "false" or "true" *)
  booleanPtr * = UNTRACED POINTER TO boolean;
  enum       * = INTEGER;  (* the below defined "enumerated constants" *)
CONST
  (* enumerated constants *)
  cNoError                            * =  0; (* no error occured *)
  cInvalidEnum                        * =  1; (* invalid enum specified *)
  cInvalidValue                       * =  2; (* invalid value specified *)
  cInvalidOperation                   * =  3; (* invalid operation executed *)
  cStackOverflow                      * =  4; (* stack overflow error *)
  cStackUnderflow                     * =  5; (* stack underflow error *)
  cOutOfMemory                        * =  6; (* out of memory *)
  cNotImplemented                     * =  7; (* not implemented in simpleGL *)
  cNoPrimitive                        * =  8; (* currently not in begin/end mode *)
  cPoints                             * =  9; (* assembling points *)
  cLineStrip                          * = 10; (* assembling a line strip *)
  cLineLoop                           * = 11; (* assembling a line loop *)
  cLines                              * = 12; (* assembling lines *)
  cPolygon                            * = 13; (* assembling a polygon *)
  cTriangleStrip                      * = 14; (* assembling a triangle strip *)
  cTriangleFan                        * = 15; (* assembling a triangle fan *)
  cTriangles                          * = 16; (* assembling triangles *)
  cQuadStrip                          * = 17; (* assembling a quad strip *)
  cQuads                              * = 18; (* assembling quads *)
  cClipPlane0                         * = 19; (* clip plane 0 *)
  cClipPlane1                         * = 20; (* clip plane 1 *)
  cClipPlane2                         * = 21; (* clip plane 2 *)
  cClipPlane3                         * = 22; (* clip plane 3 *)
  cClipPlane4                         * = 23; (* clip plane 4 *)
  cClipPlane5                         * = 24; (* clip plane 5 *)
  cLess                               * = 25; (* pass depth test if new z is less *)
  cAlways                             * = 26; (* always pass depth test *)
  cGequal                             * = 27; (* pass depth test if new z is greater or equal *)
  cGreater                            * = 28; (* pass depth test if new z is greater *)
  cLequal                             * = 29; (* pass depth test if new z is less or equal *)
  cEqual                              * = 30; (* pass depth test if new z is equal *)
  cNotEqual                           * = 31; (* pass depth test if new z is different *)
  cNever                              * = 32; (* never pass depth test *)
  cNone                               * = 33; (* draw to no buffer *)
  cFrontLeft                          * = 34; (* draw to front left buffer *)
  cFrontRight                         * = 35; (* draw to front right buffer *)
  cBackLeft                           * = 36; (* draw to back left buffer *)
  cBackRight                          * = 37; (* draw to back right buffer *)
  cLeft                               * = 38; (* draw to front and back left buffers *)
  cRight                              * = 39; (* draw to front and back right buffers *)
  cFront                              * = 40; (* draw to left and right front buffers *)
  cBack                               * = 41; (* draw to left and right back buffers *)
  cFrontAndBack                       * = 42; (* draw to all buffers *)
  cAux0                               * = 43; (* draw to auxiliary buffer 0 *)
  cColorMaterial                      * = 44; (* enable current color tracking *)
  cCullFace                           * = 45; (* enable back face culling *)
  cDepthTest                          * = 46; (* enable depth test *)
  cFog                                * = 47; (* enable fog calculation *)
  cLighting                           * = 48; (* enable lighting *)
  cNormalize                          * = 49; (* enable auto normalization *)
  cDither                             * = 50; (* enable dithering *)
  cFogMode                            * = 51; (* specify fog mode *)
  cFogDensity                         * = 52; (* specify fog density *)
  cFogStart                           * = 53; (* distance where no fog occurs *)
  cFogEnd                             * = 54; (* distance where full fog occurs *)
  cFogColor                           * = 55; (* color of fog *)
  cFogIndex                           * = 56; (* not implemented *)
  cCw                                 * = 57; (* clock wise *)
  cCcw                                * = 58; (* counter clock wise *)
  cAuxBuffers                         * = 59; (* get number of auxiliary buffers *)
  cDepthBits                          * = 60; (* get number of depth buffer bits *)
  cRedBits                            * = 61; (* get number of red component bits *)
  cGreenBits                          * = 62; (* get number of green component bits *)
  cBlueBits                           * = 63; (* get number of blue component bits *)
  cAlphaBits                          * = 64; (* get number of alpha component bits *)
  cColorClearValue                    * = 65; (* get current clear color *)
  cColorMaterialFace                  * = 66; (* get current color tracking face(s) *)
  cColorMaterialParameter             * = 67; (* get current color tracking material property *)
  cCullFaceMode                       * = 68; (* get current cull face mode *)
  cCurrentColor                       * = 69; (* get current color *)
  cCurrentNormal                      * = 70; (* get current normal *)
  cDepthClearValue                    * = 71; (* get current depth clear value *)
  cDepthFunc                          * = 72; (* get current depth test function *)
  cDepthRange                         * = 73; (* get current depth range *)
  cDoublebuffer                       * = 74; (* ask wheter doublebuffering is possible *)
  cDrawBuffer                         * = 75; (* get current draw buffer(s) *)
  cEdgeFlag                           * = 76; (* get current edge flag *)
  cFrontFace                          * = 77; (* get current front face orientation *)
  cMatrixMode                         * = 78; (* get current matrix mode *)
  cMaxClipPlanes                      * = 79; (* get maximum number of clipping planes *)
  cMaxLights                          * = 80; (* get maximum number of lights *)
  cMaxModelviewStackDepth             * = 81; (* get maximum modelview matrix stack depth *)
  cMaxNameStackDepth                  * = 82; (* get maximum name stack depth *)
  cMaxProjectionStackDepth            * = 83; (* get maximum projection matrix stack depth *)
  cMaxViewportDims                    * = 84; (* get maximum viewport dimensions *)
  cModelviewMatrix                    * = 85; (* get current modelview matrix *)
  cModelviewStackDepth                * = 86; (* get current modelview matrix stack depth *)
  cNameStackDepth                     * = 87; (* get current name stack depth *)
  cPolygonMode                        * = 88; (* get current polygon rasterisation mode *)
  cProjectionMatrix                   * = 89; (* get current projection matrix *)
  cProjectionStackDepth               * = 90; (* get current projection matrix stack depth *)
  cRenderMode                         * = 91; (* get current render mode *)
  cShadeModel                         * = 92; (* get current shade model *)
  cStereo                             * = 93; (* ask whether stereo drawing is possible  *)
  cViewport                           * = 94; (* get current viewport dimensions *)
  cVendor                             * = 95; (* get the implementation company's name *)
  cRenderer                           * = 96; (* get platform specific string *)
  cVersion                            * = 97; (* get release version *)
  cExtensions                         * = 98; (* get list of extensions *)
  cFogHint                            * = 99; (* get current fog hint *)
  cPerspectiveCorrectionHint          * = 100;(* get current perspective correction hint *)
  cFastest                            * = 101;(* hint value 'fastest' *)
  cNicest                             * = 102;(* hint value 'nicest' *)
  cDontCare                           * = 103;(* do not care about hint *)
  cLight0                             * = 104;(* light 0 *)
  cLight1                             * = 105;(* light 1 *)
  cLight2                             * = 106;(* light 2 *)
  cLight3                             * = 107;(* light 3 *)
  cLight4                             * = 108;(* light 4 *)
  cLight5                             * = 109;(* light 5 *)
  cLight6                             * = 110;(* light 6 *)
  cLight7                             * = 111;(* light 7 *)
  cAmbient                            * = 112;(* ambient color *)
  cDiffuse                            * = 113;(* diffuse color *)
  cSpecular                           * = 114;(* specular color *)
  cPosition                           * = 115;(* light position *)
  cSpotExponent                       * = 116;(* spot exponent *)
  cSpotCutoff                         * = 117;(* spot light cutoff angle *)
  cSpotDirection                      * = 118;(* spot light direction *)
  cConstantAttenuation                * = 119;(* constant attenuation factor *)
  cLinearAttenuation                  * = 120;(* linear attenuation factor *)
  cQuadraticAttenuation               * = 121;(* quadratic attenuation factor *)
  cLightModelLocalViewer              * = 122;(* viewer at infinity or at [0,0,0,1] *)
  cLightModelTwoSide                  * = 123;(* handle front and back materials different *)
  cLightModelAmbient                  * = 124;(* ambient color of scene *)
  cEmission                           * = 125;(* emissive color *)
  cShininess                          * = 126;(* specular reflection shininess *)
  cAmbientAndDiffuse                  * = 127;(* ambient and diffuse color *)
  cModelview                          * = 128;(* modelview matrix mode *)
  cProjection                         * = 129;(* perspective matrix mode *)
  cPoint                              * = 130;(* polygon rasterisation mode 'point' *)
  cLine                               * = 131;(* polygon rasterisation mode 'line' *)
  cFill                               * = 132;(* polygon rasterisation mode 'fill' *)
  cRender                             * = 133;(* render primitives *)
  cSelect                             * = 134;(* determine selected primitives *)
  cFeedback                           * = 135;(* determine data, that would have been rendered *)
  cFlat                               * = 136;(* flat shading *)
  cSmooth                             * = 137;(* gouraud shading *)
  cS                                  * = 138;(* TexGen s coordinate *)
  cT                                  * = 139;(* TexGen t coordinate *)
  cR                                  * = 140;(* TexGen r coordinate *)
  cQ                                  * = 141;(* TexGen q coordinate *)
  cPackSwapBytes                      * = 142;(* swap bytes while packing image data *)
  cPackLsbFirst                       * = 143;(* swap bits while packing image data *)
  cPackRowLength                      * = 144;(* image row length for packing *)
  cPackSkipPixels                     * = 145;(* image left offset for packing *)
  cPackSkipRows                       * = 146;(* image bottom offset for packing *)
  cPackAlignment                      * = 147;(* image packing row alignment *)
  cUnpackSwapBytes                    * = 148;(* swap bytes while unpacking image data *)
  cUnpackLsbFirst                     * = 149;(* swap bits while unpacking image data *)
  cUnpackRowLength                    * = 150;(* image row length for unpacking *)
  cUnpackSkipPixels                   * = 151;(* image left offset for unpacking *)
  cUnpackSkipRows                     * = 152;(* image bottom offset for unpacking *)
  cUnpackAlignment                    * = 153;(* image unpacking row alignment *)
  cMapColor                           * = 154;(* color mapping via lookup tables *)
  cMapStencil                         * = 155;(* stencil mapping vias lookup table *)
  cIndexShift                         * = 156;(* index shift for images *)
  cIndexOffset                        * = 157;(* index offset for images *)
  cRedScale                           * = 158;(* red scale for images *)
  cRedBias                            * = 159;(* red bias for images *)
  cGreenScale                         * = 160;(* green scale for images *)
  cGreenBias                          * = 161;(* green bias for images *)
  cBlueScale                          * = 162;(* blue scale for images *)
  cBlueBias                           * = 163;(* blue bias for images *)
  cAlphaScale                         * = 164;(* alpha scale for images *)
  cAlphaBias                          * = 165;(* alpha bias for images *)
  cDepthScale                         * = 166;(* depth scale for images *)
  cDepthBias                          * = 167;(* depth bias for images *)
  cAlphaTest                          * = 168;(* not implemented *)
  cAutoNormal                         * = 169;(* not implemented *)
  cModulate                           * = 170;(* texture environment mode modulate *)
  cDecal                              * = 171;(* texture environment mode decal *)
  cBlend                              * = 172;(* texture environment mode blend *)
  cLineSmooth                         * = 173;(* not implemented *)
  cLineStipple                        * = 174;(* not implemented *)
  cLogicOp                            * = 175;(* not implemented *)
  cMap1Color4                         * = 176;(* not implemented *)
  cMap1Index                          * = 177;(* not implemented *)
  cMap1Normal                         * = 178;(* not implemented *)
  cMap1TextureCoord1                  * = 179;(* not implemented *)
  cMap1TextureCoord2                  * = 180;(* not implemented *)
  cMap1TextureCoord3                  * = 181;(* not implemented *)
  cMap1TextureCoord4                  * = 182;(* not implemented *)
  cMap1Vertex3                        * = 183;(* not implemented *)
  cMap1Vertex4                        * = 184;(* not implemented *)
  cMap2Color4                         * = 185;(* not implemented *)
  cMap2Index                          * = 186;(* not implemented *)
  cMap2Normal                         * = 187;(* not implemented *)
  cMap2TextureCoord1                  * = 188;(* not implemented *)
  cMap2TextureCoord2                  * = 189;(* not implemented *)
  cMap2TextureCoord3                  * = 190;(* not implemented *)
  cMap2TextureCoord4                  * = 191;(* not implemented *)
  cMap2Vertex3                        * = 192;(* not implemented *)
  cMap2Vertex4                        * = 193;(* not implemented *)
  cPointSmooth                        * = 194;(* not implemented *)
  cPolygonSmooth                      * = 195;(* not implemented *)
  cPolygonStipple                     * = 196;(* not implemented *)
  cScissorTest                        * = 197;(* not implemented *)
  cStencilTest                        * = 198;(* not implemented *)
  cTexture1d                          * = 199;(* 1D texture mapping *)
  cTexture2d                          * = 200;(* 2D texture mapping *)
  cTextureGenQ                        * = 201;(* q-texture-coordinate generation *)
  cTextureGenR                        * = 202;(* r-texture-coordinate generation *)
  cTextureGenS                        * = 203;(* s-texture-coordinate generation *)
  cTextureGenT                        * = 204;(* t-texture-coordinate generation *)
  cAccumAlphaBits                     * = 205;(* not implemented *)
  cAccumBlueBits                      * = 206;(* not implemented *)
  cAccumClearValue                    * = 207;(* not implemented *)
  cAccumGreenBits                     * = 208;(* not implemented *)
  cAccumRedBits                       * = 209;(* not implemented *)
  cAlphaTestFunc                      * = 210;(* not implemented *)
  cAlphaTestRef                       * = 211;(* not implemented *)
  cAttribStackDepth                   * = 212;(* attribute stack depth *)
  cBlendDst                           * = 213;(* not implemented *)
  cBlendSrc                           * = 214;(* not implemented *)
  cColorWritemask                     * = 215;(* not implemented *)
  cCurrentIndex                       * = 216;(* not implemented *)
  cCurrentRasterColor                 * = 217;(* not implemented *)
  cCurrentRasterIndex                 * = 218;(* not implemented *)
  cCurrentRasterPosition              * = 219;(* not implemented *)
  cCurrentRasterTextureCoords         * = 220;(* not implemented *)
  cCurrentRasterPositionValid         * = 221;(* not implemented *)
  cCurrentTextureCoords               * = 222;(* not implemented *)
  cDepthWritemask                     * = 223;(* not implemented *)
  cIndexBits                          * = 224;(* number of color index bits *)
  cIndexClearValue                    * = 225;(* not implemented *)
  cIndexMode                          * = 226;(* not implemented *)
  cIndexWritemask                     * = 227;(* not implemented *)
  cLineSmoothHint                     * = 228;(* not implemented *)
  cLineStipplePattern                 * = 229;(* not implemented *)
  cLineStippleRepeat                  * = 230;(* not implemented *)
  cLineWidth                          * = 231;(* not implemented *)
  cLineWidthGranularity               * = 232;(* not implemented *)
  cLineWidthRange                     * = 233;(* not implemented *)
  cListBase                           * = 234;(* not implemented *)
  cListIndex                          * = 235;(* not implemented *)
  cListMode                           * = 236;(* not implemented *)
  cLogicOpMode                        * = 237;(* not implemented *)
  cMap1Color04                        * = 238;(* not implemented *)
  cMap1GridDomain                     * = 239;(* not implemented *)
  cMap1GridSegments                   * = 240;(* not implemented *)
  cMap2Color04                        * = 241;(* not implemented *)
  cMap2GridDomain                     * = 242;(* not implemented *)
  cMap2GridSegments                   * = 243;(* not implemented *)
  cMaxAttribStackDepth                * = 244;(* not implemented *)
  cMaxEvalOrder                       * = 245;(* not implemented *)
  cMaxListNesting                     * = 246;(* not implemented *)
  cMaxPixelMapTable                   * = 247;(* maximum mapping table size *)
  cMaxTextureSize                     * = 248;(* maximum texture size *)
  cMaxTextureStackDepth               * = 249;(* maximum texture stack depth *)
  cPixelMapAtoAsize                   * = 250;(* alpha to alpha mapping table size *)
  cPixelMapBtoBsize                   * = 251;(* blue to blue mapping table size *)
  cPixelMapGtoGsize                   * = 252;(* green to green mapping table size *)
  cPixelMapItoAsize                   * = 253;(* index to alpha mapping table size *)
  cPixelMapItoBsize                   * = 254;(* index to blue mapping table size *)
  cPixelMapItoGsize                   * = 255;(* index to green mapping table size *)
  cPixelMapItoIsize                   * = 256;(* index to index mapping table size *)
  cPixelMapItoRsize                   * = 257;(* index to red mapping table size *)
  cPixelMapRtoRsize                   * = 258;(* red to red mapping table size *)
  cPixelMapStoSsize                   * = 259;(* stencil to stencil mapping table size *)
  cPixelMapAtoA                       * = 260;(* alpha to alpha mapping table *)
  cPixelMapBtoB                       * = 261;(* blue to blue mapping table *)
  cPixelMapGtoG                       * = 262;(* green to green mapping table *)
  cPixelMapItoA                       * = 263;(* index to alpha mapping table *)
  cPixelMapItoB                       * = 264;(* index to blue mapping table *)
  cPixelMapItoG                       * = 265;(* index to green mapping table *)
  cPixelMapItoI                       * = 266;(* index to index mapping table *)
  cPixelMapItoR                       * = 267;(* index to red mapping table *)
  cPixelMapRtoR                       * = 268;(* red to red mapping table *)
  cPixelMapStoS                       * = 269;(* stencil to stencil mapping table *)
  cPointSize                          * = 270;(* not implemented *)
  cPointSizeGranularity               * = 271;(* not implemented *)
  cPointSizeRange                     * = 272;(* not implemented *)
  cPointSmoothHint                    * = 273;(* not implemented *)
  cPolygonSmoothHint                  * = 274;(* not implemented *)
  cReadBuffer                         * = 275;(* not implemented *)
  cRgbaMode                           * = 276;(* RGBA mode *)
  cScissorBox                         * = 277;(* not implemented *)
  cStencilBits                        * = 278;(* not implemented *)
  cStencilClearValue                  * = 279;(* not implemented *)
  cStencilFail                        * = 280;(* not implemented *)
  cStencilFunc                        * = 281;(* not implemented *)
  cStencilPassDepthFail               * = 282;(* not implemented *)
  cStencilPassDepthPass               * = 283;(* not implemented *)
  cStencilRef                         * = 284;(* not implemented *)
  cStencilValueMask                   * = 285;(* not implemented *)
  cStencilWritemask                   * = 286;(* not implemented *)
  cSubpixelBits                       * = 287;(* not implemented *)
  cTextureEnv                         * = 288;(* texture environment *)
  cTextureEnvColor                    * = 289;(* texture environment color *)
  cTextureEnvMode                     * = 290;(* texture environment mode *)
  cTextureMatrix                      * = 291;(* texture matrix *)
  cTextureStackDepth                  * = 292;(* texture matrix stack depth *)
  cZoomX                              * = 293;(* pixel zoom x-value for images *)
  cZoomY                              * = 294;(* pixel zoom y-value for images *)
  cColorIndexes                       * = 295;(* not implemented *)
  cTexture                            * = 296;(* not implemented *)
  cUnsignedByte                       * = 297;(* unsigned byte type *)
  cByte                               * = 298;(* byte type *)
  cBitmap                             * = 299;(* single bits in unsigned byte type *)
  cUnsignedShort                      * = 300;(* unsigned short type *)
  cShort                              * = 301;(* short type *)
  cUnsignedInt                        * = 302;(* unsigned int type *)
  cInt                                * = 303;(* int type *)
  cFloat                              * = 304;(* float type *)
  cColorIndex                         * = 305;(* color index image *)
  cStencilIndex                       * = 306;(* stencil index image *)
  cDepthComponent                     * = 307;(* depth component image *)
  cRed                                * = 308;(* red image *)
  cGreen                              * = 309;(* green image *)
  cBlue                               * = 310;(* blue image *)
  cAlpha                              * = 311;(* alpha image *)
  cRgb                                * = 312;(* rgb image *)
  cRgba                               * = 313;(* rgba image *)
  cLuminance                          * = 314;(* luminance image *)
  cLuminanceAlpha                     * = 315;(* luminance alpha image *)
  cLinear                             * = 316;(* fog mode linear *)
  cExp                                * = 317;(* fog mode exp    *)
  cExp2                               * = 318;(* fog mode exp2   *)
  cEyeLinear                          * = 319;(* eye linear texture generation mode *)
  cObjectLinear                       * = 320;(* object linear texture generation mode *)
  cSphereMap                          * = 321;(* sphere map texture generation mode *)
  cTextureGenMode                     * = 322;(* texture generation mode *)
  cObjectPlane                        * = 323;(* object plane equation for texture generation *)
  cEyePlane                           * = 324;(* eye plane equation for texture generation *)
  cTextureWrapS                       * = 325;(* texture wrapping mode for s-coordinate *)
  cTextureWrapT                       * = 326;(* texture wrapping mode for t-coordinate *)
  cTextureMinFilter                   * = 327;(* texture minification filter type *)
  cTextureMagFilter                   * = 328;(* texture magnification filter type *)
  cTextureBorderColor                 * = 329;(* texture border color *)
  cClamp                              * = 330;(* texture wrapping mode clamp *)
  cRepeat                             * = 331;(* texture wrapping mode repeat *)
  cNearest                            * = 332;(* texture filter type nearest texel *)
  cNearestMipmapNearest               * = 333;(* texture filter type nearest mipmap nearest texel *)
  cNearestMipmapLinear                * = 334;(* texture filter type nearest mipmap linear texel *)
  cLinearMipmapNearest                * = 335;(* texture filter type linear mipmap nearest texel *)
  cLinearMipmapLinear                 * = 336;(* texture filter type linear mipmap linear texel *)
  cTextureWidth                       * = 337;(* texture image width *)
  cTextureHeight                      * = 338;(* texture image height *)
  cTextureComponents                  * = 339;(* texture image component number *)
  cTextureBorder                      * = 340;(* texture image border *)

TYPE
  lookAtPtr * = UNTRACED POINTER TO lookAt;
  lookAt * = STRUCT
    eyex     *,
    eyey     *,
    eyez     *,
    centerx  *,
    centery  *,
    centerz  *,
    upx      *,
    upy      *,
    upz      *: double;
   END;

   projectPtr * = UNTRACED POINTER TO project;
   project * = STRUCT
     objx *,
     objy *,
     objz *: double;
     winx *,		(* x coordinate of resulting point *)
     winy *,		(* y coordinate of resulting point *)
     winz *: doublePtr; (* z coordinate of resulting point *)
   END;

   unProjectPtr * = UNTRACED POINTER TO unProject;
   unProject * = STRUCT
     winx *,
     winy *,
     winz *: double;
     objx *,		(* x coordinate of resulting point *)
     objy *,		(* y coordinate of resulting point *)
     objz *: doublePtr; (* z coordinate of resulting point *)
   END;

   frustumPtr * = UNTRACED POINTER TO frustum;
   frustum * = STRUCT
     left   *,
     right  *,
     bottom *,
     top    *,
     zNear  *,
     zFar   *: double;
   END;

   orthoPtr * = UNTRACED POINTER TO ortho;
   ortho * = STRUCT
     left   *,
     right  *,
     bottom *,
     top    *,
     zNear  *,
     zFar   *: double;
   END;

   bitmapPtr * = UNTRACED POINTER TO bitmap;
   bitmap * = STRUCT
     width  * : sizei;
     height * : sizei;
     xorig  * : float;
     yorig  * : float;
     xmove  * : float;
     ymove  * : float;
     bitmap * : UNTRACED POINTER TO ubyte;
   END;

(*** CyberGL Display *)
CONST
  waDummy * = u.user + 299;

(* CyberGL specific tags *)

  waRGBAMode           * = waDummy + 0;
  waOffsetX            * = waDummy + 1;
  waOffsetY            * = waDummy + 2;
  waError              * = waDummy + 3;
  waBuffered           * = waDummy + 4;

(* window specific tags *)

  waLeft              * = I.waLeft;
  waTop               * = I.waTop;
  waWidth             * = I.waWidth;
  waHeight            * = I.waHeight;
  waDetailPen         * = I.waDetailPen;
  waBlockPen          * = I.waBlockPen;
  waIDCMP             * = I.waIDCMP;
  waFlags             * = I.waFlags;
  waGadgets           * = I.waGadgets;
  waCheckmark         * = I.waCheckmark;
  waTitle             * = I.waTitle;
  waScreenTitle       * = I.waScreenTitle;
  waCustomScreen      * = I.waCustomScreen;
  waMinWidth          * = I.waMinWidth;
  waMinHeight         * = I.waMinHeight;
  waMaxWidth          * = I.waMaxWidth;
  waMaxHeight         * = I.waMaxHeight;
  waInnerWidth        * = I.waInnerWidth;
  waInnerHeight       * = I.waInnerHeight;
  waPubScreenName     * = I.waPubScreenName;
  waPubScreen   	 	   * = I.waPubScreen;
  waPubScreenFallBack * = I.waPubScreenFallBack;
  waColors            * = I.waColors;
  waZoom              * = I.waZoom;
  waMouseQueue        * = I.waMouseQueue;
  waBackFill          * = I.waBackFill;
  waRptQueue          * = I.waRptQueue;
  waSizeGadget        * = I.waSizeGadget;
  waDragBar           * = I.waDragBar;
  waDepthGadget       * = I.waDepthGadget;
  waCloseGadget       * = I.waCloseGadget;
  waBackdrop          * = I.waBackdrop;
  waReportMouse       * = I.waReportMouse;
  waNoCareRefresh     * = I.waNoCareRefresh;
  waBorderless        * = I.waBorderless;
  waActivate          * = I.waActivate;
  waRMBTrap           * = I.waRMBTrap;
  waSimpleRefresh     * = I.waSimpleRefresh;
  waSmartRefresh      * = I.waSmartRefresh;
  waSizeBRight        * = I.waSizeBRight;
  waSizeBBottom       * = I.waSizeBBottom;
  waAutoAdjust        * = I.waAutoAdjust;
  waGimmeZeroZero     * = I.waGimmeZeroZero;
  waMenuHelp          * = I.waMenuHelp;
  waNewLookMenus      * = I.waNewLookMenus;
  waAmigaKey          * = I.waAmigaKey;
  waNotifyDepth       * = I.waNotifyDepth;
  waPointer           * = I.waPointer;
  waBusyPointer       * = I.waBusyPointer;
  waPointerDelay      * = I.waPointerDelay;
  waTabletMessages    * = I.waTabletMessages;
  waHelpGroup         * = I.waHelpGroup;
  waHelpGroupWindow   * = I.waHelpGroupWindow;

VAR
  base -: e.LibraryPtr;

(* now the procedures *)

(*--------------gl window related ---------------------------------------------*)

PROCEDURE openGLWindowTagList    * {base, - 1EH} (width{0}, height{1}: int; tagList{8} : ARRAY OF u.TagItem): voidPtr;
PROCEDURE openGLWindowTags       * {base, - 1EH} (width{0}, height{1}: int; tag1{8}.. : u.Tag): voidPtr;
PROCEDURE closeGLWindow          * {base, - 24H} (window{8}: voidPtr);

PROCEDURE attachGLWindowTagList  * {base, - 2AH} (wnd{8}: I.WindowPtr; width{0}, height{1}: int; tagList{9}  : ARRAY OF u.TagItem): voidPtr;
PROCEDURE attachGLWindowTags     * {base, - 2AH} (wnd{8}: I.WindowPtr; width{0}, height{1}: int; tag1   {9}..: u.Tag): voidPtr;
PROCEDURE disposeGLWindow        * {base, - 30H} (window{8}: voidPtr);
PROCEDURE resizeGLWindow         * {base, - 36H} (window{8}: voidPtr; width{0}, height{1}: int);

PROCEDURE getWindow              * {base, - 3CH} (window{8}: voidPtr): I.WindowPtr;

PROCEDURE allocColor             * {base, - 42H} (window{8}: voidPtr; r{0}, g{1}, b{2}: ubyte);
PROCEDURE allocColorRange        * {base, - 48H} (window{8}: voidPtr; r1{0}, g1{1}, b1{2}, r2{3}, g2{4}, b2{5}, num{6}: ubyte);
PROCEDURE attachGLWndToRPTagList * {base, - 4EH} (scr{8}: I.ScreenPtr; rp{9}: G.RastPortPtr; width{0}, height{1}: int; tagList{10}  : ARRAY OF u.TagItem): voidPtr;
PROCEDURE attachGLWndToRPTags    * {base, - 4EH} (scr{8}: I.ScreenPtr; rp{9}: G.RastPortPtr; width{0}, height{1}: int; tag1   {10}..: u.Tag): voidPtr;

(*----------------------Contexts-----------------------------*)

PROCEDURE GetError               * {base, - 66H} (): enum;
PROCEDURE Enable                 * {base, - 6CH} (cap{0}: enum);

PROCEDURE Disable                * {base, - 72H} (cap{0}: enum);
PROCEDURE IsEnabled              * {base, - 78H} (cap{0}: enum): boolean;
PROCEDURE GetBooleanv            * {base, - 7EH} (pname{0}: enum; VAR params{8}: boolean);
PROCEDURE GetIntegerv            * {base, - 84H} (pname{0}: enum; VAR params{8}: int);
PROCEDURE GetFloatv              * {base, - 8AH} (pname{0}: enum; VAR params{8}: float);
PROCEDURE GetDoublev             * {base, - 90H} (pname{0}: enum; VAR params{8}: double);
PROCEDURE GetClipPlane           * {base, - 96H} (plane{0}: enum; VAR equation{8}: double);
PROCEDURE GetLightfv             * {base, - 9CH} (light{0}: enum; pname{1}: enum; VAR params{8}: float);
PROCEDURE GetLightiv             * {base, -0A2H} (light{0}: enum; pname{1}: enum; VAR params{8}: int);
PROCEDURE GetMaterialfv          * {base, -0A8H} (face{0}: enum;  pname{1}: enum; VAR params{8}: float);
PROCEDURE GetMaterialiv          * {base, -0AEH} (face{0}: enum;  pname{1}: enum; VAR params{8}: int);
PROCEDURE GetTexGendv            * {base, -0B4H} (coord{0}: enum; pname{1}: enum; VAR params{8}: double);
PROCEDURE GetTexGenfv            * {base, -0BAH} (coord{0}: enum; pname{1}: enum; VAR params{8}: float);
PROCEDURE GetTexGeniv            * {base, -0C0H} (coord{0}: enum; pname{1}: enum; VAR params{8}: int);
PROCEDURE GetPixelMapfv          * {base, -0C6H} (map{0}: enum; VAR values{8}: float);
PROCEDURE GetPixelMapuiv         * {base, -0CCH} (map{0}: enum; VAR values{8}: uint);
PROCEDURE GetPixelMapusv         * {base, -0D2H} (map{0}: enum; VAR values{8}: ushort);
PROCEDURE GetTexEnvfv            * {base, -0D8H} (target{0}: enum; pname{1}: enum; VAR params{8}: float);
PROCEDURE GetTexEnviv            * {base, -0DEH} (target{0}: enum; pname{1}: enum; VAR params{8}: int);
PROCEDURE GetTexLevelParameterfv * {base, -0E4H} (target{0}: enum; level{1}: int;  pname{2}: enum; VAR params{8}: float);
PROCEDURE GetTexLevelParameteriv * {base, -0EAH} (target{0}: enum; level{1}: int;  pname{2}: enum; VAR params{8}: int);
PROCEDURE GetTexParameterfv      * {base, -0F0H} (target{0}: enum; pname{1}: enum; VAR params{8}: float);
PROCEDURE GetTexParameteriv      * {base, -0F6H} (target{0}: enum; pname{1}: enum; VAR params{8}: int);
PROCEDURE GetTexImage            * {base, -0FCH} (target{0}: enum; level{1}: int;  format{2}: enum; type{3}: enum; VAR pixels{8}: void);
PROCEDURE GetString              * {base, -102H} (name{0}: enum): ubytePtr;
PROCEDURE PushAttrib             * {base, -108H} (mask{0}: bitfield);
PROCEDURE PopAttrib              * {base, -10EH} ();

(*----------------------Primitives---------------------------*)

PROCEDURE Begin          * {base, -114H} (mode{0}: enum);
PROCEDURE End            * {base, -11AH} ();
PROCEDURE Vertex2s       * {base, -120H} (x{0}, y{1}: short);
PROCEDURE Vertex2i       * {base, -126H} (x{0}, y{1}: int);
PROCEDURE Vertex2f       * {base, -12CH} (x{0}, y{1}: float);
PROCEDURE Vertex2d       * {base, -132H} (x{0}, y{1}: double);
PROCEDURE Vertex3s       * {base, -138H} (x{0}, y{1}, z{2}: short);
PROCEDURE Vertex3i       * {base, -13EH} (x{0}, y{1}, z{2}: int);
PROCEDURE Vertex3f       * {base, -144H} (x{0}, y{1}, z{2}: float);
PROCEDURE Vertex3d       * {base, -14AH} (x{0}, y{1}, z{2}: double);
PROCEDURE Vertex4s       * {base, -150H} (x{0}, y{1}, z{2}, w{3}: short);
PROCEDURE Vertex4i       * {base, -156H} (x{0}, y{1}, z{2}, w{3}: int);
PROCEDURE Vertex4f       * {base, -15CH} (x{0}, y{1}, z{2}, w{3}: float);
PROCEDURE Vertex4d       * {base, -162H} (x{0}, y{1}, z{2}, w{3}: double);
PROCEDURE Vertex2sv      * {base, -168H} (v{8}: shortPtr ); (* const *)
PROCEDURE Vertex2iv      * {base, -16EH} (v{8}: intPtr   ); (* const *)
PROCEDURE Vertex2fv      * {base, -174H} (v{8}: floatPtr ); (* const *)
PROCEDURE Vertex2dv      * {base, -17AH} (v{8}: doublePtr); (* const *)
PROCEDURE Vertex3sv      * {base, -180H} (v{8}: shortPtr ); (* const *)
PROCEDURE Vertex3iv      * {base, -186H} (v{8}: intPtr   ); (* const *)
PROCEDURE Vertex3fv      * {base, -18CH} (v{8}: floatPtr ); (* const *)
PROCEDURE Vertex3dv      * {base, -192H} (v{8}: doublePtr); (* const *)
PROCEDURE Vertex4sv      * {base, -198H} (v{8}: shortPtr ); (* const *)
PROCEDURE Vertex4iv      * {base, -19EH} (v{8}: intPtr   ); (* const *)
PROCEDURE Vertex4fv      * {base, -1A4H} (v{8}: floatPtr ); (* const *)
PROCEDURE Vertex4dv      * {base, -1AAH} (v{8}: doublePtr); (* const *)

PROCEDURE TexCoord1s     * {base, -1B0H} (s{0}: short);
PROCEDURE TexCoord1i     * {base, -1B6H} (s{0}: int);
PROCEDURE TexCoord1f     * {base, -1BCH} (s{0}: float);
PROCEDURE TexCoord1d     * {base, -1C2H} (s{0}: double);
PROCEDURE TexCoord2s     * {base, -1C8H} (s{0}, t{1}: short);
PROCEDURE TexCoord2i     * {base, -1CEH} (s{0}, t{1}: int);
PROCEDURE TexCoord2f     * {base, -1D4H} (s{0}, t{1}: float);
PROCEDURE TexCoord2d     * {base, -1DAH} (s{0}, t{1}: double);
PROCEDURE TexCoord3s     * {base, -1E0H} (s{0}, t{1}, r{2}: short);
PROCEDURE TexCoord3i     * {base, -1E6H} (s{0}, t{1}, r{2}: int);
PROCEDURE TexCoord3f     * {base, -1ECH} (s{0}, t{1}, r{2}: float);
PROCEDURE TexCoord3d     * {base, -1F2H} (s{0}, t{1}, r{2}: double);
PROCEDURE TexCoord4s     * {base, -1F8H} (s{0}, t{1}, r{2}, q{3}: short);
PROCEDURE TexCoord4i     * {base, -1FEH} (s{0}, t{1}, r{2}, q{3}: int);
PROCEDURE TexCoord4f     * {base, -204H} (s{0}, t{1}, r{2}, q{3}: float);
PROCEDURE TexCoord4d     * {base, -20AH} (s{0}, t{1}, r{2}, q{3}: double);
PROCEDURE TexCoord1sv    * {base, -210H} (v{8}: shortPtr ); (* const *)
PROCEDURE TexCoord1iv    * {base, -216H} (v{8}: intPtr   ); (* const *)
PROCEDURE TexCoord1fv    * {base, -21CH} (v{8}: floatPtr ); (* const *)
PROCEDURE TexCoord1dv    * {base, -222H} (v{8}: doublePtr); (* const *)
PROCEDURE TexCoord2sv    * {base, -228H} (v{8}: shortPtr ); (* const *)
PROCEDURE TexCoord2iv    * {base, -22EH} (v{8}: intPtr   ); (* const *)
PROCEDURE TexCoord2fv    * {base, -234H} (v{8}: floatPtr ); (* const *)
PROCEDURE TexCoord2dv    * {base, -23AH} (v{8}: doublePtr); (* const *)
PROCEDURE TexCoord3sv    * {base, -240H} (v{8}: shortPtr ); (* const *)
PROCEDURE TexCoord3iv    * {base, -246H} (v{8}: intPtr   ); (* const *)
PROCEDURE TexCoord3fv    * {base, -24CH} (v{8}: floatPtr ); (* const *)
PROCEDURE TexCoord3dv    * {base, -252H} (v{8}: doublePtr); (* const *)
PROCEDURE TexCoord4sv    * {base, -258H} (v{8}: shortPtr ); (* const *)
PROCEDURE TexCoord4iv    * {base, -25EH} (v{8}: intPtr   ); (* const *)
PROCEDURE TexCoord4fv    * {base, -264H} (v{8}: floatPtr ); (* const *)
PROCEDURE TexCoord4dv    * {base, -26AH} (v{8}: doublePtr); (* const *)

PROCEDURE Normal3b       * {base, -270H} (nx{0}, ny{1}, nz{2}: byte);
PROCEDURE Normal3s       * {base, -276H} (nx{0}, ny{1}, nz{2}: short);
PROCEDURE Normal3i       * {base, -27CH} (nx{0}, ny{1}, nz{2}: int);
PROCEDURE Normal3f       * {base, -282H} (nx{0}, ny{1}, nz{2}: float);
PROCEDURE Normal3d       * {base, -288H} (nx{0}, ny{1}, nz{2}: double);
PROCEDURE Normal3bv      * {base, -28EH} (v{8}: bytePtr  ); (* const *)
PROCEDURE Normal3sv      * {base, -294H} (v{8}: shortPtr ); (* const *)
PROCEDURE Normal3iv      * {base, -29AH} (v{8}: intPtr   ); (* const *)
PROCEDURE Normal3fv      * {base, -2A0H} (v{8}: floatPtr ); (* const *)
PROCEDURE Normal3dv      * {base, -2A6H} (v{8}: doublePtr); (* const *)

PROCEDURE Color3b        * {base, -2ACH} (red{0}, green{1}, blue{2}: byte);
PROCEDURE Color3s        * {base, -2B2H} (red{0}, green{1}, blue{2}: short);
PROCEDURE Color3i        * {base, -2B8H} (red{0}, green{1}, blue{2}: int);
PROCEDURE Color3f        * {base, -2BEH} (red{0}, green{1}, blue{2}: float);
PROCEDURE Color3d        * {base, -2C4H} (red{0}, green{1}, blue{2}: double);
PROCEDURE Color3ub       * {base, -2CAH} (red{0}, green{1}, blue{2}: ubyte);
PROCEDURE Color3us       * {base, -2D0H} (red{0}, green{1}, blue{2}: ushort);
PROCEDURE Color3ui       * {base, -2D6H} (red{0}, green{1}, blue{2}: uint);
PROCEDURE Color4b        * {base, -2DCH} (red{0}, green{1}, blue{2}, alpha{3}: byte);
PROCEDURE Color4s        * {base, -2E2H} (red{0}, green{1}, blue{2}, alpha{3}: short);
PROCEDURE Color4i        * {base, -2E8H} (red{0}, green{1}, blue{2}, alpha{3}: int);
PROCEDURE Color4f        * {base, -2EEH} (red{0}, green{1}, blue{2}, alpha{3}: float);
PROCEDURE Color4d        * {base, -2F4H} (red{0}, green{1}, blue{2}, alpha{3}: double);
PROCEDURE Color4ub       * {base, -2FAH} (red{0}, green{1}, blue{2}, alpha{3}: ubyte);
PROCEDURE Color4us       * {base, -300H} (red{0}, green{1}, blue{2}, alpha{3}: ushort);
PROCEDURE Color4ui       * {base, -306H} (red{0}, green{1}, blue{2}, alpha{3}: uint);
PROCEDURE Color3bv       * {base, -30CH} (v{8}: bytePtr  ); (* const *)
PROCEDURE Color3sv       * {base, -312H} (v{8}: shortPtr ); (* const *)
PROCEDURE Color3iv       * {base, -318H} (v{8}: intPtr   ); (* const *)
PROCEDURE Color3fv       * {base, -31EH} (v{8}: floatPtr ); (* const *)
PROCEDURE Color3dv       * {base, -324H} (v{8}: doublePtr); (* const *)
PROCEDURE Color3ubv      * {base, -32AH} (v{8}: ubytePtr ); (* const *)
PROCEDURE Color3usv      * {base, -330H} (v{8}: ushortPtr); (* const *)
PROCEDURE Color3uiv      * {base, -336H} (v{8}: uintPtr  ); (* const *)
PROCEDURE Color4bv       * {base, -33CH} (v{8}: bytePtr  ); (* const *)
PROCEDURE Color4sv       * {base, -342H} (v{8}: shortPtr ); (* const *)
PROCEDURE Color4iv       * {base, -348H} (v{8}: intPtr   ); (* const *)
PROCEDURE Color4fv       * {base, -34EH} (v{8}: floatPtr ); (* const *)
PROCEDURE Color4dv       * {base, -354H} (v{8}: doublePtr); (* const *)
PROCEDURE Color4ubv      * {base, -35AH} (v{8}: ubytePtr ); (* const *)
PROCEDURE Color4usv      * {base, -360H} (v{8}: ushortPtr); (* const *)
PROCEDURE Color4uiv      * {base, -366H} (v{8}: uintPtr  ); (* const *)

PROCEDURE Indexs         * {base, -36CH} (index{0}: short);
PROCEDURE Indexi         * {base, -372H} (index{0}: int);
PROCEDURE Indexf         * {base, -378H} (index{0}: float);
PROCEDURE Indexd         * {base, -37EH} (index{0}: double);
PROCEDURE Indexsv        * {base, -384H} (v{8}: shortPtr); (* const *)
PROCEDURE Indexiv        * {base, -38AH} (v{8}: intPtr); (* const *)
PROCEDURE Indexfv        * {base, -390H} (v{8}: floatPtr); (* const *)
PROCEDURE Indexdv        * {base, -396H} (v{8}: doublePtr); (* const *)

PROCEDURE Rects          * {base, -39CH} (x1{0}, y1{1}, x2{2}, y2{3}: short);
PROCEDURE Recti          * {base, -3A2H} (x1{0}, y1{1}, x2{2}, y2{3}: int);
PROCEDURE Rectf          * {base, -3A8H} (x1{0}, y1{1}, x2{2}, y2{3}: float);
PROCEDURE Rectd          * {base, -3AEH} (x1{0}, y1{1}, x2{2}, y2{3}: double);
PROCEDURE Rectsv         * {base, -3B4H} (v1{8}, v2{9}: shortPtr  ); (* const *)
PROCEDURE Rectiv         * {base, -3BAH} (v1{8}, v2{9}: intPtr    ); (* const *)
PROCEDURE Rectfv         * {base, -3C0H} (v1{8}, v2{9}: floatPtr  ); (* const *)
PROCEDURE Rectdv         * {base, -3C6H} (v1{8}, v2{9}: doublePtr ); (* const *)

PROCEDURE EdgeFlag       * {base, -3CCH} (flag{0}: boolean);
PROCEDURE EdgeFlagv      * {base, -3D2H} (flag{8}: booleanPtr); (* const *)

PROCEDURE RasterPos2s    * {base, -3D8H} (s{0}, t{1}: short);
PROCEDURE RasterPos2i    * {base, -3DEH} (s{0}, t{1}: int);
PROCEDURE RasterPos2f    * {base, -3E4H} (s{0}, t{1}: float);
PROCEDURE RasterPos2d    * {base, -3EAH} (s{0}, t{1}: double);
PROCEDURE RasterPos3s    * {base, -3F0H} (s{0}, t{1}, r{2}: short);
PROCEDURE RasterPos3i    * {base, -3F6H} (s{0}, t{1}, r{2}: int);
PROCEDURE RasterPos3f    * {base, -3FCH} (s{0}, t{1}, r{2}: float);
PROCEDURE RasterPos3d    * {base, -402H} (s{0}, t{1}, r{2}: double);
PROCEDURE RasterPos4s    * {base, -408H} (s{0}, t{1}, r{2}, q{3}: short);
PROCEDURE RasterPos4i    * {base, -40EH} (s{0}, t{1}, r{2}, q{3}: int);
PROCEDURE RasterPos4f    * {base, -414H} (s{0}, t{1}, r{2}, q{3}: float);
PROCEDURE RasterPos4d    * {base, -41AH} (s{0}, t{1}, r{2}, q{3}: double);
PROCEDURE RasterPos2sv   * {base, -420H} (v{8}: shortPtr); (* const *)
PROCEDURE RasterPos2iv   * {base, -426H} (v{8}: intPtr); (* const *)
PROCEDURE RasterPos2fv   * {base, -42CH} (v{8}: floatPtr); (* const *)
PROCEDURE RasterPos2dv   * {base, -432H} (v{8}: doublePtr); (* const *)
PROCEDURE RasterPos3sv   * {base, -438H} (v{8}: shortPtr); (* const *)
PROCEDURE RasterPos3iv   * {base, -43EH} (v{8}: intPtr); (* const *)
PROCEDURE RasterPos3fv   * {base, -444H} (v{8}: floatPtr); (* const *)
PROCEDURE RasterPos3dv   * {base, -44AH} (v{8}: doublePtr); (* const *)
PROCEDURE RasterPos4sv   * {base, -450H} (v{8}: shortPtr); (* const *)
PROCEDURE RasterPos4iv   * {base, -456H} (v{8}: intPtr); (* const *)
PROCEDURE RasterPos4fv   * {base, -45CH} (v{8}: floatPtr); (* const *)
PROCEDURE RasterPos4dv   * {base, -462H} (v{8}: doublePtr); (* const *)

(*----------------------Transforming-------------------------*)

PROCEDURE DepthRange     * {base, -468H} (zNear{0}: clampd; zFar{1}: clampd);
PROCEDURE Viewport       * {base, -46EH} (x{0}, y{1}: int; width{2}, height{3}: sizei);

PROCEDURE MatrixMode     * {base, -474H} (mode{0}: enum);
PROCEDURE LoadMatrixf    * {base, -47AH} (m{8}: floatPtr); (* const *)
PROCEDURE LoadMatrixd    * {base, -480H} (m{8}: doublePtr); (* const *)
PROCEDURE MultMatrixf    * {base, -486H} (m{8}: floatPtr); (* const *)
PROCEDURE MultMatrixd    * {base, -48CH} (m{8}: doublePtr); (* const *)

PROCEDURE LoadIdentity   * {base, -492H} ();

PROCEDURE Rotatef        * {base, -498H} (angle{0}, x{1}: float; y{2}: float; z{3}: float);
PROCEDURE Rotated        * {base, -49EH} (angle{0}: double; x{1}: double; y{2}: double; z{3}: double);
PROCEDURE Translatef     * {base, -4A4H} (x{0}, y{1}, z{2}: float);
PROCEDURE Translated     * {base, -4AAH} (x{0}, y{1}, z{2}: double);
PROCEDURE Scalef         * {base, -4B0H} (x{0}, y{1}, z{2}: float);
PROCEDURE Scaled         * {base, -4B6H} (x{0}, y{1}, z{2}: double);

PROCEDURE Frustum        * {base, -4BCH} (VAR f{8}: frustum); (* const *)
PROCEDURE FrustumAPI     *               (left, right, bottom, top, zNear, zFar: double);
VAR f: frustum;
BEGIN
     f.left   := left;   f.right := right;
     f.bottom := bottom; f.top   := top;
     f.zNear  := zNear;  f.zFar  := zFar;
     Frustum (f);
END FrustumAPI;

PROCEDURE Ortho          * {base, -4C2H} (VAR ortho{8}: ortho); (* const *)
PROCEDURE OrthoAPI       *               (left, right, bottom, top, zNear, zFar: double);
VAR o: ortho;
BEGIN
     o.left   := left;   o.right := right;
     o.bottom := bottom; o.top   := top;
     o.zNear  := zNear;  o.zFar  := zFar;
     Ortho (o);
END OrthoAPI;

PROCEDURE PushMatrix     * {base, -4C8H} ();
PROCEDURE PopMatrix      * {base, -4CEH} ();
PROCEDURE Ortho2D        * {base, -4D4H} (left{0}, right{1}, bottom{2}, top{3}: double);

PROCEDURE Project        * {base, -4DAH} (VAR project{8}: project): boolean; (* const *)
PROCEDURE ProjectAPI     *               (objx, objy, objz: double;
                                          VAR winx, winy, winz: double): boolean;
VAR p: project; res: boolean;
BEGIN
     p.objx := objx; p.objy := objy; p.objz := objz;
     p.winx := y.ADR(winx); p.winy := y.ADR(winy); p.winz := y.ADR(winz);
     res := Project (p);
     (* $NilChk- *)
     winx := p.winx^; winy := p.winy^; winz := p.winz^;
     (* $NilChk= *)
END ProjectAPI;

PROCEDURE UnProject      * {base, -4E0H} (VAR unProject{8}: unProject): boolean; (* const *)
PROCEDURE UnProjectAPI   *               (winx, winy, winz: double;
                                          VAR objx, objy, objz: double): boolean;
VAR up: unProject; res: boolean;
BEGIN
     up.winx := winx; up.winy := winy; up.winz := winz;
     up.objx := y.ADR(objx); up.objy := y.ADR(objy); up.objz := y.ADR(objz);
     res := UnProject (up);
     (* $NilChk- *)
     objx := up.objx^; objy := up.objy^; objz := up.objz^;
     (* $NilChk= *)
END UnProjectAPI;

PROCEDURE Perspective    * {base, -4E6H} (fovy{0}, aspect{1}, zNear{2}, zFar{3}: double);

PROCEDURE LookAt         * {base, -4ECH} (VAR lookAt{8}: lookAt); (* const *)
PROCEDURE LookAtAPI      *               (eyex,    eyey,    eyez,
                                          centerx, centery, centerz,
                                          upx,     upy,     upz    : double);
VAR la: lookAt;
BEGIN
     la.eyex    := eyex;    la.eyey    := eyey;    la.eyez    := eyez;
     la.centerx := centerx; la.centery := centery; la.centerz := centerz;
     la.upx     := upx;     la.upy     := upy;     la.upz     := upz;
     LookAt (la);
END LookAtAPI;

PROCEDURE PickMatrix     * {base, -4F2H} (x{0}, y{1}, width{2}, height{3}: double);

(*----------------------Clipping-----------------------------*)

PROCEDURE ClipPlane      * {base, -4F8H} (plane{0}: enum; equation{8}: doublePtr); (* const *)

(*----------------------Drawing--------------------------*)


PROCEDURE Clear          * {base, -4FEH} (mask{0}: bitfield);
PROCEDURE ClearColor     * {base, -504H} (red{0}, green{1}, blue{2}, alpha{3}: clampf);
PROCEDURE ClearIndex     * {base, -50AH} (index{0}: float);
PROCEDURE ClearDepth     * {base, -510H} (depth{0}: clampd);
PROCEDURE Flush          * {base, -516H} ();
PROCEDURE Finish         * {base, -51CH} ();
PROCEDURE Hint           * {base, -522H} (target{0}, mode{1}: enum);
PROCEDURE DrawBuffer     * {base, -528H} (mode{0}: enum);
PROCEDURE Fogf           * {base, -52EH} (pname{0}: enum; param{1}: float);
PROCEDURE Fogi           * {base, -534H} (pname{0}: enum; param{1}: int);
PROCEDURE Fogfv          * {base, -53AH} (pname{0}: enum; params{8}: floatPtr); (* const *)
PROCEDURE Fogiv          * {base, -540H} (pname{0}: enum; params{8}: intPtr); (* const *)
PROCEDURE DepthFunc      * {base, -546H} (func{0}: enum);
PROCEDURE PolygonMode    * {base, -54CH} (face{0}, mode{1}: enum);
PROCEDURE ShadeModel     * {base, -552H} (mode{0}: enum);
PROCEDURE CullFace       * {base, -558H} (mode{0}: enum);
PROCEDURE FrontFace      * {base, -55EH} (mode{0}: enum);

(*----------------------Selection----------------------------*)

PROCEDURE RenderMode     * {base, -564H} (mode{0}: enum): int;
PROCEDURE InitNames      * {base, -56AH} ();
PROCEDURE LoadName       * {base, -570H} (name{0}: uint);
PROCEDURE PushName       * {base, -576H} (name{0}: uint);
PROCEDURE PopName        * {base, -57CH} ();
PROCEDURE SelectBuffer   * {base, -582H} (size{0}: sizei; buffer{8}: uintPtr);

(*----------------------Lighting-----------------------------*)

PROCEDURE Lightf         * {base, -588H} (light{0}, pname{1}: enum; param{2}: float);
PROCEDURE Lighti         * {base, -58EH} (light{0}, pname{1}: enum; param{2}: int);
PROCEDURE Lightfv        * {base, -594H} (light{0}, pname{2}: enum; params{8}: floatPtr);
PROCEDURE Lightiv        * {base, -59AH} (light{0}, pname{2}: enum; params{8}: intPtr);
PROCEDURE LightModelf    * {base, -5A0H} (pname{0}: enum; param{1}: float);
PROCEDURE LightModeli    * {base, -5A6H} (pname{0}: enum; param{1}: int);
PROCEDURE LightModelfv   * {base, -5ACH} (pname{0}: enum; params{8}: floatPtr);
PROCEDURE LightModeliv   * {base, -5B2H} (pname{0}: enum; params{8}: intPtr);
PROCEDURE Materialf      * {base, -5B8H} (face{0}, pname{1}: enum; param{2}: float);
PROCEDURE Materiali      * {base, -5BEH} (face{0}, pname{1}: enum; param{2}: int);
PROCEDURE Materialfv     * {base, -5C4H} (face{0}, pname{1}: enum; params{8}: floatPtr);
PROCEDURE Materialiv     * {base, -5CAH} (face{0}, pname{1}: enum; params{8}: intPtr);
PROCEDURE ColorMaterial  * {base, -5D0H} (face{0}, mode{1}: enum);

(*----------------------Texturing----------------------------*)

PROCEDURE TexGeni        * {base, -5D6H} (coord{0}, pname{1}: enum; param{2}: int);
PROCEDURE TexGenf        * {base, -5DCH} (coord{0}, pname{1}: enum; param{2}: float);
PROCEDURE TexGend        * {base, -5E2H} (coord{0}, pname{1}: enum; param{2}: double);
PROCEDURE TexGeniv       * {base, -5E8H} (coord{0}, pname{1}: enum; params{8}: intPtr); (* const *)
PROCEDURE TexGenfv       * {base, -5EEH} (coord{0}, pname{1}: enum; params{8}: floatPtr); (* const *)
PROCEDURE TexGendv       * {base, -5F4H} (coord{0}, pname{1}: enum; params{8}: doublePtr); (* const *)
PROCEDURE TexEnvf        * {base, -5FAH} (target{0}, pname{1}: enum; param{2}: float);
PROCEDURE TexEnvi        * {base, -600H} (target{0}, pname{1}: enum; param{2}: int);
PROCEDURE TexEnvfv       * {base, -606H} (target{0}, pname{1}: enum; params{8}: floatPtr); (* const *)
PROCEDURE TexEnviv       * {base, -60CH} (target{0}, pname{1}: enum; params{8}: intPtr); (* const *)
PROCEDURE TexParameterf  * {base, -612H} (target{0}, pname{1}: enum; param{2}: float);
PROCEDURE TexParameteri  * {base, -618H} (target{0}, pname{1}: enum; param{2}: int);
PROCEDURE TexParameterfv * {base, -61EH} (target{0}, pname{1}: enum; params{8}: floatPtr); (* const *)
PROCEDURE TexParameteriv * {base, -624H} (target{0}, pname{1}: enum; params{8}: intPtr); (* const *)
PROCEDURE TexImage1D     * {base, -62AH} (target{0}: enum; level{1}, components{2}: int;  width{3}: sizei; 
                                          border{4}: int;  format{5}, type{6}: enum; pixels{8}: voidPtr); (* const *)
PROCEDURE TexImage2D     * {base, -630H} (target{0}: enum; level{1}, components{2}: int;  width{3}, height{4}: sizei; 
                                          border{5}: int;  format{6}, type{7}: enum; pixels{8}: voidPtr); (* const *)

(*------------------------Images-----------------------------*)

PROCEDURE PixelStorei    * {base, -636H} (pname{0}: enum; param{1}: int);
PROCEDURE PixelStoref    * {base, -63CH} (pname{0}: enum; param{1}: float);
PROCEDURE PixelTransferi * {base, -642H} (pname{0}: enum; param{1}: int);
PROCEDURE PixelTransferf * {base, -648H} (pname{0}: enum; param{1}: float);
PROCEDURE PixelMapuiv    * {base, -64EH} (map{0}: enum; mapsize{1}: sizei; values{2}: ARRAY OF uint  ); (* const *)
PROCEDURE PixelMapusv    * {base, -654H} (map{0}: enum; mapsize{1}: sizei; values{2}: ARRAY OF ushort); (* const *)
PROCEDURE PixelMapfv     * {base, -65AH} (map{0}: enum; mapsize{1}: sizei; values{2}: ARRAY OF float ); (* const *)
PROCEDURE PixelZoom      * {base, -660H} (xfactor{0}, yfactor{1}: float);
PROCEDURE DrawPixels     * {base, -666H} (width{0}, height{1}: sizei; format{2}, type{3}: enum; data{8}: voidPtr); (* const *)
PROCEDURE Bitmap         * {base, -66CH} (VAR bitmap{8}: bitmap); (* const *)
PROCEDURE BitmapAPI      *               (width, height: sizei;
                                          xorig, yorig, xmove, ymove: float;
                                          VAR bitMap: ubytePtr); (* const *)
VAR bm: bitmap;
BEGIN
     bm.width := width; bm.height := height;
     bm.xorig := xorig; bm.yorig := yorig; bm.xmove := xmove; bm.ymove := ymove;
     bm.bitmap := bitMap;
     Bitmap (bm);
END BitmapAPI;

(*-----------------------------------------------------------*)

BEGIN
     base := e.OpenLibrary (name, minversion);
(*
     IF base = NIL THEN
        IF I.DisplayAlert (I.recoveryAlert, "\x00\x64\x14missing cybergl.library\o\o", 50) THEN END;
        HALT (20)
     END; (* IF *)
*)
CLOSE
     IF base # NIL THEN e.CloseLibrary (base); base := NIL END (* IF *)
END CyberGL.
