// const app = require("./app");
// const http = require("http");
// const pool = require("./db");
// var admin = require("firebase-admin");
// var regiStrationToken;

// var serviceAccount = require("../frontend/serviceAccountKey.json");

// const cors = require("cors");
// const port = process.env.port_message_server;
// admin.initializeApp({
//     credential: admin.credential.cert(serviceAccount),
//     databaseURL: "https://wired-bf519-default-rtdb.asia-southeast1.firebasedatabase.app",
// });
// let server = http.createServer(app);
// let io = require("socket.io")(server, {
//     cors: {
//         origin: "*",
//     },
// });
// console.log("dfdfdfdf");
// app.use(cors());
// let clients = {};

// io.on("connection", (socket) => {
//     console.log("connected");
//     console.log(socket.id, "has Joined");
//     socket.on("signin", (id) => {
//         console.log(id);
//         clients[id] = socket;
//         console.log("dsdd");
//         console.log(clients);
//     });
//     socket.on("message", async(msg) => {
//         console.log(msg);
//         let recieverId = msg.reciever_id;
//         console.log(recieverId);
//         let senderId = msg.sender_id;
//         console.log(senderId);
//         let content = msg.message;
//         console.log(content);
//         if (clients[recieverId]) {
//             clients[recieverId].emit("message", msg);
//         }
//         await pool.query(
//             `INSERT INTO msg(content, sender_id, reciever_id)
//            VALUES(($1), ($2), ($3));`, [content, senderId, recieverId]
//         );


//         var sendername = await pool.query('SELECT username FROM users WHERE id = ($1)', [senderId]);
        
//         var tok = await pool.query(
//             `SELECT notif_token FROM users WHERE id = ($1)`, [recieverId]
//         );
//         regiStrationToken = tok.rows[0].notif_token;
        
//         var message = {
//             notification: {
//                 title: "Ether",
//                 body: `${sendername.rows[0].username}: ${content}`,
//             },
//             token: regiStrationToken,
//         };
//         admin
//             .messaging()
//             .send(message)
//             .then((response) => {
//                 // Response is a message ID string.
//                 console.log("Successfully sent message:", response);
//             })
//             .catch((error) => {
//                 console.log("Error sending message:", error);
//             });
//     });
// });


// server.listen(port, process.env.ip, () => {
//     console.log("connected fdgvfdgg");
// });

