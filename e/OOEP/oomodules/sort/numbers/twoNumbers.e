/*

twoNumbers

Take two objects that consist of numbers, e.g. Complex and Fraction.
Those exist of two numbers, only the methods are a bit different, so why
don't make a class of it and derive those two from it? Well, here you are.

Objects to derive from this:

Fraction
Complex
Line?

*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort/numbers'

OBJECT twoNumbers OF number
PRIVATE
  value1:PTR TO number
  value2:PTR TO number
ENDOBJECT
