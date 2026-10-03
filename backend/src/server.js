require("dotenv").config();

const express = require("express");
const pool = require("./db");
const cors = require("cors");


const app = express();
app.use(cors());
//the below line is used to parse incoming JSON requests and make the data available in req.body
app.use(express.json());

// app.get("/health", (req, res) => {
//     res.json({
//         message: "Server is working"
//     });
// });

// app.get("/", (req, res) => {
//     res.send("Welcome to Mini Task App API");
// });

app.get("/db-test", async (req, res) => {
    const result = await pool.query("SELECT NOW()");

    res.json(result.rows);
});

app.get("/tasks", async (req, res) => {
    const result = await pool.query(
        `SELECT * FROM tasks
        ORDER BY completed ASC`
    );

    res.json(result.rows);
});

app.get("/tasks/:id", async (req, res) => {
    const id = req.params.id;

    const result = await pool.query(
        `SELECT * FROM tasks 
        WHERE id = $1`,
        [id]
    );
    if (result.rows.length === 0) {
        return res.status(404).json({
            message: "Task not found"
        });
    }
    res.json(result.rows[0]);
});

app.post("/tasks", async (req, res) => {
    const { title } = req.body;

    if (!title) {
        return res.status(400).json({
            message: "Title is required"
        });
    }

    const result = await pool.query(
        `INSERT INTO tasks (title) 
         VALUES ($1) 
         RETURNING *`,
        [title]
    );

    res.json(result.rows[0]);
});

app.patch("/tasks/:id", async (req, res) => {
    const id = req.params.id;
    const { title, completed } = req.body;

    const result = await pool.query(
        `UPDATE tasks
         SET title = COALESCE($1, title),
             completed = COALESCE($2, completed)
         WHERE id = $3
         RETURNING *`,
        [title, completed, id]
    );

    if (result.rows.length === 0) {
        return res.status(404).json({
            message: "Task not found"
        });
    }

    res.json(result.rows[0]);
});

app.delete("/tasks/:id", async (req, res) => {
    const id = req.params.id;

    const result = await pool.query(
        `DELETE FROM tasks 
        WHERE id = $1 
        RETURNING *`,
        [id]
    );
    
    if (result.rows.length === 0) {
        return res.status(404).json({
            message: "Task not found"
        });
    }

    res.json(result.rows[0]);
});

app.listen(3000, () => {
    console.log("Server running on http://localhost:3000");
});