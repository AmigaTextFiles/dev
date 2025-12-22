#
#	SDL::FontTool	-	format agnostic font tool
#
#	Copyright (C) 2002 David J. Goehrig

package SDL::FontTool;

use SDL;
use SDL::Font;
use SDL::TTFont;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	$self = {};
	my %option = @_;

	verify (%option, qw/ -sfont -ttfont -size -fg -bg -foreground -background
			  	-normal -bold -italic -underline / ) if $SDL::DEBUG;

	if ($option{-sfont}) {
		$$self{-font} = new SDL::Font $option{-sfont};
	} elsif ($option{-ttfont} || $option{-t}) {
		$option{-size} ||= 12;
		$$self{-font} = new SDL::TTFont 
					-name => $option{-ttfont} || $option{-t},
					-size => $option{-size} || $option{-s},
					-fg => $option{-foreground} || $option{-fg} ,
					-bg => $option{-background} || $option{-bg};
		for (qw/ normal bold italic underline / ) {
			if ($option{"-$_"}) {
				&{"SDL::TTFont::$_"}($$self{-font});
			}
		}
	} else {
		die "SDL::FontTool requires either a -sfont or -ttfont";	
	}
	bless $self,$class;
	$self;
}

sub DESTROY {

}

sub print {
	my ($self,$surface,$x,$y,@text) = @_;
	if ($$self{-font}->isa('SDL::Font')) {
		$$self{-font}->use();
		if ($surface->isa('SDL::Surface')) {
			$surface = $$surface{-surface};
		}
		SDL::PutString( $surface, $x, $y, join('',@text));
	} else {
		$$self{-font}->print($surface,$x,$y,@text);
	}
}

1;

