import json
import db_connect, api

def check_password(admin, passwd):
    res = api.db.check_password(passwd, admin)
    if (json.loads(res))['status'] == 'ERROR':
        return res
    return None    

def check_priv(admin, emp):
    res = api.db.doQuery(db_connect.get_ancestors(emp))
    if 'ERROR' in res:
        return res   
    if str(admin) in res[0][0]:
        return None
    return db_connect.status_ER('Access Denied')    

def open_(val):
    database = val['database']
    login    = val['login']
    password = val['password']
    api.db = db_connect.DB(login, password, database)
    res = api.db.open()
    if (json.loads(res))['status'] == 'ERROR':
        return res
    if login == 'init':
        api.db.doQueryComm([db_connect.table_pracownicy, db_connect.table_dane, db_connect.table_prezes,
        db_connect.user_app, db_connect.password_app, db_connect.priv_app, db_connect.index_dane])
    api.db.close()  
    return res      


def root_(val):
    secret      = val['secret']
    if secret != 'qwerty':
        return db_connect.status_ER('zly sekret')
    newpassword = val['newpassword']
    data        = val['data']
    emp         = val['emp']
    res = db_connect.add_pracownik(newpassword, data, emp, root=True)
    api.db.open()
    res = api.db.doQueryComm(res)
    api.db.close()
    return res

def new_(val):
    admin   = val['admin']
    passwd  = val['passwd']
    data    = val['data']
    newpass = val['newpasswd']
    emp1    = val['emp1']
    emp     = val['emp']

    api.db.open()
    # check if pracownik admin exists
    res = db_connect.get_pracownik(admin)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('Admin with that emp doesn\'t exists')    
    # check for correct password
    res = check_password(admin, passwd)
    if res != None:
        return res
    # check if pracownik with emp exists
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) != 0:
        return db_connect.status_ER('User with that emp exists')
    # check if pracownik with emp1 exists
    res = db_connect.get_pracownik(emp1)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with that emp1 doesn\'t exists')        
    # check if is ancestor of emp1
    if admin != emp1:
        res = check_priv(admin, emp1)
        if res != None:
            return res
    # generate adding worker quary
    res = db_connect.add_pracownik(newpass, data, emp, emp1)
    res = api.db.doQueryComm(res)
    api.db.close()
    return res


def remove_(val):
    res = (json.loads(descendants_(val)))
    if res['status'] == 'ERROR':
        return res
    res = res['data']
    res2 = (json.loads(parent_(val)))
    if res2['status'] == 'ERROR':
        return res2
    res2 = res2['data'][0]
    api.db.open()
    # check privileges
    if val['admin'] != val['emp']:
        res = check_priv(val['admin'], val['emp'])
        if res != None:
            return res    
    # remove from parent array
    res = api.db.doQueryComm([db_connect.update_podwladni(res2, val['emp'])])
    if json.loads(res)['status'] == 'ERROR':
        return res
    # remove rec
    stack = [val['emp']]
    while len(stack) != 0:
        demp = stack.pop()
        qr = db_connect.get_children(demp)
        r = api.db.doQuery(qr)
        if "ERROR" in r:
            return r       
        stack += r[0][0]
        qr = db_connect.remove_pracownik(demp)
        r = api.db.doQueryComm(qr)
        if json.loads(r)['status'] == 'ERROR':
            return r
    res = db_connect.status_OK()    
    api.db.close()
    return res

def child_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']
    res = check_password(admin, passwd)
    if res != None:
        return res
    #check if emp exists
    api.db.open()
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with that emp doesn\'t exists')        
    res = db_connect.get_children(emp)
    res = db_connect.status_OK(api.db.doQuery(res)[0][0])
    api.db.close()
    return res

def parent_(val):
    admin  = val['admin']
    passwd = val['passwd']
    #check password
    res = check_password(admin, passwd)
    if res != None:
        return res
    emp    = val['emp']
    api.db.open()
    #check if emp exists    
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with that emp doesn\'t exists')    
    res = db_connect.get_ancestors(emp)
    res = api.db.doQuery(res)
    if 'ERROR' in res:
        return res
    res = res[0][0]
    if len(res) != 0:
        res = res[len(res)-1]    
    res = db_connect.status_OK([res])
    api.db.close()
    return res        

def ancestors_(val):
    admin  = val['admin']
    passwd = val['passwd']
    #check password
    res = check_password(admin, passwd)
    if res != None:
        return res
    emp    = val['emp']
    api.db.open()    
    #check if emp exists
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with that emp doesn\'t exists')    
    res = db_connect.get_ancestors(emp)
    res = api.db.doQuery(res)
    if "ERROR" in res:
        return res
    res = db_connect.status_OK(res[0][0])
    api.db.close()
    return res    

def descendants_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']
    res = check_password(admin, passwd)
    if res != None:
        return 
    #check if emp exists within database
    api.db.open()
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User '+str(emp)+ 'doesn\'t exists')
    res = []
    stack = [emp]
    while len(stack) != 0:
        qr = db_connect.get_children(stack.pop())
        r = api.db.doQuery(qr)
        if "ERROR" in r:
            return r       
        res += r[0][0]
        stack += r[0][0]
    res = db_connect.status_OK(res)
    api.db.close()
    return res

def ancestor_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp1   = val['emp1']
    emp2   = val['emp2']
    api.db.open()
    res = check_password(admin, passwd)
    if res != None:
        return 
    #check if emp1 and emp2 exists within database
    res = db_connect.get_pracownik(emp1)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with emp1 doesn\'t exists')
    res = db_connect.get_pracownik(emp2)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with emp2 doesn\'t exists')         

    res = check_priv(emp2, emp1)
    if res == None:
        return db_connect.status_OK(["true"])
    res = db_connect.status_OK(["false"])
    api.db.close()
    return res
        

def read_(val):
    admin  = val['admin']
    passwd = val['passwd']
    #check password
    res = check_password(admin, passwd)
    if res != None:
        return res
    emp    = val['emp']
    api.db.open()    
    #check if emp exists
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with that emp doesn\'t exists')    
    res = db_connect.get_data(emp)
    res = api.db.doQuery(res)
    if "ERROR" in res:
        return res
    res = db_connect.status_OK(res[0])
    api.db.close()   
    return res 

def update_(val):
    admin   = val['admin']
    passwd  = val['passwd']
    newdata = val['newdata']
    emp     = val['emp']

    api.db.open()
    # check for correct password
    res = check_password(admin, passwd)
    if res != None:
        return res
    # check if pracownik with emp exists
    res = db_connect.get_pracownik(emp)
    if len(api.db.doQuery(res)) == 0:
        return db_connect.status_ER('User with that emp doesn\'t exists')
    # check if is ancestor of emp1
    if admin != emp:
        res = check_priv(admin, emp)
        if res != None:
            return res
    res = db_connect.update_data(emp, newdata)
    res = api.db.doQueryComm(res)
    api.db.close()
    return res

def parse(val):
    val = json.loads(val)
    if 'open' in val:
        return open_(val['open'])
    elif 'root' in val:
        return root_(val['root'])
    elif 'new' in val:
        return new_(val['new'])
    elif 'remove' in val:
        return remove_(val['remove'])
    elif 'child' in val:
        return child_(val['child'])
    elif 'parent' in val:
        return parent_(val['parent'])
    elif 'ancestors' in val:
        return ancestors_(val['ancestors'])
    elif 'descendants' in val:
        return descendants_(val['descendants'])
    elif 'ancestor' in val:
        return ancestor_(val['ancestor'])
    elif 'read' in val:
        return read_(val['read'])
    elif 'update' in val:
        return update_(val['update'])
    else:
    #error?
        return val



#print (json.loads('{ "open": { "baza": "student", "login": "init", "password": "qwerty"}}',
#object_hook=parse))

