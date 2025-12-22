ink 1.1.1.}
@{" Catprop's methods " Link 1.1.2.}
@ENDNODE

@NODE 1.1.1. "Catprop's attributes"
(  8)   flag:LONG

The flag holds information detailing whether the instance is
Universal or Particular, and whether the instance is
Affirmative or Negative.  From these values we can determine
what kind of Categorical Proposition we're dealing with.

At the moment, it also holds whether or not the
subject/predicate is a non-type (that is, 'non-cats'
as opposed to 'cats').

( 12)   sub:LONG

This holds the subject for the proposition.

( 16)   pred:LONG

This holds the predicate for the proposition.

@ENDNODE

@NODE 1.1.2. "Catprop's methods"
        notSubject()

This will change the subject so it is a non- statement.

        notPredicate()

This will change the predicate so it is a non- statement.

        subject(a)

This changes the subject to 'a'.

        predicate(a)

This changes the predicate to 'a'.

        subpred(a,b)

This changes the subject to 'a' and the predicate to 'b'.

        beUniversal()

This makes the statement a Universal statement (All, No).

        beParticular()

This makes the statement a Particular statement (Some).

        beAffirmative()

This makes the statement an Affirmative statement (All,
are).

        beNegative()

Th