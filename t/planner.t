use strict;
use warnings;
use Test::More;
use Test::Roo;
use AtteanX::Store::LDF::Plan::Triple;
use Attean::RDF;

package TestCreateStore {
        use Moo;
        with 'Test::Attean::Store::LDF::Role::CreateStore';
};

my $triples = [
                                   triple(iri('http://example.org/bar'), iri('http://example.org/c'), iri('http://example.org/foo')),
                                   triple(iri('http://example.org/foo'), iri('http://example.org/p'), iri('http://example.org/baz')),
                                   triple(iri('http://example.org/baz'), iri('http://example.org/b'), literal('2')),
                                   triple(iri('http://example.com/foo'), iri('http://example.org/p'), literal('dahut')),
                                   triple(iri('http://example.org/dahut'), iri('http://example.org/dahut'), literal('1')),
                                  ];

my $test = TestCreateStore->new;
my $store = $test->create_store(triples => $triples);

my $plan = AtteanX::Store::LDF::Plan::Triple->new(subject => variable('s'),
																  predicate => iri('http://example.org/p'),
																  object => variable('o'),
																  distinct => 0
);

is($store->cost_for_plan($plan), 12, 'Correct');

done_testing;
