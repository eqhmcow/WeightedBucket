#!/usr/bin/perl -w
use strict;
use warnings;

# Test file for WeightedBucket

use WeightedBucket;

my @yells = (
    {
        'quote' => 'SOMETHING BAD',
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
);

print WeightedBucket::random_weighted_quote(@yells), "\n";

