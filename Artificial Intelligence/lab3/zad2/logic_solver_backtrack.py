
import sys, getopt
import numpy as np
import copy
import os

import random

def main(argv):
   inputfile = 'zad_input.txt'
   outputfile = 'zad_output.txt'

   load_file(inputfile, outputfile)

def load_file(fin, fout):
   f = None

   try: f = open(fin, 'r')
   except:
      print('error while reading file: ' + fin)
      sys.exit(2)

   X,Y = f.readline().split(' ')
   X = int(X)
   Y = int(Y)
   valY = []
   valX = []
   for i in range(0, X):
      valX.append(list(map(lambda x: int(x), f.readline().split(' '))))
   for i in range(0, Y):         
      valY.append(list(map(lambda x: int(x), f.readline().split(' '))))

   board, sX, sY = wrapper(valX, valY, X, Y)
   board = recGuess(board, valX, valY, sX, sY, X, Y, 0, 0)

   fout = open(fout, 'w')   
   for i in board:
      for j in i:
         if j == 0 or j == -1:
            fout.write('.')
         else:
            fout.write('#')
      fout.write('\n')
   
   fout.close()
   f.close()

def and_product(states):

    #ln = next(states, [])
    ln = next(iter(states), [])
    if len(ln) == 0: return []
    res = list(map(lambda x: -1 if x == 0 else x, ln))
    for state in states:
        for k in range(0, len(res)):
            if state[k] == 1 and res[k] == 1: res[k] = 1
            elif state[k] == 0 and res[k] == -1: res[k] = -1
            else: res[k] = 0
    return res

def draw_state(starting, state, val):
    #res = starting.copy()
    res = copy.copy(starting)
    for i in range(len(state)):
        for j in range(0, val[i]):
            if res[state[i]+j] == -1: return []
            res[state[i]+j] = 1
    return res
        
def ok_state(line, valX):
    if len(line) == 0: return False
    i = 0
    for i in range(len(line)):
        if line[i] == 1:
            break
    for v in range(len(valX)):
        cnt = 0      
        for b in line[i:]:
            if b == 1: cnt += 1
            else: break
        if cnt != valX[v]: return False
        if v == len(valX)-1: break                
        for i in range(i + cnt+1,len(line)):
            if line[i] == 1:
                break                
    for i in range(i + cnt+1,len(line)):
        if line[i] == 1: return False         
    return True

def possible_move(starts, valX, size):
    s = valX[0] + starts[0]
    for i in range(1, len(starts)):
        if s > starts[i] - 1: return False
        s += valX[i] + (starts[i] - (starts[i-1] + valX[i-1]))   
    return s <= size

def possible_states(line, valX):
    states = []
    starts = [0]
    for i in range(1, len(valX)):
        starts.append(starts[i-1] + 1 + valX[i-1])      
    i = len(starts)-1
    while(i >= 0): 
        pm = possible_move(starts, valX, len(line))       
        if i == 0 and not pm:
            break
        if pm: 
            #states.append(starts.copy())
            states.append(copy.copy(starts))
            i = len(starts)-1
        else: 
            i -= 1
            for j in range(i+1, len(starts)) : starts[j] = starts[j-1] + 1 + valX[j-1]      
        for j in range(i, len(starts)):
            starts[j] += 1

    return states

def progress(board, valX):
    xsum = 0
    valsum = 0
    for l in range(0, board.shape[0]):
        lineX = board[l,:]
        lineX = np.array(list(map(lambda x: 0 if x == -1 else x, lineX)))
        xsum += lineX.sum() 
        valsum += np.array(valX[l]).sum()
    return xsum * 100 / valsum

def wrapper(valX, valY, X, Y):
    board = np.zeros([X,Y], dtype=int)
    pStatesX, pStatesY = [], []
    for i in range(X):
        pStatesX.append(possible_states(board[i, :], valX[i]))
    for i in range(Y):
        pStatesY.append(possible_states(board[:, i], valY[i]))

    board = solver2(valX, valY, board, pStatesX, pStatesY, X, Y)
    return board, pStatesX, pStatesY    

def findNext(ix, iy, board, X, Y):
    for ix in range(X):
        for iy in range(Y):
            if board[ix, iy] == 0:
                return ix, iy
    return -1, -1 

def recGuess(board, valX, valY, pStatesX, pStatesY, X, Y, ix, iy):
    print('finished: {:0.2f} %'.format(progress(board, valX)))

    ix, iy = findNext(ix, iy, board, X, Y)
    if ix == -1: return board

    board[ix, iy] = 1
    res = solver2(valX, valY, copy.copy(board), pStatesX, pStatesY, X, Y)

    if len(res) != 0:
        res2 = recGuess(copy.copy(res), valX, valY, pStatesX, pStatesY, X, Y, ix, iy)
        if len(res2) != 0: return res2

            
    board[ix][iy] = -1
    res = solver2(valX, valY, copy.copy(board), pStatesX, pStatesY, X, Y)
    if len(res) == 0: return []
    return recGuess(copy.copy(res), valX, valY, pStatesX, pStatesY, X, Y, ix, iy)

# best 1 = 45  pypy: 35
# best 2 = 118 pypy: 58

def solver2(valX, valY, board, pStatesX, pStatesY, X, Y):
    s = np.abs(board).sum()
    while(True):
        statesX, statesY = [], []
        for i in range(X):
            res = and_product(filter(
                lambda y: ok_state(y, valX[i]),
                map(
                    lambda x: draw_state(board[i,:], x, valX[i]),
                    pStatesX[i]
                )
            ))
            if len(res) == 0: return []
            statesX.append(res)

        for i in range(Y):
            res = and_product(filter(
                lambda y:  ok_state(y, valY[i]),
                map(
                    lambda x: draw_state(board[:,i], x, valY[i]),
                    pStatesY[i]
                )
            ))
            if len(res) == 0: return []
            statesY.append(res)

        for i in range(X):
            for k in range(Y):
                if statesX[i][k] == 1: board[i,k] = 1
                elif statesX[i][k] == -1 : board[i,k] = -1
        for i in range(Y):
            for k in range(X):
                if statesY[i][k] == 1: board[k,i] = 1
                elif statesY[i][k] == -1 : board[k,i] = -1          
                    
        ns = np.abs(board).sum()
        if ns == s: break
        s = ns
    return board


if __name__ == "__main__":
   main(sys.argv[1:])