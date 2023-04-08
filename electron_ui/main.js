// Modules to control application life and create native browser window
const {app, BrowserWindow, ipcMain, dialog} = require('electron')
const sqlite3 = require('sqlite3').verbose()
const path = require('path')
let db = {}

async function db_connect() {
  const DATABASE_PATH = process.env.JUBILANT_TRIBBLE_DATABASE

  console.log(`path to db is ${DATABASE_PATH}`)

  db = new sqlite3.Database(DATABASE_PATH, (err) => {
    if (err) {
      return err.message
    }
  });

  db.close();

  return `path to db is ${DATABASE_PATH}`
}

ipcMain.handle('connect_db', async (event) => {
  let result = await db_connect()
  return result
})

function createWindow () {
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  })
  
  // and load the index.html of the app.
  mainWindow.loadFile('index.html')

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow()

  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit()
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
