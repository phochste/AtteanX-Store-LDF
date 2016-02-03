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
    my $store = Attean->get_store('LDF')->new(start_url => $uri);

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

- new( start\_url => $start\_url )

    Returns a new LDF-backed storage object. The required `start_url`
    argument is a URL pointing at any Linked Data Fragment. The attribure
    will be coerced, so it can be a string, a URI object, etc.

- count\_triples\_estimate( $subject, $predicate, $object ) 

    Return the count of triples matching the specified subject, predicate and 
    objects.

- get\_triples( $subject, $predicate, $object)

    Returns a stream object of all statements matching the specified subject,
    predicate and objects. Any of the arguments may be undef to match any value.

- cost\_for\_plan($plan)

    Returns an cost estimation for a single LDF triple based on
    estimates. The cost will be in the interval 10-1000 if the supplied
    argument is a [AtteanX::Store::LDF::Plan::Triple](https://metacpan.org/pod/AtteanX::Store::LDF::Plan::Triple), undef otherwise.

# SEE ALSO

[Attean](https://metacpan.org/pod/Attean) , [Attean::API::TripleStore](https://metacpan.org/pod/Attean::API::TripleStore)

# BUGS

Please report any bugs or feature requests to through the GitHub web interface
at [https://github.com/phochste/AtteanX-Store-LDF](https://github.com/phochste/AtteanX-Store-LDF).

# AUTHOR

Patrick Hochstenbach  `<patrick.hochstenbach@ugent.be>`
Kjetil Kjernsmo &lt;kjetilk@cpan.org>.

# COPYRIGHT

This software is copyright (c) 2015 by Patrick Hochstenbach.
This software is copyright (c) 2016 by Patrick Hochstenbach and Kjetil Kjernsmo.
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
