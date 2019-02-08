package PerlX::Let;

use v5.12;

use strict;
use warnings;

use Const::Fast ();
use Keyword::Simple;
use Text::Balanced ();

sub import {
    # create keyword 'provided', expand it to 'if' at parse time
    Keyword::Simple::define 'let', sub {
        my ($ref) = @_;

        my ( $name, $val, $code );

        ( $name, $$ref ) = Text::Balanced::extract_variable($$ref);
        $$ref =~ s/^\s*\=>?\s*// or die;
        ( $val, $$ref ) = Text::Balanced::extract_quotelike($$ref);
        ( $val, $$ref ) = Text::Balanced::extract_bracketed($$ref)
            unless defined $val;
        ( $val, $$ref ) = $$ref =~ /(\S+)(.*)/
            unless defined $val;
        ( $code, $$ref ) = Text::Balanced::extract_codeblock( $$ref, '{' );

        my $let = "Const::Fast::const $name => $val;";

        if ($code) {
            substr( $code, index( $code, '{' ) + 1, 0 ) = $let;
            substr( $$ref, 0, 0 ) = $code;
        }
        else {
            substr( $$ref, 0, 0 ) = $let;
        }

    };
}

sub unimport {
    Keyword::Simple::undefine 'let';
}


1;
