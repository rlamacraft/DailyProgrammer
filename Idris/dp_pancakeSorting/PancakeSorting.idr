module PancakeSorting

import Data.Fin

%default total

||| Modelling a pancake as a natural number (its size)
data Pancake = I | S Pancake

add : Pancake -> Pancake -> Pancake
add I y = S y
add (S x) y = S (add x y)

mult : Pancake -> Pancake -> Pancake
mult I y = y
mult (S x) y = add y $ mult x y

-- anything <1 is rounded to 1
fromInt : Integer -> Pancake
fromInt 1 = I
fromInt n = if (n > 1) then S (fromInt (assert_smaller n (n - 1))) else I

Num Pancake where
  (+) = add
  (*) = mult

  fromInteger = fromInt

Eq Pancake where
  I == I         = True
  (S x) == (S y) = x == y
  _ == _         = False

Ord Pancake where
  compare I I = EQ
  compare I (S y) = LT
  compare (S x) I = GT
  compare (S x) (S y) = compare x y


||| A stack of pancakes, which may or may not be sorted.
data PancakeStack : Nat -> Type where
  Top : PancakeStack Z
  (::) : Pancake -> PancakeStack n -> PancakeStack (S n)

head : PancakeStack (S n) -> Pancake
head (x::xs) = x

reverse : PancakeStack n -> PancakeStack n
reverse Top = Top
reverse stack = helper Top stack where
  helper : PancakeStack n -> PancakeStack m -> PancakeStack (n+m)
  helper {n}         acc Top       = rewrite plusZeroRightNeutral n in acc
  helper {n} {m=S m} acc (x :: xs) = rewrite sym $ plusSuccRightSucc n m
                                       in helper (x::acc) xs

||| Flip the sub-stack above a given index
flip : Fin n -> PancakeStack n -> PancakeStack n
flip FZ stack = reverse stack
flip (FS x) (this :: y) = this :: (flip x y)

flipProof : (3::4::5::Top) = flip 1 (3::5::4::Top)
flipProof = Refl

||| Find the largest pancake in the stack
indexOfLargestPancake : PancakeStack (S m) -> Fin (S m)
indexOfLargestPancake stack = findKnownPancake stack $ largestPancake stack (head stack) where

  largestPancake : PancakeStack n -> Pancake -> Pancake
  largestPancake Top largest = largest
  largestPancake (x::xs) largest = if x > largest then largestPancake xs x else largestPancake xs largest

  largestPancakeProof : 5 = largestPancake (3::4::5::Top) 3
  largestPancakeProof = Refl

  ||| Given a stack and a pancake we know to be in the stack, where is it?
  findKnownPancake : PancakeStack (S m) -> Pancake -> Fin (S m)
  findKnownPancake (x :: Top) p = FZ
  findKnownPancake (x :: xs :: xss) p = if p == x then FZ else FS (findKnownPancake (xs :: xss) p)

  findKnownTest : (the (Fin 3) (FS FZ)) = (findKnownPancake (3::5::4::Top) 5)
  findKnownTest = Refl

indexOfLargestPancakeTest : (the (Fin 3) (FS (FS FZ))) = (indexOfLargestPancake (3::4::5::Top))
indexOfLargestPancakeTest = Refl

indexOfLargestPancakeTest2 : the (Fin 3) (FS FZ) = indexOfLargestPancake (3::5::4::Top)
indexOfLargestPancakeTest2 = Refl

||| Flip the pile at the largest item to move it to the top, and then flip the whole pile to move it to the bottom
largestAtBottom : PancakeStack (S n) -> PancakeStack (S n)
largestAtBottom stack = flip 0 $ flip (indexOfLargestPancake stack) stack

largestAtBottomTest : (5::3::4::Top) = largestAtBottom (4::5::3::Top)
largestAtBottomTest = Refl

||| Move the largest pancake to the bottom, repeat recursively on the rest
pancakeSort : PancakeStack (S n) -> PancakeStack (S n)
pancakeSort (x :: Top) = (x :: Top)
pancakeSort (x :: xs :: xss) = let
  (largest :: rest) = largestAtBottom (x :: xs :: xss)
  in
  largest :: (pancakeSort rest)

pancakeSortTest : (9::7::6::3::1::Top) = pancakeSort (3::9::6::1::7::Top)
pancakeSortTest = Refl
