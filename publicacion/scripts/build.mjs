import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const publicDirectory = path.join(root, 'publicacion', 'public');
const outputDirectory = path.join(root, 'publicacion', 'dist');

function isWithin(parent, target) {
  const relative = path.relative(parent, target);
  return relative !== '' && relative !== '..' && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative);
}

async function copyPublicFiles(sourceDirectory, destinationDirectory, relativeDirectory = '') {
  const entries = await fs.readdir(sourceDirectory, { withFileTypes: true });
  entries.sort((left, right) => left.name.localeCompare(right.name));

  for (const entry of entries) {
    const sourcePath = path.join(sourceDirectory, entry.name);
    const details = await fs.lstat(sourcePath);
    if (details.isSymbolicLink()) throw new Error(`No se copian enlaces simbólicos: ${sourcePath}`);
    if (entry.name.startsWith('.') || entry.name.endsWith('.map')) continue;

    const relativePath = path.join(relativeDirectory, entry.name);
    const destinationPath = path.join(destinationDirectory, relativePath);
    if (details.isDirectory()) {
      await copyPublicFiles(sourcePath, destinationDirectory, relativePath);
    } else if (details.isFile()) {
      await fs.mkdir(path.dirname(destinationPath), { recursive: true });
      await fs.copyFile(sourcePath, destinationPath);
    }
  }
}

async function main() {
  if (!isWithin(path.join(root, 'publicacion'), outputDirectory)) {
    throw new Error('La salida debe permanecer dentro de publicacion/.');
  }
  const publicDetails = await fs.lstat(publicDirectory);
  if (!publicDetails.isDirectory() || publicDetails.isSymbolicLink()) throw new Error('No existe una carpeta publicacion/public segura.');
  const existingOutput = await fs.lstat(outputDirectory).catch((error) => error.code === 'ENOENT' ? null : Promise.reject(error));
  if (existingOutput?.isSymbolicLink()) throw new Error('No se elimina dist porque es un enlace simbólico.');
  if (existingOutput) await fs.rm(outputDirectory, { recursive: true, force: true });
  await fs.mkdir(outputDirectory, { recursive: true });
  await copyPublicFiles(publicDirectory, outputDirectory);

  for (const requiredPath of ['index.html', 'download.js', 'app/index.html', 'app/service-worker.js']) {
    await fs.access(path.join(outputDirectory, requiredPath));
  }
  console.log(`Publicación estática preparada en ${path.relative(root, outputDirectory)}.`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});