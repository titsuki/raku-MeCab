use v6;
use NativeCall;

my constant $library = %?RESOURCES<libraries/mecab>.Str;

enum DictionaryInfoType is export (
  :MECAB_SYS_DIC(0),
  :MECAB_USR_DIC(1),
  :MECAB_UNK_DIC(2)
);

class MeCab::Path is repr('CStruct') { ... }
class MeCab::Node is repr('CStruct') is export {
    enum Stat is export (
        :MECAB_NOR_NODE(0),
        :MECAB_UNK_NODE(1),
        :MECAB_BOS_NODE(2),
        :MECAB_EOS_NODE(3),
        :MECAB_EON_NODE(4)
    );

    my sub mecab_node_t_surface_get(MeCab::Node) returns Str is native($library) { * };
    has MeCab::Node $.prev;
    has MeCab::Node $.next;
    has MeCab::Node $.enext;
    has MeCab::Node $.bnext;
    has MeCab::Path $.rpath;
    has MeCab::Path $.lpath;
    has Pointer[int8] $!surface;
    has Str $.feature;
    has uint32 $.id;
    has uint16 $.length;
    has uint16 $.rlength;
    has uint16 $.rcAttr;
    has uint16 $.lcAttr;
    has uint16 $.posid;
    has uint8 $.char_type;
    has uint8 $!stat;
    has uint8 $!isbest;
    has num32 $.alpha;
    has num32 $.beta;
    has num32 $.prob;
    has int16 $.wcost;
    has int64 $.cost;

    method surface {
        mecab_node_t_surface_get(self);
    }

    method stat {
        Stat($!stat)
    }

    method isbest returns Bool {
        Bool($!isbest)
    }
}

class MeCab::Path is export {
    has MeCab::Node $.rnode;
    has MeCab::Path $.rnext;
    has MeCab::Node $.lnode;
    has MeCab::Path $.lnext;
    has int32 $.cost;
    has num32 $.prob;
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
