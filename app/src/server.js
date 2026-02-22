const express = require('express');

const app = express();
const port = process.env.PORT || 3000;

// Versionado por variables de entorno (para CD)
const version = process.env.APP_VERSION || 'dev';

// Endpoint de salud (para healthcheck)
app.get('/health', (req, res) => {
  const fail = process.env.HEALTH_FAIL === 'true';
  if (fail) {
    return res.status(500).json({ status: 'fail' });
  }
  res.status(200).json({ status: 'ok' });
});

// Endpoint de versión (para verficar que release está activo)
app.get('/version', (req, res) => {
  res.status(200).json({ version });
});

// Raíz simple
app.get('/', (req, res) => {
  res.status(200).send(`Hello World! Version: ${version}\n`);
});

app.listen(port, () => {
  console.log(`Server running on port ${port} (Version: ${version})`);
});

