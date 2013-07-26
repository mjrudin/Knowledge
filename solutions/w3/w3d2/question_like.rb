require 'question'
require 'questions_database'
require 'user'

class QuestionLike
  def self.likers_for_question_id(question_id)
    users_data = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT users.*
        FROM users
        JOIN question_likes
          ON question_likes.user_id = users.id
       WHERE question_likes.question_id = ?
    SQL
    
    users_data.map { |user_data| User.new(user_data) }
  end
  
  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.execute(<<-SQL, question_id)[0]["likes"]
      SELECT COUNT(*) AS likes
        FROM questions
        JOIN question_likes
          ON question_likes.user_id = questions.id
       WHERE questions.id = ?
    SQL
  end
  
  def self.liked_questions_for_user_id(user_id)
    questions_data = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT questions.*
        FROM questions
        JOIN question_likes
          ON question_likes.question_id = questions.id
       WHERE question_likes.user_id = ?
    SQL
    
    questions_data.map { |question_data| Question.new(question_data) }
  end
  
  def self.most_liked_questions(n)
    questions_data = QuestionsDatabase.execute(<<-SQL, n)
      SELECT questions.*
        FROM questions
        JOIN question_likes
          ON question_likes.question_id = questions.id
       ORDER BY COUNT(*)
       LIMIT ?
    SQL
    
    questions_data.map { |question_data| Question.new(question_data) }
  end
end
