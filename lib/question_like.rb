require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class QuestionLike

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = ?
    SQL

    Reply.new(query.first)
  end

  def self.likers_for_question_id(question_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.first_name, users.last_name
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    query.each_with_object([]) do |data, users|
      users << User.new(data)
    end
  end

  def self.num_likes_for_question_id(question_id)
    self.likers_for_question_id(question_id).length
  end

  def self.liked_questions_for_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL

    query.each_with_object([]) do |data, questions|
      questions << Question.new(data)
    end
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end





