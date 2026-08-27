/* Minimal local KernelSU WebUI bridge wrapper. */
let callbackId = 0;
export function exec(command) {
  return new Promise((resolve, reject) => {
    const name = 'adb_wifi_cb_' + Date.now() + '_' + (callbackId++);
    window[name] = (errno, stdout, stderr) => {
      delete window[name];
      resolve({ errno, stdout: stdout || '', stderr: stderr || '' });
    };
    try {
      if (!window.ksu || typeof window.ksu.exec !== 'function') throw new Error('当前管理器未注入 KernelSU WebUI API');
      window.ksu.exec(command, '{}', name);
    } catch (e) { delete window[name]; reject(e); }
  });
}
