import sys
import os
import heapq
from lib.tree import Tree
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
    return sum*10e3

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
        return [[tuple(box) for box in self.boxes], tuple(self.player), self.last]


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
        self.last = save[2]

    def check_condition(self):
        for i in range(len(self.boxes)):
            tmp = False
            for j in range(len(self.finish)):
                if self.eq(self.boxes[i], self.finish[j]):
                    tmp = True
                    break
            if tmp == False:
                return False
        return True    

    


    def possible_moves(self):
        return self.accesible_fields()

    def accesible_fields(self):
        res = []
        queue = []
        heapq.heappush(queue, mapper((self.player[0], self.player[1]), 0))
        
        while(len(queue) > 0):
            pop = heapq.heappop(queue).value
            self.map[pop[0]][pop[1]] = '+'

            if self.map[pop[0]+1][pop[1]] == '.':
                heapq.heappush(queue, mapper((pop[0]+1,pop[1]), 0))
            elif self.map[pop[0]+1][pop[1]] == 'B':
                if self.map[pop[0]+2][pop[1]] == '.' or self.map[pop[0]+2][pop[1]] == '+':                
                    res.append([(pop[0], pop[1]), 'D'])

            if self.map[pop[0]-1][pop[1]] == '.':
                heapq.heappush(queue, mapper((pop[0]-1,pop[1]), 0))
            elif self.map[pop[0]-1][pop[1]] == 'B':
                if self.map[pop[0]-2][pop[1]] == '.' or self.map[pop[0]-2][pop[1]] == '+':
                    res.append([(pop[0], pop[1]), 'U'])
            
            if self.map[pop[0]][pop[1]+1] == '.':
                heapq.heappush(queue, mapper((pop[0],pop[1]+1), 0))
            elif self.map[pop[0]][pop[1]+1] == 'B':
                if self.map[pop[0]][pop[1]+2] == '.' or self.map[pop[0]][pop[1]+2] == '+':
                    res.append([(pop[0], pop[1]), 'R'])
            
            if self.map[pop[0]][pop[1]-1] == '.':
                heapq.heappush(queue, mapper((pop[0],pop[1]-1), 0))
            elif self.map[pop[0]][pop[1]-1] == 'B':
                if self.map[pop[0]][pop[1]-2] == '.' or self.map[pop[0]][pop[1]-2] == '+':
                    res.append([(pop[0], pop[1]), 'L'])                                              

        for i in range(len(self.map)):
            for j in range(len(self.map[i])):
                if self.map[i][j] == '+':
                    self.map[i][j] = '.'
        return res

    def eq(self, f,s):
        return (f[0] == s[0]) and (f[1] == s[1])

    def make_move(self, m):
        move = m[1]
        self.player[0] = m[0][0]
        self.player[1] = m[0][1]

        self.last = (self.player[0], self.player[1])
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

    while(len(heap) > 0):

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

def mm(val, dir):
    if dir == 'D':
        return (val[0]-1, val[1])
    elif dir == 'U':
        return (val[0]+1, val[1])
    elif dir == 'R':
        return (val[0], val[1]+1)
    elif dir == 'L':
        return (val[0],val[1]-1)

def shortest_path(start, dst, board):
    queue = []
    cnt = 0
    heapq.heappush(queue, mapper((start, ""), cnt))
    board.clear_board()
    board.draw_board()
    #print(np.array(board.map))
    while(len(queue) > 0):
        cnt += 1
        pop = heapq.heappop(queue).value
        if pop[0][0] == dst[0] and pop[0][1] == dst[1]:
            return pop[1]

        board.map[pop[0][0]][pop[0][1]] = '+'
            
        if board.map[pop[0][0]+1][pop[0][1]] == '.':
            heapq.heappush(queue, mapper(((pop[0][0]+1,pop[0][1]), pop[1]+'U'), cnt))
            cnt = cnt + 1
        if board.map[pop[0][0]-1][pop[0][1]] == '.':
            heapq.heappush(queue, mapper(((pop[0][0]-1,pop[0][1]), pop[1]+'D'), cnt))
            cnt = cnt + 1
        if board.map[pop[0][0]][pop[0][1]+1] == '.':
            heapq.heappush(queue, mapper(((pop[0][0],pop[0][1]+1), pop[1]+'L'), cnt))
            cnt = cnt + 1
        if board.map[pop[0][0]][pop[0][1]-1] == '.':
            heapq.heappush(queue, mapper(((pop[0][0],pop[0][1]-1), pop[1]+'R'), cnt))                                                         
            cnt = cnt + 1


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
        if board.last[0] < pos[0]:
            hist += 'D'
        elif board.last[0] > pos[0]:
            hist += 'U'
        elif board.last[1] < pos[1]:
            hist += 'R'
        else:
            hist += 'L'
        pos = board.last
        board.load_state(node.data)                         
        pPos = (board.player[0], board.player[1])

        hist += shortest_path(pos, pPos,  board)
        board.clear_board()
        for i in range(len(board.map)):
            for j in range(len(board.map[i])):
                if board.map[i][j] == '+':
                    board.map[i][j] = '.' 
        
           
        if node.identifier == root:
            board.load_state(fstate)
            print("moves:", len(hist))
            return hist[::-1]            
        node = tree.parent(node.identifier)



if __name__ == "__main__":
   main(sys.argv[1:])