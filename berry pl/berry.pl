:- dynamic memo/4.

% Base case: If only one bowl is left, we've found the poisonous one.
can_identify(1, _, _, [Action]) :- Action = 'Poison is in the only remaining bowl'.

% Base case: If only two bowls and one servant is left, we can also identify the poisonous bowl.
can_identify(2, 1, _, [Action]) :- Action = 'Servant tests one bowl. If they die, the other bowl is poisonous'.

% Base case: If no rounds are left, we can't identify the poisonous bowl.
can_identify(_, _, 0, []) :- !, fail.

% Recursive case: Use memoization to avoid redundant calculations.
can_identify(Bowls, Servants, Rounds, Actions) :-
    memo(Bowls, Servants, Rounds, Actions), !.

% Recursive case: Use the servants to test different combinations of bowls.
can_identify(Bowls, Servants, Rounds, [Action|Actions]) :-
    Bowls > 2,
    Servants > 0,
    Rounds > 0,
    NextRounds is Rounds - 1,
    NextServants is Servants - 1,
    MaxGroup is Bowls // Servants,
    between(1, MaxGroup, N),
    RemainingBowls is Bowls - N,
    Action = ['Servant tests bowls 1 to ', N, '. Remaining bowls: ', RemainingBowls],
    (can_identify(N, NextServants, NextRounds, Actions);
     can_identify(RemainingBowls, Servants, NextRounds, Actions)),
    assertz(memo(Bowls, Servants, Rounds, [Action|Actions])).

% Test if we can identify the poisonous bowl within the given rounds
test_identification(Bowls, Rounds) :-
    retractall(memo(_,_,_,_)), % clear previous memoizations
    can_identify(Bowls, 3, Rounds, Actions),
    write('Poisonous bowl can be identified within '), write(Rounds), write(' rounds. Actions: '), write(Actions), nl.
