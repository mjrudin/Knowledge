require_relative 'database'

class RestaurantReview
  def self.reviews_for_critic_id(critic_id)
    reviews_data = Database.execute(<<-SQL, critic_id)
      SELECT *
        FROM restaurant_reviews
       WHERE restaurant_reviews.critic_id = ?
    SQL
    
    reviews_data.map { |review_data| RestaurantReview.new(review_data) }
  end
  
  def self.reviews_for_restaurant_id(restaurant_id)
    reviews_data = Database.execute(<<-SQL, restaurant_id)
      SELECT *
        FROM restaurant_reviews
       WHERE restaurant_reviews.restaurant_id = ?
    SQL
    
    reviews_data.map { |review_data| RestaurantReview.new(review_data) }
  end
  
  def initialize(options)
    @id, @critic_id, @restaurant_id, @review_date, @body, @score =
      options.values_at(
        "id",
        "critic_id",
        "restaurant_id",
        "review_date",
        "body",
        "score"
      )
  end  
end
