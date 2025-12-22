UWORD gradientpens[] = { 0, 0, ~0 };
struct ColorWheelRGB colorwheel_rgb;
struct ColorWheelHSB colorwheel_hsb;

/******************************************/
/** This project was just a try to show, **/
/** how to conduct the background of a   **/
/** gradientslider in connection with a  **/
/** colorwheel. But the current value of **/
/** the gradientslider can't read out by **/
/** this program, and seems like it only **/
/** takes two different values: 0 and 1. **/
/** Who knows why ? If you know how,     **/
/** please write it to shamane@exmail.de **/
/******************************************/

void Startup(void)
{
    /** get the most black pen **/

    gradientpens[1] = ObtainBestPen(Screen1->ViewPort.ColorMap, 0, 0, 0, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
}

void Shutdown(void)
{
    /** free all obtained pens **/

    ReleasePen(Screen1->ViewPort.ColorMap, gradientpens[0]);
    ReleasePen(Screen1->ViewPort.ColorMap, gradientpens[1]);
}

void Window1_ShowWindow_Event(void)
{
    Colorwheel1_GadgetUp_Event();
}

void Window1_CloseWindow_Event(void)
{
    Emperor_QuitProgram();
}

void Gradientslider1_GadgetUp_Event(void)
{
}

void Colorwheel1_GadgetUp_Event(void)
{
    /** insert background of gradientslider **/
    /** and handle all the gadgetvalues     **/

    ULONG red, green, blue, hue, saturation, brightness;

    GetAttr(WHEEL_RGB, Colorwheel1, (ULONG *) &colorwheel_rgb);
    GetAttr(WHEEL_HSB, Colorwheel1, (ULONG *) &colorwheel_hsb);
    red = colorwheel_rgb.cw_Red;
    green = colorwheel_rgb.cw_Green;
    blue = colorwheel_rgb.cw_Blue;
    hue = colorwheel_hsb.cw_Hue;
    saturation = colorwheel_hsb.cw_Saturation;
    brightness = colorwheel_hsb.cw_Brightness;
    Emperor_SetGadgetAttr(Slider1, inttostring(red >> 24));
    Emperor_SetGadgetAttr(Slider2, inttostring(green >> 24));
    Emperor_SetGadgetAttr(Slider3, inttostring(blue >> 24));
    Emperor_SetGadgetAttr(Slider4, inttostring(hue >> 24));
    Emperor_SetGadgetAttr(Slider5, inttostring(saturation >> 24));
    Emperor_SetGadgetAttr(Slider6, inttostring(brightness >> 24));
    gradientpens[0] = (UWORD) ObtainBestPen(Screen1->ViewPort.ColorMap, red, green, blue, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    SetGadgetAttrs(Gradientslider1, Window1, NULL, GRAD_PenArray, gradientpens, TAG_DONE);
}

void Slider1_GadgetUp_Event(void)
{
    Emperor_SetGadgetAttrComplex(Colorwheel1, WHEEL_Red, Emperor_GetGadgetAttr(Slider1));
    Colorwheel1_GadgetUp_Event();
}

void Slider2_GadgetUp_Event(void)
{
    Emperor_SetGadgetAttrComplex(Colorwheel1, WHEEL_Green, Emperor_GetGadgetAttr(Slider2));
    Colorwheel1_GadgetUp_Event();
}

void Slider3_GadgetUp_Event(void)
{
    Emperor_SetGadgetAttrComplex(Colorwheel1, WHEEL_Blue, Emperor_GetGadgetAttr(Slider3));
    Colorwheel1_GadgetUp_Event();
}

void Slider4_GadgetUp_Event(void)
{
    Emperor_SetGadgetAttrComplex(Colorwheel1, WHEEL_Hue, Emperor_GetGadgetAttr(Slider4));
    Colorwheel1_GadgetUp_Event();
}

void Slider5_GadgetUp_Event(void)
{
    Emperor_SetGadgetAttrComplex(Colorwheel1, WHEEL_Saturation, Emperor_GetGadgetAttr(Slider5));
    Colorwheel1_GadgetUp_Event();
}

void Slider6_GadgetUp_Event(void)
{
    Emperor_SetGadgetAttrComplex(Colorwheel1, WHEEL_Brightness, Emperor_GetGadgetAttr(Slider6));
    Colorwheel1_GadgetUp_Event();
}

