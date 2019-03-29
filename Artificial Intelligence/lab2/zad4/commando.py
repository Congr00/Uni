import sys
import os
import heapq
from lib.tree import Tree
import random
from lib.node import Node



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
    res = sokoban_bfs(board(inp, None))
    fout = open(fout, 'w')  
    fout.write(retrace_history(res[0], res[1], res[2], res[3]))
    fout.close()
    f.close()  


class board:
    map = []
    player = set()
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
                    self.player.add((i,j))
                elif input[i][j] == 'G':
                    self.finish.append([i,j])
                elif input[i][j] == 'B':
                    self.finish.append([i,j])
                    self.player.add((i,j))                    
                
            self.map.append(tmp)

    def save_state(self):
        return [pos for pos in self.player]

    def load_state(self, save):
        self.player.clear()
        for pos in save:
            self.player.add(pos)

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

    def make_move(self, move):
  
        tmp = set()
        if move == 'L':
            for i in self.player:
                if self.map[i[0]][i[1]-1] != '#':
                    tmp.add((i[0],i[1]-1))
                else:
                    tmp.add(i)
        elif move == 'R':       
            for i in self.player:
                if self.map[i[0]][i[1]+1] != '#':
                    tmp.add((i[0],i[1]+1))
                else:
                    tmp.add(i)
        elif move == 'D':
            for i in self.player:
                if self.map[i[0]+1][i[1]] != '#':
                    tmp.add((i[0]+1,i[1]))
                else:
                    tmp.add(i)      
        elif move == 'U':
            for i in self.player:
                if self.map[i[0]-1][i[1]] != '#':
                    tmp.add((i[0]-1,i[1]))
                else:
                    tmp.add((i))
        
        #print(self.player, tmp, move)           
        self.player.clear()
        self.player = tmp

    def get_priority(self):
        self.cnt += 1        
        if self.heuristic == None:
            return self.cnt
        else: return self.heuristic(self) + self.cnt

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

    rnd_try = 2000
    rnd_mv = 120

    tree = None
    bVal = 9999
    borderline = 2
    _root = id_map(board)
    id_state = None


    if board.check_condition() == True:
        return (tree, _root, board, _root)    
    
    rnd = random.Random()
    st = board.save_state()
    for _ in range(rnd_try):
        ttree = Tree()
        ttree.add_node(create_node(_root, (board.save_state(), ''), tag="kek"))
        parent = _root
        for _ in range(rnd_mv):
            state = board.save_state()
            vals = []
            for mv in board.possible_moves():
                board.make_move(mv)
                vals.append((board.greedy_value(), mv))
                board.load_state(state)

            vals.sort(key = lambda x : x[0])

            best = []
            l = vals[0]
            for val in vals:
                if val[0] > vals[0][0]:
                    break
                else:
                    best.append(val)
            
            move = best[rnd.randint(0, len(best)-1)][1]
            board.make_move(move)
            id = id_map(board)
            if ttree.contains(id):
                board.load_state(state)
                continue
            ttree.add_node(create_node(id, (board.save_state(), move)), parent)
            parent = id

            if board.check_condition() == True:
                return (ttree, id, board, _root)   

            l = len(board.player)
            if l < bVal:
                id_state = parent
                bVal = l
                tree = ttree
                st = board.save_state()
                break

        l = len(board.player)
        if l < bVal:
            id_state = parent
            bVal = l
            tree = ttree
            st = board.save_state()
        if bVal <= borderline:
            break
        board.load_state(ttree[_root].data[0])
    board.load_state(st)

    heap = []    
    heapq.heappush(heap, mapper(id_state, 0))


    while(len(heap) > 0):

        '''
        if tree.depth() > bDepth:
            print(tree.depth())
            bDepth = tree.depth()
        '''
        n = heapq.heappop(heap)
        node = tree[n.value]
        val = n.key

        board.load_state(node.data[0])
        moves = board.possible_moves()

        for i in range(len(moves)):

            board.load_state(node.data[0])
            board.make_move(moves[i])

            id = id_map(board)
            if tree.contains(id):
                continue

            tree.add_node(create_node(id, (board.save_state(), moves[i])), node.identifier)
            heapq.heappush(heap, mapper(id, val+1))      
                    
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