# mastermind
A version of the classic game, Mastermind. It could be used to practice techniques, or watch how a computer algorithm breaks the code. 

The cpu mode will guess any code with 5 guesses or less.
It works by first getting absolute data:

1st guess: 1122
2nd guess: 3344
3rd guess: 5566

This results in being able to separate the left(odd) and right(even) sides into solved or unsolved status.
If both even numbers were on the left side, the even side will be yellow (it will know the numbers) but not the order.
Worst case scenario, it flips those numbers on the 5th guess.
