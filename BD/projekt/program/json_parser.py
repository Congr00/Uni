import json


def open_(val):
    db.database = val['baza']
    db.username = val['login']
    db.password = val['password']
    db.open()
    # echo status?

def root_(val):

def new_(val):

def remove_(val):

def child_(val):

def parent_(val):

def ancestors_(val):

def descendants_(val):

def ancestor_(val):

def read_(val):

def update_(val):



def parse(val):
    if 'open' in val:
        return open_(val['open'])
    else if 'root' in val:
        return root_(val['root'])
    else if 'new' in val:
        return new_(val['new'])
    else if 'remove' in val:
        return remove_(val['remove'])
    else if 'child' in val:
        return child_(val['child'])
    else if 'parent' in val:
        return parent_(val['parent'])
    else if 'ancestors' in val:
        return ancestors_(val['ancestors'])
    else if 'descendants' in val:
        return descendants_(val['descendants'])
    else if 'ancestor' in val:
        return ancestor_(val['ancestor'])
    else if 'read' in val:
        return read_(val['read'])
    else if 'update' in val:
        return update_(val['update'])
    else:
    #error?
    return val


#print (json.loads('{ "open": { "baza": "student", "login": "init", "password": "qwerty"}}',
#object_hook=parse))

