const pool = require('../utils/db/db')

exports.getLeaderBoardPerPracticeId = async (req, res, next) => {
  const { practice_id } = req.params
  try {
    const query = `
   select 
users.name,
users.user_id, 
sessions.practice_id, 
sum(sessions.session_score) as total_score
from users
join sessions on sessions.user_id = users.user_id
where sessions.practice_id = $1
group by (users.user_id, sessions.user_id, sessions.practice_id)

    `;

    const result = (await pool.query(query,[practice_id])).rows

    res.status(200).json({
      status: 'Success',
      result
    });

  } catch (error) {
    console.error("Error fetching leaderboard data: ", error);
    res.status(500).json({ error: "Failed to fetch leaderboard data." });
  }
  next()
}