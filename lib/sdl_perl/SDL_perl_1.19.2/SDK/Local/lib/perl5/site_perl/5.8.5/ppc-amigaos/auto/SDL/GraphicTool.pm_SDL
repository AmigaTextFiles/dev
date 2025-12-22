#
#	SDL::GraphicTool   -	zooming and rotating graphic tool
#
#	Copyright (C) 2002 Russell E. Valentine
#	Copyright (C) 2002 David J. Goehrig

package SDL::GraphicTool;

use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	$self = {};

	bless $self, $class;
	$self;
}


sub DESTROY {

}


sub zoom {
	my ( $self, $surface, $zoomx, $zoomy, $smooth) = @_;
	if($surface->isa('SDL::Surface')) {
		my $newSurface = $$surface{-surface};
		$$surface{-surface} = SDL::GFXZoom($newSurface, $zoomx, $zoomy, $smooth);
	} else {
		$surface = SDL::GFXZoom($surface, $zoomx, $zoomy, $smooth);
	}
}

sub rotoZoom {
	my ( $self, $surface, $angle, $zoom, $smooth) = @_;
	if($surface->isa('SDL::Surface')) {
		my $newSurface = $$surface{-surface};
		$$surface{-surface} = SDL::GFXRotoZoom($newSurface, $angle, $zoom, $smooth);
	} else {
		$surface = SDL::GFXRotoZoom($surface, $angle, $zoom, $smooth);
	}
}

1;
