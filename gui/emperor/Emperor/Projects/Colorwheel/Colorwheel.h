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
/** please write it to shamane@gmx.net   **/
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

void Window1_CloseWindow_Evt(void)
{
    Ep_QuitProgram();
}

void Gradientslider1_GadgetUp_Evt(void)
{
}

void Colorwheel1_GadgetUp_Evt(void)
{
    /** insert background of gradientslider **/
    /** and handle all the gadgetvalues     **/

    ULONG red, green, blue, hue, saturation, brightness;

    GetAttr(WHEEL_RGB, gad[GID_Colorwheel1], (ULONG *) &colorwheel_rgb);
    GetAttr(WHEEL_HSB, gad[GID_Colorwheel1], (ULONG *) &colorwheel_hsb);
    red = colorwheel_rgb.cw_Red;
    green = colorwheel_rgb.cw_Green;
    blue = colorwheel_rgb.cw_Blue;
    hue = colorwheel_hsb.cw_Hue;
    saturation = colorwheel_hsb.cw_Saturation;
    brightness = colorwheel_hsb.cw_Brightness;
    Ep_SetGadgetAttr(gad[GID_Slider1], inttostring(red >> 24));
    Ep_SetGadgetAttr(gad[GID_Slider2], inttostring(green >> 24));
    Ep_SetGadgetAttr(gad[GID_Slider3], inttostring(blue >> 24));
    Ep_SetGadgetAttr(gad[GID_Slider4], inttostring(hue >> 24));
    Ep_SetGadgetAttr(gad[GID_Slider5], inttostring(saturation >> 24));
    Ep_SetGadgetAttr(gad[GID_Slider6], inttostring(brightness >> 24));
    gradientpens[0] = (UWORD) ObtainBestPen(Screen1->ViewPort.ColorMap, red, green, blue, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    SetGadgetAttrs(gad[GID_Gradientslider1], win[WID_Window1], NULL, GRAD_PenArray, gradientpens, TAG_DONE);
}

void Window1_ShowWindow_Evt(void)
{
    Colorwheel1_GadgetUp_Evt();
}

void Slider1_GadgetUp_Evt(void)
{
    Ep_SetGadgetAttrComplex(gad[GID_Colorwheel1], WHEEL_Red, Ep_GetGadgetAttr(gad[GID_Slider1]));
    Colorwheel1_GadgetUp_Evt();
}

void Slider2_GadgetUp_Evt(void)
{
    Ep_SetGadgetAttrComplex(gad[GID_Colorwheel1], WHEEL_Green, Ep_GetGadgetAttr(gad[GID_Slider2]));
    Colorwheel1_GadgetUp_Evt();
}

void Slider3_GadgetUp_Evt(void)
{
    Ep_SetGadgetAttrComplex(gad[GID_Colorwheel1], WHEEL_Blue, Ep_GetGadgetAttr(gad[GID_Slider3]));
    Colorwheel1_GadgetUp_Evt();
}

void Slider4_GadgetUp_Evt(void)
{
    Ep_SetGadgetAttrComplex(gad[GID_Colorwheel1], WHEEL_Hue, Ep_GetGadgetAttr(gad[GID_Slider4]));
    Colorwheel1_GadgetUp_Evt();
}

void Slider5_GadgetUp_Evt(void)
{
    Ep_SetGadgetAttrComplex(gad[GID_Colorwheel1], WHEEL_Saturation, Ep_GetGadgetAttr(gad[GID_Slider5]));
    Colorwheel1_GadgetUp_Evt();
}

void Slider6_GadgetUp_Evt(void)
{
    Ep_SetGadgetAttrComplex(gad[GID_Colorwheel1], WHEEL_Brightness, Ep_GetGadgetAttr(gad[GID_Slider6]));
    Colorwheel1_GadgetUp_Evt();
}

