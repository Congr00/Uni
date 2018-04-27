
%cukier
word --> "".
word --> "a", word, "b".

word_d --> "".
word_d --> "a", word_d, "b",!.

word_c(0) --> [].
word_c(X) --> [a], word_c(Y), {X is Y + 1}, [b], !.

test --> [].
test --> [a], test.
