[["dylan", "password"], 
 ["aaron", "ponies"], 
 ["Peter", "spiderman"]].each do |username, password|
   u = User.new(:username => username, :password => password)
   u.save
end

["http://i.imgur.com/62Dx7i5.jpg", 
 "http://i.imgur.com/6UOjJPQ.jpg",
 "http://i.imgur.com/bnJP5cC.jpg"].each do |url|
  p = Photo.new(:url => url)
  p.owner = User.first
  p.save
end

[[1,2], [1,3]].each do |friender, friendee|
  f = Friendship.new(:friender_id => friender, :friendee_id => friendee)
  f.save
end

[[1,1], [1,2]].each do |photo, user|
  t = Tag.new(:photo_id => photo, :user_id => user)
  t.save
end