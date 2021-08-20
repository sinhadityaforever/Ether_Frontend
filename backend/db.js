const Pool = require("pg").Pool;

const pool = new Pool({

  user: "postgres",
  password: "Jagulai66",
  database: "Wired",
  host: "bhosda.cig6jz3yfdx4.ap-south-1.rds.amazonaws.com",
  port: 5432,
  ssl: false,
  

});
module.exports = pool;