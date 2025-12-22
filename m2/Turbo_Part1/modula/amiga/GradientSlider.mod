IMPLEMENTATION MODULE GradientSlider ;

FROM M2Lib IMPORT OpenLib ;

BEGIN
  GradientSliderBase := OpenLib("gadgets/gradientslider.gadget",VERSION);
END GradientSlider.
