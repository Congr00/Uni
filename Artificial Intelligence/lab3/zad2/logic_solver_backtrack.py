
import sys, getopt
import numpy as np
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

   board = solver(valX, valY, X, Y)
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

def count(it):
    cnt = 0
    for _ in it: cnt += 1

    return cnt

def and_product(states):

    ln = next(states, [])
    if len(ln) == 0: return []
    res = list(map(lambda x: -1 if x == 0 else x, ln))
    for state in states:
        for k in range(0, len(res)):
            if state[k] == 1 and res[k] == 1: res[k] = 1
            elif state[k] == 0 and res[k] == -1: res[k] = -1
            else: res[k] = 0
    return res

def draw_state(starting, state, val):
    res = starting.copy()
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
            states.append(starts.copy())
            i = len(starts)-1
        else: 
            i -= 1
            for j in range(i+1, len(starts)) : starts[j] = starts[j-1] + 1 + valX[j-1]      
        for j in range(i, len(starts)):
            starts[j] += 1

    return states
#np.array(list(filter(lambda x: (x.tolist() not in y), np.argwhere(x == 1))))

def finished(board, valX, valY):
    for l in range(0, board.shape[0]):
        lineX = board[l,:]
        if ok_state(lineX, valX[l]) == False: return False
        lineX = np.array(list(map(lambda x: 0 if x == -1 else x, lineX)))
        if lineX.sum() != np.array(valX[l]).sum(): return False

    for l in range(0, board.shape[1]):
        lineY = board[:, l]
        if ok_state(lineY, valY[l]) == False: return False
        lineY = np.array(list(map(lambda x: 0 if x == -1 else x, lineY)))   
        if lineY.sum() != np.array(valY[l]).sum(): return False    
    return True


def solver(valX, valY, X, Y):
    stateTracker = []
    board = np.zeros([X,Y], dtype=int)

    pStatesX, pStatesY = [], []
    for i in range(X):
        pStatesX.append(possible_states(board[i, :], valX[i]))
    for i in range(Y):
        pStatesY.append(possible_states(board[:, i], valY[i]))
    
    stateTracker.append((board, []))

    while(True):
        
        s = np.abs(board).sum()
        wrong = False
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
                if len(res) == 0: 
                    wrong = True
                    break
                
                statesX.append(res)
            for i in range(Y):
                res = and_product(filter(
                    lambda y:  ok_state(y, valY[i]),
                    map(
                        lambda x: draw_state(board[:,i], x, valY[i]),
                        pStatesY[i]
                    )
                ))
                if len(res) == 0: 
                    wrong = True
                    break
                
                statesY.append(res)
            
            if wrong == True: break
            
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

        print("step: ", s, "states: ", len(stateTracker))

        if finished(board, valX, valY) : break
        # we are stuck so save state and make random shoot
        #TODO?: random -1 or 1
        if wrong == False:
            r = list(filter(lambda x: x.tolist(), np.argwhere((board != -1) & (board != 1))))            
            r = r[random.randint(0, len(r)-1)]
            if len(stateTracker) == 0:
                stateTracker.append((board.copy(), [list(r.tolist())]))
            else:                
                _, prev = stateTracker[-1]
                prev.append(list(r.tolist()))
                stateTracker.append((board.copy(), prev.copy()))
            board[r[0], r[1]] = 1

        # Backtrack time cuz something went wrong
        while(wrong):
            print('backtracking...')
            board, prevShoots = stateTracker.pop()
            
            r = list(filter(lambda x: x.tolist() not in prevShoots, np.argwhere((board != -1) & (board != 1))))
            if len(r) == 0:
                continue
            r = r[random.randint(0, len(r)-1)]
            prevShoots.append(r.tolist())
            stateTracker.append((board.copy(), prevShoots.copy()))
            board[r[0], r[1]] = 1
            wrong = False



    return board



if __name__ == "__main__":
   main(sys.argv[1:])