#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use File::stat;
use File::Spec;
use File::Slurp;
use Benchmark qw/cmpthese/;
use Time::HiRes qw/gettimeofday time tv_interval/;

use Text::Xslate;

my $xslate = Text::Xslate->new(
    cache_dir => File::Spec->tmpdir,
    cache     => 2,
    path      => ['.'],
);

{ # cache !
    $xslate->render('tiny.tx', {bench => time});
    $xslate->render('large.tx', {bench => time});
}

my $t = stat('tiny.tx');
my $l = stat('large.tx');

printf "perl version: %s(xslate: %s)\nsize of tiny.tx: %s\nsize of large.tx: %s\n",
    $], $Text::Xslate::VERSION, $t->size, $l->size;

{ # how long does render() take?
    my $tiny_t = [gettimeofday];
    $xslate->render('tiny.tx', {bench => time});
    my $tiny_e = tv_interval $tiny_t;

    my $large_t = [gettimeofday];
    $xslate->render('large.tx', {bench => time});
    my $large_e = tv_interval $large_t;

    printf "render  tiny.tx: %f\nrender large.tx: %f\n",
        $tiny_e, $large_e;
}

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

