=head1 NAME

AtteanX::Store::LDF - Linked Data Fragment RDF store

=begin markdown

# STATUS
[![Build Status](https://travis-ci.org/phochste/AtteanX-Store-LDF.svg)](https://travis-ci.org/phochste/AtteanX-Store-LDF)
[![Coverage Status](https://coveralls.io/repos/phochste/AtteanX-Store-LDF/badge.svg)](https://coveralls.io/r/phochste/AtteanX-Store-LDF)
[![Kwalitee Score](http://cpants.cpanauthors.org/dist/AtteanX-Store-LDF.png)](http://cpants.cpanauthors.org/dist/AtteanX-Store-LDF)

=end markdown

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

our $VERSION = '0.002';

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

sub _term_as_string {
    my ($self,$term) = @_;  
    if (!defined $term) {
        return undef
    }
    elsif ($term->does('Attean::API::Literal')) {
        return $term->as_string; # includes quotes and any language or datatype
    } 
    else {
        return $term->value; # the raw IRI or blank node identifier value, without other syntax
    }
}

=item count_triples ( $subject, $predicate, $object ) 

Return the count of triples matching the specified subject, predicate and 
objects.

=cut
sub count_triples {
    my $self    = shift;
    my ($s_pattern,$p_pattern,$o_pattern) = @_;
           
    my $ldf_iter = $self->ldf->get_statements(
        $self->_term_as_string($s_pattern),
        $self->_term_as_string($p_pattern),
        $self->_term_as_string($o_pattern)
    );

    return 0 unless defined $ldf_iter;

    my ($statement,$info) = $ldf_iter->();

    return $info->{'hydra_totalItems'};
}

=item get_triples( $subject, $predicate, $object)

Returns a stream object of all statements matching the specified subject,
predicate and objects. Any of the arguments may be undef to match any value.

=cut
sub get_triples {
    my $self    = shift;
    my ($s_pattern,$p_pattern,$o_pattern) = @_;

    my $ldf_iter = $self->ldf->get_statements(
        $self->_term_as_string($s_pattern),
        $self->_term_as_string($p_pattern),
        $self->_term_as_string($o_pattern)
    );

    return Attean::ListIterator->new(values => [] , item_type => 'Attean::API::Triple')
            unless $ldf_iter;

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
