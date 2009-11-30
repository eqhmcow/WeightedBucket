package WeightedBucket;
use strict;
use warnings;

use List::Util;

# This is example code
# see the test file for usage
our $DEBUG = 0;
sub random_weighted_quote
{
    my $buckets_hashref = bucketize(@_);

    my $bucket_arrayref = random_weighted_bucket($buckets_hashref,
        map_buckets($buckets_hashref, weigh_buckets($buckets_hashref)));

    return $bucket_arrayref->[rand @{$bucket_arrayref}];    
}

# put items in buckets by score; scores >= 0 go in the same bucket
sub bucketize
{
    my %buckets;
    push @{$buckets{$_->{'score'} >= 0 ? 0 : $_->{'score'}}},
        $_->{'quote'} foreach @_;
    if ($DEBUG) {
        require Data::Dumper;
        print "Bucketized data:\n";
        print Data::Dumper::Dumper(\%buckets);
    }
    return \%buckets;
}

# weight = number of entries * normalized score
sub weigh_buckets
{
    my $buckets_hashref = shift;
    my $lowest_score = List::Util::min(keys %$buckets_hashref);
    if ($lowest_score > 0) {
        $lowest_score = 0;
    }
    my %weights;
    foreach my $bucket (keys %$buckets_hashref) {
        $weights{$bucket} = @{$buckets_hashref->{$bucket}} *
            (abs($lowest_score) - abs($bucket >= 0 ? 0 : $bucket) + 1);
    }
    if ($DEBUG) {
        require Data::Dumper;
        print "Weighed bucket data:\n";
        print Data::Dumper::Dumper(\%weights);
    }
    return \%weights;
}

# map buckets to ranges of real numbers
sub map_buckets
{
    my ($buckets_hashref, $bucket_weights_hashref) = @_;
    my $total_weight = List::Util::sum(values %$bucket_weights_hashref);

    my %bucket_mapping;
    my $current_weight = 0;
    foreach my $bucket (keys %$buckets_hashref) {
        $bucket_mapping{$bucket}{'min'} = $current_weight / $total_weight;
        $current_weight += $bucket_weights_hashref->{$bucket};
        $bucket_mapping{$bucket}{'max'} = $current_weight / $total_weight;
    }
    if ($DEBUG) {
        require Data::Dumper;
        print "Bucket mapping data:\n";
        print Data::Dumper::Dumper(\%bucket_mapping);
    }
    return \%bucket_mapping;
}

sub random_weighted_bucket
{
    my ($buckets_hashref, $bucket_mapping_hashref) = @_;

    my $random_float = rand;
    foreach my $bucket (keys %$buckets_hashref) {
        if ($DEBUG) {
            require Data::Dumper;
            print "Testing $random_float against:\n";
            print Data::Dumper::Dumper($bucket_mapping_hashref->{$bucket});
        }
        return $buckets_hashref->{$bucket}
            if $bucket_mapping_hashref->{$bucket}{'min'} <= $random_float and
                $random_float < $bucket_mapping_hashref->{$bucket}{'max'};
    }

    require Data::Dumper;
    die "Should have found a match for $random_float in " .
        Data::Dumper::Dumper($bucket_mapping_hashref);
}

1;
