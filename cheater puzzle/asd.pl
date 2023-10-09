% https://chat.openai.com/c/d349d54c-fb97-4549-958d-8cf97124a85c

% Statement of A: C won't cheat unless B cheated
statement_a :- cheated(c), \+ cheated(b), !, fail.
statement_a.

% Statement of B: Either A or B cheated
statement_b :- cheated(a); cheated(b).

% Statement of C: B didn't cheat, I cheated
statement_c :- \+ cheated(b), cheated(c).

% Statement of D: B cheated
statement_d :- cheated(b).

% Cheater possibilities
cheated(a).
cheated(b).
cheated(c).
cheated(d).

% Only one person is lying
one_liar(X) :-
    findall(S, (member(S, [a, b, c, d]), \+ (atom_concat('statement_', S, Predicate), call(Predicate))), Liars),
    length(Liars, N),
    N =:= 1,
    Liars = [X].

% Finding the solution
solution(Liar, Cheater) :-
    one_liar(Liar),
    findall(S, cheated(S), Cheaters),
    member(Cheater, Cheaters),
    % Multiple-choice filter
    member((Liar, Cheater), [(c, b), (b, b), (a, c), (d, c)]).
