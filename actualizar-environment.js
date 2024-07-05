const fs = require('fs');
const path = require('path');

const newIp = process.argv[2];
if (!newIp) {
  console.error('Por favor, proporciona una nueva IP o dominio como argumento.');
  process.exit(1);
}

const projects = ['Blitzvideo-Visualizer', 'Blitzvideo-Auth', 'Blitzvideo-Creadores'];
const environmentFiles = ['environment.ts', 'environment.prod.ts'];

const ipRegex = /http:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|http:\/\/localhost/g;

projects.forEach((project) => {
  const basePath = path.join(__dirname, project, 'src', 'environments');

  environmentFiles.forEach((file) => {
    const filePath = path.join(basePath, file);
    fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) {
        console.error(`Error al leer el archivo ${filePath}:`, err);
        return;
      }

      const result = data.replace(ipRegex, `http://${newIp}`);

      fs.writeFile(filePath, result, 'utf8', (err) => {
        if (err) {
          console.error(`Error al escribir en el archivo ${filePath}:`, err);
          return;
        }
        console.log(`Archivo ${filePath} actualizado correctamente.`);
      });
    });
  });
});
