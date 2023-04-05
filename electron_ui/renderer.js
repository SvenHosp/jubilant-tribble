/**
 * This file is loaded via the <script> tag in the index.html file and will
 * be executed in the renderer process for that window. No Node.js APIs are
 * available in this process because `nodeIntegration` is turned off and
 * `contextIsolation` is turned on. Use the contextBridge API in `preload.js`
 * to expose Node.js functionality from the main process.
 */

const setButton = document.getElementById('btn')
const titleInput = document.getElementById('title')
const span_out = document.getElementById('outcome')

setButton.addEventListener('click', () => {
    const title = titleInput.value
    //window.electronAPI.setTitle(title)
    span_out.innerText = title
});

const btn = document.getElementById('btn2')
const filePathElement = document.getElementById('filePath')

btn.addEventListener('click', async () => {
  const filePath = await window.electronAPI.openFile()
  filePathElement.innerText = filePath
})
