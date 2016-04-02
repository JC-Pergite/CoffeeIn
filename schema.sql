DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS article CASCADE; 

CREATE TABLE users(
  id SERIAL PRIMARY KEY, 
  name VARCHAR(30) UNIQUE,
  email VARCHAR(75),
  password_digest VARCHAR(255),
  img_url TEXT
);

CREATE TABLE category(
  id SERIAL PRIMARY KEY,
  name VARCHAR(30) UNIQUE

);

CREATE TABLE article(
  id SERIAL PRIMARY KEY,
  title VARCHAR(75) UNIQUE,
  content VARCHAR(255),
  dates DATE,
  img_url TEXT,
  user_id INTEGER REFERENCES users(id),
  category_id INTEGER REFERENCES category(id)

);



INSERT INTO users
(name, email, password_digest, img_url)
VALUES
('Ted', 'ted@ted.com', 'pass', 'image_url');

INSERT INTO category 
(name)
VALUES
('North America & The Caribbean'),
('Central America'), 
('South American'), 
('East Africa'), 
('West Africa'), 
('Arabian Peninsula'), 
('Asia');

INSERT INTO article
(title, content)
VALUES
('Colombian Coffee'), 
('Colombia, the worlds best-known coffee producer, ranks second worldwide in yearly production. A high standard of excellence results in consistently good, mild coffees with a well-balanced acidity and a delicate, aromatic sweetness.');
