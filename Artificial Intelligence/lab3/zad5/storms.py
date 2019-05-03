from itertools import chain



def B(i,j):
    return 'B_%d_%d' % (i,j)

def domains(Vs):
    return [ q + ' in 0..1' for q in Vs ]

def get_column(j, max):
    return [B(i,j) for i in range(max)] 
            
def get_raw(i, max):
    return [B(i,j) for j in range(max)]     

def print_constraints(Cs, indent, d):
    position = indent
    write((indent - 1) * ' ')
    for c in Cs:
        write(c + ',')
        position += len(c)
        if position > d:
            position = indent
            writeln('')
            write((indent - 1) * ' ')

def col_sums(cols, max):
    dd = []
    for i in range(len(cols)):
        res = ""            
        col = get_column(i, max)        
        for j in range(len(col)-1):
            res += col[j] + " + "
        res += col[-1]
        dd.append((res, cols[i]))
    return dd

def row_sums(rows, max):
    dd = []
    for i in range(len(rows)):
        res = ""            
        row = get_raw(i, max)        
        for j in range(len(row)-1):
            res += row[j] + " + "
        res += row[-1]
        dd.append((res, rows[i]))
    return dd    

def storms(raws, cols, triples):
    writeln(':- use_module(library(clpfd)).')
    
    R = len(raws)
    C = len(cols)
    
    bs = [ B(i,j) for i in range(R) for j in range(C)]
    
    writeln('solve([' + ', '.join(bs) + ']) :- ')

    cs = []
    # starting values
    for i,j,val in triples:
        cs.append( '%s #= %d' % (B(i,j), val) )
    # col and row radars sums
    for res,val in chain(col_sums(cols, C), row_sums(raws, R)):
        cs.append( '%s #= %d' % (res, val))       

    print_constraints(cs, 4, 70)
 
    writeln('')
    # valid 2x2 storm
    storm_2x2 = [
        [0,0,0,0], [1,1,1,1], [1,0,1,0], [0,1,0,1],
        [1,0,0,0], [0,1,0,0], [0,0,1,0], [0,0,0,1],
        [1,1,0,0], [0,0,1,1]
    ]
    # valud 1x3 / 3x1 storms
    storm_3x = [
        [0,0,0], [1,0,0], [0,0,1],
        [1,1,1], [1,1,0], [0,1,1],
        [1,0,1]
    ]


    fields_2x2 = [[B(i, j), B(i, j+1), B(i+1, j), B(i+1, j+1)] for i in range(R-2) for j in range(C-2)]
    fields_3x1 = [[B(i, j), B(i, j+1), B(i, j+2)] for i in range(R) for j in range(C-2)]
    fields_1x3 = [[B(i, j), B(i+1, j), B(i+2, j)] for i in  range(R-2) for j in range(C)]
    
    writeln('    tuples_in({}, {}),'.format(str(fields_2x2).replace("'", ""), storm_2x2))
    writeln('    tuples_in({}, {}),'.format(str(fields_3x1).replace("'", ""), storm_3x))
    writeln('    tuples_in({}, {}),'.format(str(fields_1x3).replace("'", ""), storm_3x))
    
    writeln('')
    
    writeln('    labeling([ff], [' +  ', '.join(bs) + ']).' )
    writeln('')
    writeln(":- tell('prolog_result.txt'), solve(X), write(X), nl, told.")

def writeln(s):
    output.write(s + '\n')
def write(s):
    output.write(s)

txt = open('zad_input.txt').readlines()
output = open('zad_output.txt', 'w')

raws = map(int, txt[0].split())
cols = map(int, txt[1].split())
triples = []

for i in range(2, len(txt)):
    if txt[i].strip():
        triples.append(map(int, txt[i].split()))

storms(raws, cols, triples)            
        

