"-------------------------------------------------------------"
"Random Class - Generate a random number.  Some investigation "
"               will have to be done to see just how random it"
"               really is!                                    "
"-------------------------------------------------------------"

Class Random :Object
! seed !
[
   new
      seed <- 1
|
   randomize
      seed <- <primitive 161>
|
   first
      ^ <primitive 32 (seed <- <primitive 35 seed >) >
|
   next
      ^ <primitive 32 (seed <- <primitive 35 seed >) >
|
   between: low and: high
      ^ (self next * (high - low)) + low
|
   randInteger: limit
      ^ (self next * limit) truncated + 1
|
   next: n    ! newa !
      newa <- Array new: n.
      (1 to: n) do: [:x | newa at: x put: self next].
      ^ newa
]
