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
# DEPRECATED
# my sub mecab_get_partial(MeCab::Tagger) returns int32 is native($library) { * }
# my sub mecab_set_partial(MeCab::Tagger, bool) is native($library) { * }
my sub mecab_get_theta(MeCab::Tagger) is native($library) { * }
my sub mecab_set_theta(MeCab::Tagger, num32) is native($library) { * }
my sub mecab_get_lattice_level(MeCab::Tagger) returns int32 is native($library) { * }
my sub mecab_set_lattice_level(MeCab::Tagger, int32) returns int32 is native($library) { * }
# DEPRECATED
# my sub mecab_get_all_morphs(MeCab::Tagger) returns int32 is native($library) { * }
# my sub mecab_set_all_morphs(MeCab::Tagger, int32) returns int32 is native($library) { * }
my sub mecab_parse_lattice(MeCab::Tagger, MeCab::Lattice) returns int32 is native($library) { * }
my sub mecab_sparse_tonode(MeCab::Tagger, Str) returns MeCab::Node is native($library) { * }
my sub mecab_sparse_tostr(MeCab::Tagger, Str) returns Str is native($library) { * }
my sub mecab_sparse_tostr2(MeCab::Tagger, size_t, Str, size_t) returns CArray[int8] is native($library) { * }
my sub mecab_sparse_tostr3(MeCab::Tagger, size_t, Str, size_t, CArray[int8], size_t) returns CArray[int8] is native($library) { * }
my sub mecab_nbest_init(MeCab::Tagger, Str) returns int32 is native($library) { * }
my sub mecab_nbest_init2(MeCab::Tagger, Str, size_t) returns int32 is native($library) { * }
my sub mecab_nbest_next_tostr(MeCab::Tagger) returns Str is native($library) { * }
my sub mecab_nbest_next_tostr2(MeCab::Tagger, CArray[int8], size_t) returns CArray[int8] is native($library) { * }
my sub mecab_nbest_next_tonode(MeCab::Tagger) returns MeCab::Node is native($library) { * }
my sub mecab_format_node(MeCab::Tagger, MeCab::Node) returns Str is native($library) { * }
# DEPRECATED
# my sub mecab_get_request_type(MeCab::Tagger) returns int32 is native($library) { * }
# my sub mecab_set_request_type(MeCab::Tagger, int32) is native($library) { * }
my sub mecab_dictionary_info(MeCab::Tagger) returns MeCab::DictionaryInfo is native($library) { * }
my sub mecab_strerror(MeCab::Tagger) returns Str is native($library) { * }

method new(Str $arg) {
    mecab_new2($arg);
}

# DEPRECATED
# multi method request-type(Int $type) {
#     mecab_set_request_type(self, $type);
# }

# DEPRECATED
# multi method request-type {
#     mecab_get_request_type(self);
# }

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

method nbest-init(Str $text) returns Bool {
    Bool(mecab_nbest_init(self, $text))
}

method nbest-next-tostr {
    mecab_nbest_next_tostr(self)
}

method nbest-next-tonode {
    mecab_nbest_next_tonode(self)
}

method format-node(MeCab::Node $node) {
    mecab_format_node(self, $node)
}

# DEPRECATED
# multi method request-type {
#     mecab_get_request_type(self)
# }

# DEPRECATED
# multi method request-type(Int $type) {
#     mecab_set_request_type(self, $type)
# }

method dictionary-info {
    mecab_dictionary_info(self)
}

method strerror {
    mecab_strerror(self)
}

submethod DESTROY {
    mecab_destroy(self)
}
