use strict;
use warnings;
use Test::More;
use Test::Roo;
use RDF::Trine::Model;
use RDF::Trine qw(statement iri blank literal);
use RDF::LinkedData;
use Test::LWP::UserAgent;
use Plack::Request;
use HTTP::Message::PSGI;
use Data::Dumper;

sub create_store {
	my $self = shift;
	my %args        = @_;
	my $triples       = $args{triples} // [];
	my $model = RDF::Trine::Model->temporary_model; # For creating endpoint
	foreach my $atteantriple (@{$triples}) {
		my $s = iri($atteantriple->subject->value);
		if ($atteantriple->subject->is_blank) {
			$s = blank($atteantriple->subject->value);
		}
		my $p = iri($atteantriple->predicate->value);
		my $o = iri($atteantriple->object->value);
		if ($atteantriple->object->is_literal) {
			# difference with RDF 1.0 vs RDF 1.1 datatype semantics
			if ($atteantriple->object->datatype->value eq 'http://www.w3.org/2001/XMLSchema#string') {
				$o = literal($atteantriple->object->value, $atteantriple->object->language);
			} else {
				$o = literal($atteantriple->object->value, $atteantriple->object->language, $atteantriple->object->datatype->value);
			}
		} elsif ($atteantriple->object->is_blank) {
			$o = blank($atteantriple->object->value);
		}
		$model->add_statement(statement($s, $p, $o));
	}

	my $ld = RDF::LinkedData->new(
		model            => $model ,
		base_uri         => 'http://example.org' ,
		void_config      => { 
			urispace => 'http://example.org/' 
		} ,
		fragments_config => { 
			fragments_path => '/fragments' ,
			allow_dump_dataset => 1,
		} ,
	);

	my $endpoint = 'http://example.org/fragments';

	my $useragent = Test::LWP::UserAgent->new;
	$useragent->register_psgi('example.org', sub {
	    my $env = shift;
	    $ld->request(Plack::Request->new($env));
		return $ld->response($endpoint)->finalize;
	});

	my $store = Attean->get_store('LDF')->new(endpoint_url => $endpoint);

	RDF::Trine->default_useragent($useragent);

	return $store;
}

with 'Test::Attean::TripleStore';
run_me;

done_testing;