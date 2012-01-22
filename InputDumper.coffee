out = (require 'fs').createWriteStream 'Input.dump'

process.stdin.resume()
process.stdin.setEncoding('ascii')
process.stdin.on 'data', (chunk) -> 
  out.write(chunk)
  process.stdout.write 'go\n'
process.stdin.on 'end', -> 
  out.destroySoon()
  process.exit()