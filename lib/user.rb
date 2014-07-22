require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follower'

class User

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(query.first)
  end

  def self.find_by_name(first_name, last_name)
    params = [first_name, last_name]
    query = QuestionsDatabase.instance.execute(<<-SQL, *params)
      SELECT
        *
      FROM
        users
      WHERE
        users.first_name = ?
        AND users.last_name = ?
    SQL

    User.new(query.first)
  end

  attr_accessor :id, :first_name, :last_name

  def initialize(options = {})
    @id = options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

end





