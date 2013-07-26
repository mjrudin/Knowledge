require_relative 'question'
require_relative 'questions_database'
require_relative 'question_follower'

class User
  def self.find(id)
    users_data = QuestionsDatabase.execute(<<-SQL, id)
      SELECT *
        FROM users
       WHERE users.id = ?
    SQL
    
    users_data.empty? ? nil : User.new(users_data[0])
  end
  
  def self.find_by_name(fname, lname)
    users_data = QuestionsDatabase.execute(<<-SQL, fname, lname)
      SELECT *
        FROM users
       WHERE users.fname = ? AND users.lname = ?
    SQL
    
    users_data.map { |user_data| User.new(user_data) }
  end
  
  attr_reader :id
  attr_accessor :fname, :lname
  
  def initialize(options = {})
    @id, @fname, @lname = options.values_at("id", "fname", "lname")
  end
  
  def attrs
    { :fname => fname, :lname => lname }
  end
  
  def save
    if @id
      QuestionsDatabase.execute(<<-SQL, attrs.merge({ :id => id }))
        UPDATE users
           SET fname = :fname, lname = :lname
         WHERE users.id = :id
      SQL
    else
      QuestionsDatabase.execute(<<-SQL, attrs)
        INSERT INTO users (fname, lname) VALUES (:fname, :lname)
      SQL
      
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
  
  def authored_questions
    Question.find_by_author_id(id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end
  
  def authored_replies
    Reply.find_by_user_id(id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end
  
  def slow_average_karma
    # This is called an N+1 query; N+1 queries are slow
    total_likes = 0
    total_questions = authored_questions.count
    
    authored_questions.each do |question|
      # num_likes fires a query; so for user with 10_000 questions, fires 10k
      # Db queries

      total_likes += question.num_likes
    end
    
    total_likes / total_questions
  end
  
  def average_karma
    QuestionsDatabase.execute(<<-SQL, id)[0]["avg_karma"]
      SELECT AVG(likes) AS avg_karma
      FROM (
          SELECT COUNT(question_likes.author_id) likes
            FROM questions
            LEFT OUTER JOIN question_likes
              ON question_likes.question_id = questions.id
           WHERE questions.author_id = ?
           GROUP BY questions.id
      )
    SQL
  end
  
  def no_subquery_average_karma
    # Subquery-free version.
    QuestionsDatabase.execute(<<-SQL, id)[0]["avg_karma"]
        SELECT COUNT(question_likes.author_id) / COUNT(DISTINCT questions.id) AS avg_karma
          FROM questions
          LEFT OUTER JOIN question_likes
            ON question_likes.question_id = questions.id
         WHERE questions.author_id = ?
    SQL
  end
end
