module Portfolio

  class Server < Sinatra::Base

    use Rack::MethodOverride

    enable :sessions
    table = "category"


    def db_connect
      PG.connect(dbname: 'coffee_in')
    end
    
    def current_user
      db = db_connect
      if session["user_id"]
         @this_user ||= db.exec_params("SELECT * FROM users WHERE id = $1",
          [session["user_id"]]).first
      else 
        {}
      end
    end


    get "/" do 
      erb :index
    end 


    get "/signup/?" do 
      erb :signup
    end

    post "/signup/?" do
      params[:name]
      params[:password_digest]
      params[:email]
      db = db_connect

      encrypted_password = BCrypt::Password.create(params[:password_digest])
      query = "INSERT INTO users(name, password_digest, email) VALUES ($1, $2, $3) RETURNING id;"
      users_info = db.exec_params(query, [params[:name], encrypted_password, params[:email]])

      session["user_id"] = users_info.first["id"]
      redirect "/category"
    end


    get "/login/?" do 
      erb :login
    end

    post "/login/?" do 
      params[:name]
      db = db_connect
      @users_info = db.exec_params("SELECT * FROM users WHERE name = $1", [params[:name]]).first
    
      if BCrypt::Password.new(@users_info["password_digest"]) == params[:password_digest]
        session["user_id"] = @users_info["id"]
        redirect "/"
      else
        @error = "Invalid Password"
        erb :login
      end
    end 

  
    get "/category/?" do 
      db = db_connect
      @topic = db.exec("SELECT name FROM #{table}")
      erb :categories
    end 

    get "/category/article/?" do 
      erb :post_entry
    end

    post "/category/article/?" do
      db = db_connect
      title = params[:title]
      content = params[:content]
      article_id = db.exec_params("INSERT INTO article (title, content) VALUES ($1, $2) RETURNING id", [title, content]).first["id"].to_i
      @entry = params[:entry]
      #generate some_id
      redirect "/category/article/#{article_id}"
    end

    get '/category/article/:id/?' do
      db = db_connect
      @title = params['title']
      @content = params['content']
      @id = params['id']
      @dates = params['dates']
      @this_article = db.exec_params("SELECT * FROM article WHERE id = #{@id}").first
      erb :entries
    end

    put '/category/article/:id/?' do
      db = db_connect
      @title = params['title']
      @content = params['content']
      @id = params['id']
      @this_article = db.exec_params("SELECT title, content FROM article WHERE id = #{@id}").first
    
      db.exec_params("UPDATE article SET title = $1, content = $2  WHERE id = $3", [@title, @content, @id])
      redirect back
    end
  end
end