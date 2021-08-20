const express = require("express");
const CheckAuth = require("./middleware/check-auth");
const router = express.Router();
const pool = require("../db");
const jwt = require("jsonwebtoken");
const { json, response } = require("express");

// ROUTER USED TO SIGNUP
router.post("/signup", async(req, res) => {
    try {
        const email = req.body.email;
        const password = req.body.password;
        const username = req.body.username;
        const result = await pool.query(
            "INSERT INTO users (email, username, password) VALUES ($1, $2, crypt($3, gen_salt('bf'))) RETURNING id;", [email, username, password]
        );

        const token = jwt.sign({
                id: result.rows[0].id,
            },
            process.env.JWT_KEY,

            {
                expiresIn: "8760hr",
            }
        );

        res.status(200).json({
            message: "User created succesfully!",
            token: token,
            id: result.rows[0].id,
        });
    } catch (error) {
        res.status(400).json({
            error: error,
        });
    }
});

//ROUTER USED TO LOGIN AND AUTH
router.post("/login", async(req, res) => {
    try {
        const email = req.body.email;
        const password = req.body.password;
        const result = await pool.query(
            "SELECT id FROM users WHERE email = $1 AND password = crypt($2, password);", [email, password]
        );
        if (result.rows[0].length == 0) {
            res.status(400).message("Auth failed");
        } else {
            const token = jwt.sign({
                    id: result.rows[0].id,
                },
                process.env.JWT_KEY, {
                    expiresIn: "8760hr",
                }
            );

            res.status(200).json({
                message: "logged in succesfully",
                token: token,
                id: result.rows[0].id,
            });
        }
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

//ROUTER CREATED TO PATCH THE PROFILE
router.patch("/:id", CheckAuth, async(req, res) => {
    try {
        const id = req.params.id;
        const userName = req.body.username;
        const bio = req.body.bio;
        const avatarUrl = req.body.avatar_url;
        await pool.query(
            `UPDATE users SET username=($1), bio=($2), avatar_url=($3) 
      WHERE id=($4);`, [userName, bio, avatarUrl, id]
        );
        res.status(200).json({
            message: "profile patched succesfully",
        });
    } catch (error) {
        console.log(error);
        res.status(400).json({ error: error });
    }
});

//ROUTER TO VIEW THE PROFILE OF A SPECIFIC USER
//YOU CAN SEE THE PROFILE OF ONLY THOSE PEOPLE WHO BECOME YOUR CONTACTS
//THIS NEEDS SPECIFIC EDITS ONCE THE MATCHES THING IS DONE
router.get("/:id", CheckAuth, async(req, res) => {
    try {
        const id = req.params.id;
        const profile = await pool.query(`SELECT * FROM users WHERE id = ($1)`, [
            id,
        ]);
        if (profile.rows.length == 0) {
            res.status(400).json({ message: "user not found" });
        } else {
            res.status(200).json(profile.rows[0]);
        }
    } catch (error) {
        console.log(error);
        res.status(400).json({ error: error });
    }
});

router.patch("/nextmatch/:id", CheckAuth, async(req, res) => {
    try {
        const id = req.params.id;
        await pool.query(
            `UPDATE users
    SET next_match = CURRENT_DATE
    WHERE id= ($1);`, [id]
        );
        res.status(200).json({ message: "date updated successfully" });
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

router.get("/nextmatch/:id", CheckAuth, async(req, res) => {
    try {
        const id = req.params.id;
        nextMatch = await pool.query(
            `SELECT TO_CHAR(next_match::DATE, 'yyyy-mm-dd') FROM users where id =($1);`, [id]
        );
        res.status(200).json(nextMatch.rows[0].to_char);
    } catch (error) {
        res.status(400);
    }
});

router.patch("/block/:id/", CheckAuth, async(req, res) => {
    try {
        const id = req.params.id;
        const selfId = req.body.self_id;
        await pool.query(`UPDATE users SET blocks = blocks+1 WHERE id= ($1)`, [id]);
        await pool.query(
            `DELETE FROM matches WHERE contact_id = ($1) AND user_id = ($2)`, [id, selfId]
        );
        await pool.query(`DELETE FROM users WHERE blocks >= 2 AND id = ($1)`, [id]);
        await pool.query(
            `INSERT INTO blocks(good_boy_id, bad_boy_id)
        VALUES
            (($1), ($2)),
            (($2), ($1))`, [selfId, id]
        );

        res.status(200).json({
            message: "User has been blocked successfully",
        });
    } catch (error) {
        res.status(400).json({ error: error });
    }
});

module.exports = router;