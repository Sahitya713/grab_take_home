const client = require("./connection.js");
const app = require("./app");

// handle errors in synchronous code
process.on("uncaughtException", (err) => {
  console.log("UNCAUGHT EXCEPTION! Shutting down...");
  console.log(err.name, err.message);
  process.exit(1);
});

client.connect();

const server = app.listen(3300, (error) => {
  if (error) throw error;
  console.log("Server listening on port 3300...");
});

process.on("unhandledRejection", (err) => {
  console.log("UNHANDLED REJECTION! Shutting down...");
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});
