#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use File::stat;
use File::Spec;
use File::Slurp;
use Benchmark qw/cmpthese/;

use Text::Xslate;

my $xslate = Text::Xslate->new(
    cache_dir => File::Spec->tmpdir,
    cache     => 2,
    path      => ['.'],
);

print "perl version: $]\n";

my $t = stat('tiny.tx');
my $l = stat('large.tx');

printf "size of tiny.tx: %s\nsize of large.tx: %s\n",
    $t->size, $l->size;

sub tiny {
    $xslate->render('tiny.tx', {bench => time});
}

sub large {
    $xslate->render('large.tx', {bench => time});
}

cmpthese(0,{
    tiny  => \&tiny,
    large => \&large,
});

exit;

