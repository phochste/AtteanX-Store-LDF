# perl version
requires 'perl','>=5.14.1';

on 'test', sub {
  requires 'Test::More', '0.88';
  requires 'Test::Exception', 0;
  requires 'Test::Roo' , 0;
  requires 'Test::LWP::UserAgent', 0;
  requires 'RDF::LinkedData', '>=0.74';
  requires 'RDF::Generator::Void', 0;
};

# modules
requires        'Attean'                    , '>= 0.010';
requires        'RDF::LDF'                  , 0;
requires        'MooX::Log::Any'            , 0;