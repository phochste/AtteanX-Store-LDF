# NAME

AtteanX::Store::LDF - Linked Data Fragment RDF store

# STATUS
[![Build Status](https://travis-ci.org/phochste/AtteanX-Store-LDF.svg)](https://travis-ci.org/phochste/AtteanX-Store-LDF)
[![Coverage Status](https://coveralls.io/repos/phochste/AtteanX-Store-LDF/badge.svg)](https://coveralls.io/r/phochste/AtteanX-Store-LDF)
[![Kwalitee Score](http://cpants.cpanauthors.org/dist/AtteanX-Store-LDF.png)](http://cpants.cpanauthors.org/dist/AtteanX-Store-LDF)

# SYNOPSIS

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

# DESCRIPTION

AtteanX::Store::LDF provides a triple-store connected to a Linked Data Fragment server.
For more information on Triple Pattern Fragments consult [http://linkeddatafragments.org/](http://linkeddatafragments.org/)

# METHODS

Beyond the methods documented below, this class inherits methods from the
[Attean::API::TripleStore](https://metacpan.org/pod/Attean::API::TripleStore) class.

- new( endpoint\_url => $endpoint\_url )

    Returns a new LDF-backed storage object.

- count\_triples ( $subject, $predicate, $object ) 

    Return the count of triples matching the specified subject, predicate and 
    objects.

- get\_triples( $subject, $predicate, $object)

    Returns a stream object of all statements matching the specified subject,
    predicate and objects. Any of the arguments may be undef to match any value.

# SEE ALSO

[Attean](https://metacpan.org/pod/Attean) , [Attean::API::TripleStore](https://metacpan.org/pod/Attean::API::TripleStore)

# BUGS

Please report any bugs or feature requests to through the GitHub web interface
at [https://github.com/phochste/AtteanX-Store-LDF](https://github.com/phochste/AtteanX-Store-LDF).

# AUTHOR

Patrick Hochstenbach  `<patrick.hochstenbach@ugent.be>`

# COPYRIGHT

This software is copyright (c) 2015 by Patrick Hochstenbach.
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
