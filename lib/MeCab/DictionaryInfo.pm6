use v6;
unit class MeCab::DictionaryInfo is repr('CStruct');

has Str $.filename;
has Str $.charset;
has uint32 $.size;
has int32 $.type;
has uint32 $.lsize;
has uint32 $.rsize;
has uint16 $.version;
has MeCab::DictionaryInfo $.next;
