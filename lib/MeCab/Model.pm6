use v6;
unit class MeCab::Model:auth<zef:titsuki>:ver<0.0.17> is repr('CPointer');

use NativeCall;
use MeCab::Tagger;
use MeCab::Lattice;

my constant $library = %?RESOURCES<libraries/mecab>.Str;

my sub mecab_model_destroy(MeCab::Model) is native($library) { * }
my sub mecab_model_new(int32, CArray[Str]) returns MeCab::Model is native($library) { * }
my sub mecab_model_new2(Str) returns MeCab::Model is native($library) { * }
my sub mecab_model_new_tagger(MeCab::Model) returns MeCab::Tagger is native($library) { * }
my sub mecab_model_new_lattice(MeCab::Model) returns MeCab::Lattice is native($library) { * }

multi submethod new {
    mecab_model_new2("-C")
}

multi submethod new(Str $argv) {
    mecab_model_new2($argv);
}

multi submethod new(
    Str :$rcfile,
    Str :$dicdir,
    Str :$userdic,
) {
    my @args;
    @args.push('-C'); # allocate-sentence

    if $rcfile.defined {
        $rcfile.IO.f or die "$rcfile doesn't exist.";
        $dicdir.defined or die ":rcfile requires :dicdir.";
        $dicdir.IO.d or die "$dicdir doesn't exist.";

        @args.push(sprintf('-r %s', $rcfile));
    }

    if $dicdir.defined {
        $dicdir.IO.d or die "$dicdir doesn't exist.";

        @args.push(sprintf('-d %s', $dicdir));
    }

    if $userdic.defined {
        $userdic.IO.f or die "$userdic doesn't exist.";

        @args.push(sprintf('-u %s', $userdic))
    }
    mecab_model_new2(@args.join(' '));
}

method create-tagger {
    mecab_model_new_tagger(self)
}

method create-lattice {
    mecab_model_new_lattice(self)
}

submethod DESTROY {
    mecab_model_destroy(self)
}

=begin pod

=head1 NAME

MeCab::Model - A Raku MeCab::Model class

=head1 SYNOPSIS

       use MeCab;
       use MeCab::Lattice;
       use MeCab::Tagger;
       use MeCab::Model;
       
       my MeCab::Model $model .= new;
       my MeCab::Tagger $tagger = $model.create-tagger;
       my MeCab::Lattice $lattice = $model.create-lattice;
       $lattice.add-request-type(MECAB_NBEST);
       $lattice.sentence("今日も");

       if $tagger.parse($lattice) {
          say $lattice.nbest-tostr(2);
       }

       # OUTPUT«
       # 今日    名詞,副詞可能,*,*,*,*,今日,キョウ,キョー
       # も      助詞,係助詞,*,*,*,*,も,モ,モ
       # EOS
       # 今日    名詞,副詞可能,*,*,*,*,今日,コンニチ,コンニチ
       # も      助詞,係助詞,*,*,*,*,も,モ,モ
       # EOS
       # »

=head1 DESCRIPTION

MeCab::Model is a Raku MeCab::Model class.

=head2 METHODS

=head3 new

Defined as:

        multi method new() returns MeCab::Model
        multi method new(Str $extra-argv) returns MeCab::Model

Creates a new MeCab::Model object.

=head3 create-tagger

Defined as:

        method create-tagger() returns MeCab::Tagger

Creates a new MeCab::Tagger object.

=head3 create-lattice

Defined as:

        method create-lattice() returns MeCab::Lattice

Creates a new MeCab::Lattice object.

=head1 AUTHOR

titsuki <titsuki@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 titsuki

libmecab ( http://taku910.github.io/mecab/ ) by Taku Kudo is licensed under the GPL, LGPL or BSD Licenses.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
