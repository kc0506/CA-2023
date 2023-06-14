const http = require('http');
const url = require('url');

const server = http.createServer((req, res) => {
    const { pathname, query } = url.parse(req.url, true);

    if (pathname === '/hello') {
        const name = query.name || 'Anonymous';
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/plain');

        if (name === "sleep1") {
            setTimeout(function () {
                res.end(`Hello, ${name}!\n`);
            }, 3000);
        } else if (name === "sleep2") {
            setTimeout(function () {
                res.end(`Hello, ${name}!\n`);
            }, 1000);
        } else
            res.end(`Hello, ${name}!\n`);
    } else {
        res.statusCode = 404;
        res.end('Not found');
    }
});

const port = 3000;
server.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
