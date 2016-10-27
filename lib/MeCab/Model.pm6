use v6;
unit class MeCab::Model is repr('CPointer');

use NativeCall;
use MeCab::Tagger;
use MeCab::Lattice;

my constant $library = %?RESOURCES<libraries/mecab>.Str;

my sub mecab_model_destroy(MeCab::Model) is native($library) { * }
my sub mecab_model_new(int32, CArray[Str]) returns MeCab::Model is native($library) { * }
my sub mecab_model_new2(CArray[Str]) returns MeCab::Model is native($library) { * }
my sub mecab_model_new_tagger(MeCab::Model) returns MeCab::Tagger is native($library) { * }
my sub mecab_model_new_lattice(MeCab::Model) returns MeCab::Lattice is native($library) { * }

method new {
    my CArray[Str] $argv .= new;
    $argv[0] = "-C";
    mecab_model_new2($argv)
}

method create-tagger(MeCab::Model $model) {
    mecab_model_new_tagger(self)
}

method create-lattice(MeCab::Model $model) {
    mecab_model_new_lattice(self)
}

submethod DESTROY {
    mecab_model_destroy(self)
}
