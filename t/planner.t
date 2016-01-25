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
my $plan = AtteanX::Store::LDF::Plan::Triple->new(subject => variable('s'),
																  predicate => iri('http://example.org/p'),
																  object => variable('o'),
																  distinct => 0
																 );
isa_ok($plan, 'AtteanX::Store::LDF::Plan::Triple');
is($plan->as_string, "- LDFQuad { ?s, <http://example.org/p>, ?o, ?graph }\n", 'Serialized plan ok');


{
	my $store = $test->create_store(triples => []);
	is($store->cost_for_plan($plan), 10000, 'Correct cost for plan with empty store');
}

{
	my $store = $test->create_store(triples => $triples);
	is($store->cost_for_plan($plan), 406, 'Correct cost for plan with populated store');
}

{
	my $plan2 = AtteanX::Store::LDF::Plan::Triple->new(subject => variable('s'),
																		predicate => iri('http://example.org/nothere'),
																		object => variable('o'),
																		distinct => 0
																	  );
	isa_ok($plan2, 'AtteanX::Store::LDF::Plan::Triple');
	is($plan2->as_string, "- LDFQuad { ?s, <http://example.org/nothere>, ?o, ?graph }\n", 'Serialized plan ok');
	my $store = $test->create_store(triples => $triples);
	is($store->cost_for_plan($plan2), 10, 'Correct cost for plan with populated store but no hits');
}

done_testing;
