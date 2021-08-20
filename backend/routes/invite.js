const express = require("express");
const router = express.Router();
const pool = require("../db");
const CheckAuth = require("./middleware/check-auth");

const crypto = require("crypto");
const algorithm = "aes-256-cbc";
const key = crypto.randomBytes(32);
const iv = crypto.randomBytes(16);

function encrypt(text) {
  let cipher = crypto.createCipheriv("aes-256-cbc", Buffer.from(key), iv);
  let encrypted = cipher.update(text);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  return { iv: iv.toString("hex"), encryptedData: encrypted.toString("hex") };
}

function decrypt(text) {
  let iv = Buffer.from(text.iv, "hex");
  let encryptedText = Buffer.from(text.encryptedData, "hex");
  let decipher = crypto.createDecipheriv("aes-256-cbc", Buffer.from(key), iv);
  let decrypted = decipher.update(encryptedText);
  decrypted = Buffer.concat([decrypted, decipher.final()]);
  return decrypted.toString();
}

// var hw = encrypt("So how are you?")
// console.log(hw)
// console.log(decrypt(hw))

router.post("/:id", async (req, res) => {
  try {
    const username = req.body.username.toString();
    const id = req.params.id;
    var encrypted1 = encrypt(
      username.toString() +
        Math.floor(100000 + Math.random() * 900000).toString()
    );
    var encrypted2 = encrypt(
      username.toString() +
        Math.floor(100000 + Math.random() * 900000).toString()
    );
    var encrypted3 = encrypt(
      username.toString() +
        Math.floor(100000 + Math.random() * 900000).toString()
    );

    const result = await pool.query(
      `INSERT INTO invite(user_id, encrypted_data) VALUES(($1), ($2)), (($1), ($3)), (($1), ($4)) RETURNING encrypted_data;  `,
      [
        id,
        encrypted1.encryptedData,
        encrypted2.encryptedData,
        encrypted3.encryptedData,
      ]
    );
    if (result.rows.length > 0) {
      res
        .status(200)
        .json({
          inviteCode1: result.rows[0].encrypted_data,
          inviteCode2: result.rows[1].encrypted_data,
          inviteCode3: result.rows[2].encrypted_data,
        });
    } else res.status(400).json({ message: "cant encrypt" });
  } catch (error) {
    res.status(400).json({ error: error });
  }
});

router.get("/:string", async (req, res) => {
  try {
    const string = req.params.string;
    const inviter = await pool.query(
      `SELECT username
      FROM users
      JOIN invite on invite.user_id = users.id
      WHERE encrypted_data = ($1);`,
      [string.toString()]
    );

    if (inviter.rows.length > 0) {
      res.status(200).json(inviter.rows[0].username);
    } else {
      res.status(400).json({ message: "Invalid invite" });
    }
  } catch (error) {
    res.status(400).json({ error: error });
  }
});

router.delete("/:string", async (req, res) => {
  try {
    const string = req.params.string;
    result = await pool.query(
      `DELETE FROM invite WHERE encrypted_data =($1) RETURNING 'DELETED';`,
      [string.toString()]
    );
    if (result.rows.length > 0) {
      res.status(200).json({ message: "Successfully deleted" });
    } else {
      res.status(400).json({ message: `Invalid invite` });
    }
  } catch (error) {
    res.status(400).json({ error: error });
  }
});
module.exports = router;
