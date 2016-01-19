package AtteanX::Model::LDF;

use v5.14;
use warnings;

use Moo;
use Types::Standard qw(InstanceOf);
use namespace::clean;

extends 'Attean::API::TripleModel'; #, 'Attean::API::CostPlanner';


# sub cost_for_plan {
# 	my $self = shift;
#  	my $plan = shift;
#  	my $planner = shift;

# 	# TODO: check if the store does something
# 	if ($plan->isa('AtteanX::Store::LDF::Plan::BGP')) {
# 		# BGPs should have a cost proportional to the number of triple patterns,
# 		# but be much more costly if they contain a cartesian product.
# 		if ($plan->children_are_variable_connected) {
# 			return 10 * scalar(@{ $plan->children });
# 		} else {
# 			return 100 * scalar(@{ $plan->children });
# 		}
# 	}
# 	return;
# }

sub get_graphs {
	return Attean::ListIterator->new();
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

AtteanX::Model::LDF - Attean Linked Data Fragments Model

=head1 SYNOPSIS

  my $store = Attean->get_store('LDF')->new(endpoint_url => $url);
  my $model = AtteanX::Model::LDF->new( store => $store );

=head1 DESCRIPTION

This model is in practice a thin wrapper around the underlying LDF
store, that adds facilities only to allow quering and planning with
quad semantics.

It consumes L<Attean::API::Model> and L<Attean::API::CostPlanner> and
adds no new methods or attributes.

=cut

