#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#if
x = int(input("Please enter an integer: "))
if x < 0:
     x = 0
     print('Negative changed to zero')
elif x == 0:
     print('Zero')
elif x == 1:
     print('Single')
else:
     print('More')

#for
words = ['cat', 'window', 'defenestrate']
for w in words:
    print(w, len(w))

for n in range(2, 10):
     for x in range(2, n):
         if n % x == 0:
             print(n, 'equals', x, '*', n//x)
             break
     else:
         # loop fell through without finding a factor
         print(n, 'is a prime number')

for num in range(2, 10):
     if num % 2 == 0:
         print("Found an even number", num)
         continue
     print("Found a number", num)

def fib(n):    # write Fibonacci series up to n
     """Print a Fibonacci series up to n."""
     a, b = 0, 1
     while a < n:
         print(a, end=' ')
         a, b = b, a+b
     print()
fib(100)

# def f(a, L=[]):
#     L.append(a)
#     return L

# If you don’t want the default to be shared between subsequent calls,
# you can write the function like this instead:

def f(a, L=None):
    if L is None:
        L = []
    L.append(a)
    return L

print(f(1))
print(f(2))
print(f(3))