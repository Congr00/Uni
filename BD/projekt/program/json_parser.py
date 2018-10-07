import json, db_connect, api


def check_admin(admin, passwd):
    # check if pracownik admin exists
    res = db_connect.get_pracownik(admin)
    if len(api.db.doQuery(res)) == 0:
        # error so end connection
        api.db.close()
        return db_connect.status_ER('Admin with emp: ' + str(admin) + ' doesn\'t exists')    
    # check for correct password
    res = check_password(admin, passwd)
    if res != None:
        return res    

def check_existance(emp):
    res = db_connect.get_pracownik(emp)
    # check if we can get user with given emp
    res = api.db.doQuery(res)  
    if len(res) != 0:
        # user with that id exists so we cant create new
        return db_connect.status_ER('User with emp: ' + str(emp) + ' exists -> can\'t override') 
    api.db.close()
    return None

def check_password(admin, passwd):
    res = api.db.check_password(passwd, admin)
    if (json.loads(res))['status'] == 'ERROR':
        # error so end connection
        api.db.close()
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

    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if there isn't pracownik with given emp
    res = check_existance(emp)
    if res != None:
        return res
    api.db.open()          
    # check if pracownik with emp1 exists
    res = check_existance(emp1)        
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp1) + ' doesn\'t exists')  
    # check if is ancestor of emp1
    # he obv is if admin == emp1
    if admin != emp1:
        res = check_priv(admin, emp1)
        if res != None:
            return res
    # generate adding worker query
    res = db_connect.add_pracownik(newpass, data, emp, emp1)
    # commit
    res = api.db.doQueryComm(res)
    api.db.close()
    return res


def remove_(val):

    # load all descendants and check for errors
    res = (json.loads(descendants_(val)))
    if res['status'] == 'ERROR':
        return res
    # get array of descendants
    res = res['data']
    # get parent to update his workers
    api.db.open()    
    res2 = (json.loads(parent_(val)))
    if res2['status'] == 'ERROR':
        return res2
    res2 = res2['data'][0]
    # prev functions closed bd so reopen it
    api.db.open()
    # note that admin checking was done by descendants and parent functions

    # check privileges
    if val['admin'] != val['emp']:
        res = check_priv(val['admin'], val['emp'])
        if res != None:
            return res    
    # remove worker from parent
    res = api.db.doQueryComm([db_connect.update_podwladni(res2, val['emp'])])
    if json.loads(res)['status'] == 'ERROR':
        return res
    # remove workers recursivly
    stack = [val['emp']]
    while len(stack) != 0:
        # get pracownik to remove
        demp = stack.pop()
        # get all of his children
        qr = db_connect.get_children(demp)
        r = api.db.doQuery(qr)
        if "ERROR" in r:
            return r       
        # add new workers to process
        stack += r[0][0]
        qr = db_connect.remove_pracownik(demp)
        # run removing query
        r = api.db.doQueryComm(qr)
        if json.loads(r)['status'] == 'ERROR':
            return r
    # all done return OK status
    res = db_connect.status_OK()    
    api.db.close()
    return res

def child_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']

    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp exists in database
    res = check_existance(emp)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp) + ' doesn\'t exists')     
    # get query   
    res = db_connect.get_children(emp)
    # commit and return data
    res = db_connect.status_OK(api.db.doQuery(res)[0][0])
    api.db.close()
    return res

def parent_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']

    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp exists in database
    res = check_existance(emp)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp) + ' doesn\'t exists')    
    # get query
    res = db_connect.get_ancestors(emp)
    # commit and return data if not error
    res = api.db.doQuery(res)
    if 'ERROR' in res:
        return res
    res = res[0][0]
    # get last value of workers array
    if len(res) != 0:
        res = res[len(res)-1]    
    res = db_connect.status_OK([res])
    api.db.close()
    return res        

def ancestors_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']

    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp exists in database
    res = check_existance(emp)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp) + ' doesn\'t exists')   
    # get query
    res = db_connect.get_ancestors(emp)
    res = api.db.doQuery(res)
    if "ERROR" in res:
        return res
    # return whole array if no errors occured
    res = db_connect.status_OK(res[0][0])
    api.db.close()
    return res    

def descendants_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']
    
    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp exists in database
    res = check_existance(emp)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp) + ' doesn\'t exists')  
    res = db_connect.get_anc(emp)
    res = api.db.doQuery(res)
    api.db.close()
    if len(res) == 0:
        return db_connect.status_OK([])
    for val in range(len(res)):
        res[val] = res[val][0]
    return db_connect.status_OK(res)

def ancestor_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp1   = val['emp1']
    emp2   = val['emp2']
    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp1 exists in database
    res = check_existance(emp1)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp1) + ' doesn\'t exists') 
    # check if pracownik with given emp2 exists in database
    res = check_existance(emp2)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp2) + ' doesn\'t exists')           
    # check if emp2 is 'above' emp1 ( by checking priviliges )
    res = check_priv(emp2, emp1)
    # if check_priv returnes None, emp 2 is privileged over emp1, so true
    if res == None:
        return db_connect.status_OK(["true"])
    # false otherwise
    # note string cast for bool values ( so return is uniwersal )
    res = db_connect.status_OK(["false"])
    api.db.close()
    return res
        

def read_(val):
    admin  = val['admin']
    passwd = val['passwd']
    emp    = val['emp']
   # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp1 exists in database
    res = check_existance(emp)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp) + ' doesn\'t exists') 
    # check if is ancestor of emp1
    if admin != emp:
        res = check_priv(admin, emp)
        if res != None:
            return res    
    # get data of user emp
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

    # security check
    res = check_admin(admin, passwd)
    # if failed returns error
    if res != None:
        return res
    # check if pracownik with given emp1 exists in database
    res = check_existance(emp)
    if res == None:
        return db_connect.status_ER('User with emp: ' + str(emp) + ' doesn\'t exists') 
    # check if is ancestor of emp1
    if admin != emp:
        res = check_priv(admin, emp)
        if res != None:
            return res
    # update data
    res = db_connect.update_data(emp, newdata)
    res = api.db.doQueryComm(res)
    api.db.close()
    return res

def parse(val):
    val = json.loads(val)
    if 'open' in val:
        return open_(val['open'])
    # open connection to database    
    api.db.open()   
    if 'root' in val:
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
