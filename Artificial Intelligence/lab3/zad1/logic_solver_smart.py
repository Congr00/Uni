import math, random
import sys, getopt
import numpy as np
import os

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
         if j == 0:
            fout.write('.')
         else:
            fout.write('#')
      fout.write('\n')
   
   fout.close()
   f.close()  

def and_product(states):
    res = states[0]
    for i in range(1, len(states)):
        for k in range(0, len(res)):
            if states[i][k] == 1 and res[k] == 1: res[k] = 1
            else: res[k] = 0
    return res

def draw_state(starting, state, val):
    res = starting.copy()
    for i in range(len(state)):
        for j in range(0, val[i]):
            res[state[i]+j] = 1
    return res
        
def ok_state(line, valX):
    i = 0
    for i in range(len(line)):
        if line[i] == 1:
            break
    for val in valX:
        cnt = 0      
        for b in line[i:]:
            if b == 1: cnt += 1
            else: break
        for i in range(i + cnt+1,len(line)):
            if line[i] == 1:
                break

        if cnt != val: return False
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
    # move last blocks first
    while(i >= 0): 
        #print(starts, valX, line)
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

        

# [#.###]
# [#.##.]
# [#..##]
# [.#.##]

def solver(valX, valY, X, Y):
    board = np.zeros([X,Y], dtype=int)
    t = 0
    s = board.sum()
    #'''
    while(True):
        statesX = []
        statesY = []
        
        for i in range(X):
            statesX.append(and_product(list(filter(
                lambda y: ok_state(y, valX[i]),
                map(
                    lambda x: draw_state(board[i,:], x, valX[i]),
                    possible_states(board[i,:], valX[i])
                )
            ))))
             
        for i in range(Y):
            statesY.append(and_product(list(filter(
                lambda y: ok_state(y, valY[i]),
                map(
                    lambda x: draw_state(board[:,i], x, valY[i]),
                    possible_states(board[:,i], valY[i])
                )
            ))))
        #print(statesY, '\n', statesX)
        for i in range(X):
            for k in range(X):
                if statesX[i][k] == 1: board[i,k] = 1

        for i in range(Y):
            for k in range(Y):
                if statesY[i][k] == 1: board[k][i] = 1
        ns = board.sum()
        if ns == s: break
        s = ns
        '''
        j = 1
        
        st = possible_states(board[j,:], valX[j])
        tmp = []
        print(board, "\n")
        for s in st:
            print(s, board[j,:])
            d = draw_state(board[j,:], s, valX[j]) 
            print(d)
            if ok_state(d, valX[j]):
                tmp.append(d)
                print('OK')

        print('?', valX[j])
        print(and_product(tmp))
        print(statesX[j])
        break
        #
        #
        #
        #TODO odrzucic stan jako niepoprawny jesli po wstawieniu go na boarda warunki nie sa spelnione(valX/Y)
        #
        #
        #
        '''
        '''
        st = possible_states(np.zeros(Y), valY[j])
        tmp = []
    
        for s in st: 
            tmp.append(draw_state(np.zeros(Y), s, valY[j]))
            #print(draw_state(np.zeros(Y, dtype=int), s, valY[j]))
        print('?', valY[j])
        print(and_product(tmp))#
        '''        
    return board
'''
    k = 0
    states = possible_states(np.zeros(X), valX[k])

    draw_states = []
    for state in states: 
        #print(state)
        #print(draw_state(np.zeros(X, dtype=int), state, valX[k]))
        drawn = draw_state(np.zeros(X, dtype=int), state, valX[k])
        if ok_state(drawn, valX[k]): draw_states.append(drawn)
    print("res : ", draw_states)
    print(and_product(draw_states))
'''



if __name__ == "__main__":
   main(sys.argv[1:])