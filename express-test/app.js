const express = require('express');
const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// GET endpoint
app.get('/', (req, res) => {
    res.send('Welcome to the GET endpoint!');
});

// POST endpoint
app.post('/submit', (req, res) => {
    const { name, age } = req.body;
    if (name && age) {
        res.status(200).send(`Received name: ${name} and age: ${age}`);
    } else {
        res.status(400).send('Name and age are required');
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
