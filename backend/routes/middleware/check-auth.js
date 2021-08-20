const jwt = require("jsonwebtoken");
const CheckAuth = (req, res, next) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decoded = jwt.verify(token, process.env.JWT_KEY);
    req.userData = decoded;
    next();
  } catch (error) {
    return res.status(400).json({
      message: "Auth failed",
    });
  }
};

module.exports = CheckAuth;
