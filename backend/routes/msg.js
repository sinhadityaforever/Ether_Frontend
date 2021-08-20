const express = require("express");
const CheckAuth = require("./middleware/check-auth");
const router = express.Router();
const pool = require("../db");

//Write queries here by using router.get, router.post etc
router.get("/:id", async(req, res) => {
    try {
        const id = req.params.id;
        const result = await pool.query(
            `SELECT * FROM msg
           WHERE sender_id = ($1) OR reciever_id = ($1)
           ORDER BY created_at;`, [id]
        );
        res.status(200).json(result.rows);
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

//

module.exports = router;