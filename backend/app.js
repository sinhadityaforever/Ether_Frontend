const express = require("express");

const app = express();

const userRoutes = require("./routes/users");
const msgRoutes = require("./routes/msg");
const matchesRoutes = require("./routes/matches");
const interestsRoutes = require("./routes/interests");
const otpRoutes = require("./routes/otp");
const tokenRoutes = require("./routes/token");
const inviteRoutes = require("./routes/invite")

app.use(express.json());

app.use("/users", userRoutes);
app.use("/msg", msgRoutes);
app.use("/matches", matchesRoutes);
app.use("/interests", interestsRoutes);
app.use("/otp", otpRoutes);
app.use("/token", tokenRoutes);
app.use("/invite", inviteRoutes);


module.exports = app;