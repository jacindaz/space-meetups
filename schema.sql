CREATE TABLE meetup (
  id serial PRIMARY KEY,
  user VARCHAR (200),
  description VARCHAR (1000) NOT NULL,
  resource_id INTEGER NOT NULL,
  create_on TIMESTAMP NOT NULL
);


CREATE TABLE users (

);


INSERT INTO resources (name, url, votes)
  VALUES ('Codecademy', 'http://www.codecademy.com', 1);
