#!/pro/bin/perl

use strict;
use warnings;

our $VERSION = "0.04 - 20191106";

my $fmd  = "Checklist.md";
my $fhtm = "Checklist.html";

my %c = map  { $_ => (stat $_)[9] || 0 } $fmd, $fhtm;
$c{$fmd} && $c{$fhtm} && $c{$fhtm} - $c{$fmd} > 2 and
    die "Did you edit $fhtm instead of $fmd\n";

-d ".git" or exit 0;

my @m = stat $fmd;
my @h = stat $fhtm;

$m[9] && $h[9] && $h[9] >= $m[9] and exit 0;
open my $fh, ">", $fhtm or die "Cannot make $fhtm: $!\n";

print "Converting $fmd to $fhtm\n";

print $fh <<"EOH";
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
  <title>Release Checklist</title>
  </head>
<body>
EOH

my $fhx = $fhtm . "_x";
system "multimarkdown", "-o", $fhx, $fmd;
open my $xh, "<", $fhx or die "multimarkdown failed!\n";
print $fh do { local $/; <$xh>; }
    =~ s{<p><code>(\w+)}{<pre class="$1">}gr
    =~ s{<pre><code class="(\w+)">}{<pre class="$1">\n}gr
    =~ s{<p><code>}{<pre>}gr
    =~ s{<pre><code>}{<pre>}gr
    =~ s{</code></p>}{</pre>}gr
    =~ s{</code></pre>}{</pre>}gr
    =~ s{<pre>\K(?=.)}{\n}gr
    =~ s{<(?:li|p)>\K }{}gr,
    "</body></html>";
close $xh;
close $fh;
unlink $fhx;

my $t = (stat $fmd)[9] + 1;
utime $t, $t, $fhtm;
