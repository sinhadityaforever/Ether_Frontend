const express = require("express");
const router = express.Router();
const pool = require("../db");
const CheckAuth = require("./middleware/check-auth");

//Write queries here by using router.get, router.post etc

//POST REQUEST WILL BE NEEDED ON THE INTEREST SCREEN AFTER THE SIGNUP
router.post("/:user_id", CheckAuth, async(req, res) => {
    try {
        const interest = req.body.interest;
        const userId = req.params.user_id;
        await pool.query(
            `INSERT INTO interests(user_id, interests)
            VALUES (($1), ($2))`, [userId, interest]
        );
        res.status(200).json({
            message: "Interest added successfully",
        });
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

//GET ROUTER TO BE USED AT THE PROFILE VIEW SCREEN TO SHOW THE INTERESTS OF THE USER
router.get("/:user_id", CheckAuth, async(req, res) => {
    try {
        const userId = req.params.user_id;
        const result = await pool.query(
            `SELECT * FROM interests WHERE user_id = ($1)`, [userId]
        );
        res.status(200).json({
            result: result.rows,
        });
    } catch (error) {
        res.status(400).json({
            error: error,
        });
    }
});

//DELETE ROUTER TO BE USED IN THE INTEREST PAGE IN TIME OF USER ENTRY AND IN THE TIME OF EDITING HIS INTERSTS
router.delete("/:user_id", CheckAuth, async(req, res) => {
    try {
        const user_id = req.params.user_id;
        const todelete = req.body.interest;
        await pool.query(
            `DELETE FROM interests WHERE user_id = ($1) AND interests = ($2)`, [user_id, todelete]
        );
        res.status(200).json({
            message: "interest succesfully deleted",
        });
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

module.exports = router;