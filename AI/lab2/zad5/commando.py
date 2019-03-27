import sys
import os
import heapq
from lib.tree import Tree
import random
from lib.node import Node

#import numpy as np


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

    inp = []
    for line in f.readlines():
        inp.append(line.strip())
    res = sokoban_bfs(board(inp, heuristic=heuristic))
    fout = open(fout, 'w')  
    fout.write(retrace_history(res[0], res[1], res[2], res[3]))
    fout.close()
    f.close()  

def heuristic(board):
    s = []
    max = 0
    for pos in board.player:
        r = board.player[pos]
        if r > max:
            max = r
    return max*4


def bfs_len(board, pos):
    queue = []
    heapq.heappush(queue, mapper((pos[0], pos[1]), 0))
    res = []
    while(len(queue) > 0):
        p = heapq.heappop(queue)
        pop = p.value
        pr = p.key

        board.map[pop[0]][pop[1]] = '+'
        for fin in board.finish:     
            if pop[0] == fin[0] and pop[1] == fin[1]:
                res.append(pr)
                break

        if board.map[pop[0]+1][pop[1]] == ' ':
            heapq.heappush(queue, mapper((pop[0]+1,pop[1]), pr+1))

        if board.map[pop[0]-1][pop[1]] == ' ':
            heapq.heappush(queue, mapper((pop[0]-1,pop[1]), pr+1))
        
        if board.map[pop[0]][pop[1]+1] == ' ':
            heapq.heappush(queue, mapper((pop[0],pop[1]+1), pr+1))

        if board.map[pop[0]][pop[1]-1] == ' ':
            heapq.heappush(queue, mapper((pop[0],pop[1]-1), pr+1))
    return res

class board:
    map = []
    player = {}
    finish = []
    mX = 0
    mY = 0
    cnt = 1000

    def __init__(self, input, heuristic=None):
        self.mX = len(input)
        self.mY = len(input[0])
        self.heuristic = heuristic
        
        for i in range(self.mX):
            tmp = []
            for j in range(self.mY):
                if input[i][j] == '#':
                    tmp.append('#')
                else:
                    tmp.append(' ')
                if input[i][j] == 'S':                    
                    self.player[(i,j)] = -1
                elif input[i][j] == 'G':
                    self.finish.append([i,j])
                elif input[i][j] == 'B':
                    self.finish.append([i,j])
                    self.player[(i,j)] = -1                    
                
            self.map.append(tmp)

        for pos in self.player:
            self.clear_board()
            res = bfs_len(self, pos)
            self.player[pos] = min(res)
            

    def save_state(self):
        return [(pos, self.player[pos]) for pos in self.player]

    def load_state(self, save):
        self.player.clear()
        for pos, dist in save:
            self.player[pos] = dist

    def check_condition(self):
        for val in self.player:
            tmp = False
            for j in range(len(self.finish)):
                if self.eq(val, self.finish[j]):
                    tmp = True
                    break
            if tmp == False:
                return False
        return True    

    def draw_board(self):
        for pos in self.player:
            self.map[pos[0]][pos[1]] = 'S'


    def possible_moves(self):
        return ['L', 'R', 'D', 'U']

    def eq(self, f,s):
        return (f[0] == s[0]) and (f[1] == s[1])

    def clear_board(self):
        for i in range(len(self.map)):
            for j in range(len(self.map[i])):
                if self.map[i][j] == '+':
                    self.map[i][j] = ' '


    def make_move(self, move):
        tmp = {}

        if move == 'L':
            for i in self.player:
                pair = (i[0], i[1])
                Npair = (i[0], i[1]-1)

                if self.map[Npair[0]][Npair[1]] != '#':
                    
                    if Npair in tmp:
                        if self.player[pair] < tmp[Npair]:
                            tmp[Npair] = self.player[pair]
                    else:
                        tmp[Npair] = self.player[pair]
                else:
                    if pair in tmp:
                        if self.player[pair] < tmp[pair]:
                            tmp[pair] = self.player[pair]
                    else:
                        tmp[pair] = self.player[pair]                    

        elif move == 'R':       
            for i in self.player:
                pair = (i[0], i[1])
                Npair = (i[0], i[1]+1)
                if self.map[Npair[0]][Npair[1]] != '#':
                    
                    if Npair in tmp:
                        if self.player[pair] < tmp[Npair]:
                            tmp[Npair] = self.player[pair]
                    else:
                        tmp[Npair] = self.player[pair]
                else:
                    if pair in tmp:
                        if self.player[pair] < tmp[pair]:
                            tmp[pair] = self.player[pair]
                    else:
                        tmp[pair] = self.player[pair]   

        elif move == 'D':
            for i in self.player:
                pair = (i[0], i[1])
                Npair = (i[0]+1, i[1])
                if self.map[Npair[0]][Npair[1]] != '#':
                    
                    if Npair in tmp:
                        if self.player[pair] < tmp[Npair]:
                            tmp[Npair] = self.player[pair]
                    else:
                        tmp[Npair] = self.player[pair]
                else:
                    if pair in tmp:
                        if self.player[pair] < tmp[pair]:
                            tmp[pair] = self.player[pair]
                    else:
                        tmp[pair] = self.player[pair]   
        elif move == 'U':
            for i in self.player:
                pair = (i[0], i[1])
                Npair = (i[0]-1, i[1])
                if self.map[Npair[0]][Npair[1]] != '#':
                    
                    if Npair in tmp:
                        if self.player[pair] < tmp[Npair]:
                            tmp[Npair] = self.player[pair]
                    else:
                        tmp[Npair] = self.player[pair]
                else:
                    if pair in tmp:
                        if self.player[pair] < tmp[pair]:
                            tmp[pair] = self.player[pair]
                    else:
                        tmp[pair] = self.player[pair]   

        self.player = tmp
        

    def get_priority(self):
        self.cnt += 1        
        if self.heuristic == None:
            return self.cnt
        else: return self.heuristic(self)

    def greedy_value(self):
        return len(self.player)

def create_node(id, val, tag=""):
    return Node(tag=tag, identifier=id, expanded=False, data=val)

def id_map(board):
    return (str(board.player)).replace(' ', '')

class mapper:
    def __init__(self, id, value):
        self.key = value
        self.value = id

    def __cmp__(self, other):
        return self.key == other.key
    def __lt__(self, other):
        return self.key < other.key

def sokoban_bfs(board):


    tree = Tree()
    heap = []
    _root = id_map(board)
    tree.add_node(create_node(_root, (board.save_state(), ''), tag="kek"))
    heapq.heappush(heap, mapper(_root, 0))    
    bDepth = 0
    while(len(heap) > 0):

        
        if tree.depth() > bDepth:
            #print(tree.depth())
            print(len(board.player))
            bDepth = tree.depth()
        

        n = heapq.heappop(heap)
        node = tree[n.value]
        k = n.key

        board.load_state(node.data[0])
        moves = board.possible_moves()

        for i in range(len(moves)):

            board.load_state(node.data[0])
            board.make_move(moves[i])

            id = id_map(board)
            if tree.contains(id):
                continue

            tree.add_node(create_node(id, (board.save_state(), moves[i])), node.identifier)
            heapq.heappush(heap, mapper(id, board.get_priority() + k+1))
                    
            if board.check_condition() == True:
                return (tree, id, board, _root)                                         

    print('no solution!')
    exit()

def retrace_history(tree, id, board, root):
    node = tree[id]
    hist = ''
    
    if node.data == None:
        return hist

    while(True):
        hist += node.data[1]
        if node.identifier == root:
            print("moves:", len(hist))
            return hist[::-1]     
        node = tree.parent(node.identifier)

if __name__ == "__main__":
   main(sys.argv[1:])