require 'database'
require 'review_data'

class Chef
  def initialize(options)
    @id, @fname, @lname, @mentor_id =
      options.values_at("id", "fname", "lname", "mentor_id")
  end
  
  def proteges
    chefs_data = Database.execute(<<-SQL, id)
      SELECT *
        FROM chefs
       WHERE chefs.mentor_id = ?
    SQL
    
    chefs_data.map { |chef_data| Chef.new(chef_data) }
  end
  
  def num_proteges
    Database.execute(<<-SQL, id)[0]["num_proteges"]
      SELECT COUNT(*) AS num_proteges
        FROM chefs
       WHERE chefs.mentor_id = ?
    SQL
  end
  
  def reviews
    reviews_data = Database.execute(<<-SQL, id)
      SELECT restaurant_reviews.*
        FROM restaurant_reviews
        JOIN chef_tenures
          ON ((restaurant_reviews.restaurant_id = chef_tenures.restaurant_id)
              AND (restaurant_reviews.review_date BETWEEN
                   chef_tenures.start_date AND chef_tenures.end_date))
       WHERE chef_tenures.chef_id = ?
    SQL
    
    reviews_data.map { |review_data| RestaurantReview.new(review_data) }
  end
  
  def co_workers
    chefs_data = Database.execute(<<-SQL, id)
      SELECT coworker_chefs.*
        FROM chefs coworker_chefs
        JOIN chef_tenures coworker_tenures
          ON coworker_chefs.id = coworker_tenures.chef_id
        JOIN chef_tenures my_tenures
          ON ((coworker_tenures.end_date >= my_tenures.start_date
              AND (coworker_tenures.start_date <= my_tenures.end_date)
              AND (coworker_tenures.chef_id != my_tenures.chef_id))
       WHERE my_tenures.chef_id = ?
    SQL
    
    chefs_data.map { |chef_data| Chef.new(chef_data) }
  end
end
