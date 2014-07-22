CREATE TABLE users (

  id INTEGER PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL

);

CREATE TABLE questions (

  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)

);

CREATE TABLE question_followers (

  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

CREATE TABLE replies (

  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)

);

CREATE TABLE question_likes (

  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

INSERT INTO
  users (first_name, last_name)
VALUES
  ("Malcolm", "Carradine"), ("Stefan", "Huynh"), ("Charlie", "Brown");

INSERT INTO
  questions (title, body, user_id)
VALUES
  ("Life", "What is the meaning of life?", (
    SELECT id FROM users WHERE first_name = "Malcolm")
  ), ("Lightbulb", "How do you screw in a lightbulb?", (
    SELECT id FROM users WHERE first_name = "Stefan")
  ), ("Woodchuck", "How much wood could a woodchuck chuck, etc.?", (
    SELECT id FROM users WHERE first_name = "Charlie")
  );

INSERT INTO
  question_followers (user_id, question_id)
VALUES
  (1, 1), (1, 3), (2, 2), (2, 1), (3, 3);

INSERT INTO
  replies (body, user_id, question_id, reply_id)
VALUES
  ("42", 2, 1, NULL), ("Aren't woodchucks veg?", 1, 3, NULL),
  ("Your mom!", 3, 3, 2), ("Good answer!", 1, 1, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1), (1, 3), (2, 1), (3, 3);



