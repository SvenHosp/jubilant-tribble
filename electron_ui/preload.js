/**
 * The preload script runs before. It has access to web APIs
 * as well as Electron's renderer process modules and some
 * polyfilled Node.js functions.
 * 
 * https://www.electronjs.org/docs/latest/tutorial/sandbox
 */

const { contextBridge, ipcRenderer } = require('electron')

window.addEventListener('DOMContentLoaded', () => {
  const replaceText = (selector, text) => {
    const element = document.getElementById(selector)
    if (element) element.innerText = text
  }

  for (const dependency of ['chrome', 'node', 'electron']) {
    replaceText(`${dependency}-version`, process.versions[dependency])
  }

  // add eventlistener for button
  const dbButton = document.getElementById('btn')
  dbButton.addEventListener('click', async () => {
    ipcRenderer.invoke('connect_db').then((result) => {
      const element = document.getElementById('outcome')
      if (element) element.innerText = result
    })
  })
})
/*
contextBridge.exposeInMainWorld('electronAPI', {
  connect_to_db: () => ipcRenderer.invoke('connect_db').then((result) => {
    const element = document.getElementById('outcome')
    if (element) element.innerText = result
  })
})
*/
