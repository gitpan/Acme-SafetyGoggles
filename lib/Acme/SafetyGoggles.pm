package Acme::SafetyGoggles;

use warnings;
use strict;
use Carp;
use Filter::Simple;
use Text::Diff;

$Carp::Internal{'Filter::Simple'}++;

FILTER {
  my ($pkg, $file, $line) = caller(1); # caller(0) is Filter::Simple

  if ($file eq '-e') {
    carp "Acme::SafetyGoggles cannot protect against code in an '-e' construction";
    return;
  }

  my $vh;
  unless (open $vh, '<', $file) {
    carp "Acme::SafetyGoggles: cannot read source file $file ! $!\n";
    return;
  }
  my $original = '';
  while (my $line = <$vh>) {
    last if $line =~ /^__END__$/;
    $original .= $line;
  }
  close $vh;

  my $current = $_;
  my $diff = Text::Diff::diff(\$original, \$current, { STYLE => 'OldStyle' } );
  if ($diff) {
    carp "File $file has been source filtered!\n", $diff, "===\n";
  }
};

=head1 NAME

Acme::SafetyGoggles - Protects programmer's eyes from source filtering

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


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

C<Acme::SafetyGoggles> can only (maybe) protect you from
source filtering. It is not designed or warranted to 
protect you from improper use of any other potentially
dangerous or evil Perl construction.

C<Acme::SafetyGoggles> does not operate on code specified by
perl's C<-e> command line option.

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

Inspired by cpmments on source filtering from stackoverflow.com's Ether:
http://stackoverflow.com/questions/2818155/#2819871

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Marty O'Brien.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut





1; # End of Acme::SafetyGoggles
