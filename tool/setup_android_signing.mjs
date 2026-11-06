import { randomBytes } from 'node:crypto';
import { spawnSync } from 'node:child_process';
import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const privateDirectory = path.join(root, '.private', 'android');
const keystorePath = path.join(privateDirectory, 'bola-va-release.p12');
const propertiesPath = path.join(privateDirectory, 'key.properties');
const temporarySuffix = `.tmp-${process.pid}`;

async function assertAbsent(target) {
  try {
    await fs.lstat(target);
    throw new Error(`Ya existe ${path.relative(root, target)}; no se sobrescribe una firma.`);
  } catch (error) {
    if (error.code !== 'ENOENT') throw error;
  }
}

async function assertNoSymlink(target) {
  try {
    const details = await fs.lstat(target);
    if (details.isSymbolicLink()) throw new Error(`No se usa una ruta privada simbólica: ${target}`);
  } catch (error) {
    if (error.code !== 'ENOENT') throw error;
  }
}

async function main() {
  await assertNoSymlink(path.join(root, '.private'));
  await assertNoSymlink(privateDirectory);
  await fs.mkdir(privateDirectory, { recursive: true });
  await assertAbsent(keystorePath);
  await assertAbsent(propertiesPath);

  const password = randomBytes(36).toString('base64url');
  const temporaryKeystore = `${keystorePath}${temporarySuffix}`;
  const temporaryProperties = `${propertiesPath}${temporarySuffix}`;
  let finalKeystoreCreated = false;

  try {
    const result = spawnSync(process.env.KEYTOOL || 'keytool', [
      '-genkeypair',
      '-noprompt',
      '-storetype', 'PKCS12',
      '-keystore', temporaryKeystore,
      '-alias', 'bolava-release',
      '-keyalg', 'RSA',
      '-keysize', '3072',
      '-validity', '10000',
      '-dname', 'CN=Bola Va, OU=Release, O=Bola Va, L=Valencia, ST=Valencia, C=ES',
      '-storepass:env', 'BOLAVA_RELEASE_PASSWORD',
      '-keypass:env', 'BOLAVA_RELEASE_PASSWORD',
    ], {
      env: { ...process.env, BOLAVA_RELEASE_PASSWORD: password },
      encoding: 'utf8',
      stdio: ['ignore', 'ignore', 'ignore'],
    });
    if (result.error) throw new Error(`No se pudo ejecutar keytool: ${result.error.message}`);
    if (result.status !== 0) throw new Error(`keytool terminó con código ${result.status}.`);

    const properties = [
      'storeFile=../.private/android/bola-va-release.p12',
      'storePassword=' + password,
      'keyAlias=bolava-release',
      'keyPassword=' + password,
      '',
    ].join('\n');
    await fs.writeFile(temporaryProperties, properties, { flag: 'wx', mode: 0o600 });
    await fs.rename(temporaryKeystore, keystorePath);
    finalKeystoreCreated = true;
    await fs.rename(temporaryProperties, propertiesPath);
    console.log('Firma release creada en .private/android/. No compartas esa carpeta; consérvala como copia privada para futuras actualizaciones.');
  } catch (error) {
    await fs.rm(temporaryKeystore, { force: true });
    await fs.rm(temporaryProperties, { force: true });
    if (finalKeystoreCreated) await fs.rm(keystorePath, { force: true });
    throw error;
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});