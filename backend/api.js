const express = require('express');
const request = require('request');

const app = express();
const port = 3000;

app.use(express.json());

function generateQRCode() {
    return new Promise((resolve, reject) => {
        const headers = {
            'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXJhbSI6IntcImlkXCI6NzIsXCJ0aW1lc3RhbXBcIjoxNzQxMzE1MTkwMzc5fSJ9.BSAA7Q8AHw0HaSFDqLE7AxdP6oLWVRpHbhG1FUCJpK8',
            'Content-Type': 'application/json'
        };

        const options = {
            url: 'http://mzy-jp.dajingtcm.com/double-ja/business/qrcode/patient/login/generate',
            method: 'POST',
            headers: headers,
            body: JSON.stringify({})
        };

        request(options, (error, response, body) => {
            if (error) {
                reject(error);
            } else if (response.statusCode !== 200) {
                reject(new Error(`Request failed with status code ${response.statusCode}`));
            } else {
                resolve(body);
            }
        });
    });
}

app.post('/generate-qrcode', async (req, res) => {
    try {
        const data = await generateQRCode();
        res.json({ success: true, data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
