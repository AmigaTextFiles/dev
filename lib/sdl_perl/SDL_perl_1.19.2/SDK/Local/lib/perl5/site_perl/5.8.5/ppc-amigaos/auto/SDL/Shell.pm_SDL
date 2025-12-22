package SDL::Shell;

use IO::File;
use SDL::Console;
@ISA = qw/ SDL::Console /;

my %cmds = (
	'sub' => sub { my ($self,$params) = @_; 
		my ($routine,$body) = ($params =~ /(\w+)\s+{(.*)}/);
		print "Defining $routine as { $body }\n";
		my $tmpsub;
		eval "sub $routine { $body }";
		eval "\$tmpsub = sub { $body }"; 
		$@ ? $self->print("Error $@") : $self->print("OK");
		SDL::Console::AddCommand($routine,$tmpsub);
	},
	':' => sub { my ($self, $params) = @_; 
		$params =~ s/;$//g;
		eval "\$self->print($params)";
		$@ ? $self->print("Error $@"):  $self->print("OK");
	},
	'!' => sub { my ($self,$params) = @_; $self->print(`$params`); },
	'?' => sub { my ($self,$params) = @_; $self->print(`perldoc $params`); },
	':q' => sub { exit(0); },
);


for (keys %cmds ) {
	SDL::Console::AddCommand($_,$cmds{$_});
}

sub new {
	my ($class,%options) = @_;
	my $self = new SDL::Console %options;
	bless $self, ref($class) || $class;	$self;
}

sub process {
	my ($self,$event) = @_;
	SDL::Console::Event($event);	
}

1;
