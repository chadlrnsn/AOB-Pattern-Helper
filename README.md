# AOB Pattern Helper

A convenient tool for Cheat Engine that helps manage and copy AOB (Array of Bytes) patterns.

## Features

- Easy-to-use interface integrated into Cheat Engine's menu bar
- Copy bytes from any memory address
- Support for module+offset address format (e.g., client.dll+1B4A429)
- Real-time byte count display
- Wildcard bytes support

## Installation

1. Open Cheat Engine
2. Go to "Table" -> "Show Cheat Table Lua Script"
3. Copy the contents of `src/aobmanager_ce.lua` into the Lua Engine
4. Execute the script

The "AOB Manager" option will appear in your Cheat Engine menu bar.

## Usage

1. Click on "AOB Manager" in the menu bar to open the tool
2. Enter the memory address in the first field
   - You can use direct addresses (e.g., "0x140001000")
   - Or module+offset format (e.g., "client.dll+1B4A429")
3. Enter the byte pattern in the second field
   - Use space-separated bytes (e.g., "89 43 ? 48 8B")
   - Use "?" for wildcard bytes
4. Click "Copy Bytes" to copy the bytes at the specified address to clipboard

## Example

Let's say you want to copy bytes from address "client.dll+1B4A429":

1. Enter "client.dll+1B4A429" in the address field
2. Enter your byte pattern (e.g., "89 43 ? 48 8B")
3. Click "Copy Bytes"
4. The actual bytes at that address will be copied to your clipboard

## Contributing

Feel free to submit issues and pull requests to improve the tool.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
