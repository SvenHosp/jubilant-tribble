// Modules to control application life and create native browser window
const {app, BrowserWindow, ipcMain} = require('electron')
const sqlite3 = require('sqlite3').verbose()
const path = require('path')

var clock_types = []

async function get_active_clocks() {
  const DATABASE_PATH = process.env.JUBILANT_TRIBBLE_DATABASE

  const db = new sqlite3.Database(DATABASE_PATH, (err) => {
    if (err) {
      return err.message
    }
  });

  let sql = "SELECT symbol from worktime w WHERE w.timeslot_finish == FALSE;"

  db.all(sql, [], (err, rows) => {
    if (err) {
      throw err;
    }
    var _active_clocks = []
    rows.forEach((row) => {
      _active_clocks.push(row.symbol);
    });

    BrowserWindow.getAllWindows().forEach((window) => {
      window.webContents.send('send_active_clocks', _active_clocks, clock_types)
    });
  });

  db.close();
}

ipcMain.handle('get_active_clocks', async (event) => {
  get_active_clocks()
})

ipcMain.handle('get_clock_types', async (event) => {
  let path = "config.json"
  const fs = require('fs')
  const config = JSON.parse(fs.readFileSync(path))
  const clock_types_config = config["clock_types"]
  var _clock_types = []
  clock_types_config.forEach((clock_type_obj) => {
    _clock_types.push(clock_type_obj.name)
  })
  clock_types = _clock_types

  return clock_types 
})

ipcMain.handle('clock_hours', async (event, symbol) => {
  // logic to clock_in
  const execSync = require('child_process').execSync;
  execSync(`zsh ../clock.sh m ${symbol}`, { encoding: 'utf-8' })
  get_active_clocks()
})

function createWindow () {
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    width: 200,
    height: 300,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  })
  
  // and load the index.html of the app.
  mainWindow.loadFile('index.html')

  // Open the DevTools.
  //mainWindow.webContents.openDevTools()
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
  /*
  for (const config_index in clock_types_config){
    console.log(clock_types_config[config_index]["name"])
  }
  */
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit()
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.

