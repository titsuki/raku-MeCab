[![Build Status](https://travis-ci.org/titsuki/raku-MeCab.svg?branch=master)](https://travis-ci.org/titsuki/raku-MeCab)

NAME
====

MeCab - A Raku bindings for libmecab ( http://taku910.github.io/mecab/ )

SYNOPSIS
========

EXAMPLE 1
---------

    use MeCab;
    use MeCab::Tagger;

    my Str $text = "すもももももももものうち。";
    my $mecab-tagger = MeCab::Tagger.new('-C');
    loop ( my MeCab::Node $node = $mecab-tagger.parse-tonode($text); $node; $node = $node.next ) {
           say ($node.surface, $node.feature).join("\t");
    }

    # OUTPUT«
    #         BOS/EOS,*,*,*,*,*,*,*,*
    # すもも  名詞,一般,*,*,*,*,すもも,スモモ,スモモ
    # も      助詞,係助詞,*,*,*,*,も,モ,モ
    # もも    名詞,一般,*,*,*,*,もも,モモ,モモ
    # も      助詞,係助詞,*,*,*,*,も,モ,モ
    # もも    名詞,一般,*,*,*,*,もも,モモ,モモ
    # の      助詞,連体化,*,*,*,*,の,ノ,ノ
    # うち    名詞,非自立,副詞可能,*,*,*,うち,ウチ,ウチ
    # 。      記号,句点,*,*,*,*,。,。,。
    #         BOS/EOS,*,*,*,*,*,*,*,*
    # »

EXAMPLE 2
---------

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

DESCRIPTION
===========

MeCab is a Raku bindings for libmecab ( http://taku910.github.io/mecab/ ).

NOTICE
======

COMPATIBILITY
-------------

MeCab currently doesn't support Windows. It supports Linux/Unix or Mac OS X.

BUILDING MeCab
--------------

MeCab depends on the following:

  * wget

  * mecab-0.996

  * mecab-ipadic-2.7.0-20070801

Once the build starts, it automatically downloads `mecab-0.996` and `mecab-ipadic-2.7.0-20070801` with `wget` and installs these stuffs under the `$HOME/.p6mecab` directory, where `$HOME` is your home directory.

Use 3rd-party dictionary
========================

mecab-ipadic-neologd
--------------------

  * Step1: download and install neologd

Example:

    $ git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
    $ cd mecab-ipadic-neologd
    $ export PATH=$HOME/.p6mecab/bin:$PATH
    $ ./bin/install-mecab-ipadic-neologd -p $HOME/.p6mecab/lib/mecab/dic/ipadic-neologd

  * Step2: Use .new(:dicdir(PATH_TO_THE_DIR))

Example:

    use MeCab;
    use MeCab::Tagger;

    my Str $text = "トランプ大統領 ワシントンで大規模軍事パレードを指示";
    my $mecab-tagger = MeCab::Tagger.new(:dicdir("$*HOME/.p6mecab/lib/mecab/dic/ipadic-neologd"));
    loop ( my MeCab::Node $node = $mecab-tagger.parse-tonode($text); $node; $node = $node.next ) {
           say ($node.surface, $node.feature).join("\t");
    }

    # OUTPUT«
    #         BOS/EOS,*,*,*,*,*,*,*,*
    # トランプ大統領  名詞,固有名詞,人名,一般,*,*,ドナルド・トランプ,トランプダイトウリョウ,トランプダイトウリョー
    # ワシントン      名詞,固有名詞,地域,一般,*,*,ワシントン,ワシントン,ワシントン
    # で      助詞,格助詞,一般,*,*,*,で,デ,デ
    # 大規模  名詞,一般,*,*,*,*,大規模,ダイキボ,ダイキボ
    # 軍事パレード    名詞,固有名詞,一般,*,*,*,軍事パレード,グンジパレード,グンジパレード
    # を      助詞,格助詞,一般,*,*,*,を,ヲ,ヲ
    # 指示    名詞,サ変接続,*,*,*,*,指示,シジ,シジ
    #         BOS/EOS,*,*,*,*,*,*,*,*
    # »

AUTHOR
======

titsuki <titsuki@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2016 titsuki

libmecab ( http://taku910.github.io/mecab/ ) by Taku Kudo is licensed under the GPL, LGPL or BSD Licenses.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

