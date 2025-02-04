--[[
    AOB Pattern Helper
    Author: chadlrnsn
    Repository: https://github.com/chadlrnsn/AOB-Pattern-Helper
    License: MIT
]]

-- Remove old menu item if it exists
local mmTools = getMainForm().Menu.Items
for i=0, mmTools.Count-1 do
    if mmTools[i].Caption == 'AOB Manager' then
        mmTools.delete(i)
        break
    end
end

-- Create new menu item
local AOBMenuItem = createMenuItem(mmTools)
AOBMenuItem.Caption = 'AOB Manager'

-- Create form
local form = createForm(false)
form.Caption = "AOB Manager"
form.Width = 400
form.Height = 170
form.BorderStyle = bsSizeable
form.Position = poScreenCenter
form.Constraints.MinWidth = 400
form.Constraints.MinHeight = 170

-- Create bytes input field
local bytesEdit = createEdit(form)
bytesEdit.Text = "Enter bytes pattern (e.g., 89 43 ? 48 8B ...)"
bytesEdit.Width = 350
bytesEdit.Height = 25
bytesEdit.Top = 10
bytesEdit.Left = 20
bytesEdit.Anchors = '[akLeft,akTop,akRight]'

-- Create address input field
local addressEdit = createEdit(form)
addressEdit.Text = "Enter address (e.g., client.dll+1B4A429)"
addressEdit.Width = 350
addressEdit.Height = 25
addressEdit.Top = 45
addressEdit.Left = 20
addressEdit.Anchors = '[akLeft,akTop,akRight]'

-- Create copy button
local saveButton = createButton(form)
saveButton.Caption = "Copy Bytes"
saveButton.Width = 150
saveButton.Height = 25
saveButton.Top = 80
saveButton.Left = 20
saveButton.Anchors = '[akLeft,akTop]'

-- Create author and repo buttons
local authorButton = createButton(form)
authorButton.Caption = "Author: chadlrnsn"
authorButton.Width = 150
authorButton.Height = 25
authorButton.Top = saveButton.Top + saveButton.Height + 10
authorButton.Left = saveButton.Left
authorButton.Anchors = '[akLeft,akTop]'

local repoButton = createButton(form)
repoButton.Caption = "GitHub Repository"
repoButton.Width = 150
repoButton.Height = 25
repoButton.Top = authorButton.Top
repoButton.Left = authorButton.Left
repoButton.Anchors = '[akLeft,akTop]'

-- Create info labels
local totalBytesLabel = createLabel(form)
totalBytesLabel.Caption = "Total bytes: 0"
totalBytesLabel.Left = saveButton.Left + saveButton.Width + 30
totalBytesLabel.Top = saveButton.Top + 3
totalBytesLabel.Width = 100
totalBytesLabel.Anchors = '[akLeft,akTop]'

local wildcardBytesLabel = createLabel(form)
wildcardBytesLabel.Caption = "Wildcards: 0"
wildcardBytesLabel.Left = totalBytesLabel.Left + totalBytesLabel.Width + 10
wildcardBytesLabel.Top = totalBytesLabel.Top
wildcardBytesLabel.Width = 100
wildcardBytesLabel.Anchors = '[akLeft,akTop]'

-- Create star label
local starLabel = createLabel(form)
starLabel.Caption = "Leave a star if you like this script ⭐"
starLabel.Left = totalBytesLabel.Left + 30
starLabel.Top = authorButton.Top + 3
starLabel.Width = 200
starLabel.Anchors = '[akLeft,akTop]'


-- Function to count total bytes
function countTotalBytes(byteString)
    local count = 0
    for byte in string.gmatch(byteString, "[%x%?]+") do
        count = count + 1
    end
    return count
end

-- Function to count wildcard bytes
function countWildcardBytes(byteString)
    local count = 0
    for byte in string.gmatch(byteString, "[%x%?]+") do
        if byte == "?" then
            count = count + 1
        end
    end
    return count
end

-- Button click handler
saveButton.OnClick = function()
    local byteString = bytesEdit.Text
    local addressString = addressEdit.Text
    
    -- Get address
    local baseAddress = getAddressSafe(addressString)
    if baseAddress == nil then
        showMessage("Invalid address!")
        return
    end
    
    -- Count total bytes
    local totalBytes = countTotalBytes(byteString)
    
    -- Read bytes and create clipboard string
    local bytesForClipboard = {}
    for i = 0, totalBytes - 1 do
        local byte = readBytes(baseAddress + i, 1, true)[1]
        table.insert(bytesForClipboard, string.format("%02X", byte))
    end
    
    -- Copy to clipboard
    writeToClipboard(table.concat(bytesForClipboard, " "))
    showMessage("Bytes copied to clipboard!")
end

-- Update byte count on text change
bytesEdit.OnChange = function()
    local byteString = bytesEdit.Text
    local total = countTotalBytes(byteString)
    local wildcards = countWildcardBytes(byteString)
    totalBytesLabel.Caption = "Total bytes: " .. total
    wildcardBytesLabel.Caption = "Wildcards: " .. wildcards
end

-- Form close handler
form.OnClose = function(sender)
    form.hide()
    return caHide
end

-- Menu item click handler
AOBMenuItem.OnClick = function()
    form.show()
end

-- Button click handlers for opening URLs
authorButton.OnClick = function()
    shellExecute('https://github.com/chadlrnsn')
end

repoButton.OnClick = function()
    shellExecute('https://github.com/chadlrnsn/AOB-Pattern-Helper')
end

-- Add menu item to main menu
mmTools.add(AOBMenuItem) 