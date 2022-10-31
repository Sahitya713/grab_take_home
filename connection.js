const { Client } = require("pg");
// const dotenv = require("dotenv");

// console.log(process.env.POSTGRES_PASSWORD);
const client = new Client({
  host: "localhost",
  user: "postgres",
  port: 5433,
  password: "Sasweet713!",
  databse: "postgres",
});

module.exports = client;
