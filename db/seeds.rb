include ActionDispatch::TestProcess

def create_user(name)
  user = User.find_or_create_by(email: "#{name}@user.com") do |user|
    user.name = name
    user.password = '12345678'
    user.password_confirmation = '12345678'
  end
  puts "create user: #{name}"
  return user
end

def create_images(user, stop = 200)
  size = user.uploaded_images.size
  loop do
    break if size > stop
    i = Image.new(owner: user)
    i.image=(File.open(Rails.root.join('spec', 'fixtures', 'test.jpg')))
    i.save!
    puts "create image id=#{i.id}"
    size += 1
  end
end

def create_vote(user, type, size = 50)
  size_votes = user.votes.where(validate: type).size
  Image.limit(size).order("RANDOM()").each do |image|
    break if size_votes > 50
    v = Vote.new(image: image, user: user, validate: type)
    if type == :pending
      v.latitude = rand(1.0..90.0)
      v.longitude = rand(1.0..90.0)
    end
    v.save!
    puts "create vote id=#{v.id}"
    size += 1
  end
end

default_user = create_user 'default'
admin_user = create_user 'admin'
create_images default_user
create_images admin_user
create_vote admin_user, :pending
create_vote admin_user, :unknow
