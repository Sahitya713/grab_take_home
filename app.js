const express = require("express");
const AppError = require("./utils/appError");
const controller = require("./controller");
const app = express();

// BODY PARSER. Reading data from body into req.body
const bodyParser = require("body-parser");
app.use(bodyParser.json());
app.use(express.json());
// reading data from form
app.use(express.urlencoded({ extended: true }));

// app.run

app.route("/runtimes").post(controller.getRuntimes);
app.get("/distribution/:year", controller.getDistribution);
app
  .route("/collections")
  .get(controller.getCollections)
  .post(controller.saveChart);
app.get("/collections/:collection", controller.getCharts);
app.get("/scores/:year", controller.getScores);

app.all("*", (req, res, next) => {
  next(new AppError(`Cannot find ${req.originalUrl} on this server!`, 404));
});

module.exports = app;
