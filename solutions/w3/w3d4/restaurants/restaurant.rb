require_relative 'restaurant_review'
class Restaurant
  def self.restaurants_for_neighborhood(neighborhood)
    restaurants_data = Database.execute(<<-SQL, neighborhood)
      SELECT *
        FROM restaurants
       WHERE restaurants.neighborhood = ?
    SQL
    
    restaurants_data.map { |restaurant_data| new(restaurant_data) }
  end
  
  def self.top_restaurants(n)
    restaurants_data = Database.execute(<<-SQL, n)
      SELECT restaurants.*
        FROM restaurants
        LEFT OUTER JOIN restaurant_reviews /* include restaurants with no reviews*/
          ON restaurants.id = restaurant_reviews.restaurant_id
       GROUP BY restaurants.id
       ORDER BY AVG(restaurant_reviews.score)
       LIMIT ?
    SQL
    
    restaurants_data.map { |restaurant_data| new(restaurant_data) }
  end
  
  def self.frequently_reviewed_restaurants(min_reviews)
    restaurants_data = Database.execute(<<-SQL, n)
      SELECT restaurants.*
        FROM restaurants
        JOIN restaurant_reviews
          ON restaurants.id = restaurant_reviews.restaurant_id
       GROUP BY restaurants.id
      HAVING COUNT(*) >= ?
    SQL
    
    restaurants_data.map { |restaurant_data| new(restaurant_data) }
  end
  
  def initialize(options)
    @id, @name, @neighborhood, @cuisine =
      options.values_at("id", "name", "neighborhood", "cuisine")
  end
  
  def reviews
    RestaurantReview.reviews_for_restaurant_id(id)
  end
  
  def average_review_score
    Database.execute(<<-SQL, id)[0]["avg_score"]
      SELECT AVG(restaurant_reviews.score) AS avg_score
        FROM restaurant_reviews
       WHERE restaurant_reviews.restaurant_id = ?
    SQL
  end
end
