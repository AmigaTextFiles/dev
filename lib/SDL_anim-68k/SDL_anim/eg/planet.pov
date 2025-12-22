#include "colors.inc"
camera {
	location <0, 0, -7.75>
	look_at 0
	angle 40
	}

#declare Land = texture {
	pigment {
	  agate
	  turbulence 1
	  lambda 2.5
	  omega .5
	  octaves 5
	  frequency 1
	  color_map {
	      [0.00 color Grey ]
	      [0.30 color Yellow * .5 ]
	      [0.60 color DarkSlateGrey ]
	      [0.60 color DarkSlateGrey ]
	      [1.00 color HuntersGreen ]
	    }
	  rotate -45*z
	  }
	finish {
		ambient 1
		diffuse 0
		phong 0
		roughness 0
		specular 0
		reflection 0
		}
	}

#declare WaterOverlay = texture {
	pigment {
	  bozo
	  turbulence .75
	  lambda 1.5
	  omega 0.8
	  octaves 5
	  frequency 1
	  color_map {
	      [0.00 color Blue * .65 ]
	      [0.30 color Blue * .65 ]
	      [0.60 color Blue ]
	      [0.60 color rgbt <1, 1, 1, 1> ]
	      [1.00 color rgbt <1, 1, 1, 1> ]
	    }
	  rotate -45*z
	  }
	finish {
		ambient 0
		diffuse 1
		phong 0
		roughness 0
		specular .1
		reflection 1
		}
	}

#declare CloudOverlay = texture {
	pigment {
		bozo
		turbulence .5
		color_map {
			[0 White]
			[1 White transmit 1]
			}
		}
	scale <.5, .5, .5>
	rotate <5, 45, 0>
	finish {
		ambient 1
		diffuse 0
		}
	}

sphere { <0, 0, 0>, 2
	texture { Land }
	texture { WaterOverlay }
	texture { CloudOverlay }
	rotate <0, clock * 360, 0>
//	rotate <0, 20, -15>
	}

light_source { <300, 300, -700> White }
//light_source { <300, 300, -700> Yellow }
