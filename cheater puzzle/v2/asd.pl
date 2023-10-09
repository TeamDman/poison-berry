% Statement of A: C won't cheat unless B cheated
statement_a(Cheaters) :- \+ member(c, Cheaters); member(b, Cheaters).

% Statement of B: Either A or B cheated
statement_b(Cheaters) :- member(a, Cheaters); member(b, Cheaters).

% Statement of C: B didn't cheat, I cheated
statement_c(Cheaters) :- \+ member(b, Cheaters), member(c, Cheaters).

% Statement of D: B cheated
statement_d(Cheaters) :- member(b, Cheaters).

% Only one person is lying
one_liar(Liar, Cheaters) :-
    findall(S, (member(S, [a, b, c, d]), 
               atom_concat('statement_', S, Pred), 
               Term =.. [Pred, Cheaters], 
               \+ call(Term)), Liars),
    length(Liars, N),
    N =:= 1,
    Liars = [Liar].

% Finding the solution based on multiple-choice options
solution(Liar, Cheater) :-
    findall(X, member(X, [a, b, c, d]), AllSuspects),
    ordered_subset(Cheaters, AllSuspects),
    one_liar(Liar, Cheaters),
    % Multiple-choice filter
    member((Liar, Cheater), [(c, b), (b, b), (a, c), (d, c)]),
    member(Cheater, Cheaters),
    !.

% Ordered subset helper function
ordered_subset([], _).
ordered_subset([E|A], B) :-
    select(E, B, B1),
    ordered_subset(A, B1).
