#!/usr/bin/perl -w
use strict;
use warnings;

# Test file for WeightedBucket

use WeightedBucket;
$WeightedBucket::DEBUG = 1;

my @yells = (
    {
        'quote' => 'SOMETHING VERY VERY BAD',
        'score' => -3,
    },
    {
        'quote' => 'SOMETHING ELSE VERY VERY BAD',
        'score' => -3,
    },
    {
        'quote' => 'SOMETHING VERY BAD',
        'score' => -2,
    },
    {
        'quote' => 'SOMETHING BAD',
        'score' => -1,
    },
    {
        'quote' => 'SOMETHING ELSE BAD',
        'score' => -1,
    },
    {
        'quote' => 'SOMETHING OK',
        'score' => 0,
    },
    {
        'quote' => 'SOMETHING GOOD',
        'score' => 1,
    },
    {
        'quote' => 'SOMETHING VERY GOOD',
        'score' => 2,
    },
);

print WeightedBucket::random_weighted_quote(@yells), "\n";

