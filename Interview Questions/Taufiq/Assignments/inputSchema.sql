create schema learning;

-- 1.users table:  name(user name), active(boolean to check if user is active)
CREATE SEQUENCE learning.users_id_seq;
CREATE TABLE learning.users (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL ('users_id_seq'),
  name VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2.batches  table:  name(batch name), active(boolean to check if batch is active)
CREATE SEQUENCE learning.batch_id_seq;
CREATE TABLE learning.batches (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('batch_id_seq'),
  name VARCHAR(100) UNIQUE NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 3.student_batch_maps  table: this table is a mapping of the student and his batch. deactivated_at is the time when a student is made inactive in a batch.
CREATE SEQUENCE learning.student_batch_maps_id_seq;
CREATE TABLE learning.student_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('student_batch_maps_id_seq'),
  user_id INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  deactivated_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 4.instructor_batch_maps  table: this table is a mapping of the instructor and the batch he has been assigned to take class/session.
CREATE SEQUENCE learning.instructor_batch_maps_id_seq;
CREATE TABLE learning.instructor_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('instructor_batch_maps_id_seq'),
  user_id INTEGER REFERENCES users(id),
  batch_id INTEGER REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 5.sessions table: Every day session happens where the teacher takes a session or class of students.
CREATE SEQUENCE learning.sessions_id_seq;
CREATE TABLE learning.sessions (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('sessions_id_seq'),
  conducted_by INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 6.attendances table: After session or class happens between teacher and student, attendance is given by student. students provide ratings to the teacher.
CREATE TABLE learning.attendances (
  student_id INTEGER NOT NULL REFERENCES users(id),
  session_id INTEGER NOT NULL REFERENCES sessions(id),
  rating DOUBLE PRECISION NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, session_id)
);


-- 7.tests table: Test is created by instructor. total_mark is the maximum marks for the test.
CREATE SEQUENCE learning.tests_id_seq;
CREATE TABLE learning.tests (
   id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('tests_id_seq'),
  batch_id INTEGER REFERENCES batches(id),
  created_by INTEGER REFERENCES users(id),
  total_mark INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
);


-- 8.test_scores table: Marks scored by students are added in the test_scores table.
CREATE TABLE learning.test_scores (
  test_id INTEGER REFERENCES tests(id),
  user_id INTEGER REFERENCES users(id),
  score INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(test_id, user_id)
);