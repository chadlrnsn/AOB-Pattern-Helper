-- Создаем форму с двумя полями ввода
local form = createForm()
form.Caption = "AOB Менеджер"
form.Width = 400
form.Height = 180

-- Создаем поле для ввода байтов
local bytesEdit = createEdit(form)
bytesEdit.Text = "Введите байты (пример: 89 43 ? 48 8b ...)"
bytesEdit.Width = 350
bytesEdit.Height = 25
bytesEdit.Top = 10
bytesEdit.Left = 20

-- Создаем поле для ввода адреса
local addressEdit = createEdit(form)
addressEdit.Text = "Введите адрес (пример: client.dll+1B4A429)"
addressEdit.Width = 350
addressEdit.Height = 25
addressEdit.Top = 45
addressEdit.Left = 20

-- Глобальная переменная для хранения оригинальных байтов
originalBytes = {}
baseAddress = 0

-- Создаем кнопку для сохранения байтов
local saveButton = createButton(form)
saveButton.Caption = "Копировать байты"
saveButton.Width = 150
saveButton.Height = 25
saveButton.Top = 80
saveButton.Left = 20

-- Создаем метки для отображения информации о байтах
local totalBytesLabel = createLabel(form)
totalBytesLabel.Caption = "Всего байт: 0"
totalBytesLabel.Left = 180
totalBytesLabel.Top = 83
totalBytesLabel.Width = 100

local wildcardBytesLabel = createLabel(form)
wildcardBytesLabel.Caption = "Плавающих: 0"
wildcardBytesLabel.Left = 290
wildcardBytesLabel.Top = 83
wildcardBytesLabel.Width = 100

-- Функция для преобразования строки байтов в таблицу
function parseBytes(byteString)
    local bytes = {}
    for byte in string.gmatch(byteString, "%x+") do
        if byte ~= "?" then
            table.insert(bytes, tonumber(byte, 16))
        end
    end
    return bytes
end

-- Функция для подсчета количества байт (включая ?)
function countTotalBytes(byteString)
    local count = 0
    for byte in string.gmatch(byteString, "[%x%?]+") do
        count = count + 1
    end
    return count
end

-- Функция для подсчета плавающих байтов
function countWildcardBytes(byteString)
    local count = 0
    for byte in string.gmatch(byteString, "[%x%?]+") do
        if byte == "?" then
            count = count + 1
        end
    end
    return count
end

-- Обработчик нажатия кнопки
saveButton.OnClick = function()
    local byteString = bytesEdit.Text
    local addressString = addressEdit.Text
    
    -- Получаем адрес
    baseAddress = getAddressSafe(addressString)
    if baseAddress == nil then
        showMessage("Неверный адрес!")
        return
    end
    
    -- Считаем общее количество байт
    local totalBytes = countTotalBytes(byteString)
    
    -- Читаем байты и формируем строку для буфера обмена
    local bytesForClipboard = {}
    for i = 0, totalBytes - 1 do
        local byte = readBytes(baseAddress + i, 1, true)[1]
        table.insert(bytesForClipboard, string.format("%02X", byte))
    end
    
    -- Копируем в буфер обмена
    writeToClipboard(table.concat(bytesForClipboard, " "))
    showMessage("Байты скопированы в буфер обмена!")
end

-- Обновляем обработчик изменения текста в поле байтов
bytesEdit.OnChange = function()
    local byteString = bytesEdit.Text
    local total = countTotalBytes(byteString)
    local wildcards = countWildcardBytes(byteString)
    totalBytesLabel.Caption = "Всего байт: " .. total
    wildcardBytesLabel.Caption = "Плавающих: " .. wildcards
end

-- Удаляем неиспользуемые функции и переменные
originalBytes = nil
restoreBytes = nil
form.OnDestroy = nil

-- Показываем форму
form.show()