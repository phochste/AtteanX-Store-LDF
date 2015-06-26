use v5.14;
use warnings;

package AtteanX::Store::LDF 0.001 {
    use Moo;
    use Attean::API::Store;
    use Type::Tiny::Role;
    use Types::Standard qw(Str);
    use RDF::LDF;
    use namespace::clean;

    with 'Attean::API::TripleStore';

    has url => (is => 'ro', isa => Str, required => 1);
    has ldf => (is => 'ro', lazy => 1, builder => '_ldf');

    sub _ldf {
        my $self = shift;
        RDF::LDF->new(url => $self->url);
    }

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
}

1;

__END__
