use Test;
use MeCab;
use MeCab::Lattice;
use MeCab::Tagger;
use MeCab::Model;


subtest {
    my MeCab::Model $model .= new;

    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    if $tagger.parse($lattice) {
        is $lattice.size, 0;
    }
}, "Given an empty sentence, then MeCab::Lattice.size should return 0";

subtest {
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    $lattice.sentence("シジル");
    is $lattice.sentence, "シジル";
}, "Given a text with setter method, then MeCab::Lattice.sentence should return the same text";

subtest {
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice .= new;
    $lattice.sentence("シジル");
    $lattice.clear;
    nok $lattice.sentence.defined;
}, "MeCab::Lattice.clear should clear the contents";

subtest {
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    $lattice.sentence("見ざる、聞かざる、言わざる");
    if $tagger.parse($lattice) {
        is $lattice.is-available, True;
    }
}, "Given a fulfilled MeCab::Lattice instance, then MeCab::Lattice.is-available should return True";

subtest {
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    $lattice.sentence("見ざる、聞かざる、言わざる");
    if $tagger.parse($lattice) {
        is $lattice.bos-node.surface, '';
        is $lattice.bos-node.feature, "BOS/EOS,*,*,*,*,*,*,*,*";
        is $lattice.bos-node.isbest, True;
        is $lattice.bos-node.stat, MECAB_BOS_NODE;
    }
}, "Given a fulfilled MeCab::Lattice instance, then MeCab::Lattice.bos-node should return a defined MeCab::Node";

subtest {
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    $lattice.sentence("見ざる、聞かざる、言わざる");
    if $tagger.parse($lattice) {
        is $lattice.eos-node.surface, '';
        is $lattice.eos-node.feature, "BOS/EOS,*,*,*,*,*,*,*,*";
        is $lattice.eos-node.isbest, True;
        is $lattice.eos-node.stat, MECAB_EOS_NODE;
    }
}, "Given a fulfilled MeCab::Lattice instance, then MeCab::Lattice.eos-node should return a defined MeCab::Node";

subtest {
    my MeCab::Model $model .= new;
    my @texts = (("私","僕") xx 3).flat;

    my @actual = (@texts.hyper(:batch(1))\
                  .map(
                         {
                             my MeCab::Tagger $tagger = $model.create-tagger;
                             my MeCab::Lattice $lattice = $model.create-lattice;
                             $lattice.sentence($_);
                             $lattice.tostr if $tagger.parse($lattice);
                             $tagger.DESTROY;
                             $lattice.DESTROY;
                         }
                     ).list);
    
    my Str $r1 = ("私\t名詞,代名詞,一般,*,*,*,私,ワタシ,ワタシ\nEOS\n");
    my Str $r2 = ("僕\t名詞,代名詞,一般,*,*,*,僕,ボク,ボク\nEOS\n");
    my @expected = (($r1, $r2) xx 3).flat;
    is @actual, @expected;
}, "MeCab::Tagger should work in the multithread environment";

{
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    $lattice.request-type(MECAB_ONE_BEST);
    is $lattice.request-type, MECAB_ONE_BEST;
}

{
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    is $lattice.has-constraint, False;
    $lattice.boundary-constraint(0, MECAB_ANY_BOUNDARY);
    is $lattice.has-constraint, True;
}

{
    my MeCab::Model $model .= new;
    my MeCab::Tagger $tagger = $model.create-tagger;
    my MeCab::Lattice $lattice = $model.create-lattice;
    $lattice.boundary-constraint(0, MECAB_ANY_BOUNDARY);
    is $lattice.boundary-constraint(0), MECAB_ANY_BOUNDARY;
}

done-testing;
