package Acme::SafetyGoggles;

use warnings;
use strict;
use Carp;
use Filter::Simple;
FILTER {
  # use File::Slurp;
  my ($pkg, $file, $line) = caller(1); # caller(0) is Filter::Simple

  # print STDERR "caller is $pkg / $file / $line\n";

  if ($file eq '-e') {
    carp "Acme::SafetyGoggles cannot protect against code in an '-e' construction";
    return;
  }

  my $vh;
  unless (open $vh, '<', $file) {
    carp "Acme::SafetyGoggles: failed to open original source file $file! $!\n";
    return;
  }
  my $original = join '',<$vh>;
  close $vh;

  open my $wh, '>', './safety0';
  print $wh $original;
  close $wh;
  system qq[grep -v "use Acme::SafetyGoggles" safety0  > safety1];

  open my $xh, '>', './safety0';
  print $xh $_;
  close $xh;
  system qq[grep -v "use Acme::SafetyGoggles" safety0  > safety2];

  my @diff = `diff safety1 safety2`;
  if (@diff) {
    carp "Code in $file has been source filtered!:\n", @diff, "===\n";
  }
  unlink './safety0','./safety1','./safety2';
};

=head1 NAME

Acme::SafetyGoggles - Protects programmer's eyes 
from dangerous use of power tools like source filtering.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use Some::Module::That::Might::Use::Source::Filtering;
    use Acme::SafetyGoggles;

    $ perl -MAcme::SafetyGoggles possibly_dangerous_script.pl 

=head1 DESCRIPTION

Is some module you imported using source filtering? If the
answer is yes, or if the answer is "I don't know", then
you can't trust the code in front of your own eyes! 

That's why you should always use patent-pending 
C<Acme::SafetyGoggles> in your untrusted Perl code. 
C<Acme::SafetyGoggles> compares your original source file
with the code that is actually going to be run, and
alerts you to any differences. 

=head1 SUBROUTINES/METHODS

None.

=head1 BUGS

Relies on system tools C<grep> and C<diff>. If you don't have
those tools, then this module will fail spectacularly.

This version of C<Acme::SafetyGoggles> flags source files with
the C<__END__> token.

C<Acme::SafetyGoggles> can only (maybe) protect you from
source filtering. It is not designed or warranted to 
protect you from improper use of any other potentially
dangerous or evil Perl construction.

Please report any other bugs or feature requests to 
C<bug-acme-safetygoggles at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Acme-SafetyGoggles>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 AUTHOR

Marty O'Brien, C<< <mob at cpan.org> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Acme::SafetyGoggles


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Acme-SafetyGoggles>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Acme-SafetyGoggles>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Acme-SafetyGoggles>

=item * Search CPAN

L<http://search.cpan.org/dist/Acme-SafetyGoggles/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Marty O'Brien.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut





1; # End of Acme::SafetyGoggles
