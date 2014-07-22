require_relative 'questions_database'

class Question
include Save

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?;
    SQL

    Question.new(query.first)
  end

  def self.find_by_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.user_id = ?;
    SQL

    query.each_with_object([]) do |data, questions|
      questions << Question.new(data)
    end
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def table
    'questions'
  end

  def author
    query = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        first_name, last_name
      FROM
        users
      WHERE
        users.id = ?;
    SQL

    User.new(query.first)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

end





