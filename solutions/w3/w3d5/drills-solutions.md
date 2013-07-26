# Drills Solutions

## Question 1.

For **each** of the associations in the following scenarios, specify
the **:class_name, :primary_key, and :foreign_key** that would be
generated **by default**. For the :primary_key and :foreign_key,
please specify **which table** Rails will look for them in.

NB: some of these associations are not set up properly yet; we'll fix
them in Question 2.

# Solution

#### Scenario 1
```
class User
  has_many :posts,
    class_name: 'Post',
    foreign_key: :user_id, (in the posts table)
    primary_key: :id (in the users table)
end
```


#### Scenario 2
```
class User
  has_many :posts,
    class_name: 'Post',
    foreign_key: :user_id, (in the posts table)
    primary_key: :id (in the users table)
end

class Post
  belongs_to :user,
    class_name: 'User',
    foreign_key: :user_id, (in the posts table)
    primary_key: :id
end
```

#### Scenario 3
```
class User
  has_many :writings,
    class_name: 'Writing',
    foreign_key: :user_id, (in the writings table),
    primary_key: :id (in the users table)
end

class Post
  belongs_to :author,
    class_name: 'Author',
    foreign_key: :author_id, (in the posts table)
    primary_key: :id (in the authors table)
end
```

#### Scenario 4
```
class Spaceman
  has_many :minions,
  has_many :planet_visits
  has_one :spaceship
  belongs_to :race
end
```

#Solution

```
class Spaceman
  has_many :minions, 
    class_name: 'Minion', 
    foreign_key: :spaceman_id (in the minions table),
    primary_key: :id (in the spacemen table)

  has_many :planet_visits, 
    class_name: 'PlanetVisit', 
    foreign_key: :spaceman_id (in the planet_visits table),
    primary_key: :id (in the spacemen table)
  
  has_one :spaceship, 
    class_name: 'Spaceship', 
    foreign_key: :spaceman_id (in the spaceships table),
    primary_key: :id (in the spacemen table)

  belongs_to :race, 
    class_name: 'Race', 
    foreign_key: :race_id (in the spacemen table),
    primary_key: :id (in the races table)
end
```

#### Scenario 5
```
 # Building on Scenario 4

class Minion
  belongs_to :overlord
end

class Visit
  belongs_to :visitor
  belongs_to :planet
end

class Spaceship
  belongs_to :owner
end

class Race
  has_many :people
end

class Planet
end

```

#Solution

```
class Minion
  belongs_to :overlord,
    class_name: 'Overlord',
    foreign_key: :overlord_id (in minions table),
    primary_key: :id (in overlords table)
end

class Visit
  belongs_to :visitor,
    class_name: 'Visitor',
    foreign_key: :visitor_id (in visits table),
    primary_key: :id (in visitors table)
    
  belongs_to :planet,
    class_name: 'Planet',
    foreign_key: :planet_id (in visits table),
    primary_key: :id (in planets table)
end

class Spaceship
  belongs_to :owner,
    class_name: 'Owner',
    foreign_key: :owner_id (in spaceships table),
    primary_key: :id (in owners table)
end

class Race
  has_many :people,
    class_name: 'Person',
    foreign_key: :race_id (in people table),
    primary_key: :id (in races table)
end

class Planet
end
```


## Question 2.

Scenarios 3, 4, and 5 will not work as written. Please fix them so they work. 
**Do not change the name of any of the associations or write any new ones.** 
Use the options we've learned to make them work.

**Scenario 3**

* For the `has_many`, I want `Post` objects back 
* For the `belongs_to`, I want a `User` back

#Solution

```
 ### assuming the posts table has 'author_id', not 'user_id'

class User
  has_many :writings,
    class_name: 'Post',
    foreign_key: :author_id
end

class Post
  belongs_to :author,
    class_name: 'User'
end
```

**Scenarios 4 & 5**

* On `Spaceman`:
  * For `planet_visits`, I want `Visit` objects back
* On `Minion` & `Visit` & `Spaceship` & `Race`:
  * For `overlord`/`visitor`/`owner`/`people`, I want `Spaceman` objects back

#Solution

```
class Spaceman
  has_many :minions,
    foreign_key: :overlord_id
    
  has_many :planet_visits,
    class_name: 'Visit',
    foreign_key: :visitor_id
    
  has_one :spaceship,
    foreign_key: :owner_id
        
  belongs_to :race
end

class Minion
  belongs_to :overlord,
    class_name: 'Spaceman'
end

class Visit
  belongs_to :visitor,
    class_name: 'Spaceman'
    
  belongs_to :planet
end

class Spaceship
  belongs_to :owner,
    class_name: 'Spaceman'
end

class Race
  has_many :people,
    class_name: 'Spaceman'
end

class Planet
end

```


## Question 3.

For Scenarios 4 & 5 above, please write **a single association** so that I can call `Spaceman.first.visited_planets` and get an array of `Planet` objects back.

#Solution

```
class Spaceman
  has_many :visited_planets, through: :planet_visits, source: :planet
end
```

## Question 4.

# Solution

```
class User
  has_many :memberships
  has_many :my_teams, 
    through: :memberships, 
    source: :team
end

class Memberships
  belongs_to :team
  belongs_to :user
end

class Teams
  has_many :memberships
  has_many :players, 
    through: :memberships, 
    source: :user
    
  # Note that the '#player_ids' method is provided 
  # by the has_many association
end
```

Please write the necessary associations on the above models so that I can call the following methods:

* `User.first.my_teams`
* `Membership.first.team`
* `Membership.first.user`
* `Team.first.players`
* `Team.first.player_ids`


## Question 5.

```
class User
  has_many :posts
end

class Post
  belongs_to :user
end
```

There are 5 posts (with id's 1-5). All belong to the first User (user with id 1). 

I then run:

```
u = User.create(name: 'Jim')  # <= This user's id is 2
u.post_ids = [3, 4, 5]
```
# Solution

1. Have any attributes changed?
   
   Yes.
   
2. If any attributes have changed, which attributes exactly?
   
   The `user_id` attribute of posts 3, 4, and 5 have been set
   to 2.
   
3. Have any changes been persisted to the database?

   Yes, the changes have been persisted to the database.

*NB:The `has_many` association provides a `#collection_singular_ids=` method
which sets the foreign keys and persists the change to the database.*

## Question 6.

Oops. I didn't mean to assign the post with `id` 5 to the second
user. Set the user of that post back to the first user. Do not set the
`user_id` directly; use an association-generated helper method.

#Solution

```
Post.find(5).user = User.first

###
  Helper method '#user=' is generated by the belongs_to association and immediately 
  persists the changes to the database.
###
```

## Question 7.

```
class Team
  has_many :memberships
  has_many :users, through: :memberships
end

class Memberships
  belongs_to :team
  belongs_to :user
end

class User
  has_many :teams
end
```

This code is broken. Please fix it so that I can call `User.first.team_ids = [3, 4, 5]`.

# Solution

```
class Team
  has_many :memberships
  has_many :users, through: :memberships
end

class Memberships
  belongs_to :team
  belongs_to :user
end

class User
  has_many :memberships
  has_many :teams, through: :memberships
end
```

Now that it's fixed, I call `User.first.team_ids = [3, 4, 5]`.

# Solution

1. Has anything been changed in the database?

   Yes.

2. If anything, what exactly has changed in the database?

   The memberships table has been updated so that there are three entries
   for the first user:
   
   ```
   user_id   |   team_id
   ----------------------
     1       |     3
     1       |     4
     1       |     5
   ```
   If the first user had any other rows in the table, they have been deleted.


## Question 8.

```
class User
  has_many :posts
end

class Post
  belongs_to :user
  
  validates :user_id, presence: true
end
```

I call: 

```
u = User.new(name: 'Jim')
u.posts.build(title: 'My first post')
u.save
```
But it doesn't work. Please fix it.

## Question 9.

For each of the following scenarios, please write out the params that
would be generated. Note that some of these don't follow conventions.

#### Scenario 1

```
<input name='user[name]' value='Jim'></input>
<input name='user[password]' value='****'></input>
<input name='user[address][street]' value='1234 Cherry Lane'></input>
<input name='user[address][city]' value='San Francisco'></input>
<input name='user[address][state]' value='CA'></input>
```

#### Scenario 2

```
<input name='user[name]' value='Jim'></input>
<input name='user[name][supername]' value='Superman'></input>
<input name='post[body]' value='Hi'></input>
<input name='comment[title]' value='Bye'></input>
<input name='user[name]' value='Bob'></input>
```

#### Scenario 3

```
<input name='bob[patient_ids]' value='1'></input>
<input name='bob[patient_ids]' value='2'></input>
<input name='bob[patient_ids]' value='3'></input>
<input name='bob[patient_ids]' value='4'></input>
<input name='bob[patient_ids]' value='5'></input>
```

Also, what did the Rails application writer probably intend?

#### Scenario 4
```
<input name='bill[neverland][]' value='1'></input>
<input name='bill[neverland][]' value='2'></input>
<input name='bill[neverland][]' value='3'></input>
<input name='user_attributes[name]' value='Lalala'></input>
<input name='user_attributes[age]' value='5'></input>
```

#### Scenario 5
```
<input name='boom' value='1'></input>
<input name='aqualung[artist]' value='Jethro Tull'></input>
<input name='am_I_real' value='3'></input>
<input name='yes[no][actually_yes]' value='4'></input>
<input name='yes[no]' value='5'></input>
```

## Question 10.

Please write the correct `form` tag that will get me the desired
results for each scenario. NB: not all these examples make a lot of
sense.

1. post to 'http://www.google.com'
2. get to '/i-have-something-to-show-you'
3. post to '/users'
4. post to 'http://blahblah.com'
5. get to '/tolstoy-went-soft'

## Question 11.

Here is an `erb` form:

```
<%= form_for @user, url: '/people' do |f| %>
  <%= f.label :name, 'My Very Special Name' %>
  <%= f.text_field :name, class: 'super-name' %>
  <%= f.text_field :email %>
  <%= f.fields_for :posts do |post_f| %>
    <%= post_f.label :body %>
    <%= post_f.text_area :body %>
    <%= post_f.label :title %>
    <%= post_f.text_field :title %>
  <% end %>
<% end %>
```

1. Write the HTML that it generates.
2. Write out how Rails will interpret the uploaded params.


#Solution

###HTML
```
 ### 
 Note 1:
 I previously told you all that 'fields_for' automatically uses assocation_attributes for 
 the input name attribute regardless of whether you have 'accepts_nested_attributes_for'
 defined on the model. I was incorrect. 'fields_for' checks for the presence of a writer
 method called '#assocation_attributes=' on the object passed to 'form_for' (which is what
 'accepts_nested_attributes_for' defines for you, but you could also write one yourself) and
 if it finds one, then it will use 'association_attributes' in the input name attribute; 
 otherwise, it will simply use 'association'. Below, I have done it both ways so that you can 
 see the difference.
 
 Note 2:
 Rails will include some extra pieces of information in the form such as a hidden field for 
 the authenticity token as well as some class names, size attributes, and the like. I have
 left those out as they're not critical to our understanding of forms.
 ###
 
 
 *** Scenario 1: Without a writer method called '#posts_attributes=' on '@user'
 
<form action="/people" id="new_user" method="post">
  <label for="user_name">My Very Special Name</label>
  <input id="user_name" name="user[name]" type="text" />
  <input id="user_email" name="user[email]" type="text" />
  
  <label for="user_posts_body">Body</label>
  <textarea id="user_posts_body" name="user[posts][body]"></textarea>
  <label for="user_posts_title">Title</label>
  <input id="user_posts_title" name="user[posts][title]" type="text" />
</form>

 *** Scenario 2: With a writer method called '#posts_attributes=' on '@user'
 
<form action="/people" id="new_user" method="post">
  <label for="user_name">My Very Special Name</label>
  <input id="user_name" name="user[name]" type="text" />
  <input id="user_email" name="user[email]" type="text" />
  
  <label for="user_posts_attributes_0_body">Body</label>
  <textarea id="user_posts_attributes_0_body" name="user[posts_attributes][0][body]">
  </textarea>
  
  <label for="user_posts_attributes_0_title">Title</label>
  <input id="user_posts_attributes_0_title" name="user[posts_attributes][0][title]" type="text" />
</form>
```

###Params
```
###
There is more in the params like the character encoding, authenticity token, and commit action information. I have left that out as they are not relevant for our purposes.
###

*** Scenario 1 (posts)

params = {
  'user' => {
    'name' => 'Jim',
    'email' => 'jim@jimmy.com'
    'posts' => {
      'body' => 'Hi there',
      'title' => 'My first post'
    }
  }
}

*** Scenario 2 (posts_attributes)

params = {
  'user' => {
    'name' => 'Jim',
    'email' => 'jim@jimmy.com',
    'posts_attributes' => {
      '0' => {
        'body' => 'Hi there',
        'title' => 'My first post'
      }
    }
  }
}
```

## Question 12.

Once the form in the previous question submits, it comes to the
following controller:

```
class UsersController
  def create
    @user = User.create(params[:user])
  end
  
  def new
    # what goes here?
  end
end
```

Here is the model currently:

```
class User
  attr_accessible :name, :email
  
  has_many :posts
end

class Post
  attr_accessible :body, :title
  
  validate :body, :title, :author_id, :presence => true
end
```

0. One-by-one, list the attributes that will be mass-assigned.
1. Does this work as is? Why or why not?
2. If not, fix it.

## Question 13.

A user `has_many :projects`. Please alter the form in Question 11 to
display checkboxes for all the `Project`s so that the user may select
which ones he wants to sign up for.

1. Do the erb version.
2. Do the HTML version. 
3. Update how your params hash comes in.

## Question 14.

Now, let's say the controller action we have remains exactly the same. 

1. Will the controller action work as expected? Why or why not?
2. If not, what do you need to change for it to work (exact code you need)?

# Solution

```
 ### Controller action remains the same
class UsersController
  def create
    @user = User.create(params[:user])
  end
end

1. Will the controller action work as expected? Why or why not?

No, it will not. A MassAssignmentError will be raised on :project_ids.


2. If not, what do you need to change for it to work (exact code you need)?

class User
  attr_accessible :name, :email, :project_ids
end


```