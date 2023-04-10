/**
 * The preload script runs before. It has access to web APIs
 * as well as Electron's renderer process modules and some
 * polyfilled Node.js functions.
 * 
 * https://www.electronjs.org/docs/latest/tutorial/sandbox
 */

const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  receive_active_clocks: (callback) => ipcRenderer.on('send_active_clocks', callback)
})

window.addEventListener('DOMContentLoaded', () => {

  const table_root = document.createElement('table')

  // add clock status
  const first_row = document.createElement('tr')
  const db_column = document.createElement('td')

  const db_button = document.createElement('button')
  db_button.id = 'button_db_status'
  db_button.innerText = 'get clock status'
  const db_span = document.createElement('span')
  db_span.id = 'span_db_status'

  db_button.addEventListener('click', async () => {
    ipcRenderer.invoke('get_active_clocks').then((result) => {
      const element = document.getElementById('db_status')
      if (element) element.innerText = result
    })
  })

  db_column.appendChild(db_button)
  db_column.appendChild(db_span)
  first_row.appendChild(db_column)
  table_root.appendChild(first_row)

  document.body.appendChild(table_root)

  ipcRenderer.invoke('get_clock_types').then((clock_types_list) => {
    clock_types_list.forEach((clock_type) => {
      const row = document.createElement('tr')
      const column = document.createElement('td')
      const clock_button = document.createElement('button')
      const span_symbol = document.createElement('span')

      const symbol = clock_type

      clock_button.id = `button_${symbol}`
      span_symbol.id = `span_${symbol}`

      clock_button.innerText = `clock ${symbol}`

      clock_button.addEventListener('click', async () => {
        ipcRenderer.invoke('clock_hours', symbol)
      })

      column.appendChild(clock_button)
      column.appendChild(span_symbol)
      row.appendChild(column)
      table_root.appendChild(row)
    })
  })
})
