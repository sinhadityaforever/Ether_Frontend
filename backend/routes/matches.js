const express = require("express");
const router = express.Router();
const pool = require("../db");
const CheckAuth = require("./middleware/check-auth");
const sendnotif = require("../send_notif");

//Write queries here by using router.get, router.post etc

//Creating matches

router.post("/:id", async(req, res) => {
    try {
        const id = req.params.id;
        matched_data = await pool.query(
            `SELECT * FROM interests
            WHERE interests=(SELECT interests FROM interests WHERE user_id=$1
            ORDER BY RANDOM() LIMIT 1) AND user_id != $1 AND user_id NOT IN (
                SELECT bad_boy_id FROM blocks WHERE good_boy_id = $1) AND user_id IN (SELECT id FROM users WHERE next_match = CURRENT_DATE)
            ORDER BY RANDOM() LIMIT 1;`, [id]
        );
        matched_userId = matched_data.rows[0].user_id;

        result = await pool.query(
            `INSERT INTO matches(user_id, contact_id) VALUES(($1),($2)), (($2),($1)) RETURNING user_id;`, [id, matched_userId]
        );

        if (result.rows.length > 0) {
            try {
                await pool.query(
                    `UPDATE users
                    SET next_match = CURRENT_DATE + 3
                    WHERE id= ($1) OR id =($2);`, [id, matched_userId]
                );
                try {
                    const notiftokens = await pool.query(
                        "SELECT notif_token FROM users WHERE id =($1) OR id = ($2)", [id, matched_userId]
                    );
                    sendnotif({
                        regToken: notiftokens.rows[0].notif_token,
                        notifTitle: "New Connection",
                        notifbody: "Ether has a new friend for you!",
                    });
                    sendnotif({
                        regToken: notiftokens.rows[1].notif_token,
                        notifTitle: "New Connection",
                        notifbody: "Ether has a new friend for you!",
                    });
                } catch (error) {
                    console.log(error);
                }

                res.status(200).json({
                    message: "Match created succesfully",
                    userId1: id,
                    userId2: matched_userId,
                    interest: matched_data.rows[0].interests,
                });
            } catch (error) {
                res.status(400).json(error);
            }
        } else {
            res.status(400).json({ message: "Unable to match at this time" });
        }
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

router.get("/:id", CheckAuth, async(req, res) => {
    try {
        const id = req.params.id;
        contacts = await pool.query(
            `SELECT *
           FROM matches
           JOIN users on users.id = matches.contact_id
           WHERE user_id = ($1);`, [id]
        );
        res.status(200).json({
            message: "Here is the list of contacts of the requested user",
            contacts: contacts.rows,
        });
    } catch (error) {
        console.log(error);
        res.status(400).json({ error: error });
    }
});

module.exports = router;