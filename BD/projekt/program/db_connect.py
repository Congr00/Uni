import psycopg2


class db_connect:
    hostname = 'localhost' #?
    username = ''
    password = ''
    database = ''

    def open(self):
        self.connect = psycopg2.connect( 
            host=self.hostname, user=self.username, 
            password=self.password, dbname=self.database)

    def close(self):
        self.connect.close()

    def doQuery(self, quarry) :
        cur = self.connect.cursor()
        cur.execute(quarry)
        return cur

        #for firstname, lastname in cur.fetchall() :
        #    print firstname, lastname
