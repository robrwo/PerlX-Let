package PerlX::Let;

# ABSTRACT: Syntactic sugar for lexical constants

use v5.12;

use strict;
use warnings;

use Const::Fast ();
use Keyword::Simple;
use Text::Balanced ();

our $VERSION = 'v0.0.2';

=head1 SYNOPSIS

  use PerlX::Let;

  let $val = "key" {

    if ( $a->($val} > $b->{$val} ) {

      something( $val );

    }

  }

=head1 DESCRIPTION

The code

  let $var = "thing" { ... }

is shorthand for

  {
     use Const::Fast;
     const my $var => "thing";

     ...
  }

=cut

sub import {
    Keyword::Simple::define 'let', \&_rewrite_let;
}

sub unimport {
    Keyword::Simple::undefine 'let';
}

sub _rewrite_let {
    my ($ref) = @_;

    my ( $name, $val, $code );

    ( $name, $$ref ) = Text::Balanced::extract_variable($$ref);
    $$ref =~ s/^\s*\=>?\s*// or die;
    ( $val, $$ref ) = Text::Balanced::extract_quotelike($$ref);
    ( $val, $$ref ) = Text::Balanced::extract_bracketed($$ref)
      unless defined $val;

    unless ( defined $val ) {
        ($val) = $$ref =~ /^(\S+)/;
        $$ref =~ s/^\S+//;
    }

    ( $code, $$ref ) = Text::Balanced::extract_codeblock( $$ref, '{' );

    my $let = "Const::Fast::const my $name => $val;";

    if ($code) {
        substr( $code, index( $code, '{' ) + 1, 0 ) = $let;
        substr( $$ref, 0, 0 ) = $code;
    }
    else {
        substr( $$ref, 0, 0 ) = $let;
    }

}

=head1 KNOWN ISSUES

This is an experimental version.

The parsing of assignments is rudimentary, and may fail when assigning
to another variable or the result of a function.

=head1 SEE ALSO

L<Keyword::Simple>

=cut


1;
