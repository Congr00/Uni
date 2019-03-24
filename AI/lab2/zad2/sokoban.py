import math, random
import sys, getopt
import os
from treelib import Tree, Node
import heapq
import numpy as np
import hashlib
import copy

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
    res = sokoban_bfs(board(inp, box_heuristic))
    fout = open(fout, 'w')  
    fout.write(retrace_history(res[0], res[1], res[2], res[3]))
    fout.close()
    f.close()  

def box_heuristic(board):

    sum = 0
    fins = []
    for box in board.boxes:
        for fin in board.finish:
            if box[0] == fin[0] and box[1] == fin[1]:
                fins.append(True)
            else:
                fins.append(False)

    for box in board.boxes:
        lowest = board.mX + board.mY
        for i in range(len(board.finish)):
            if board.eq(board.finish[i], box):
                lowest = 0
                break
            if fins[i] == False:
                dist = abs(board.finish[i][0] - box[0]) + abs(board.finish[i][1] - box[1])
                if dist < lowest:
                    lowest = dist
        sum += lowest
    # *2/3 dla zad2
    # *10e6 dla zad3
    return sum*2

class board:
    map = []
    player = [0,0]
    boxes = []
    finish = []
    mX = 0
    mY = 0
    cnt = 1000
    Hcnt = 0
    Bcnt = 0
    last = None


    def __init__(self, input, heuristic=None):
        self.mX = len(input)
        self.mY = len(input[0])
        self.heuristic = heuristic
        
        for i in range(self.mX):
            tmp = []
            for j in range(self.mY):
                if input[i][j] == 'W':
                    tmp.append('W')
                else:
                    tmp.append('.')
                if input[i][j] == 'K':                    
                    self.player = [i,j]
                elif input[i][j] == 'B':
                    self.boxes.append([i,j])
                elif input[i][j] == 'G':
                    self.finish.append([i,j])
                elif input[i][j] == '*':
                    self.boxes.append([i,j])
                    self.finish.append([i,j])
                elif input[i][j] == '+':
                    self.finish.append([i,j])
                    self.player = [i,j]
            self.map.append(tmp)
            self.Bcnt = (self.mX+self.mY)*len(self.boxes)            

    def save_state(self):
        return [[tuple(box) for box in self.boxes], tuple(self.player)]


    def clear_board(self):
        for box in self.boxes:
            self.map[box[0]][box[1]] = '.'
    def draw_board(self):
        for box in self.boxes:
            self.map[box[0]][box[1]] = 'B'        

    def load_state(self, save):
        for i in range(len(self.boxes)):
            self.boxes[i] = list(save[0][i]) 
        self.player = list(save[1])

        
        

    def check_condition(self):
        for i in range(len(self.boxes)):
            tmp = False
            for j in range(len(self.finish)):
#                print(self.boxes[0], self.finish[0])
                if self.eq(self.boxes[i], self.finish[j]):
                    tmp = True
                    break
            if tmp == False:
                return False
        return True    

    


    def possible_moves(self):
        moves = ''
        # left side
        if self.map[self.player[0]][self.player[1]-1] == '.' :
            moves += "L"
        elif self.map[self.player[0]][self.player[1]-1] == 'B' :
            if self.map[self.player[0]][self.player[1]-2] == '.':
                moves += "L"
        # right side
        if self.map[self.player[0]][self.player[1]+1] == '.' :
            moves += "R"
        elif self.map[self.player[0]][self.player[1]+1] == 'B' :
            if self.map[self.player[0]][self.player[1]+2] == '.':
                moves += "R"                
        # upper side
        if self.map[self.player[0]+1][self.player[1]] == '.' :
            moves += "D"
        elif self.map[self.player[0]+1][self.player[1]] == 'B' :
            if self.map[self.player[0]+2][self.player[1]] == '.':
                moves += "D" 
        # lower side
        if self.map[self.player[0]-1][self.player[1]] == '.' :
            moves += "U"
        elif self.map[self.player[0]-1][self.player[1]] == 'B' :
            if self.map[self.player[0]-2][self.player[1]] == '.':  
                moves += "U"         

        return moves 

    def unmake_move(self):
        return None # if opt is needed

    def eq(self, f,s):
        return (f[0] == s[0]) and (f[1] == s[1])

    def make_move(self, move):
        #self.last =  move
        if move == 'L':
            for i in range(len(self.boxes)):
                if self.eq(self.boxes[i],(self.player[0],self.player[1]-1)):
                    self.map[self.boxes[i][0]][self.boxes[i][1]] = '.'
                    self.boxes[i][1] -= 1
                    break
            self.player[1] -= 1
        elif move == 'R':       
            for i in range(len(self.boxes)):
                if self.eq(self.boxes[i], (self.player[0],self.player[1]+1)):
                    self.map[self.boxes[i][0]][self.boxes[i][1]] = '.'                    
                    self.boxes[i][1] += 1
                    break     
            self.player[1] += 1
        elif move == 'D':
            for i in range(len(self.boxes)):
                if self.eq(self.boxes[i],(self.player[0]+1,self.player[1])):
                    self.map[self.boxes[i][0]][self.boxes[i][1]] = '.'                    
                    self.boxes[i][0] += 1
                    break
            self.player[0] += 1         
        elif move == 'U':
            for i in range(len(self.boxes)):
                if self.eq(self.boxes[i], (self.player[0]-1,self.player[1])):
                    self.map[self.boxes[i][0]][self.boxes[i][1]] = '.'                    
                    self.boxes[i][0] -= 1
                    break
            self.player[0] -= 1             

    def get_priority(self):
        self.cnt += 1        
        if self.heuristic == None:
            return self.cnt
        else: return self.heuristic(self) + self.cnt#*10e6 + self.cnt    

        

def create_node(id, val, tag=""):
    return Node(tag=tag, identifier=id, expanded=False, data=val)

def id_map(board):
    return (str(board.player) + str(board.boxes)).replace(' ', '')

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

    _root = id_map(board)

    tree.add_node(create_node(_root, board.save_state(), tag="kek"))

    if board.check_condition() == True:
        return (tree, _root, board, _root)    
    

    heap = []    
    heapq.heappush(heap, mapper(_root, board.get_priority()))
    depth = 1
    while(len(heap) > 0):
        #if tree.depth() > 8:
        #    print('err')
        #    exit()
        #if tree.depth() > depth:
         
        #    depth = tree.depth()
        #    print(depth) 


        node = tree[heapq.heappop(heap).value]

        board.clear_board()
        board.load_state(node.data)
        board.draw_board()
        moves = board.possible_moves()
        
        for i in range(len(moves)):
            board.clear_board()
            board.load_state(node.data)
            board.draw_board()

            board.make_move(moves[i])

            id = id_map(board)
            if tree.contains(id):
                continue

            tree.add_node(create_node(id, board.save_state()), node.identifier)
            heapq.heappush(heap, mapper(id, board.get_priority()))            
            #'''
            #hist = (retrace_history(tree, id, board, _root))   
            #print(hist)   
            #if hist == "RLD":
                #print(board.possible_moves())
  
            #print(moves, hist)
            #print(tmp, tmp4, tmp2, tmp3, moves[i])
            #    exit()
            #'''
                       
            if board.check_condition() == True:
                return (tree, id,board, _root)


    print('no solution!')
    exit()

def retrace_history(tree, id, board, root):
    node = tree[id]
    hist = ''
    fstate = board.save_state()

    if node.data == None:
        return hist

    board.clear_board()
    board.load_state(node.data)
    node = tree.parent(id)

    while(True):
        pos = board.player
        board.load_state(node.data)
        if board.player[0] < pos[0]:
            hist += 'D'
        elif board.player[0] > pos[0]:
            hist += 'U'
        elif board.player[1] < pos[1]:
            hist += 'R'
        else:
            hist +='L'

        if node.identifier == root:
            board.load_state(fstate)
            print("moves:", len(hist))
            return hist[::-1]            
        node = tree.parent(node.identifier)



if __name__ == "__main__":
   main(sys.argv[1:])