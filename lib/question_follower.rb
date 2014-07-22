require_relative 'questions_database'
require_relative 'user'

class QuestionFollower

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_followers
      WHERE
        question_followers.id = ?
    SQL

    QuestionFollower.new(query.first)
  end

  def self.followers_for_question_id(question_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.first_name, users.last_name
      FROM
        users
      JOIN
        question_followers ON users.id = question_followers.user_id
      WHERE
        question_followers.question_id = ?
    SQL

    query.each_with_object([]) do |data, users|
      users << User.new(data)
    end
  end

  def self.followed_questions_for_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_followers ON questions.id = question_followers.question_id
      WHERE
        question_followers.user_id = ?
    SQL

    query.each_with_object([]) do |data, questions|
      questions << Question.new(data)
    end
  end

  def self.most_followed_questions(n)
    query = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      questions.id, questions.title, questions.body, questions.user_id
    FROM
      questions
    JOIN
      question_followers ON questions.id = question_followers.question_id
    GROUP BY
      question_followers.question_id
    ORDER BY
      COUNT(question_followers.user_id)
    SQL

    query[0...n].each_with_object([]) do |data, questions|
      questions << Question.new(data)
    end

  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @question_id = option['question_id']
    @user_id = options['user_id']
  end

end