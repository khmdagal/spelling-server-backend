-- Drop existing tables if they exist
DROP TABLE IF EXISTS 
weeklypractice,
schools,
users,
sessions,
spelling_table
cascade;

-- Create the weeklyspellingpractice table
CREATE TABLE weeklypractice (
   id SERIAL PRIMARY KEY, 
   practice_id VARCHAR (255) UNIQUE NOT NULL, 
   words text[] NOT NULL, 
   created_at TIMESTAMP NOT NULL, 
   expires_in TIMESTAMP NOT NULL
);

-- Create the schools table
CREATE TABLE schools (
    school_id SERIAL PRIMARY KEY NOT NULL,
    school_name VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(255) UNIQUE,
    classes TEXT[] NOT NULL
);

-- Create users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL, -- can be 'teacher' or 'student'
    school_id INT NOT NULL,
    approved BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_school
        FOREIGN KEY(school_id) 
        REFERENCES schools(school_id)
        ON DELETE SET NULL
);

-- Create sessions table
CREATE TABLE sessions (
session_id serial PRIMARY KEY,
user_id INT REFERENCES users (user_id),
correctWordsList TEXT,
wrongWordsList TEXT,
number_of_correct_words INT,
number_of_incorrect_words INT,
session_accuracy_percentage NUMERIC(5,2),
percentage_sign VARCHAR(1) DEFAULT '%'
);

-- Create words table
CREATE TABLE spelling_table(
word_id serial PRIMARY KEY,
year3And4Words varchar(50),
year5And6Words varchar(50)
);


INSERT INTO spelling_table(year3And4Words, year5And6Words)
VALUES
  ('accident', 'accompany'),
  ('accidentally', 'according'),
  ('actual', 'achieve'),
  ('actually', 'aggressive'),
  ('address', 'amateur'),
  ('answer', 'ancient'),
  ('appear', 'apparent'),
  ('arrive', 'appreciate'),
  ('believe', 'attached'),
  ('bicycle', 'available'),
  ('breath', 'average'),
  ('breathe', 'awkward'),
  ('build', 'bargain'),
  ('busy', 'bruise'),
  ('business', 'category'),
  ('calendar', 'cemetery'),
  ('caught', 'committee'),
  ('centre', 'communicate'),
  ('century', 'community'),
  ('certain', 'competition'),
  ('circle', 'conscience'),
  ('complete', 'conscious'),
  ('consider', 'controversy'),
  ('continue', 'convenience'),
  ('decide', 'correspond'),
  ('describe', 'criticise'),
  ('different', 'curiosity'),
  ('difficult', 'definite'),
  ('disappear', 'desperate'),
  ('early', 'determined'),
  ('earth', 'develop'),
  ('eight', 'dictionary'),
  ('eighth', 'disastrous'),
  ('enough', 'embarrass'),
  ('exercise', 'environment'),
  ('experience', 'equip'),
  ('experiment', 'especially'),
  ('extreme', 'exaggerate'),
  ('famous', 'excellent'),
  ('favourite', 'existence'),
  ('February', 'explanation'),
  ('forward', 'familiar'),
  ('forwards', 'foreign'),
  ('fruit', 'forty'),
  ('grammar', 'frequently'),
  ('group', 'government'),
  ('guard', 'guarantee'),
  ('guide', 'harass'),
  ('heard', 'hindrance'),
  ('heart', 'identity'),
  ('height', 'immediate'),
  ('history', 'individual'),
  ('imagine', 'interfere'),
  ('increase', 'interrupt'),
  ('important', 'language'),
  ('interest', 'leisure'),
  ('island', 'lightning'),
  ('knowledge', 'marvellous'),
  ('learn', 'mischievous'),
  ('length', 'muscle'),
  ('library', 'necessary'),
  ('material', 'neighbour'),
  ('medicine', 'nuisance'),
  ('mention', 'occupy'),
  ('minute', 'occur'),
  ('natural', 'opportunity'),
  ('naughty', 'parliament'),
  ('notice', 'persuade'),
  ('occasion', 'physical'),
  ('occasionally', 'prejudice'),
  ('often', 'privilege'),
  ('opposite', 'profession'),
  ('ordinary', 'programme'),
  ('particular', 'pronunciation'),
  ('peculiar', 'queue'),
  ('perhaps', 'recognise'),
  ('popular', 'recommend'),
  ('position', 'relevant'),
  ('possess', 'restaurant'),
  ('possession', 'rhyme'),
  ('possible', 'rhythm'),
  ('potatoes', 'sacrifice'),
  ('pressure', 'secretary'),
  ('probably', 'shoulder'),
  ('promise', 'signature'),
  ('purpose', 'sincere'),
  ('quarter', 'soldier'),
  ('question', 'stomach'),
  ('recent', 'sufficient'),
  ('regular', 'suggest'),
  ('reign', 'symbol'),
  ('remember', 'system'),
  ('sentence', 'temperature'),
  ('separate', 'thorough'),
  ('special', 'twelfth'),
  ('straight', 'variety'),
  ('strange', 'vegetable'),
  ('strength', 'vehicle'),
  ('suppose', 'yacht'),
  ('surprise', ''),
  ('therefore', ''),
  ('though', ''),
  ('although', ''),
  ('thought', ''),
  ('through', ''),
  ('various', ''),
  ('weight', ''),
  ('woman', ''),
  ('women', '');