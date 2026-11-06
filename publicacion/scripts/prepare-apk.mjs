import { createHash } from 'node:crypto';
import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const publicRoot = path.join(root, 'publicacion', 'public');
const apkDirectory = path.join(publicRoot, 'apk');
const metadataPath = path.join(publicRoot, 'release.json');
const deliveryDirectory = path.join(root, 'entrega');
const contentType = 'application/vnd.android.package-archive';

function sha256(bytes) {
  return createHash('sha256').update(bytes).digest('hex');
}

function parseArguments(args) {
  const [apkPath, ...options] = args;
  if (!apkPath || apkPath === '--help') {
    throw new Error('Uso: node publicacion/scripts/prepare-apk.mjs <apk> --version <x.y.z> --build-number <n> --min-android <versión> --application-id <id> --certificate-sha256 <hash> --architectures <lista>');
  }

  const values = new Map();
  for (let index = 0; index < options.length; index += 2) {
    const name = options[index];
    const value = options[index + 1];
    if (!name?.startsWith('--') || !value || values.has(name)) {
      throw new Error(`Argumento no válido: ${name ?? ''}`);
    }
    values.set(name, value);
  }

  const required = ['--version', '--build-number', '--min-android', '--application-id', '--certificate-sha256', '--architectures'];
  for (const name of required) {
    if (!values.has(name)) throw new Error(`Falta ${name}.`);
  }
  if (!/^\d+\.\d+\.\d+$/.test(values.get('--version'))) throw new Error('La versión debe tener formato x.y.z.');
  if (!/^\d+$/.test(values.get('--build-number'))) throw new Error('--build-number debe ser un entero positivo.');
  if (!/^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$/.test(values.get('--application-id'))) {
    throw new Error('--application-id no tiene formato válido.');
  }

  const certificateSha256 = values.get('--certificate-sha256').replaceAll(':', '').toLowerCase();
  if (!/^[a-f0-9]{64}$/.test(certificateSha256)) throw new Error('El certificado debe ser un SHA-256 hexadecimal de 64 caracteres.');
  const architectures = values.get('--architectures').split(',').map((item) => item.trim()).filter(Boolean);
  if (architectures.length === 0) throw new Error('Indica al menos una arquitectura comprobada en el APK.');

  return {
    sourcePath: path.resolve(root, apkPath),
    version: values.get('--version'),
    buildNumber: Number(values.get('--build-number')),
    minAndroid: values.get('--min-android'),
    applicationId: values.get('--application-id'),
    certificateSha256,
    architectures,
  };
}

async function pathExists(target) {
  try {
    return await fs.lstat(target);
  } catch (error) {
    if (error.code === 'ENOENT') return null;
    throw error;
  }
}

async function main() {
  const release = parseArguments(process.argv.slice(2));
  const publicRealPath = await fs.realpath(publicRoot);
  const apkDirectoryRelative = path.relative(publicRealPath, apkDirectory);
  if (apkDirectoryRelative.startsWith('..') || path.isAbsolute(apkDirectoryRelative)) {
    throw new Error('El destino APK está fuera de publicacion/public.');
  }

  const sourceDetails = await fs.lstat(release.sourcePath);
  if (!sourceDetails.isFile() || sourceDetails.isSymbolicLink() || path.extname(release.sourcePath).toLowerCase() !== '.apk') {
    throw new Error('La entrada debe ser un archivo APK regular, no un enlace simbólico.');
  }
  const sourceBytes = await fs.readFile(release.sourcePath);
  const sourceHash = sha256(sourceBytes);
  const sourceAfterRead = await fs.stat(release.sourcePath);
  if (sourceAfterRead.size !== sourceDetails.size || sourceAfterRead.mtimeMs !== sourceDetails.mtimeMs || sha256(await fs.readFile(release.sourcePath)) !== sourceHash) {
    throw new Error('El APK cambió durante la preparación.');
  }

  await fs.mkdir(apkDirectory, { recursive: true });
  const fileName = `bola-va-release-${release.version}.apk`;
  const destinationPath = path.join(apkDirectory, fileName);
  const tempPath = `${destinationPath}.tmp-${process.pid}`;
  const destinationRelativePath = path.posix.join('apk', fileName);
  const previousOutput = await pathExists(destinationPath);
  if (previousOutput?.isSymbolicLink()) throw new Error('El destino del APK es un enlace simbólico.');

  try {
    await fs.writeFile(tempPath, sourceBytes, { flag: 'wx' });
    const preparedBytes = await fs.readFile(tempPath);
    if (sha256(preparedBytes) !== sourceHash || preparedBytes.length !== sourceDetails.size) {
      throw new Error('La copia preparada no coincide con el APK original.');
    }
    await fs.rename(tempPath, destinationPath);

    const metadata = {
      appName: 'Bola Va',
      version: release.version,
      buildNumber: release.buildNumber,
      applicationId: release.applicationId,
      minAndroid: release.minAndroid,
      architectures: release.architectures,
      certificateSha256: release.certificateSha256,
      apk: {
        fileName,
        path: destinationRelativePath,
        contentType,
        sizeBytes: preparedBytes.length,
        sha256: sourceHash,
      },
      generatedAt: new Date().toISOString(),
    };
    const metadataTempPath = `${metadataPath}.tmp-${process.pid}`;
    await fs.writeFile(metadataTempPath, `${JSON.stringify(metadata, null, 2)}\n`, { flag: 'wx' });
    await fs.rename(metadataTempPath, metadataPath);

    await fs.mkdir(deliveryDirectory, { recursive: true });
    const deliveryFileName = `bola-va-${release.version}.apk`;
    const deliveryPath = path.join(deliveryDirectory, deliveryFileName);
    const deliveryTempPath = `${deliveryPath}.tmp-${process.pid}`;
    const existingDelivery = await pathExists(deliveryPath);
    if (existingDelivery?.isSymbolicLink()) throw new Error('El destino de entrega del APK es un enlace simbólico.');
    await fs.writeFile(deliveryTempPath, preparedBytes, { flag: 'wx' });
    const deliveryBytes = await fs.readFile(deliveryTempPath);
    if (sha256(deliveryBytes) !== sourceHash || deliveryBytes.length !== sourceDetails.size) {
      await fs.rm(deliveryTempPath, { force: true });
      throw new Error('La copia de entrega no coincide con el APK original.');
    }
    await fs.rename(deliveryTempPath, deliveryPath);

    const deliveryReport = {
      appName: 'Bola Va',
      version: release.version,
      buildNumber: release.buildNumber,
      applicationId: release.applicationId,
      minAndroid: release.minAndroid,
      architectures: release.architectures,
      certificateSha256: release.certificateSha256,
      apkPath: path.relative(root, deliveryPath).split(path.sep).join('/'),
      sizeBytes: deliveryBytes.length,
      sha256: sourceHash,
    };
    await fs.writeFile(path.join(deliveryDirectory, `comprobacion-android-${release.version}.json`), `${JSON.stringify(deliveryReport, null, 2)}\n`);

    const staleFiles = (await fs.readdir(apkDirectory, { withFileTypes: true }))
      .filter((entry) => entry.isFile() && /^bola-va-release-.*\.apk$/.test(entry.name) && entry.name !== fileName);
    await Promise.all(staleFiles.map((entry) => fs.unlink(path.join(apkDirectory, entry.name))));
    const staleDeliveries = (await fs.readdir(deliveryDirectory, { withFileTypes: true }))
      .filter((entry) => entry.isFile() && /^bola-va-\d+\.\d+\.\d+\.apk$/.test(entry.name) && entry.name !== deliveryFileName);
    await Promise.all(staleDeliveries.map((entry) => fs.unlink(path.join(deliveryDirectory, entry.name))));
    console.log(`APK preparado: ${destinationRelativePath}`);
    console.log(`Copia de entrega: ${path.relative(root, deliveryPath)}`);
    console.log(`Tamaño: ${preparedBytes.length} bytes`);
    console.log(`SHA-256: ${sourceHash}`);
  } catch (error) {
    await fs.rm(tempPath, { force: true });
    throw error;
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});