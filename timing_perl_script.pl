#!/usr/bin/perl
open(F, "design_metrics.csv") or die "Cannot open file";

<F>;  # Skip header
$count = 0;

while (<F>) {
    chomp;
    ($module, $setup, $hold, $area, $power) = split(/,/);

    if ($setup > 0.50 || $hold < 0.05) {
        print "$module: ";

        if ($setup > 0.50) {
            print "Setup violation ";
        }

        if ($hold < 0.05) {
            print "Hold violation ";
        }

        print "\n";
        $count++;
    }
}

close(F);
print "Total violations: $count\n";
