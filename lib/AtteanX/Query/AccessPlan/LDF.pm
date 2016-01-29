use 5.010001;
use strict;
use warnings;


package AtteanX::Query::AccessPlan::LDF;
use Class::Method::Modifiers;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

use Moo::Role;
use Carp;
use RDF::LDF;
use AtteanX::Store::LDF::Plan::Triple;

around 'access_plans' => sub {
	my $orig = shift;
	my @params = @_;
	my $self	= shift;
	my $model = shift;
	my $active_graphs	= shift;
	my $pattern	= shift;

	# First, add any plans coming from the original planner (which will
	# include queries to the remote SPARQL endpoint
	my @plans = $orig->(@params);
	# Add my plans
	push(@plans, AtteanX::Store::LDF::Plan::Triple->new(subject => $pattern->subject,
																		 predicate => $pattern->predicate,
																		 object => $pattern->object,
																		 distinct => 0));
	return @plans;
};

1;
