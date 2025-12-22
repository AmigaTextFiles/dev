% prolog reverse

UNSW - PROLOG
: trace revzap!
: rev([1,2,3], X)?
C|>revzap([1, 2, 3], [], _0)
C||>revzap([2, 3], [1], _0)
C|||>revzap([3], [2, 1], _0)
C||||>revzap([], [3, 2, 1], [3, 2, 1])
E||||<revzap([], [3, 2, 1], [3, 2, 1])
E|||<revzap([3], [2, 1], [3, 2, 1])
E||<revzap([2, 3], [1], [3, 2, 1])
E|<revzap([1, 2, 3], [], [3, 2, 1])

X = [3, 2, 1]
