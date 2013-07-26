class ChefTenure
  def initialize(options)
    @id, @chef_id, @restaurant_id, @begin_date, @end_date, @head_chef = 
      options.values_at(
        "id",
        "chef_id",
        "restaurant_id",
        "begin_date",
        "end_date",
        "head_chef"
      )
  end
end
