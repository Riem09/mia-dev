user = User.new
user.first_name = "Jack"
user.last_name = "Hayter"
user.email = "jack.hayter@gmail.com"
user.password = "rocketsauce"
user.password_confirmation = "rocketsauce"
user.admin = true
user.confirmed_at = DateTime.now
user.save!

user = User.new
user.first_name = "Brandon"
user.last_name = "McKay"
user.email = "brandon.mckay@gmail.com"
user.password = "rocketsauce"
user.password_confirmation = "rocketsauce"
user.admin = true
user.confirmed_at = DateTime.now
user.save!
