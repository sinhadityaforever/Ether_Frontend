const express = require("express");

const router = express.Router();
const pool = require("../db");

router.patch("/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const notifToken = req.body.notif_token;
    try {
      await pool.query(`UPDATE users SET notif_token = 'Logged Out' WHERE notif_token=($1)`, [notifToken])
    } catch (error) {
      console.log(error)
    }
    
    await pool.query(`UPDATE users SET notif_token = ($1) WHERE id =($2)`, [
      notifToken,
      id,
    ]);
    res.status(200).json({
      message: notifToken,
    });
  } catch (error) {
    res.status(400).json({ error: error });
  }
});

router.delete("/:id", async (req, res) => {
  try {
    const id = req.params.id;
    await pool.query(
      "UPDATE users SET notif_token = 'LOGGED_OUT' WHERE id =($1)",
      [id]
    );
    res.status(200).json({ message: "Successfully deleted" });
  } catch (error) {
    res.status(400).json(error);
  }
});

module.exports = router;
