use v6;
unit class MeCab::Tagger is repr('CPointer');

use NativeCall;
use MeCab;
use MeCab::Lattice;
use MeCab::DictionaryInfo;

my constant $library = %?RESOURCES<libraries/mecab>.Str;

my sub mecab_destroy(MeCab::Tagger) is native($library) { * }
my sub mecab_new2(Str) returns MeCab::Tagger is native($library) { * }
my sub mecab_version() returns Str is native($library) { * }
my sub mecab_get_theta(MeCab::Tagger) is native($library) { * }
my sub mecab_set_theta(MeCab::Tagger, num32) is native($library) { * }
my sub mecab_get_lattice_level(MeCab::Tagger) returns int32 is native($library) { * }
my sub mecab_set_lattice_level(MeCab::Tagger, int32) returns int32 is native($library) { * }
my sub mecab_parse_lattice(MeCab::Tagger, MeCab::Lattice) returns int32 is native($library) { * }
my sub mecab_sparse_tonode(MeCab::Tagger, Str) returns MeCab::Node is native($library) { * }
my sub mecab_sparse_tostr(MeCab::Tagger, Str) returns Str is native($library) { * }
my sub mecab_sparse_tostr2(MeCab::Tagger, size_t, Str, size_t) returns CArray[int8] is native($library) { * }
my sub mecab_sparse_tostr3(MeCab::Tagger, size_t, Str, size_t, CArray[int8], size_t) returns CArray[int8] is native($library) { * }
my sub mecab_dictionary_info(MeCab::Tagger) returns MeCab::DictionaryInfo is native($library) { * }
my sub mecab_strerror(MeCab::Tagger) returns Str is native($library) { * }

method new(Str $arg) {
    mecab_new2($arg);
}

method version {
    mecab_version();
}

multi method parse(Str $text) {
    mecab_sparse_tostr(self, $text);
}

multi method parse(MeCab::Lattice $lattice) returns Bool {
    Bool(mecab_parse_lattice(self, $lattice))
}

method parse-tonode(Str $text) {
    mecab_sparse_tonode(self, $text);
}

method dictionary-info {
    mecab_dictionary_info(self)
}

method strerror {
    mecab_strerror(self)
}

submethod DESTROY {
    mecab_destroy(self)
}
