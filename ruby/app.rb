require 'sinatra'
require 'bundler'
require 'digest/md5'
set :protection, except: :ip_spoofing
Bundler.require
enable :sessions

#
# @name TTS
# @author Tautvydas Tijunaitis
# @copyright 2013
#

################
# Duomenu baze #
################
require 'json'
svcs = JSON.parse ENV['VCAP_SERVICES']
mysql = svcs.detect { |k,v| k =~ /^mysql/ }.last.first
creds = mysql['credentials']
user, pass, host, name = %w(user password host name).map { |key| creds[key] }
DataMapper.setup(:default, "mysql://#{user}:#{pass}@#{host}/#{name}")

class Cms_content
    include DataMapper::Resource
    property :page_id, Serial
    property :name, String
    property :slug, String
    property :content, Text
    property :created, Date
    property :edited, Date
    property :created_by, Int
    property :status, Int
end

class Cms_settings
    include DataMapper::Resource
    property :id, Serial
    property :label, String
    property :value, String
end

class Cms_log
    include DataMapper::Resource
    property :id, Serial
    property :action, String
    property :user_id, Int
    property :commit, Date
end

class Cms_users
    include DataMapper::Resource
    property :user_id, Serial
    property :username, String
    property :password, String
    property :fullname, String
    property :type, Id
end

DataMapper.finalize
Cms_content.auto_upgrade!
Cms_settings.auto_upgrade!
Cms_log.auto_upgrade!
Cms_users.auto_upgrade!
### END Duomenu baze ###

#########################
# Pagrindiniai reikalai #
#########################

## Ákeliame meniu elementus iğ duomenø bazës
@meniu = Cms_content.all(:status => 1)

## Ákeliame naudotojo duomenis iğ sesijos
@user = session['user']

## Ákeliame TTS nustatymus
@settings_db = Cms_settings.all()
for setting in settings_db
    @settings[setting.label] = settings.value
    
### END Pagrindiniai reikalai ###

#############
# Front end #
#############
get '/' do
  @content = Cms_content.first(:id => settings[:homepage])
  erb :main_site
end

get '/p/:slug' do
  @content = Cms_content.first(:slug => params[:slug])
  if content.status == 0 && user.type == nil
    redirect '/'
  erb :main_site
end
### END Front end ###

##########################################
### Admin main screen and login/logout ###
##########################################
get '/admin/login' do
    username = params[:username]
    password = Digest::MD5.hexdigest(params[:password])
    loginq =  Cms_users.first(:username => username, :password => password)
    if loginq
        session['user']={'id' => loginq.user_id, 'username' => username, 'type' => loginq.type,
        'fullname' => loginq.fullname}
        ### LOGGING ###
    else
        session['info'] = 'error'
        redirect '/admin'
end

get '/admin/logout' do
    session['user'] = {}
    redirect '/admin'
end

get '/admin' do
    if(user == nil)
        erb :login
    else
        @data = Cms_content.all()
        erb :main
end
### END Admin main screen and login/logout ###

#####################
### Puslapiai add ###
#####################
get '/admin/puslapiai/add' do
    erb :puslapis_edit
end

post '/admin/puslapiai/add' do
    slug = params[:slug].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    if user.type==2
        status = 0
    else
        status = 1
        
    page = Cms_content.new(:pavadinimas => params[:name], :slug  => slug, :content => params[:content], :created => 'NOW()', :status => status)
    
    ### LOGGING ###
    
    redirect '/admin'
end
### END Puslapiai add ###

######################
### Puslapiai edit ###
######################
get '/admin/puslapiai/edit/:id' do
    @data = Cms_content.get(:id)
    if user.type == 2 && data.created_by!=user.id
        redirect '/admin'
    else
        erb :puslapis_edit
end

post '/admin/puslapiai/edit/:id' do
    content = params[:content]
    name = params[:name]
    slug = name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    Cms_content.update(:name => name, :slug => slug, :content => content, :edited => 'NOW()')
    @saved = true
    
    ### LOGGING ###
    
    erb :puslapis_edit
end
### END Puslapiai edit ###

##################
### Nustatymai ###
##################
get '/admin/nustatymai'
    @data = Cms_settings.all
    erb :main_nustatymai
end

post '/admin/nustatymai'
    @data = Cms_settings.all
    erb :main_nustatymai
end
### END Nustatymai ###

################
### Veiksmai ###
################
get '/admin/veiksmai'
    @data = Cms_log.all
    erb :main_veiksmai
end
### END Veiksmai ###