
pusher = YAML.load(File.read(Rails.root.join('config/pusher.yml')))[Rails.env]
Pusher.app_id = pusher["app_id"]
Pusher.key = pusher["key"]
Pusher.secret = pusher["secret"]
Pusher.encrypted = (pusher["encrypted"] == "1")
