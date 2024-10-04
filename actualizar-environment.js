const fs = require('fs');
const path = require('path');

const search = process.argv[2];
const replace = process.argv[3];

if (!search || !replace) {
  console.error('Por favor, proporciona la cadena a buscar y la nueva cadena como argumentos.');
  console.error('Uso: node update-environments.js "cadena_a_buscar" "nueva_cadena"');
  process.exit(1);
}

const projects = ['Blitzvideo-Visualizer', 'Blitzvideo-Auth', 'Blitzvideo-Creadores'];
const environmentFiles = ['environment.ts', 'environment.prod.ts'];

const escapeRegExp = (string) => {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
};

const searchPattern = escapeRegExp(search);
const searchRegex = new RegExp(searchPattern, 'g');

projects.forEach((project) => {
  const basePath = path.join(__dirname, project, 'src', 'environments');

  environmentFiles.forEach((file) => {
    const filePath = path.join(basePath, file);
    fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) {
        console.error(`Error al leer el archivo ${filePath}:`, err);
        return;
      }

      const result = data.replace(searchRegex, replace);

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
