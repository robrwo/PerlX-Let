#!perl

use Test::Most;

use PerlX::Let;

let $x = 3;

is $x => 3, 'global';

let $x = 1 {

    is $x => 1, 'scope';

    dies_ok { $x++ } 'read-only';

    let $x = 2 {
        is $x => 2, 'inner scope';
    };

};

for (1..3) {
    let $x = 'string' {
        is $x => 'string', 'in loop';
    }
}


let @x = (1,2),
    %y = ( a => 1, b => 2),
    $z = 3 {

        is $y{a} => $x[0], 'multiple symbols';
        is $y{b} => $x[1];
        is $x[0] + $x[1] => $z;

};

done_testing;
