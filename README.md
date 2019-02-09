# NAME

PerlX::Let - Syntactic sugar for lexical constants

# VERSION

version v0.1.1

# SYNOPSIS

```perl
use PerlX::Let;

let $x = 1,
    $y = "string" {

    if ( ($a->($y} - $x) > ($b->{$y} + $x) )
    {
      something( $y, $x );
    }

}
```

# DESCRIPTION

The code

```
let $var = "thing" { ... }
```

is shorthand for

```perl
{
   use Const::Fast;
   const my $var => "thing";

   ...
}
```

# KNOWN ISSUES

This is an experimental version.

The parsing of assignments is rudimentary, and may fail when assigning
to another variable or the result of a function.

# SEE ALSO

[Keyword::Simple](https://metacpan.org/pod/Keyword::Simple)

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2019 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
