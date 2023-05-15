/**
 * This file is loaded via the <script> tag in the index.html file and will
 * be executed in the renderer process for that window. No Node.js APIs are
 * available in this process because `nodeIntegration` is turned off and
 * `contextIsolation` is turned on. Use the contextBridge API in `preload.js`
 * to expose Node.js functionality from the main process.
 */

window.electronAPI.receive_active_clocks((_event, active_clocks, symbol_types) => {
  //const active_clocks_html = document.getElementById('span_db_status')
  //active_clocks_html.innerText = active_clocks

  symbol_types.forEach((symbol) => {
    const clock_span = document.getElementById(`span_${symbol}`)
    if (active_clocks.includes(symbol)){
      clock_span.innerText = '*'
    } else {
      clock_span.innerText = '-'
    }
  })
})

window.electronAPI.receive_current_hours((_event, current_hours) => {
  //const active_clocks_html = document.getElementById('span_db_status')
  //active_clocks_html.innerText = active_clocks

  const hour_span = document.getElementById(`span_get_current_hours`)
  hour_span.innerText = current_hours
})
