use v6;
unit class MeCab is repr('CPointer');

use NativeCall;
use MeCab::Tagger;
use MeCab::Lattice;
use MeCab::Model;

my constant $library = %?RESOURCES<libraries/mecab>.Str;

enum NodeStat is export (
  :MECAB_NOR_NODE(0),
  :MECAB_UNK_NODE(1),
  :MECAB_BOS_NODE(2),
  :MECAB_EOS_NODE(3),
  :MECAB_EON_NODE(4)
);

enum DictionaryInfoType is export (
  :MECAB_SYS_DIC(0),
  :MECAB_USR_DIC(1),
  :MECAB_UNK_DIC(2)
);

enum LatticeRequestType is export (
  :MECAB_ONE_BEST(1),
  :MECAB_NBEST(2),
  :MECAB_PARTIAL(4),
  :MECAB_MARGINAL_PROB(8),
  :MECAB_ALTERNATIVE(16),
  :MECAB_ALL_MORPHS(32),
  :MECAB_ALLOCATE_SENTENCE(64)
);

enum LatticeBoundaryConstraintType is export (
  :MECAB_ANY_BOUNDARY(0),
  :MECAB_TOKEN_BOUNDARY(1),
  :MECAB_INSIDE_TOKEN(2)
);

my sub mecab_strerror(MeCab::Tagger) returns Str is native($library) { * }
my sub mecab_destroy(MeCab::Tagger) is native($library) { * }
my sub mecab_lattice_new() returns MeCab::Lattice is native($library) { * }
my sub mecab_lattice_destroy(MeCab::Lattice) is native($library) { * }
my sub mecab_model_destroy(MeCab::Model) is native($library) { * }

method create-lattice {
    mecab_lattice_new()
}

our sub strerror(MeCab::Tagger $tagger) {
    mecab_strerror($tagger)
}

our sub destroy(MeCab::Tagger $tagger) {
    mecab_destroy($tagger)
}

our sub lattice-destroy(MeCab::Lattice $tagger) {
    mecab_lattice_destroy($tagger)
}

our sub model-destroy(MeCab::Model $model) {
    mecab_model_destroy($model)
}

=begin pod

=head1 NAME

MeCab - A Perl 6 bindings for MeCab ( http://taku910.github.io/mecab/ )

=head1 SYNOPSIS

       use MeCab;
       use MeCab::Tagger;
       use MeCab::Node;
       
       my Str $text = "すもももももももものうち。";
       my $mecab-tagger = MeCab::Tagger.new('-C');
       my @surfaces = gather loop ( my MeCab::Node $node = $mecab-tagger.parse-tonode($text); $node; $node = $node.next ) {
              take $node.surface;
       }
       say @surfaces; # ("","すもも","も","もも","も","もも","の","うち","。","");

=head1 DESCRIPTION

MeCab is a Perl 6 binding for MeCab ( http://taku910.github.io/mecab/ ).

=head1 AUTHOR

titsuki <titsuki@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 titsuki

MeCab ( http://taku910.github.io/mecab/ ) by Taku Kudo is licensed under the GPL/LGPL/BSD License.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
