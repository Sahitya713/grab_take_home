const client = require("./connection.js");
const catchAsync = require("./utils/catchAsync.js");
const AppError = require("./utils/appError");

const table = "netflix_titles";
const collection_table = "netflix_collections";

exports.getRuntimes = catchAsync(async (req, res, next) => {
  //   query = `SELECT release_year,runtime FROM ${table} WHERE release_year BETWEEN ${req.body.startyear} AND ${req.body.endyear}`;
  //   query = `SELECT release_year,AVG(runtime) FROM ${table} WHERE release_year BETWEEN 1971 AND 2008 ORDER BY release_year ASC`;

  const { startYear, endYear } = req.body;

  query = `SELECT release_year, AVG(runtime) FROM ${table}
  WHERE release_year BETWEEN ${startYear} AND ${endYear} 
  GROUP BY release_year
  ORDER BY release_year ASC`;
  const runtimes = await client.query(query);

  const data = runtimes.rows;

  res.status(201).json({
    status: "success",
    data: data,
  });
});

exports.getDistribution = catchAsync(async (req, res, next) => {
  // query = `SELECT SUM(CASE WHEN type = 'MOVIE' THEN 1 ELSE 0 END) AS movies, SUM(CASE WHEN type = 'SHOW' THEN 1 ELSE 0 END) AS shows FROM ${table}
  //   WHERE release_year=${req.params.year}`;
  query = `SELECT type, Count(*) FROM ${table}
  WHERE release_year = ${req.params.year}
  GROUP BY type`;
  const response = await client.query(query);
  const data = response.rows;

  res.status(201).json({
    status: "success",
    data,
  });
});

exports.getScores = catchAsync(async (req, res, next) => {
  query = `SELECT title, imdb_score, imdb_votes FROM ${table}
  WHERE release_year = ${req.params.year} and type = 'MOVIE' and imdb_score IS NOT NULL and imdb_votes IS NOT NULL and imdb_votes >1000
  ORDER BY imdb_score DESC, imdb_votes DESC
  LIMIT 10`;
  const response = await client.query(query);
  const data = response.rows;

  res.status(201).json({
    status: "success",
    data,
  });
});

exports.getCollections = catchAsync(async (req, res, next) => {
  //   query = `SELECT release_year,runtime FROM ${table} WHERE release_year BETWEEN ${req.body.startyear} AND ${req.body.endyear}`;
  //   query = `SELECT release_year,AVG(runtime) FROM ${table} WHERE release_year BETWEEN 1971 AND 2008 ORDER BY release_year ASC`;

  query = `SELECT distinct(collection) FROM ${collection_table}`;
  const response = await client.query(query);
  const data = response.rows;
  var result_list = [];
  for (row in data) {
    result_list.push(data[row].collection);
  }

  res.status(201).json({
    status: "success",
    result_list,
  });
});

exports.getCharts = catchAsync(async (req, res, next) => {
  query = `SELECT * FROM ${collection_table}
    WHERE collection='${req.params.collection}'`;
  const response = await client.query(query);
  const data = response.rows;

  res.status(201).json({
    status: "success",
    data,
  });
});

exports.saveChart = catchAsync(async (req, res, next) => {
  const { collection, chartType, startYear, endYear } = req.body;

  query = `INSERT INTO ${collection_table}
  VALUES ('${collection}', '${chartType}', ${startYear}, ${endYear})`;
  const response = await client.query(query);
  // const data = response.rows;

  res.status(201).json({
    status: "success",
    data: "Successfully added",
  });
});
