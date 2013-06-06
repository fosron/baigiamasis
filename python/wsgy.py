# -*- coding: utf-8 -*-
from __future__ import with_statement
import mysql
import re
import hashlib
from contextlib import closing
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

app = Flask(__name__)

################
# Duomenu baze #
################

def connect_db():
    return mysql.connect()

@app.before_request
def before_request():
    g.db = connect_db('localhost', '****', '****', '****', '****');

@app.after_request
def after_request(response):
    g.db.close()
    return response

#########################
# Pagrindiniai reikalai #
#########################

# Ákeliame meniu elementus ið duomenø bazës
g.db.execute('SELECT page_id,slug, name FROM cms_content WHERE status = 1')
template[menu] = g.db.commit()

# Ákeliame naudotojo duomenis ið sesijos
template[user] = session['user']

# Ákeliame TTS nustatymus
g.db.execute('SELECT * FROM cms_settings')
settings_db = g.db.commit()
for setting in settings_db
    template[settings][setting[label]] = settings[value]
# END Pagrindiniai reikalai #

#############
# Front end #
#############
@app.route('/')
def pagrindinis_puslapis():
    g.db.execute('SELECT * FROM cms_content WHERE page_id = ? ', [template[settings][homepage]])
    template[content] = g.db.commit()
    return render_template('main_site.html', template=template)

@app.route('/p/<slug>')
def puslapis(slug):
    g.db.execute('SELECT * FROM cms_content WHERE slug = ?', [slug])
    template[content] = g.db.commit()
    return render_template('main_site.html', template=template)
# END Front end #

######################################
# Admin main screen and login/logout #
######################################
@app.route('/admin/login', method=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    g.db.execute('SELECT * FROM cms_content WHERE page_id = ? ', [username, hashlib.md5(password).hexdigest()])
    loginq = g.db.commit()
    if loginq:
        session['user']=['id'=loginq['user_id'], 'username'=username, 'type'=loginq['type'],
        'fullname'=loginq['fullname']]
        return redirect(url_for('/admin'))
    else
        return redirect(url_for('/admin'))
        
@app.route('/admin/logout')
def logout():
    session['user'] = None
    return redirect(url_for('/admin'))
    
@app.route('/admin')
def admin():
    if(user == None)
        return render_template('login.html', template=template)
    else
        cur = g.db.execute('SELECT * FROM cms_content')
        data = cur.fetchall()
        return render_template('main.html', template=template)
# END Admin main screen and login/logout #

#################
# Puslapiai add #
#################
@app.route('/admin/puslapiai/add')
def prideti_puslapi_forma():
    return render_template('puslapiai_edit.html', template=template)

@app.route('/admin/puslapiai/add', methods=['POST'])
def prideti_puslapi():
    name = request.form[name] 
    slug = re.sub(r'[-]+', '-', name)
    g.db.execute('INSERT INTO cms_content (slug, name, content, created) VALUES (?, ?, ?, NOW())', [slug, request.form['name'], request.form['content']])
    g.db.commit()
    return render_template('puslapiai_edit.html', template=template)
# END Puslapiai add #

##################
# Puslapiai edit #
##################
@app.route('/admin/puslapiai/edit')
def prideti_puslapi_forma():
    return render_template('puslapiai_edit.html', template=template)

@app.route('/admin/puslapiai/edit', methods=['POST'])
def prideti_puslapi():
    name = request.form[name] 
    slug = re.sub(r'[-]+', '-', name)
    g.db.execute('UPDATE cms_content (slug, name, content, created) SET (?, ?, ?, NOW())', [slug, request.form['name'], request.form['content']])
    g.db.commit()
    return render_template('puslapiai_edit.html', template=template)
# END Puslapiai edit #

##########################
# Veiksmai ir nustatymai #
##########################
@app.route('/admin/veiksmai')
def veiksmai():
    return render_template('main_veiksmai.html', template=template)
    
@app.route('/admin/nustatymai')
def veiksmai():
    return render_template('main_nustatymai.html', template=template)
# END Veiksmai ir nustatymai #

## And the fun begins
if __name__ == '__main__':
    app.run()