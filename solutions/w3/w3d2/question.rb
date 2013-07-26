require_relative 'questions_database'
require_relative 'question_follower'
require_relative 'user'

class Question
  def self.find(id)
    questions_data = QuestionsDatabase.execute(<<-SQL, id)
      SELECT * 
        FROM questions
       WHERE questions.id = ?
    SQL
    
    Question.new(questions_data[0])
  end
  
  def self.find_by_author_id(author_id)
    questions_data = QuestionsDatabase.execute(<<-SQL, author_id)
      SELECT * 
        FROM questions
       WHERE questions.author_id = ?
    SQL
    
    questions_data.map { |question_data| Question.new(question_data) }
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  attr_reader :id
  attr_accessor :title, :body, :author_id
  
  def initialize(options)
    @id, @title, @body, @author_id =
      options.values_at("id", "title", "body", "author_id")
  end
  
  def attrs
    { :title => title,
      :body => body,
      :author_id => author_id }
  end
  
  def save
    if @id
      QuestionsDatabase.execute(<<-SQL, attrs.merge({ :id => id }))
        UPDATE questions
           SET title = :title, body = :body, author_id = :author_id
         WHERE questions.id = :id
      SQL
    else
      QuestionsDatabase.execute(<<-SQL, attrs)
        INSERT INTO questions (title, body, author_id)
        VALUES (:title, :body, :author_id)
      SQL
      
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
  
  def author
    User.find(author_id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(id)
  end
  
  def replies
    Replies.find_by_question_id(id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
end
