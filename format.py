#!/usr/bin/env python

"""
ex: enter this
    00000000
    00000000
    00100202
    00202101
    12112121
    12121222
and it prints a JSON repr
"""

from sys import stdin

lines = stdin.readlines()
print '['
for line in lines:
    print '[',
    for char in line.strip():
        print "{}, ".format(char),
    print '],'
print ']'