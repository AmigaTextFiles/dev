
static UBYTE UNDOBUFFER[5];

static SHORT BorderVectors1[] = {
  0,0,
  311,0,
  311,123,
  0,123,
  0,0
};
static struct Border Border1 = {
  0,0,  /* XY origin relative to container TopLeft */
  1,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors1,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct Gadget Gadget30 = {
  NULL,  /* next gadget */
  0,0,  /* origin XY of hit box relative to window TopLeft */
  1,1,  /* hit box width and height */
  GADGHBOX+GADGHIMAGE,  /* gadget flags */
  NULL,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border1,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  NULL,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE promptGadgetSIBuff[41] =
  "Select the date and date format:";
static struct StringInfo promptGadgetSInfo = {
  promptGadgetSIBuff,  /* buffer where text will be edited */
  NULL,  /* optional undo buffer */
  0,  /* character position in buffer */
  41,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static SHORT BorderVectors2[] = {
  0,0,
  292,0,
  292,10,
  0,10,
  0,0
};
static struct Border Border2 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  0,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors2,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct Gadget promptGadget = {
  &Gadget30,  /* next gadget */
  11,45,  /* origin XY of hit box relative to window TopLeft */
  291,9,  /* hit box width and height */
  NULL,  /* gadget flags */
  NULL,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border2,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&promptGadgetSInfo,  /* SpecialInfo structure */
  PROMPT_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static SHORT BorderVectors3[] = {
  0,0,
  65,0,
  65,9,
  0,9,
  0,0
};
static struct Border Border3 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  3,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors3,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct IntuiText IText1 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  0,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" + WEEK ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget weekPlusGadget = {
  &promptGadget,  /* next gadget */
  113,56,  /* origin XY of hit box relative to window TopLeft */
  64,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border3,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText1,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  WEEK_PLUS_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static SHORT BorderVectors4[] = {
  0,0,
  65,0,
  65,9,
  0,9,
  0,0
};
static struct Border Border4 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  3,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors4,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct IntuiText IText2 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  0,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" - WEEK ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget weekMinusGadget = {
  &weekPlusGadget,  /* next gadget */
  25,56,  /* origin XY of hit box relative to window TopLeft */
  64,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border4,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText2,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  WEEK_MINUS_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE dayNameGadgetSIBuff[11];
static struct StringInfo dayNameGadgetSInfo = {
  dayNameGadgetSIBuff,  /* buffer where text will be edited */
  NULL,  /* optional undo buffer */
  0,  /* character position in buffer */
  11,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct IntuiText IText3 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  -42,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" Day ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget dayNameGadget = {
  &weekMinusGadget,  /* next gadget */
  130,96,  /* origin XY of hit box relative to window TopLeft */
  80,8,  /* hit box width and height */
  GADGHBOX+GADGHIMAGE,  /* gadget flags */
  NULL,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText3,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&dayNameGadgetSInfo,  /* SpecialInfo structure */
  DAYNAME_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static SHORT BorderVectors5[] = {
  0,0,
  65,0,
  65,9,
  0,9,
  0,0
};
static struct Border Border5 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  3,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors5,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct IntuiText IText4 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  0,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" CANCEL ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget cancelGadget = {
  &dayNameGadget,  /* next gadget */
  10,108,  /* origin XY of hit box relative to window TopLeft */
  64,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE+ENDGADGET,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border5,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText4,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  CANCEL_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE timeGadgetSIBuff[11];
static struct StringInfo timeGadgetSInfo = {
  timeGadgetSIBuff,  /* buffer where text will be edited */
  NULL,  /* optional undo buffer */
  0,  /* character position in buffer */
  11,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct IntuiText IText5 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  -50,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" Time ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget timeGadget = {
  &cancelGadget,  /* next gadget */
  130,86,  /* origin XY of hit box relative to window TopLeft */
  120,8,  /* hit box width and height */
  GADGHBOX+GADGHIMAGE,  /* gadget flags */
  NULL,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText5,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&timeGadgetSInfo,  /* SpecialInfo structure */
  TIME_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE dateGadgetSIBuff[12];
static struct StringInfo dateGadgetSInfo = {
  dateGadgetSIBuff,  /* buffer where text will be edited */
  NULL,  /* optional undo buffer */
  0,  /* character position in buffer */
  12,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct IntuiText IText6 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  -50,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" Date ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget dateGadget = {
  &timeGadget,  /* next gadget */
  130,76,  /* origin XY of hit box relative to window TopLeft */
  170,8,  /* hit box width and height */
  GADGHBOX+GADGHIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText6,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&dateGadgetSInfo,  /* SpecialInfo structure */
  DATE_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static SHORT BorderVectors6[] = {
  0,0,
  33,0,
  33,9,
  0,9,
  0,0
};
static struct Border Border6 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  3,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors6,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct IntuiText IText7 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  0,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" OK ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget okGadget = {
  &dateGadget,  /* next gadget */
  261,108,  /* origin XY of hit box relative to window TopLeft */
  32,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE+ENDGADGET,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border6,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText7,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  OK_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static struct IntuiText IText9 = {
  1,0,JAM2,  /* front and back text pens, drawmode and fill byte */
  2,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)"MM/DD/YY",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct IntuiText IText8 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  -106,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" Date Format ",  /* pointer to text */
  &IText9  /* next IntuiText structure */
};

static struct Gadget dateFormatGadget = {
  &okGadget,  /* next gadget */
  130,66,  /* origin XY of hit box relative to window TopLeft */
  80,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText8,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DATE_FORMAT_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static SHORT BorderVectors7[] = {
  0,0,
  49,0,
  49,9,
  0,9,
  0,0
};
static struct Border Border7 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  3,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors7,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct IntuiText IText10 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  0,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" ZERO ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget zeroGadget = {
  &dateFormatGadget,  /* next gadget */
  254,56,  /* origin XY of hit box relative to window TopLeft */
  48,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border7,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText10,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  ZERO_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static SHORT BorderVectors8[] = {
  0,0,
  41,0,
  41,9,
  0,9,
  0,0
};
static struct Border Border8 = {
  -1,-1,  /* XY origin relative to container TopLeft */
  3,0,JAM1,  /* front pen, back pen and drawmode */
  5,  /* number of XY vectors */
  BorderVectors8,  /* pointer to XY vectors */
  NULL  /* next border in list */
};

static struct IntuiText IText11 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  0,0,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" NOW ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget nowGadget = {
  &zeroGadget,  /* next gadget */
  208,56,  /* origin XY of hit box relative to window TopLeft */
  40,8,  /* hit box width and height */
  GADGHBOX,  /* gadget flags */
  RELVERIFY+GADGIMMEDIATE,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Border8,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText11,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  NOW_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData1[] = {
  0x001F,0x00DF,0x03DF,0x0FDF,0x3FDF,0x7FDF,0x3FDF,0x0FDF,
  0x03DF,0x00DF,0x001F
};

static struct Image Image1 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData1,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget downSecondGadget = {
  &nowGadget,  /* next gadget */
  261,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image1,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DOWN_SECOND_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData2[] = {
  0x001F,0x00DF,0x03DF,0x0FDF,0x3FDF,0x7FDF,0x3FDF,0x0FDF,
  0x03DF,0x00DF,0x001F
};

static struct Image Image2 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData2,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget downMinuteGadget = {
  &downSecondGadget,  /* next gadget */
  206,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image2,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DOWN_MINUTE_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData3[] = {
  0x001F,0x00DF,0x03DF,0x0FDF,0x3FDF,0x7FDF,0x3FDF,0x0FDF,
  0x03DF,0x00DF,0x001F
};

static struct Image Image3 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData3,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget downHourGadget = {
  &downMinuteGadget,  /* next gadget */
  157,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image3,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DOWN_HOUR_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData4[] = {
  0x001F,0x00DF,0x03DF,0x0FDF,0x3FDF,0x7FDF,0x3FDF,0x0FDF,
  0x03DF,0x00DF,0x001F
};

static struct Image Image4 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData4,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget downDayGadget = {
  &downHourGadget,  /* next gadget */
  107,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image4,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DOWN_DAY_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData5[] = {
  0x001F,0x601F,0x781F,0x7E1F,0x7F9F,0x7FDF,0x7F9F,0x7E1F,
  0x781F,0x601F,0x001F
};

static struct Image Image5 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData5,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget upSecondGadget = {
  &downDayGadget,  /* next gadget */
  273,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image5,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  UP_SECOND_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData6[] = {
  0x001F,0x601F,0x781F,0x7E1F,0x7F9F,0x7FDF,0x7F9F,0x7E1F,
  0x781F,0x601F,0x001F
};

static struct Image Image6 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData6,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget upMinuteGadget = {
  &upSecondGadget,  /* next gadget */
  218,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image6,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  UP_MINUTE_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData7[] = {
  0x001F,0x601F,0x781F,0x7E1F,0x7F9F,0x7FDF,0x7F9F,0x7E1F,
  0x781F,0x601F,0x001F
};

static struct Image Image7 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData7,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget upHourGadget = {
  &upMinuteGadget,  /* next gadget */
  169,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image7,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  UP_HOUR_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData8[] = {
  0x001F,0x601F,0x781F,0x7E1F,0x7F9F,0x7FDF,0x7F9F,0x7E1F,
  0x781F,0x601F,0x001F
};

static struct Image Image8 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData8,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget upDayGadget = {
  &upHourGadget,  /* next gadget */
  119,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image8,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  UP_DAY_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData9[] = {
  0x001F,0x00DF,0x03DF,0x0FDF,0x3FDF,0x7FDF,0x3FDF,0x0FDF,
  0x03DF,0x00DF,0x001F
};

static struct Image Image9 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData9,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget downMonthGadget = {
  &upDayGadget,  /* next gadget */
  66,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image9,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DOWN_MONTH_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData10[] = {
  0x001F,0x601F,0x781F,0x7E1F,0x7F9F,0x7FDF,0x7F9F,0x7E1F,
  0x781F,0x601F,0x001F
};

static struct Image Image10 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData10,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget upMonthGadget = {
  &downMonthGadget,  /* next gadget */
  78,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image10,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  UP_MONTH_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData11[] = {
  0x001F,0x00DF,0x03DF,0x0FDF,0x3FDF,0x7FDF,0x3FDF,0x0FDF,
  0x03DF,0x00DF,0x001F
};

static struct Image Image11 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData11,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget downYearGadget = {
  &upMonthGadget,  /* next gadget */
  25,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image11,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  DOWN_YEAR_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static USHORT ImageData12[] = {
  0x001F,0x601F,0x781F,0x7E1F,0x7F9F,0x7FDF,0x7F9F,0x7E1F,
  0x781F,0x601F,0x001F
};

static struct Image Image12 = {
  0,0,  /* XY origin relative to container TopLeft */
  11,11,  /* Image width and height in pixels */
  2,  /* number of bitplanes in Image */
  ImageData12,  /* pointer to ImageData */
  0x0002,0x0000,  /* PlanePick and PlaneOnOff */
  NULL  /* next Image structure */
};

static struct Gadget upYearGadget = {
  &downYearGadget,  /* next gadget */
  36,31,  /* origin XY of hit box relative to window TopLeft */
  11,11,  /* hit box width and height */
  GADGHBOX+GADGIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  BOOLGADGET+REQGADGET,  /* gadget type flags */
  (APTR)&Image12,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  NULL,  /* SpecialInfo structure */
  UP_YEAR_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE secondGadgetSIBuff[5] =
  "00";
static struct StringInfo secondGadgetSInfo = {
  secondGadgetSIBuff,  /* buffer where text will be edited */
  UNDOBUFFER,  /* optional undo buffer */
  0,  /* character position in buffer */
  5,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct Gadget secondGadget = {
  &upYearGadget,  /* next gadget */
  264,23,  /* origin XY of hit box relative to window TopLeft */
  27,8,  /* hit box width and height */
  NULL,  /* gadget flags */
  RELVERIFY+LONGINT,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&secondGadgetSInfo,  /* SpecialInfo structure */
  SECOND_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE minuteGadgetSIBuff[5] =
  "00";
static struct StringInfo minuteGadgetSInfo = {
  minuteGadgetSIBuff,  /* buffer where text will be edited */
  UNDOBUFFER,  /* optional undo buffer */
  0,  /* character position in buffer */
  5,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct Gadget minuteGadget = {
  &secondGadget,  /* next gadget */
  209,23,  /* origin XY of hit box relative to window TopLeft */
  27,8,  /* hit box width and height */
  NULL,  /* gadget flags */
  RELVERIFY+LONGINT,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&minuteGadgetSInfo,  /* SpecialInfo structure */
  MINUTE_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE hourGadgetSIBuff[5] =
  "00";
static struct StringInfo hourGadgetSInfo = {
  hourGadgetSIBuff,  /* buffer where text will be edited */
  NULL,  /* optional undo buffer */
  0,  /* character position in buffer */
  5,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct IntuiText IText12 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  -17,-9,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" Hour Minute Second ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget hourGadget = {
  &minuteGadget,  /* next gadget */
  160,23,  /* origin XY of hit box relative to window TopLeft */
  27,8,  /* hit box width and height */
  NULL,  /* gadget flags */
  RELVERIFY+LONGINT,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText12,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&hourGadgetSInfo,  /* SpecialInfo structure */
  HOUR_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE dayGadgetSIBuff[5] =
  "01";
static struct StringInfo dayGadgetSInfo = {
  dayGadgetSIBuff,  /* buffer where text will be edited */
  UNDOBUFFER,  /* optional undo buffer */
  0,  /* character position in buffer */
  5,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct Gadget dayGadget = {
  &hourGadget,  /* next gadget */
  110,23,  /* origin XY of hit box relative to window TopLeft */
  27,8,  /* hit box width and height */
  NULL,  /* gadget flags */
  RELVERIFY+LONGINT,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&dayGadgetSInfo,  /* SpecialInfo structure */
  DAY_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE monthGadgetSIBuff[5] =
  "Jan";
static struct StringInfo monthGadgetSInfo = {
  monthGadgetSIBuff,  /* buffer where text will be edited */
  NULL,  /* optional undo buffer */
  0,  /* character position in buffer */
  5,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct Gadget monthGadget = {
  &dayGadget,  /* next gadget */
  66,23,  /* origin XY of hit box relative to window TopLeft */
  26,8,  /* hit box width and height */
  GADGHBOX+GADGHIMAGE,  /* gadget flags */
  RELVERIFY,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  NULL,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&monthGadgetSInfo,  /* SpecialInfo structure */
  MONTH_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

static UBYTE yearGadgetSIBuff[5] =
  "1978";
static struct StringInfo yearGadgetSInfo = {
  yearGadgetSIBuff,  /* buffer where text will be edited */
  UNDOBUFFER,  /* optional undo buffer */
  0,  /* character position in buffer */
  5,  /* maximum number of characters to allow */
  0,  /* first displayed character buffer position */
  0,0,0,0,0,  /* Intuition initialized and maintained variables */
  0,  /* Rastport of gadget */
  0,  /* initial value for integer gadgets */
  NULL  /* alternate keymap (fill in if you set the flag) */
};

static struct IntuiText IText13 = {
  2,1,JAM2,  /* front and back text pens, drawmode and fill byte */
  -10,-9,  /* XY origin relative to container TopLeft */
  NULL,  /* font pointer or NULL for default */
  (UBYTE *)" Year Month Day ",  /* pointer to text */
  NULL  /* next IntuiText structure */
};

static struct Gadget yearGadget = {
  &monthGadget,  /* next gadget */
  19,23,  /* origin XY of hit box relative to window TopLeft */
  40,8,  /* hit box width and height */
  NULL,  /* gadget flags */
  RELVERIFY+LONGINT,  /* activation flags */
  STRGADGET+REQGADGET,  /* gadget type flags */
  NULL,  /* gadget border or image to be rendered */
  NULL,  /* alternate imagery for selection */
  &IText13,  /* first IntuiText structure */
  NULL,  /* gadget mutual-exclude long word */
  (APTR)&yearGadgetSInfo,  /* SpecialInfo structure */
  YEAR_GADGET,  /* user-definable data */
  NULL  /* pointer to user-definable data */
};

#define GadgetList1 yearGadget

static struct Requester RequesterStructure1 = {
  NULL,  /* previous requester (filled in by Intuition) */
  4,11,  /* requester XY origin relative to TopLeft of window */
  312,124,  /* requester width and height */
  0,0,  /* relative to these mouse offsets if POINTREL is set */
  &GadgetList1,  /* gadget list */
  NULL,  /* box's border */
  NULL,  /* requester text */
  NULL,  /* requester flags */
  1,  /* back-plane fill pen */
  NULL,  /* leave these alone */
  NULL,  /* custom bitmap if PREDRAWN is set */
  NULL  /* leave this alone */
};
