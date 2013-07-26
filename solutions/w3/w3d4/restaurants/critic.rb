require_relative 'database'
require_relative 'restaurant_review'

class Critic
  def initialize(options)
    @id, @screen_name = options.values_at("id", "screen_name")
  end
  
  def reviews
    RestaurantReview.reviews_for_critic_id(id)
  end
  
  def average_review_score
    Database.execute(<<-SQL, id)[0]["avg_score"]
      SELECT AVG(restaurant_reviews.score) AS avg_score
        FROM restaurant_reviews
       WHERE restaurant_reviews.critic_id = ?
    SQL
  end
  
  def unreviewed_restaurants
    # Question for student: why can't we filter `restaurant_reviews.critic_id
    # = ?` in the outer WHERE clause? Why do we need the subquery?
    restaurants_data = Database.execute(<<-SQL, id)
      SELECT restaurants.*
        FROM restaurants
        LEFT OUTER JOIN (SELECT *
                           FROM restaurant_reviews
                          WHERE restaurant_reviews.critic_id = ?)
          ON restaurants.id = restaurant_reviews.restaurant_id
       WHERE restaurant_review.id IS NULL
    SQL
    
    restaurants_data.map { |restaurant_data| Restaurant.new(restaurant_data) }
  end
end
