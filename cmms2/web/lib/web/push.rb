require 'webpush'
begin
  PUSH = JSON.parse(open("./push.json").read)
rescue
  vapid_key = Webpush.generate_key

  # Save these in your application server settings
  File.open("./push.json", 'w') do |f|
    f.puts({
      public_key:  vapid_key.public_key,
      private_key: vapid_key.private_key
    }.to_json)
  end
  
  PUSH = JSON.parse(open("./push.json").read)  
end

class Push
  @@private_key = PUSH["private_key"]
  @@public_key  = PUSH["public_key"]
  
  def self.message root, obj
    return {status: 404} unless a=subscriptions[root]
    a.each do |sub|
      begin
	  Webpush.payload_send(
		message:  obj.to_json,
		
		endpoint: sub['endpoint'],
		p256dh:   sub['keys']['p256dh'],
		auth:     sub['keys']['auth'],
		
		vapid: {
		  subject: obj["title"],
		  public_key: @@public_key,
		  private_key: @@private_key
		},
		
		ssl_timeout: 5, # value for Net::HTTP#ssl_timeout=, optional
		open_timeout: 5, # value for Net::HTTP#open_timeout=, optional
		read_timeout: 5 # value for Net::HTTP#read_timeout=, optional
	  )  
	  rescue
	    
	  end
    end
    {status: 200}
  end
  
  def self.register root, sub
    (subscriptions[root] ||= []) << sub
  end
  
  def self.subscriptions
    @subscriptions ||= {} 
  end
  
  def self.routes this
    this.instance_exec do
      Dir.glob("./sites/*.rb").to_a.push("").each do |f|
		post "#{root=File.basename(f).split(".")[0]}/api/push/register" do
		  puts obj=JSON.parse(request.body.read)
		  Push.register root, obj
		  {status: 200}.to_json
		end
		
		post "#{root}/api/push/subscription/changed" do
		  puts obj=JSON.parse(request.body.read)
		  Push.subscriptions[root].delete obj['old']
		  Push.register root, obj['subscription']
		  "{}"
		end		

		post "#{root}/api/push" do
		  Push.message(root, JSON.parse(request.body.read)).to_json
		end    
      end
    end
  end
end
