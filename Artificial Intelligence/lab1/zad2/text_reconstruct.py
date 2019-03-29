import sys
import collections


def main(argv):
    fin = 'zad2_input.txt'
    fout = 'zad2_output.txt'
    fw = 'words_for_ai1.txt'

    load_file(fin, fout, fw)

def load_file(fin, fout, fw):
    dic = collections.defaultdict(dict)
    longest = 0
    fw = open(fw, 'r')
    for line in fw:
        l = len(line)
        if l > longest:
            longest = l
        dic[l][line.rstrip()] = 0
    fw.close()                
    raw = ""
    f = open(fin, 'r')
    open(fout, 'w').close()
    fo = open(fout, "a")
    with open(fin) as f:
        lines = f.readlines()
        last = lines[-1]
        for line in lines:
            raw = line.rstrip()
            spaces = reconstruct(raw, dic, longest)
            start = 0
            for val in range(0, len(spaces)):
                if val == len(spaces)-1:
                    fo.write(raw[start:start+spaces[val]])
                else:
                    fo.write(raw[start:start+spaces[val]] + ' ')
                start += spaces[val]      
            if line is not last:
                fo.write('\n')  
    fo.close()    


def reconstruct(raw, dic, longest):
    current_len = []
    dyn = []
    word = ''
    i = 0
    current_len = 0
    word = ''    
    for j in range(0, longest):          
        if i+j >= len(raw):
            break        
        word += raw[i+j]
        current_len += 1
        if len(word)+1 in dic:
            if word in dic[len(word)+1]:
                    dyn.append((current_len, current_len*current_len, [current_len]))

    
    end = []
    longest = 0
    for _ in range(1, len(raw)):
        dyn_ = []
        for c_len, squared, spaces in dyn:
            current_len = 0
            word = ''
            for i in range(0, len(raw)):
                if i+c_len >= len(raw):
                    end.append((squared, spaces))
                    break
                word += raw[c_len+i]
                current_len += 1
                if len(word)+1 in dic:
                    if word in dic[len(word)+1]:
                        r = squared+current_len*current_len
                        if longest < r:
                            longest = r
                        if r < longest*0.80:
                            continue
                        dyn_.append((c_len+current_len, r, spaces+[current_len]))       
        if len(dyn_) == 0:
            break                        
        dyn = dyn_
        del dyn_
    longest = 0
    space = None
    for squared, spaces in end:
        if squared > longest:
            space = spaces
            longest = squared
    return space
        

if __name__ == "__main__":
   main(sys.argv[1:])

