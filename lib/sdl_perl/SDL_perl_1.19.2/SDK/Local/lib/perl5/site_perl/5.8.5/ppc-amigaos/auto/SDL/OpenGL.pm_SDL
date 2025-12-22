# SDL::OpenGL.pm
#
#	A simplified OpenGL wrapper
#

package SDL::OpenGL;
use SDL;

require Exporter;

@ISA = qw/ Exporter /;

my @glu = qw/ LookAt Perspective Ortho2D ScaleImage Build1DMipmaps Build2DMipmaps  
	Build3DMipmaps Build1DMipmapLevels Build2DMipmapLevels Build3DMipmapLevels 
	ErrorString NewNurbsRenderer DeleteNurbsRenderer NurbsProperty	
	LoadSamplingMatrices GetNurbsProperty NurbsCallback BeginSurface EndSurface
	NurbsSurface BeginCurve EndCurve NurbsCurve NurbsCallbackData
	BeginTrim EndTrim PwlCurve
/;	

my @routines = keys %SDL::OpenGL::;
for ( @routines ) {
	if (/^GL/) {
		push @EXPORT, "&$_";
	} elsif ( in ( $_, @glu )) {
		eval "sub SDL::OpenGL::glu$_ { $_(\@_); }";
		push @EXPORT, "glu$_";
	} else {
		eval "sub SDL::OpenGL::gl$_ { $_(\@_); }";
		push @EXPORT, "gl$_";
	}
}

1;
