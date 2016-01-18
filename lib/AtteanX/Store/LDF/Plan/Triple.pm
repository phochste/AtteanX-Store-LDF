=head1 NAME

AtteanX::Store::LDF::Plan::Triple - Plan for evaluation of Linked Data Fragments

=head1 SYNOPSIS

This is typically only constructed by planning hacks deep in the code,
but might look like, but extends L<Attean::Plan::Quad>, e.g.:

  use v5.14;
  use AtteanX::Store::LDF::Plan::Triple;
  my $ldf_plan = AtteanX::Store::LDF::Plan::Triple->new(subject => $subject,
                                                        predicate => $predicate,
                                                        object => $object,
                                                        graph => $will_not_be_used);


=head1 DESCRIPTION

This plan class will aid a query planner that seeks to incorporate
Linked Data Fragments into the query planning.

=cut

package AtteanX::Store::LDF::Plan::Triple;

use v5.14;
use warnings;

use Moo;
use Data::Dumper;
use Class::Method::Modifiers;

extends 'Attean::Plan::Quad';

around 'plan_as_string' => sub {
	my $orig = shift;
	return 'LDF' . $orig->(@_);
};


1;
