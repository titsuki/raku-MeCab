[![Build Status](https://travis-ci.org/titsuki/p6-MeCab.svg?branch=master)](https://travis-ci.org/titsuki/p6-MeCab)

NAME
====

MeCab - A Perl 6 bindings for MeCab ( http://taku910.github.io/mecab/ )

SYNOPSIS
========

    use MeCab;
    use MeCab::Tagger;
    use MeCab::Node;

    my Str $text = "すもももももももものうち。";
    my $mecab-tagger = MeCab::Tagger.new('-C');
    my @surfaces = gather loop ( my MeCab::Node $node = $mecab-tagger.parse-tonode($text); $node; $node = $node.next ) {
           take $node.surface;
    }
    say @surfaces; # ("","すもも","も","もも","も","もも","の","うち","。","");

DESCRIPTION
===========

MeCab is a Perl 6 binding for MeCab ( http://taku910.github.io/mecab/ ).

AUTHOR
======

titsuki <titsuki@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2016 titsuki

MeCab ( http://taku910.github.io/mecab/ ) by Taku Kudo is licensed under the GPL/LGPL/BSD License.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
