-- Drop existing tables if they exist
DROP TABLE IF EXISTS 
schools,
classes,
weeklypractice,
users,
sessions,
words,
userprofile,
avatars,
leaderBoard,
cascade;

CREATE TABLE schools (
    school_id VARCHAR(255) PRIMARY KEY,
    school_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(50),
    website VARCHAR(150),
    address_line1 VARCHAR(255),
    city VARCHAR(100),
    postcode VARCHAR(20),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    school_type VARCHAR(100),
    urn VARCHAR(50) UNIQUE,
    UNIQUE (school_name, postcode)
);

CREATE TABLE classes (
    class_id VARCHAR(255) PRIMARY KEY,
    class_name VARCHAR(255) NOT NULL,
    school_id VARCHAR(255) NOT NULL,
    enrolled_students INT,
    CONSTRAINT fk_school
        FOREIGN KEY(school_id)
        REFERENCES schools(school_id)
        ON DELETE SET NULL
);

CREATE TABLE weeklypractice (
practice_id VARCHAR(255) PRIMARY KEY,
school_id VARCHAR(255),
assignment JSONB,
CONSTRAINT fk_school
        FOREIGN KEY(school_id) 
        REFERENCES schools(school_id)
        ON DELETE SET NULL
);

CREATE TABLE users (
    user_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL, 
    school_id VARCHAR(255) NOT NULL,
	  email VARCHAR(100),
    approved BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_school
        FOREIGN KEY(school_id) 
        REFERENCES schools(school_id)
        ON DELETE SET NULL
);

CREATE TABLE sessions (
    session_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    practice_id VARCHAR(255) NOT NULL,
    school_id VARCHAR(255) NOT NULL,

    sessionData JSONB,
    session_score INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE SET NULL,

    CONSTRAINT fk_practice
        FOREIGN KEY (practice_id)
        REFERENCES weeklypractice (practice_id)
        ON DELETE CASCADE,
        
    CONSTRAINT fk_school
        FOREIGN KEY (school_id)
        REFERENCES schools (school_id)
        ON DELETE CASCADE
);

CREATE TABLE words (
word_id serial PRIMARY KEY,
word varchar(100),
class_year varchar(20),
example JSONB
);

CREATE TABLE userprofile (
    profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id VARCHAR(255) UNIQUE NOT NULL,
    practice_rank INT NOT NULL,
    avatar_name VARCHAR(255),

    CONSTRAINT fk_profile_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE avatars (
	avatar_id UUID PRIMARY KEY  DEFAULT gen_random_uuid(),
	avatar_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE leaderBoard (
    profile_id UUID PRIMARY KEY,

    total_sessions_per_practice_id INT NOT NULL,
    ttotal_score_per_practice_id INT NOT NULL,
    total_incorrect_words_per_practice_id INT NOT NULL,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_leaderboard_profile
        FOREIGN KEY (profile_id)
        REFERENCES userprofile(profile_id)
        ON DELETE CASCADE
);

INSERT INTO schools (
    school_id,
    school_name,
    email,
    phone_number,
    website,
    address_line1,
    city,
    postcode,
    latitude,
    longitude,
    school_type,
    urn
) VALUES
(
    'c8fca0a3-7f50-4c30-9378-334b51b1b26b',
    'Lawrence Primary School',
    'contact@lawrenceprimary.co.uk',
    '01234 567890',
    'https://lawrenceprimary.co.uk',
    '123 Oak Street',
    'London',
    'W1A 1AA',
    51.5074000,
    -0.1278000,
    'Primary',
    '1234567'
),
(
    '9a2b1f6e-2c44-4c1b-ae88-4e8a6d3c2f11',
    'Riverside Academy',
    'info@riversideacademy.org',
    '020 7946 0123',
    'https://riversideacademy.org',
    '45 River Road',
    'Manchester',
    'M1 2AB',
    53.4808000,
    -2.2426000,
    'Secondary',
    '2345678'
),
(
    'f4d7b9a1-1e6a-4d8c-9b9f-7c5e8a2d9c44',
    'Hilltop Community School',
    'admin@hilltopschool.sch.uk',
    '0117 496 0789',
    'https://hilltopschool.sch.uk',
    '78 Summit Lane',
    'Bristol',
    'BS1 5TL',
    51.4545000,
    -2.5879000,
    'Primary',
    '3456789'
);

INSERT INTO avatars (avatar_name)
VALUES
('Adventurer'),
('Avataaars'),
('Adventurer Neutral'),
('Face Generator'),
('Custom Avatar'),
('Bottts'),
('Croodles - Doodle your face'),
('Fun Emoji Set'),
('Bootstrap Icons'),
('Identicon'),
('Lorelei'),
('Lorelei Neutral'),
('Avatar Illustration System'),
('Miniavs - Free Avatar Creator'),
('Open Peeps'),
('Personas by Draftbit'),
('Pixel Art'),
('Pixel Art Neutral'),
('Shapes'),
('Thumbs');

INSERT INTO words (word, class_year, example) VALUES
('accident', 'y3and4words', '{
  "example1": "I spilled my juice on the floor by accident.",
  "example2": "Tom fell off his bike, but it was just an accident and he is okay."
}'::jsonb),

('accidentally', 'y3and4words', '{
  "example1": "I accidentally kicked the football into the teacher’s garden.",
  "example2": "She accidentally dropped her ice cream on the playground."
}'::jsonb),

('actual', 'y3and4words', '{
  "example1": "The actual score of the game was five to three, not four to three.",
  "example2": "This is the actual book I was looking for in the library."
}'::jsonb),

('actually', 'y3and4words', '{
  "example1": "I actually like carrots when they are cooked with honey.",
  "example2": "He said he was scared, but he was actually very brave."
}'::jsonb),

('address', 'y3and4words', '{
  "example1": "We wrote our home address on the postcard to Grandma.",
  "example2": "The teacher asked me to read the school’s address aloud."
}'::jsonb),

('answer', 'y3and4words', '{
  "example1": "I knew the answer to the maths question on the board.",
  "example2": "She put her hand up quickly to give the answer."
}'::jsonb),

('appear', 'y3and4words', '{
  "example1": "A rainbow will appear after the rain stops.",
  "example2": "The magician made the rabbit appear out of the hat."
}'::jsonb),

('arrive', 'y3and4words', '{
  "example1": "We will arrive at the zoo just before lunchtime.",
  "example2": "My friends arrive at school early to play football."
}'::jsonb),

('believe', 'y3and4words', '{
  "example1": "I believe my team will win the football match.",
  "example2": "She couldn’t believe how big the cake was."
}'::jsonb),

('bicycle', 'y3and4words', '{
  "example1": "I rode my bicycle to the park after school.",
  "example2": "He learned to ride a bicycle without stabilisers."
}'::jsonb),
('breath', 'y3and4words', '{
  "example1": "After running fast, I had to stop to catch my breath.",
  "example2": "She took a deep breath before jumping into the pool."
}'::jsonb),

('breathe', 'y3and4words', '{
  "example1": "You need to breathe slowly when you blow up a balloon.",
  "example2": "The doctor told me to breathe in and out carefully."
}'::jsonb),

('build', 'y3and4words', '{
  "example1": "We tried to build the tallest tower with toy blocks.",
  "example2": "Dad helped me build a den in the garden."
}'::jsonb),

('busy', 'y3and4words', '{
  "example1": "The playground was busy with children playing tag.",
  "example2": "Mum was busy cooking dinner while we set the table."
}'::jsonb),

('business', 'y3and4words', '{
  "example1": "He started a pretend sweet shop business at playtime.",
  "example2": "They talked about their family business that sells bread."
}'::jsonb),

('calendar', 'y3and4words', '{
  "example1": "I circled my birthday on the calendar with a red pen.",
  "example2": "The teacher used the calendar to show us the holidays."
}'::jsonb),

('caught', 'y3and4words', '{
  "example1": "I caught the ball during our football game.",
  "example2": "She caught a butterfly gently in her hands."
}'::jsonb),

('centre', 'y3and4words', '{
  "example1": "We stood in the centre of the playground to start the game.",
  "example2": "There was a fountain in the centre of the park."
}'::jsonb),

('century', 'y3and4words', '{
  "example1": "We learned in history that a century is one hundred years.",
  "example2": "The castle was built many centuries ago."
}'::jsonb),

('certain', 'y3and4words', '{
  "example1": "I am certain I left my toy car on the table.",
  "example2": "She was certain it would rain because of the dark clouds."
}'::jsonb),
('circle', 'y3and4words', '{
  "example1": "We sat in a circle on the carpet for story time.",
  "example2": "He drew a big circle around the answer in his book."
}'::jsonb),

('complete', 'y3and4words', '{
  "example1": "I worked hard to complete my homework before dinner.",
  "example2": "She was happy to complete the jigsaw puzzle."
}'::jsonb),

('consider', 'y3and4words', '{
  "example1": "You should consider taking your raincoat if the sky is grey.",
  "example2": "I will consider which toy to bring for show-and-tell."
}'::jsonb),

('continue', 'y3and4words', '{
  "example1": "We will continue the story tomorrow in class.",
  "example2": "He asked to continue playing after playtime ended."
}'::jsonb),

('decide', 'y3and4words', '{
  "example1": "I couldn’t decide between pizza or pasta for lunch.",
  "example2": "She will decide which game we should play."
}'::jsonb),

('describe', 'y3and4words', '{
  "example1": "Can you describe what your new puppy looks like?",
  "example2": "The teacher asked us to describe the monster in the story."
}'::jsonb),

('different', 'y3and4words', '{
  "example1": "We chose different flavours of ice cream at the shop.",
  "example2": "Our shoes are the same colour but different sizes."
}'::jsonb),

('difficult', 'y3and4words', '{
  "example1": "The maths question was difficult, but I tried my best.",
  "example2": "Climbing the tall tree was difficult for me."
}'::jsonb),

('disappear', 'y3and4words', '{
  "example1": "The magician made the coin disappear in his hand.",
  "example2": "My homework seemed to disappear from my desk!"
}'::jsonb),

('early', 'y3and4words', '{
  "example1": "We woke up early to catch the school bus.",
  "example2": "He arrived early to get the best seat in class."
}'::jsonb),

('earth', 'y3and4words', '{
  "example1": "We planted flowers in the soft earth of the garden.",
  "example2": "Our planet Earth is round like a ball."
}'::jsonb),

('eight', 'y3and4words', '{
  "example1": "I ate eight strawberries for snack time.",
  "example2": "There are eight crayons in my pencil case."
}'::jsonb),

('eighth', 'y3and4words', '{
  "example1": "I came eighth in the running race at sports day.",
  "example2": "She was happy to finish in eighth place."
}'::jsonb),

('enough', 'y3and4words', '{
  "example1": "I had enough biscuits to share with my friends.",
  "example2": "There wasn’t enough milk for everyone’s cereal."
}'::jsonb),

('exercise', 'y3and4words', '{
  "example1": "We did exercise in the playground by running laps.",
  "example2": "Skipping rope is my favourite kind of exercise."
}'::jsonb),

('experience', 'y3and4words', '{
  "example1": "The school trip to the zoo was an amazing experience.",
  "example2": "Helping Mum bake a cake was a fun experience."
}'::jsonb),

('experiment', 'y3and4words', '{
  "example1": "We did a science experiment with vinegar and baking soda.",
  "example2": "The experiment showed how plants grow in sunlight."
}'::jsonb),

('extreme', 'y3and4words', '{
  "example1": "It was extreme fun sliding down the giant slide.",
  "example2": "The extreme cold made us wear extra coats."
}'::jsonb),

('famous', 'y3and4words', '{
  "example1": "Harry Potter is a famous story that many children love.",
  "example2": "The famous footballer scored a goal on TV."
}'::jsonb),

('favourite', 'y3and4words', '{
  "example1": "Chocolate ice cream is my favourite flavour.",
  "example2": "My favourite cartoon is about talking animals."
}'::jsonb),
('February', 'y3and4words', '{
  "example1": "My birthday is in February, the shortest month of the year.",
  "example2": "In February, we made Valentine cards at school."
}'::jsonb),

('forward', 'y3and4words', '{
  "example1": "The football rolled forward into the goal.",
  "example2": "She stepped forward to collect her prize."
}'::jsonb),

('forwards', 'y3and4words', '{
  "example1": "I leaned forwards to see the picture better.",
  "example2": "The car moved forwards slowly in the traffic."
}'::jsonb),

('fruit', 'y3and4words', '{
  "example1": "I ate a piece of fruit at snack time.",
  "example2": "Bananas are my favourite kind of fruit."
}'::jsonb),

('grammar', 'y3and4words', '{
  "example1": "We learned grammar by writing full sentences in class.",
  "example2": "Good grammar helps make stories easy to read."
}'::jsonb),

('group', 'y3and4words', '{
  "example1": "We worked in a group to build a Lego tower.",
  "example2": "A group of children played tag in the playground."
}'::jsonb),

('guard', 'y3and4words', '{
  "example1": "A guard stood outside the castle in our storybook.",
  "example2": "He acted like a guard to protect the fort we built."
}'::jsonb),

('guide', 'y3and4words', '{
  "example1": "The park guide showed us where the animals live.",
  "example2": "The map will guide us to the treasure in the game."
}'::jsonb),

('heard', 'y3and4words', '{
  "example1": "I heard birds singing outside my window this morning.",
  "example2": "She heard her friend calling across the playground."
}'::jsonb),

('heart', 'y3and4words', '{
  "example1": "My heart beats faster when I run very fast.",
  "example2": "He drew a heart on his Valentine’s card."
}'::jsonb),

('height', 'y3and4words', '{
  "example1": "The height of the slide made it a little scary.",
  "example2": "We measured the height of our sunflower plant."
}'::jsonb),

('history', 'y3and4words', '{
  "example1": "We learned history about kings and queens of the past.",
  "example2": "The museum showed us history from Roman times."
}'::jsonb),

('imagine', 'y3and4words', '{
  "example1": "I like to imagine flying like a superhero.",
  "example2": "She can imagine living in a castle with dragons."
}'::jsonb),

('increase', 'y3and4words', '{
  "example1": "The teacher said we should increase the volume of our voices.",
  "example2": "The number of toys on the shelf began to increase."
}'::jsonb),

('important', 'y3and4words', '{
  "example1": "It is important to wash your hands before eating.",
  "example2": "She had an important job as line leader today."
}'::jsonb),

('interest', 'y3and4words', '{
  "example1": "I have an interest in dinosaurs and space rockets.",
  "example2": "He showed great interest in drawing cartoons."
}'::jsonb),

('island', 'y3and4words', '{
  "example1": "We pretended the sandpit was a desert island.",
  "example2": "The story was about pirates on a tropical island."
}'::jsonb),

('knowledge', 'y3and4words', '{
  "example1": "Reading books gives you knowledge about the world.",
  "example2": "She used her knowledge of animals to answer the quiz."
}'::jsonb),

('learn', 'y3and4words', '{
  "example1": "I want to learn how to play the guitar.",
  "example2": "We learn new spelling words every week."
}'::jsonb),

('length', 'y3and4words', '{
  "example1": "We measured the length of the classroom with steps.",
  "example2": "The length of the rope was enough to tie the swing."
}'::jsonb),
('library', 'y3and4words', '{
  "example1": "I borrowed a storybook from the school library.",
  "example2": "The library was quiet while children read books."
}'::jsonb),

('material', 'y3and4words', '{
  "example1": "We used shiny material to make costumes for the play.",
  "example2": "The blanket was made from soft material."
}'::jsonb),

('medicine', 'y3and4words', '{
  "example1": "The doctor gave me medicine when I had a cold.",
  "example2": "I took my medicine with a spoonful of water."
}'::jsonb),

('mention', 'y3and4words', '{
  "example1": "Don’t forget to mention your homework in class.",
  "example2": "She didn’t mention the surprise party to her friend."
}'::jsonb),

('minute', 'y3and4words', '{
  "example1": "It only takes a minute to brush your teeth quickly.",
  "example2": "We waited a minute for the game to begin."
}'::jsonb),

('natural', 'y3and4words', '{
  "example1": "We saw many natural things like trees and rivers on our walk.",
  "example2": "Honey is a natural food made by bees."
}'::jsonb),

('naughty', 'y3and4words', '{
  "example1": "The naughty puppy chewed my favourite shoes.",
  "example2": "He was naughty for drawing on the wall with crayons."
}'::jsonb),

('notice', 'y3and4words', '{
  "example1": "Did you notice the rainbow after the rain?",
  "example2": "She didn’t notice her toy was under the chair."
}'::jsonb),

('occasion', 'y3and4words', '{
  "example1": "On special occasion we eat cake together.",
  "example2": "Her birthday was a happy occasion for the whole family."
}'::jsonb),

('occasionally', 'y3and4words', '{
  "example1": "We occasionally go to the cinema at the weekend.",
  "example2": "He occasionally visits his grandparents in the countryside."
}'::jsonb),

('often', 'y3and4words', '{
  "example1": "I often ride my bike after school.",
  "example2": "We often play football at playtime."
}'::jsonb),

('opposite', 'y3and4words', '{
  "example1": "The sweet shop is opposite the park.",
  "example2": "Happy is the opposite of sad."
}'::jsonb),

('ordinary', 'y3and4words', '{
  "example1": "It looked like an ordinary box, but it had a toy inside.",
  "example2": "She wore her ordinary shoes, not the fancy ones."
}'::jsonb),

('particular', 'y3and4words', '{
  "example1": "I like this particular cartoon because it’s funny.",
  "example2": "He chose a particular toy from the shelf."
}'::jsonb),

('peculiar', 'y3and4words', '{
  "example1": "The cat made a peculiar sound in the garden.",
  "example2": "He wore a peculiar hat that made us laugh."
}'::jsonb),

('perhaps', 'y3and4words', '{
  "example1": "Perhaps we will go swimming tomorrow if it’s sunny.",
  "example2": "She thought, perhaps, the box had a surprise inside."
}'::jsonb),

('popular', 'y3and4words', '{
  "example1": "Football is a popular game at our school.",
  "example2": "The most popular book in the library was borrowed first."
}'::jsonb),

('position', 'y3and4words', '{
  "example1": "I changed my position on the bench to see better.",
  "example2": "He took his position as goalkeeper in football."
}'::jsonb),

('possess', 'y3and4words', '{
  "example1": "I possess a collection of shiny marbles.",
  "example2": "She possesses a big box of colourful crayons."
}'::jsonb),

('possession', 'y3and4words', '{
  "example1": "My teddy bear is my most loved possession.",
  "example2": "His football cards are his favourite possession."
}'::jsonb),
('possible', 'y3and4words', '{
  "example1": "It is possible to finish your homework before dinner.",
  "example2": "Anything is possible if you keep trying."
}'::jsonb),

('potatoes', 'y3and4words', '{
  "example1": "We had roast potatoes with our Sunday lunch.",
  "example2": "She helped peel the potatoes for dinner."
}'::jsonb),

('pressure', 'y3and4words', '{
  "example1": "The pressure of the ball made it bounce high.",
  "example2": "He felt pressure to answer the hard question."
}'::jsonb),

('probably', 'y3and4words', '{
  "example1": "It will probably rain, so bring your umbrella.",
  "example2": "She will probably choose chocolate cake for pudding."
}'::jsonb),

('promise', 'y3and4words', '{
  "example1": "I promise to feed the class fish every morning.",
  "example2": "He made a promise to play kindly with his friends."
}'::jsonb),

('purpose', 'y3and4words', '{
  "example1": "The purpose of a pencil is to help you write.",
  "example2": "She asked the purpose of the buttons on the toy."
}'::jsonb),

('quarter', 'y3and4words', '{
  "example1": "I ate a quarter of the big pizza.",
  "example2": "He gave me a quarter of his chocolate bar."
}'::jsonb),

('question', 'y3and4words', '{
  "example1": "I asked the teacher a question about the story.",
  "example2": "She raised her hand to answer a question in maths."
}'::jsonb),

('recent', 'y3and4words', '{
  "example1": "In a recent game, our team scored three goals.",
  "example2": "A recent trip to the zoo was really exciting."
}'::jsonb),

('regular', 'y3and4words', '{
  "example1": "Brushing your teeth is a regular habit every day.",
  "example2": "He goes for a regular swim on Saturdays."
}'::jsonb),

('reign', 'y3and4words', '{
  "example1": "The reign of the king lasted many years.",
  "example2": "We learned about Queen Victoria’s reign in history."
}'::jsonb),

('remember', 'y3and4words', '{
  "example1": "I must remember to bring my homework tomorrow.",
  "example2": "She tried to remember the words to the song."
}'::jsonb),

('sentence', 'y3and4words', '{
  "example1": "We had to write a sentence using the word ‘dog’.",
  "example2": "He finished his story with a very long sentence."
}'::jsonb),

('separate', 'y3and4words', '{
  "example1": "Please separate the red bricks from the blue ones.",
  "example2": "We had to separate into two teams for the game."
}'::jsonb),

('special', 'y3and4words', '{
  "example1": "My birthday cake was very special because it had my name on it.",
  "example2": "She wore a special dress for the school play."
}'::jsonb),

('straight', 'y3and4words', '{
  "example1": "Draw a straight line with your ruler.",
  "example2": "He ran straight to the playground when school ended."
}'::jsonb),

('strange', 'y3and4words', '{
  "example1": "We heard a strange noise coming from the attic.",
  "example2": "The drink had a strange but nice taste."
}'::jsonb),

('strength', 'y3and4words', '{
  "example1": "She used all her strength to carry the heavy bag.",
  "example2": "The bridge was strong because of its strength."
}'::jsonb),

('suppose', 'y3and4words', '{
  "example1": "I suppose we can play outside if the sun shines.",
  "example2": "He didn’t suppose the puzzle would be so easy."
}'::jsonb),

('surprise', 'y3and4words', '{
  "example1": "It was a surprise when my friends shouted ‘Happy Birthday!’",
  "example2": "She found a surprise toy inside the chocolate egg."
}'::jsonb),

('therefore', 'y3and4words', '{
  "example1": "I was hungry, therefore I made a sandwich.",
  "example2": "It rained all day; therefore, the match was cancelled."
}'::jsonb),

('though', 'y3and4words', '{
  "example1": "I was tired, though I still finished my homework.",
  "example2": "Though it was raining, we played football anyway."
}'::jsonb),

('although', 'y3and4words', '{
  "example1": "Although the cake was small, it was very tasty.",
  "example2": "Although he was nervous, he sang the song loudly."
}'::jsonb),

('thought', 'y3and4words', '{
  "example1": "I thought the movie was really funny.",
  "example2": "She thought the puppy was the cutest thing ever."
}'::jsonb),

('through', 'y3and4words', '{
  "example1": "We walked through the park to get to school.",
  "example2": "He peeped through the window to see inside."
}'::jsonb),

('various', 'y3and4words', '{
  "example1": "There were various games to play at the fair.",
  "example2": "We tried various toppings on our pizza."
}'::jsonb),

('weight', 'y3and4words', '{
  "example1": "The weight of the bag made it hard to carry.",
  "example2": "She guessed the weight of the pumpkin at the fair."
}'::jsonb),

('woman', 'y3and4words', '{
  "example1": "The woman at the shop gave me some sweets.",
  "example2": "We saw a woman walking her dog in the park."
}'::jsonb),

('women', 'y3and4words', '{
  "example1": "The women in the choir sang beautifully.",
  "example2": "Two women were reading books in the library."
}'::jsonb),
('accompany', 'y5and6words', '{
  "example1": "Mum asked me to accompany her to the supermarket.",
  "example2": "A friend will accompany me to football practice."
}'::jsonb),

('according', 'y5and6words', '{
  "example1": "According to the weather forecast, it might snow tomorrow.",
  "example2": "According to my teacher, we must finish our reading first."
}'::jsonb),

('achieve', 'y5and6words', '{
  "example1": "I worked hard to achieve my swimming badge.",
  "example2": "She was proud to achieve her goal of finishing the race."
}'::jsonb),

('aggressive', 'y5and6words', '{
  "example1": "The aggressive dog barked loudly at the gate.",
  "example2": "He played too aggressive during the football match."
}'::jsonb),

('amateur', 'y5and6words', '{
  "example1": "He is an amateur guitar player who just started learning.",
  "example2": "Our school football team is made of amateur players."
}'::jsonb),

('ancient', 'y5and6words', '{
  "example1": "We saw ancient Roman coins in the museum.",
  "example2": "The story was set in ancient Egypt with pyramids."
}'::jsonb),

('apparent', 'y5and6words', '{
  "example1": "It was apparent that she was happy when she smiled.",
  "example2": "The mistake was apparent once we checked the answers."
}'::jsonb),

('appreciate', 'y5and6words', '{
  "example1": "I really appreciate your help with my homework.",
  "example2": "She wanted to appreciate the painting by looking closely."
}'::jsonb),

('attached', 'y5and6words', '{
  "example1": "The note was attached to the fridge with a magnet.",
  "example2": "He felt attached to his favourite teddy bear."
}'::jsonb),

('available', 'y5and6words', '{
  "example1": "The new football boots were not available in my size.",
  "example2": "There were no seats available on the bus."
}'::jsonb),

('average', 'y5and6words', '{
  "example1": "The average of 2, 4 and 6 is 4.",
  "example2": "On average, I read two books every week."
}'::jsonb),

('awkward', 'y5and6words', '{
  "example1": "It was awkward when I forgot my lines in the play.",
  "example2": "He felt awkward because he wore odd socks to school."
}'::jsonb),

('bargain', 'y5and6words', '{
  "example1": "We found a bargain on football stickers at the shop.",
  "example2": "Mum said the toy was a real bargain because it was cheap."
}'::jsonb),

('bruise', 'y5and6words', '{
  "example1": "He got a bruise on his knee after falling in the playground.",
  "example2": "The apple had a bruise where it had been dropped."
}'::jsonb),

('category', 'y5and6words', '{
  "example1": "We sorted the animals into the category of mammals and birds.",
  "example2": "Fiction is one category of books in the library."
}'::jsonb),

('cemetery', 'y5and6words', '{
  "example1": "We walked past an old cemetery near the church.",
  "example2": "The cemetery was full of ancient gravestones."
}'::jsonb),

('committee', 'y5and6words', '{
  "example1": "The school council is a committee of children who make decisions.",
  "example2": "A committee planned the summer fair together."
}'::jsonb),

('communicate', 'y5and6words', '{
  "example1": "We use walkie-talkies to communicate during games.",
  "example2": "She learned to communicate with her friend using sign language."
}'::jsonb),

('community', 'y5and6words', '{
  "example1": "Our community planted trees in the park together.",
  "example2": "The library is an important part of our community."
}'::jsonb),

('competition', 'y5and6words', '{
  "example1": "We entered a drawing competition at school.",
  "example2": "He won a medal in the football competition."
}'::jsonb),
('conscience', 'y5and6words', '{
  "example1": "His conscience told him to return the toy he found.",
  "example2": "She felt guilty because her conscience said it was wrong."
}'::jsonb),

('conscious', 'y5and6words', '{
  "example1": "He was conscious after falling and knew where he was.",
  "example2": "She was conscious of everyone watching her on stage."
}'::jsonb),

('controversy', 'y5and6words', '{
  "example1": "There was controversy about who won the race.",
  "example2": "The book caused controversy because people had different opinions."
}'::jsonb),

('convenience', 'y5and6words', '{
  "example1": "We bought snacks at the convenience shop near school.",
  "example2": "The bus stop is there for the convenience of the children."
}'::jsonb),

('correspond', 'y5and6words', '{
  "example1": "I like to correspond with my cousin by writing letters.",
  "example2": "The answers correspond to the questions on the sheet."
}'::jsonb),

('criticise', 'y5and6words', '{
  "example1": "The teacher did not criticise my work; she helped me improve it.",
  "example2": "It’s not kind to criticise your friends when they try hard."
}'::jsonb),

('curiosity', 'y5and6words', '{
  "example1": "Her curiosity made her open the mysterious box.",
  "example2": "He asked questions out of curiosity about space rockets."
}'::jsonb),

('definite', 'y5and6words', '{
  "example1": "There is a definite answer to this maths question.",
  "example2": "It’s definite that we will go swimming on Friday."
}'::jsonb),

('desperate', 'y5and6words', '{
  "example1": "He was desperate to find his lost football card.",
  "example2": "She felt desperate to finish the race before it rained."
}'::jsonb),

('determined', 'y5and6words', '{
  "example1": "She was determined to score a goal in the match.",
  "example2": "He was determined to finish reading the long book."
}'::jsonb),

('develop', 'y5and6words', '{
  "example1": "The baby birds will develop wings so they can fly.",
  "example2": "He wants to develop his drawing skills by practising daily."
}'::jsonb),

('dictionary', 'y5and6words', '{
  "example1": "I used a dictionary to find the meaning of the word.",
  "example2": "The teacher showed us how to use a dictionary in class."
}'::jsonb),

('disastrous', 'y5and6words', '{
  "example1": "Forgetting my lines in the play felt disastrous to me.",
  "example2": "The picnic was disastrous because it rained all day."
}'::jsonb),

('embarrass', 'y5and6words', '{
  "example1": "I didn’t want to embarrass myself by tripping on stage.",
  "example2": "He turned red when his joke didn’t work and it embarrassed him."
}'::jsonb),

('environment', 'y5and6words', '{
  "example1": "We must keep our environment clean by picking up litter.",
  "example2": "Trees are an important part of the environment."
}'::jsonb),

('equip', 'y5and6words', '{
  "example1": "The coach will equip us with new footballs for training.",
  "example2": "We need to equip the tent with poles before camping."
}'::jsonb),

('especially', 'y5and6words', '{
  "example1": "I love all fruit, especially strawberries.",
  "example2": "She enjoys sports, especially swimming at the pool."
}'::jsonb),

('exaggerate', 'y5and6words', '{
  "example1": "He likes to exaggerate by saying his fish was as big as a shark.",
  "example2": "She might exaggerate the story to make it sound funnier."
}'::jsonb),

('excellent', 'y5and6words', '{
  "example1": "You gave an excellent answer in class today.",
  "example2": "That was an excellent goal in the football game."
}'::jsonb),

('existence', 'y5and6words', '{
  "example1": "Dinosaurs are no longer in existence.",
  "example2": "The book talked about the existence of planets in space."
}'::jsonb),
('explanation', 'y5and6words', '{
  "example1": "The teacher gave a clear explanation of the science experiment.",
  "example2": "I need an explanation for why my homework is missing."
}'::jsonb),

('familiar', 'y5and6words', '{
  "example1": "The song sounded familiar because I heard it before.",
  "example2": "Her face looked familiar from the playground."
}'::jsonb),

('foreign', 'y5and6words', '{
  "example1": "We tried foreign food when we went on holiday.",
  "example2": "He learned a few foreign words from his pen pal."
}'::jsonb),

('forty', 'y5and6words', '{
  "example1": "There are forty children in the school choir.",
  "example2": "We counted forty steps to the top of the hill."
}'::jsonb),

('frequently', 'y5and6words', '{
  "example1": "I frequently ride my bike after school.",
  "example2": "She frequently visits the library to borrow books."
}'::jsonb),

('government', 'y5and6words', '{
  "example1": "The government makes rules to keep people safe.",
  "example2": "We learned about the government in our history lesson."
}'::jsonb),

('guarantee', 'y5and6words', '{
  "example1": "The shop gave a guarantee that the toy would work.",
  "example2": "I can’t guarantee it will be sunny tomorrow."
}'::jsonb),

('harass', 'y5and6words', '{
  "example1": "It is unkind to harass someone by calling them names.",
  "example2": "The teacher told us not to harass the animals at the farm."
}'::jsonb),

('hindrance', 'y5and6words', '{
  "example1": "Carrying a heavy bag was a hindrance when I ran.",
  "example2": "Loud noise can be a hindrance when you’re trying to read."
}'::jsonb),

('identity', 'y5and6words', '{
  "example1": "She showed her identity with a school card.",
  "example2": "His superhero identity was kept secret."
}'::jsonb),

('immediate', 'y5and6words', '{
  "example1": "The fire alarm made us leave the building immediate.",
  "example2": "He gave an immediate answer to the easy question."
}'::jsonb),

('individual', 'y5and6words', '{
  "example1": "Each individual in the class has their own desk.",
  "example2": "An individual ant can carry more than its own weight."
}'::jsonb),

('interfere', 'y5and6words', '{
  "example1": "Don’t interfere when two people are playing happily.",
  "example2": "The referee will interfere if the football match isn’t fair."
}'::jsonb),

('interrupt', 'y5and6words', '{
  "example1": "It’s rude to interrupt when someone is speaking.",
  "example2": "He had to interrupt the game because it started raining."
}'::jsonb),

('language', 'y5and6words', '{
  "example1": "English is the language we speak at school.",
  "example2": "She learned a new language while travelling abroad."
}'::jsonb),

('leisure', 'y5and6words', '{
  "example1": "In my leisure time, I like to draw cartoons.",
  "example2": "He spent his leisure time playing football in the park."
}'::jsonb),

('lightning', 'y5and6words', '{
  "example1": "A flash of lightning lit up the sky.",
  "example2": "The lightning was followed by a loud clap of thunder."
}'::jsonb),

('marvellous', 'y5and6words', '{
  "example1": "We had a marvellous time at the funfair.",
  "example2": "The magician performed a marvellous trick with cards."
}'::jsonb),

('mischievous', 'y5and6words', '{
  "example1": "The mischievous cat knocked over the flowerpot.",
  "example2": "He gave a mischievous smile before hiding my pencil."
}'::jsonb),

('muscle', 'y5and6words', '{
  "example1": "I used my arm muscle to lift the heavy box.",
  "example2": "He stretched his leg muscle before running the race."
}'::jsonb),
('necessary', 'y5and6words', '{
  "example1": "It is necessary to wear a helmet when riding a bike.",
  "example2": "Water is necessary for plants to grow."
}'::jsonb),

('neighbour', 'y5and6words', '{
  "example1": "Our neighbour gave us apples from her tree.",
  "example2": "We asked the neighbour to look after our cat."
}'::jsonb),

('nuisance', 'y5and6words', '{
  "example1": "The buzzing fly was a nuisance during lunch.",
  "example2": "Losing my pencil again was such a nuisance."
}'::jsonb),

('occupy', 'y5and6words', '{
  "example1": "The children occupy the swings every playtime.",
  "example2": "We used books to occupy the empty shelf."
}'::jsonb),

('occur', 'y5and6words', '{
  "example1": "A solar eclipse can occur in the daytime.",
  "example2": "The idea didn’t occur to me until later."
}'::jsonb),

('opportunity', 'y5and6words', '{
  "example1": "She had the opportunity to play piano in the concert.",
  "example2": "He grabbed the opportunity to score a goal."
}'::jsonb),

('parliament', 'y5and6words', '{
  "example1": "We learned that parliament makes laws for the country.",
  "example2": "Parliament is where leaders meet to talk and decide."
}'::jsonb),

('persuade', 'y5and6words', '{
  "example1": "I tried to persuade my friend to join the game.",
  "example2": "She persuaded her parents to let her stay up late."
}'::jsonb),

('physical', 'y5and6words', '{
  "example1": "We did physical exercise in the school gym.",
  "example2": "Football is a very physical sport."
}'::jsonb),

('prejudice', 'y5and6words', '{
  "example1": "The teacher explained that prejudice means judging unfairly.",
  "example2": "Stories help us understand why prejudice is wrong."
}'::jsonb),

('privilege', 'y5and6words', '{
  "example1": "It’s a privilege to be the first to use the new football.",
  "example2": "Having clean water is a privilege not everyone has."
}'::jsonb),

('profession', 'y5and6words', '{
  "example1": "Being a doctor is a very important profession.",
  "example2": "She chose teaching as her profession."
}'::jsonb),

('programme', 'y5and6words', '{
  "example1": "We watched a cartoon programme on TV.",
  "example2": "The summer programme included sports and games."
}'::jsonb),

('pronunciation', 'y5and6words', '{
  "example1": "The teacher helped me with the pronunciation of a tricky word.",
  "example2": "His pronunciation of the new language was very good."
}'::jsonb),

('queue', 'y5and6words', '{
  "example1": "We had to queue for ice cream at the fair.",
  "example2": "The queue for the bus was very long."
}'::jsonb),

('recognise', 'y5and6words', '{
  "example1": "I didn’t recognise my friend in her new costume.",
  "example2": "She could recognise her teacher’s voice on the phone."
}'::jsonb),

('recommend', 'y5and6words', '{
  "example1": "I recommend this book because it’s funny and exciting.",
  "example2": "The coach will recommend the best shoes for running."
}'::jsonb),

('relevant', 'y5and6words', '{
  "example1": "Your answer must be relevant to the question.",
  "example2": "The story was relevant to our history lesson."
}'::jsonb),

('restaurant', 'y5and6words', '{
  "example1": "We went to a restaurant for pizza on Saturday.",
  "example2": "The restaurant was full of people eating lunch."
}'::jsonb),

('rhyme', 'y5and6words', '{
  "example1": "Cat and hat make a rhyme.",
  "example2": "We wrote a poem with a rhyme at the end."
}'::jsonb),
('rhythm', 'y5and6words', '{
  "example1": "The drummer kept a steady rhythm in the song.",
  "example2": "We clapped to the rhythm during music class."
}'::jsonb),

('sacrifice', 'y5and6words', '{
  "example1": "He made a sacrifice by giving up his turn for his friend.",
  "example2": "The firefighter’s sacrifice kept everyone safe."
}'::jsonb),

('secretary', 'y5and6words', '{
  "example1": "The secretary helped organise the school letters.",
  "example2": "She asked the secretary for the meeting schedule."
}'::jsonb),

('shoulder', 'y5and6words', '{
  "example1": "He carried his school bag on one shoulder.",
  "example2": "I rested my head on Mum’s shoulder when I was tired."
}'::jsonb),

('signature', 'y5and6words', '{
  "example1": "I wrote my signature at the bottom of the card.",
  "example2": "The teacher asked for a parent’s signature on the form."
}'::jsonb),

('sincere', 'y5and6words', '{
  "example1": "She gave a sincere apology for breaking the toy.",
  "example2": "His smile was kind and sincere."
}'::jsonb),

('soldier', 'y5and6words', '{
  "example1": "The soldier marched proudly in his uniform.",
  "example2": "We read about a brave soldier in history class."
}'::jsonb),

('stomach', 'y5and6words', '{
  "example1": "I had a sore stomach after eating too much cake.",
  "example2": "Butterflies filled my stomach before the play started."
}'::jsonb),

('sufficient', 'y5and6words', '{
  "example1": "We had sufficient water for the whole picnic.",
  "example2": "There was sufficient time to finish the test."
}'::jsonb),

('suggest', 'y5and6words', '{
  "example1": "I suggest we play football after lunch.",
  "example2": "She will suggest a new game for playtime."
}'::jsonb),

('symbol', 'y5and6words', '{
  "example1": "A heart is a symbol of love.",
  "example2": "The school badge is our symbol of teamwork."
}'::jsonb),

('system', 'y5and6words', '{
  "example1": "The solar system has eight planets.",
  "example2": "The school has a system for borrowing books."
}'::jsonb),

('temperature', 'y5and6words', '{
  "example1": "The temperature dropped and it started to snow.",
  "example2": "The nurse checked my temperature when I felt ill."
}'::jsonb),

('thorough', 'y5and6words', '{
  "example1": "He gave the room a thorough clean before guests arrived.",
  "example2": "The teacher did a thorough check of our homework."
}'::jsonb),

('twelfth', 'y5and6words', '{
  "example1": "My birthday is on the twelfth of June.",
  "example2": "She was twelfth in the line for the bus."
}'::jsonb),

('variety', 'y5and6words', '{
  "example1": "The fruit bowl had a variety of apples and bananas.",
  "example2": "We played a variety of games at the party."
}'::jsonb),

('vegetable', 'y5and6words', '{
  "example1": "Carrots are my favourite vegetable.",
  "example2": "We grew a vegetable garden behind the house."
}'::jsonb),

('vehicle', 'y5and6words', '{
  "example1": "A bus is a vehicle that carries many people.",
  "example2": "Dad parked the vehicle outside the shop."
}'::jsonb),

('yacht', 'y5and6words', '{
  "example1": "We saw a big yacht sailing in the harbour.",
  "example2": "The yacht had tall white sails."
}'::jsonb);