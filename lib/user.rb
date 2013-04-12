class User < Hash
  attr_reader :user, :id

  def initialize(id)
    return false unless id

    @user = REDIS.get(id)
    @id = id

    if ! @user
      @user = fetch id
    else
      @user = JSON.parse(@user)
    end
  end

  def latest_gist
    GistList.new(@user['login'], 1).list.first
  end

  def name
    @user['name'].to_s
  end

  def login
    @user['login'].to_s
  end

private
  def fetch(id)
    begin
      user = Github::Users.new.get(user: id, client_id: Roughdraft.gh_config['client_id'], client_secret: Roughdraft.gh_config['client_secret'])

      REDIS.setex(user['login'], 60, user.to_hash.to_json)
      user.to_hash
    rescue Github::Error::NotFound
      false
    end
  end
end