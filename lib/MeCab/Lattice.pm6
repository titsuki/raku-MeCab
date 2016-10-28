use v6;
use NativeCall;

unit class MeCab::Lattice is repr('CPointer');

use MeCab::Loadable;

my constant $library = %?RESOURCES<libraries/mecab>.Str;

enum RequestType is export (
  :MECAB_ONE_BEST(1),
  :MECAB_NBEST(2),
  :MECAB_PARTIAL(4),
  :MECAB_MARGINAL_PROB(8),
  :MECAB_ALTERNATIVE(16),
  :MECAB_ALL_MORPHS(32),
  :MECAB_ALLOCATE_SENTENCE(64)
);

enum BoundaryConstraintType is export (
  :MECAB_ANY_BOUNDARY(0),
  :MECAB_TOKEN_BOUNDARY(1),
  :MECAB_INSIDE_TOKEN(2)
);

my sub mecab_lattice_destroy(MeCab::Lattice) is native($library) { * }
my sub mecab_lattice_new() returns MeCab::Lattice is native($library) { * }
my sub mecab_lattice_clear(MeCab::Lattice) is native($library) { * }
my sub mecab_lattice_is_available(MeCab::Lattice) returns int32 is native($library) { * }
my sub mecab_lattice_get_bos_node(MeCab::Lattice) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_get_eos_node(MeCab::Lattice) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_get_all_begin_nodes(MeCab::Lattice) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_get_all_end_nodes(MeCab::Lattice) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_get_begin_nodes(MeCab::Lattice, size_t) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_get_end_nodes(MeCab::Lattice, size_t) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_get_sentence(MeCab::Lattice) returns Str is native($library) { * }
my sub mecab_lattice_set_sentence(MeCab::Lattice, Str) is native($library) { * }
my sub mecab_lattice_set_sentence2(MeCab::Lattice, Str, size_t) is native($library) { * }
my sub mecab_lattice_get_size(MeCab::Lattice) returns size_t is native($library) { * }
my sub mecab_lattice_get_z(MeCab::Lattice) returns num64 is native($library) { * }
my sub mecab_lattice_set_z(MeCab::Lattice, num64) returns num64 is native($library) { * }
my sub mecab_lattice_get_theta(MeCab::Lattice) returns num64 is native($library) { * }
my sub mecab_lattice_set_theta(MeCab::Lattice, num64) is native($library) { * }
my sub mecab_lattice_next(MeCab::Lattice) returns int32 is native($library) { * }
my sub mecab_lattice_get_request_type(MeCab::Lattice) returns int32 is native($library) { * }
my sub mecab_lattice_has_request_type(MeCab::Lattice, int32) returns int32 is native($library) { * }
my sub mecab_lattice_set_request_type(MeCab::Lattice, int32) is native($library) { * }
my sub mecab_lattice_add_request_type(MeCab::Lattice, int32) is native($library) { * }
my sub mecab_lattice_remove_request_type(MeCab::Lattice, int32) is native($library) { * }
my sub mecab_lattice_new_node(MeCab::Lattice) returns MeCab::Node is native($library) { * }
my sub mecab_lattice_tostr(MeCab::Lattice) returns Str is native($library) { * }
my sub mecab_lattice_tostr2(MeCab::Lattice, CArray[int8] is rw, size_t) returns Str is native($library) { * }
my sub mecab_lattice_nbest_tostr(MeCab::Lattice, size_t) returns Str is native($library) { * }
my sub mecab_lattice_nbest_tostr2(MeCab::Lattice, size_t, CArray[int8] is rw, size_t) returns Str is native($library) { * }
my sub mecab_lattice_has_constraint(MeCab::Lattice) returns int32 is native($library) { * }
my sub mecab_lattice_get_boundary_constraint(MeCab::Lattice, size_t) returns int32 is native($library) { * }
my sub mecab_lattice_get_feature_constraint(MeCab::Lattice, size_t) returns Str is native($library) { * }
my sub mecab_lattice_set_boundary_constraint(MeCab::Lattice, size_t, int32) is native($library) { * }
my sub mecab_lattice_set_feature_constraint(MeCab::Lattice, size_t, size_t, Str) is native($library) { * }
my sub mecab_lattice_set_result(MeCab::Lattice, Str) is native($library) { * }
my sub mecab_lattice_strerror(MeCab::Lattice) returns Str is native($library) { * }

method new {
    mecab_lattice_new();
}

method clear {
    mecab_lattice_clear(self)
}

method is-available returns Bool {
    Bool(mecab_lattice_is_available(self))
}

method bos-node {
    mecab_lattice_get_bos_node(self)
}

method eos-node {
    mecab_lattice_get_eos_node(self)
}

method all_begin_nodes {
    mecab_lattice_get_all_begin_nodes(self)
}

method all_end_nodes {
    mecab_lattice_get_all_end_nodes(self)
}

multi method sentence {
    mecab_lattice_get_sentence(self)
}

multi method sentence(Str $text) {
    mecab_lattice_set_sentence(self, $text)
}

method size {
    mecab_lattice_get_size(self)
}

multi method z {
    mecab_lattice_get_z(self)
}

multi method z(Num $z) {
    mecab_lattice_set_z(self, $z)
}

multi method theta {
    mecab_lattice_get_theta(self)
}

multi method theta(Num $theta) {
    mecab_lattice_set_theta(self, $theta)
}

method next {
    mecab_lattice_next(self)
}

multi method request-type returns RequestType {
    RequestType(mecab_lattice_get_request_type(self))
}

multi method request-type(Int $type) {
    mecab_lattice_set_request_type(self, $type)
}

method has-request-type(Int $type) {
    mecab_lattice_has_request_type(self, $type)
}

method add-request-type(Int $type) {
    mecab_lattice_add_request_type(self, $type)
}

method remove-request-type(Int $type) {
    mecab_lattice_remove_request_type(self, $type)
}

method create-node {
    mecab_lattice_new_node(self)
}

method tostr {
    mecab_lattice_tostr(self)
}

method nbest-tostr(Int $size) {
    mecab_lattice_nbest_tostr(self, $size)
}

method has-constraint returns Bool {
    Bool(mecab_lattice_has_constraint(self))
}

multi method boundary-constraint(Int $pos) returns BoundaryConstraintType {
    BoundaryConstraintType(mecab_lattice_get_boundary_constraint(self, $pos))
}

multi method boundary-constraint(Int $pos, BoundaryConstraintType $boundary-type) {
    mecab_lattice_set_boundary_constraint(self, $pos, $boundary-type)
}

multi method feature-constraint(Int $begin-pos, Int $end-pos, Str $feature) {
    mecab_lattice_set_feature_constraint(self, $begin-pos, $end-pos, $feature)
}

multi method feature-constraint(Int $pos) {
    mecab_lattice_get_feature_constraint(self, $pos)
}

submethod DESTROY {
    mecab_lattice_destroy(self)    
}
