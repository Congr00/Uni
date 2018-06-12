import psycopg2, json

table_pracownicy = ("""CREATE TABLE pracownicy(\
    id         BIGSERIAL PRIMARY KEY,\
    podwladni  varchar(20)[],\
    podlega    varchar(20)[],\
    haslo      text NOT NULL);""",)

table_dane       = ("""CREATE TABLE dane(\
    id         BIGINT references pracownicy(id) ON DELETE CASCADE,\
    emp        varchar(20) NOT NULL UNIQUE,\
    dane       text);""",)

table_prezes    = ("""CREATE TABLE prezes(\
    id         BIGINT references pracownicy(id));""",)

user_app        = ('CREATE USER app;',)
password_app    = ('ALTER USER app WITH PASSWORD \'qwerty\'',)
priv_app        = ("""GRANT ALL ON pracownicy TO app;
                      GRANT ALL ON dane TO app;
                      GRANT SELECT ON prezes TO app;
                      GRANT ALL ON pracownicy_id_seq TO app;""",)
index_dane      = ('CREATE INDEX h_dane_emp_index ON dane USING hash(emp);',)


def update_podwladni(emp, demp):
    return ("""UPDATE pracownicy p SET podwladni = ( \
SELECT array_agg(elements) FROM (SELECT unnest((SELECT podwladni FROM pracownicy JOIN dane USING(id) WHERE emp=%s))\
except SELECT unnest(%s::varchar[])) t (elements))\
FROM dane d WHERE d.emp = %s AND d.id = p.id\
;""", (str(emp), '{' + str(demp) + '}', str(emp)))


def remove_pracownik(emp):
    return [('DELETE FROM pracownicy p WHERE p.id IN(SELECT id FROM dane WHERE emp = %s);', (str(emp),))]

def get_data(emp):
    return ('SELECT dane FROM dane WHERE emp=%s;', (str(emp),))

def get_children(emp):
    return ('SELECT podwladni FROM pracownicy JOIN dane USING(id) WHERE emp=%s;', (str(emp),)) 

def get_ancestors(emp):
    return ('SELECT podlega FROM pracownicy JOIN dane USING(id) WHERE emp = %s;', (str(emp),))

def get_pracownik(emp):
    return('SELECT * from pracownicy JOIN dane USING(id) WHERE emp = %s;', (str(emp),))

def update_data(emp, newdata):
    return[('UPDATE dane SET dane=%s WHERE emp=%s;', (str(newdata), str(emp)))]

def add_pracownik(password, data, emp, emp1=None, root=None):
    res = []
    if emp1 != None:
        res.append(('UPDATE pracownicy p SET podwladni = array_append(podwladni, %s) FROM dane d WHERE d.emp = %s AND d.id = p.id;', 
        (str(emp), str(emp1))))
        res.append(("""INSERT INTO pracownicy(podwladni, podlega, haslo) VALUES(\
            ARRAY[]::varchar[]\
            ,array_append((SELECT podlega FROM pracownicy JOIN dane USING(id) WHERE emp = %s), %s)\
            , md5(%s));""",
        (str(emp1), str(emp1), password)))
    else:
        # its root
        res.append(('INSERT INTO pracownicy(podwladni, podlega, haslo) VALUES(ARRAY[]::varchar[], ARRAY[]::varchar[], md5(%s));',
        (password,)))        
    res.append(('INSERT INTO dane(id, emp, dane) VALUES((SELECT currval(\'pracownicy_id_seq\')), %s, %s );', 
     (str(emp), data)))
    if root != None:
        res.append(('INSERT INTO prezes(id) VALUES((SELECT currval(\'pracownicy_id_seq\')))',))
    return res


def status_OK(data=None):
    if data == None:
        return json.dumps({'status' : 'OK'})
    else:
        return json.dumps({'status' : 'OK', 'data' : data})

def status_ER(debug):
    res = {'status' : 'ERROR', 'debug' : str(debug)}
    res = json.dumps(res)
    return res


class DB:
    hostname = 'localhost' #default
    username = ''
    password = ''
    database = ''

    def __init__(self, user, password, databs):
        self.username = user
        self.password = password
        self.database = databs
    
    def check_password(self, password, emp):
        query = ("""SELECT * FROM pracownicy JOIN dane USING(id) WHERE\
            emp = %s AND\
            pracownicy.haslo = md5(%s);""", (str(emp), password))
        res = self.doQuery(query)
        if len(res) == 0:
            return status_ER('Wrong admin password')
        else:
            return status_OK()


    def open(self):
        try:
            self.connect = psycopg2.connect( 
                host=self.hostname, user=self.username, 
                password=self.password, dbname=self.database)
            self.cur = self.connect.cursor()
            return status_OK()
        except (Exception, psycopg2.DatabaseError) as error:
            return status_ER(error)
        

    def close(self):     
        self.connect.close()
        self.cur.close()

    def doQuery(self, quarry) :
        try:
            if len(quarry) == 1:
                self.cur.execute(quarry[0])
            else:
                self.cur.execute(quarry[0], quarry[1])
            return self.cur.fetchall()
        except (Exception, psycopg2.DatabaseError) as error:
            return status_ER(error)

    def doQueryComm(self, quarry):
        try:
            for qr in quarry:
                if len(qr) == 1:
                    self.cur.execute(qr[0])
                else:                  
                    self.cur.execute(qr[0], qr[1])
            self.connect.commit()                    
            return status_OK()
        
        except (Exception, psycopg2.DatabaseError) as error:
            self.connect.commit()
            return status_ER(error)        