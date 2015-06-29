=head1 NAME

AtteanX::Store::LDF - Linked Data Fragment RDF store

=head1 SYNOPSIS

    use v5.14;
    use Attean;
    use Attean::RDF qw(iri blank literal);
    use AtteanX::Store::LDF;

    my $uri   = 'http://fragments.dbpedia.org/2014/en';
    my $store = Attean->get_store('LDF')->new(endpoint_url => $uri);

    my $iter = $store->get_triples(undef,undef,literal("Albert Einstein"));

    while (my $triple = $iter->next) {
     say $triple->subject->ntriples_string .
       " " .
       $triple->predicate->ntriples_string . 
       " " .
       $triple->object->ntriples_string  .
       " .";
    }

=head1 DESCRIPTION

AtteanX::Store::LDF provides a triple-store connected to a Linked Data Fragment server.
For more information on Triple Pattern Fragments consult L<http://linkeddatafragments.org/>

=cut
use v5.14;
use warnings;

package AtteanX::Store::LDF;

our $VERSION = '0.001';

use Moo;
use Attean::API::Store;
use Type::Tiny::Role;
use Types::Standard qw(Str);
use RDF::LDF;
use namespace::clean;

with 'Attean::API::TripleStore';

=head1 METHODS

Beyond the methods documented below, this class inherits methods from the
L<Attean::API::TripleStore> class.

=over 4

=item new( endpoint_url => $endpoint_url )

Returns a new LDF-backed storage object.

=cut

has endpoint_url => (is => 'ro', isa => Str, required => 1);
has ldf => (is => 'ro', lazy => 1, builder => '_ldf');

sub _ldf {
    my $self = shift;
    RDF::LDF->new(url => $self->endpoint_url);
}

=item get_triples( $subject, $predicate, $object)

Returns a stream object of all statements matching the specified subject,
predicate and objects. Any of the arguments may be undef to match any value.

=cut
sub get_triples {
    my $self    = shift;
    my ($s_pattern,$p_pattern,$o_pattern) = @_;

    my $ldf_iter = $self->ldf->get_statements(
        $s_pattern ? $s_pattern->ntriples_string : undef,
        $p_pattern ? $p_pattern->ntriples_string : undef,
        $o_pattern ? $o_pattern->ntriples_string : undef
    );

    my $iter = Attean::CodeIterator->new(
        generator => sub {
          my $statement = $ldf_iter->();
          return () unless defined($statement);
          my ($subject,$predicate,$object);

          if ($statement->subject->is_resource) {
                $subject = Attean::IRI->new($statement->subject->value);
          }
          else {
                $subject = Attean::Blank->new($statement->subject->value);
          }

          $predicate = Attean::IRI->new($statement->predicate->value);

          if ($statement->object->is_resource) {
                $object = Attean::IRI->new($statement->object->value);
          }
          elsif ($statement->object->is_literal) {
                $object = Attean::Literal->new($statement->object->value);
          }
          else {
                $object = Attean::Blank->new($statement->object->value);
          }

          my @res = (
            Attean::Triple->new(
                subject   => $subject ,
                predicate => $predicate ,
                object    => $object
            )
          );

          @res;
        },
        item_type => 'Attean::API::Triple',
    );

    return $iter;
}

1;

__END__

=back

=head1 SEE ALSO

L<Attean> , L<Attean::API::TripleStore>

=head1 BUGS

Please report any bugs or feature requests to through the GitHub web interface
at L<https://github.com/phochste/AtteanX-Store-LDF>.

=head1 AUTHOR

Patrick Hochstenbach  C<< <patrick.hochstenbach@ugent.be> >>

=head1 COPYRIGHT

This software is copyright (c) 2015 by Patrick Hochstenbach.
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
