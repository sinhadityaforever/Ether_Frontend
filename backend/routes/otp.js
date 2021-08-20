const express = require("express");

const router = express.Router();
const pool = require("../db");

var nodemailer = require("nodemailer");

var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: "learnsters01@gmail.com", //email ID
        pass: "Jagulai@66", //Password
    },
});

function sendMail(email, otp) {
    var details = {
        from: "learnsters01@gmail.com", // sender address same as above
        to: email, // Receiver's email id
        subject: "Your OTP for Ether is ", // Subject of the mail.
        html: otp, // Sending OTP
    };

    transporter.sendMail(details, function(error, data) {
        if (error) {
            console.log(error);
            return 400;
        } else {
            console.log(200);

            return 200;
        }
    });
}

router.post("/", async(req, res) => {
    try {
        const email = req.body.email.toString();
        let otp = Math.floor(100000 + Math.random() * 900000);
        let statusCode = sendMail(email, otp.toString());

        //  let otpId =  await pool.query(
        //         `INSERT INTO otp(email, otp)
        //         VALUES
        //         (($1), ($2)) RETURNING id;`, [email, otp]
        //     );
        res.status(200).json(otp);
    } catch (error) {
        res.status(400).json({ message: error });
    }
});

router.get("/:id", async(req, res) => {
    try {
        const id = req.params.id
        const result = await pool.query('SELECT notif_token, username FROM users WHERE id = ($1)', [id]);
    
        res.status(200).json(result.rows[0].username);
        
    } catch (error) {
        res.status(400).json(error)
    }
   
});


module.exports = router;