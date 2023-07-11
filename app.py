from flask import Flask, request,render_template, session, redirect, url_for
from flask_mysqldb import MySQL
from datetime import datetime, date, timedelta

app = Flask(__name__)

app.secret_key = '08001002653'  # Used to encrypt session data

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'perpus_alpukat'

mysql = MySQL(app)



def input_tamu(nama):
    try: 
        cursor = mysql.connection.cursor()
        cursor.execute("INSERT INTO tamu (nama) VALUES (%s)", (nama,))
        mysql.connection.commit()
        cursor.close()
        return True
    except: 
        return False

# landing page / home
@app.route("/", methods=['GET','POST'])
def home():
    # cek session
    if 'username' in session:
            return redirect(url_for('dashboard'))

    error = None
    if request.method == 'POST':
        nama = request.form['nama']
        cursor = mysql.connection.cursor()
        cursor.execute("INSERT INTO tamu (nama) VALUES (%s)", (nama,))
        mysql.connection.commit()
        cursor.close()
        return render_template('index.html', error=error, nama=nama)
    
    return render_template('index.html', error=error)


# halaman buku
@app.route("/buku", methods=['GET','POST'])
def buku():
    # cek session
    if 'username' in session:
            return redirect(url_for('dashboard'))

    # search
    if request.args.get('search', '') :
        search = request.args.get('search', '')
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM buku WHERE judul LIKE %s", ('%'+search+'%',))
        bukus = cursor.fetchall()
        return render_template('buku.html', bukus=bukus, search=search)
    
    # get all buku
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM buku")
    bukus = cursor.fetchall()
    return render_template('buku.html', bukus=bukus)

# halaman login
@app.route("/login", methods=['GET','POST'])
def login():
    # cek session
    if 'username' in session:
            return redirect(url_for('dashboard'))
    
    error = None
    # login proses
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM pengurus WHERE username=%s AND password=%s", (username,password,))
        user = cursor.fetchone()
        if user:
            session['username'] = username
            return redirect(url_for('dashboard'))
        else:
            error = 'Username atau password salah'
            return render_template('login.html', error=error)
        
    return render_template('login.html')

# dashboard home
@app.route("/dashboard", methods=['GET','POST'])
def dashboard():
    # cek session
    if 'username' in session:
        # search
        if request.args.get('search', '') :
            search = request.args.get('search', '')
            cursor = mysql.connection.cursor()
            cursor.execute("SELECT * FROM buku WHERE judul LIKE %s", ('%'+search+'%',))
            bukus = cursor.fetchall()
            return render_template('dashboard/buku/index.html', bukus=bukus, search=search)
        
        # get all buku
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM buku")
        bukus = cursor.fetchall()
        return render_template('dashboard/buku/index.html', bukus = bukus)
    else:
        return redirect(url_for('login'))

# dashboard tambah buku
@app.route("/dashboard/tambah-buku", methods=['GET','POST'])
def tambah_buku():
    # cek session
    if 'username' in session:
        error = None
        if request.method == 'POST':
            judul = request.form['judul']
            tahun_terbit = str(request.form['tahun_terbit'])
            sinopsis = request.form['sinopsis']
            penerbit = request.form['penerbit']
            lokasi = request.form['lokasi']
            jumlah = request.form['jumlah']

            # insert data
            cursor = mysql.connection.cursor()
            cursor.execute("INSERT INTO buku (judul, tahun_terbit, sinopsis, penerbit, lokasi, total_stok, stok_terkini) VALUES (%s, %s, %s, %s, %s, %s, %s)", (judul, tahun_terbit, sinopsis, penerbit, lokasi, jumlah,jumlah,))
            mysql.connection.commit()
            cursor.close()
            return redirect(url_for('dashboard'))
        
        return render_template('dashboard/buku/tambah.html', error=error)
    else:
        return redirect(url_for('login'))
    
# dashboard edit buku
@app.route("/dashboard/buku/edit/<id>", methods=['GET','POST'])
def edit_buku(id):
    # cek session
    if 'username' in session:
        error = None
        if request.method == 'POST':
            judul = request.form['judul']
            tahun_terbit = str(request.form['tahun_terbit'])
            sinopsis = request.form['sinopsis']
            penerbit = request.form['penerbit']
            lokasi = request.form['lokasi']
            jumlah = request.form['jumlah']
            jumlah_terkini = request.form['jumlah_terkini']

            # update data
            cursor = mysql.connection.cursor()
            cursor.execute("UPDATE buku SET judul=%s, tahun_terbit=%s, sinopsis=%s, penerbit=%s, lokasi=%s, total_stok=%s, stok_terkini=%s WHERE id=%s", (judul, tahun_terbit, sinopsis, penerbit, lokasi, jumlah,jumlah_terkini,id,))
            mysql.connection.commit()
            cursor.close()
            return redirect(url_for('dashboard'))
        
        # get buku
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM buku WHERE id=%s", (id,))
        buku = cursor.fetchone()
        return render_template('dashboard/buku/edit.html', buku=buku, error=error)
    else:
        return redirect(url_for('login'))

# dashboard hapus buku
@app.route("/dashboard/buku/hapus/<id>", methods=['GET','POST'])
def hapus_buku(id):
    # cek session
    if 'username' in session:
        cursor = mysql.connection.cursor()
        cursor.execute("DELETE FROM buku WHERE id=%s", (id,))
        mysql.connection.commit()
        cursor.close()
        return redirect(url_for('dashboard'))
    else:
        return redirect(url_for('login'))
    
# dashboard peminjaman
@app.route("/dashboard/peminjaman", methods=['GET','POST'])
def peminjaman():
    if 'username' in session:
        # get all peminjaman and join table
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT peminjaman.id, buku.judul, anggota.nama, peminjaman.nik_anggota, peminjaman.status,  peminjaman.tgl, peminjaman.tgl_jatuh_tempo FROM peminjaman INNER JOIN buku ON peminjaman.id_buku = buku.id INNER JOIN anggota ON peminjaman.nik_anggota = anggota.nik")
        peminjamans = cursor.fetchall()
        cursor.close()
        return render_template('dashboard/peminjaman/index.html', peminjamans=peminjamans)
    else:
        return redirect(url_for('login'))
    
# dashboard tambah peminjaman
@app.route("/dashboard/peminjaman/tambah", methods=['GET','POST'])
def peminjaman_tambah():
    # cek session
    if 'username' in session:

        if request.method == 'POST':
            id_buku = request.form['id_buku']
            nik = request.form['nik']
            tgl = datetime.now().strftime('%Y-%m-%d')
            date_1 = datetime.strptime(tgl, '%Y-%m-%d')
            tgl_jatuh_tempo = date_1 + timedelta(days=7)

            # insert data
            cursor = mysql.connection.cursor()
            cursor.execute("INSERT INTO peminjaman (tgl, tgl_jatuh_tempo, nik_anggota, id_buku ) VALUES (%s, %s, %s, %s)", (tgl, tgl_jatuh_tempo, nik, id_buku,))
            mysql.connection.commit()

            # update stok buku
            cursor.execute("UPDATE buku SET stok_terkini=stok_terkini-1 WHERE id=%s", (id_buku,))
            mysql.connection.commit()
            cursor.close()

            return redirect(url_for('peminjaman'))

        # get all buku
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM buku")
        bukus = cursor.fetchall()
        # get all anggota
        cursor.execute("SELECT * FROM anggota")
        anggotas = cursor.fetchall()
        cursor.close()
        return render_template('dashboard/peminjaman/tambah.html', bukus = bukus, anggotas=anggotas)
    else:
        return redirect(url_for('login'))
    
# dashboard edit peminjaman
@app.route("/dashboard/peminjaman/edit/<id>", methods=['GET','POST'])
def peminjaman_edit(id):
    # cek session
    if 'username' in session:
        error = None
        if request.method == 'POST':
            status = request.form['status']
            id_buku = request.form['id_buku']

            # insert data
            cursor = mysql.connection.cursor()
            cursor.execute("UPDATE peminjaman SET status=%s WHERE id=%s", (status,id,))
            mysql.connection.commit()
            
            if status == 'kembali':
                # update stok buku
                cursor.execute("UPDATE buku SET stok_terkini=stok_terkini+1 WHERE id=%s", (id_buku,))
                mysql.connection.commit()
            elif status == 'dipinjam':
                # update stok buku
                cursor.execute("UPDATE buku SET stok_terkini=stok_terkini-1 WHERE id=%s", (id_buku,))
                mysql.connection.commit()
            cursor.close()
            return redirect(url_for('peminjaman'))
        
        
        # get peminjaman and join table
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT peminjaman.id, buku.judul, peminjaman.nik_anggota, peminjaman.status, buku.id FROM peminjaman INNER JOIN buku ON peminjaman.id_buku = buku.id WHERE peminjaman.id=%s", (id,))
        peminjaman = cursor.fetchone()
        cursor.close()
        return render_template('dashboard/peminjaman/edit.html', peminjaman=peminjaman, error=error)
    else:
        return redirect(url_for('login'))
    
# dashbaord tamu
@app.route("/dashboard/tamu", methods=['GET','POST'])
def tamu():
    if 'username' in session:
        # get all tamu
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM tamu")
        tamus = cursor.fetchall()
        cursor.close()
        return render_template('dashboard/tamu/index.html', tamus=tamus)
    else:
        return redirect(url_for('login'))

# dashboard anggota
@app.route("/dashboard/anggota", methods=['GET','POST'])
def anggota():
    if 'username' in session:
        # get all anggota
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM anggota")
        anggotas = cursor.fetchall()
        cursor.close()
        return render_template('dashboard/anggota/index.html', anggotas=anggotas)
    else:
        return redirect(url_for('login'))
    
# dashboard tambah anggota
@app.route("/dashboard/anggota/tambah", methods=['GET','POST'])
def anggota_tambah():
    if 'username' in session:
        if request.method == 'POST':
            nik = request.form['nik']
            nama = request.form['nama']
            # insert data
            cursor = mysql.connection.cursor()
            cursor.execute("INSERT INTO anggota (nik, nama) VALUES (%s, %s)", (nik, nama,))
            mysql.connection.commit()
            cursor.close()
            return redirect(url_for('anggota'))
        return render_template('dashboard/anggota/tambah.html')
    else:
        return redirect(url_for('login'))
    
# dashboard edit anggota
@app.route("/dashboard/anggota/edit/<nik>", methods=['GET','POST'])
def anggota_edit(nik):
    if 'username' in session:
        if request.method == 'POST':
            nik_baru = request.form['nik']
            nama = request.form['nama']
            # insert data
            cursor = mysql.connection.cursor()
            cursor.execute("UPDATE anggota SET nama=%s, nik=%s WHERE nik=%s", (nama, nik_baru, nik,))
            mysql.connection.commit()
            cursor.close()
            return redirect(url_for('anggota'))
        # get anggota
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM anggota WHERE nik=%s", (nik,))
        anggota = cursor.fetchone()
        cursor.close()
        return render_template('dashboard/anggota/edit.html', anggota=anggota)
    else:
        return redirect(url_for('login'))
    
# logout
@app.route("/logout", methods=['GET','POST'])
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))




@app.route('/hello/')

@app.route('/hello/<name>')
def hello(name=None):
    return render_template('index.html', name=name)