require ::File.expand_path('../config/environment',  __FILE__)
class Application
  def call(env)
  	req = Rack::Request.new(env)
  	name_string = req.params['name'].to_s
  	#body = User.where(name: name_string).map{|user| user.name}.join(", ") #exact match
  	body = User.all.select{|user| user.name.to_s.include?(name_string)}.map{|user| user.name.to_s}.join(", ") #matching substring
    return [status=403, {}, ['Only Accept GET Request']] unless req.get?
    [status=200,  { "Content-Type" => "application/json" }, [ { :user_names => body }.to_json ]]
  end
end

app = Rack::Builder.new do |builder|
	builder.use Rack::ETag
  builder.use Rack::Auth::Basic do |username, password|
  	username == 'mango' && password == 'apps'
  end

  builder.run Application.new
end

run app

#curl -u mango -X GET -d name='user_name_to_match' localhost:9292 -m 30 -v