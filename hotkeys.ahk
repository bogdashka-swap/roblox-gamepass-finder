; Инициализация глобальных переменных
global userId := ""
global cookies := ""
global proxy := ""
global password := ""  ; Добавляем переменную password
global cookiesFile := A_Temp "\cookies.txt"
global CurrentMode := 2

ClipboardIsText() {
    try {
        return DllCall("IsClipboardFormatAvailable", "UInt", 1) ; CF_TEXT
    } catch {
        return false
    }
}

WaitForTextClipboard(timeoutMs := 3000) {
    elapsed := 0
    while (elapsed < timeoutMs) {
        if (ClipboardIsText()) {
            return true
        }
        Sleep(100)
        elapsed += 100
    }
    return false
}

+sc10:: {
    global CurrentMode := 1
    return
}
+sc11:: {
    global CurrentMode := 2
    return
}
+sc12:: {
    global CurrentMode := 3
    return
}

F1:: {
    SendInput("^a")
    Sleep(10)
    Send("https://www.roblox.com/NewLogin?ReturnUrl=%2Fmy%2Faccount#!info")
    Send("{Enter}")
}

F3:: {
    Send("^c")
    ClipWait(5)
    if (!WaitForTextClipboard()) {
        MsgBox("Ошибка: буфер не содержит текст.")
        return
    }

    Sleep(100)
    global cookies := A_Clipboard

    if (CurrentMode = 1) {
        global cookiesFile
        if (cookies != "") {
            if (FileExist(cookiesFile)) {
                FileDelete(cookiesFile)
            }
            FileAppend(cookies, cookiesFile)
        } else {
            MsgBox("Ошибка: Буфер обмена пуст или не удалось скопировать куки.")
        }
    }
}

F2:: {
    Send("^c")
    ClipWait(2)
    Sleep(100)
    if (WaitForTextClipboard()) {
        global proxy := A_Clipboard
    } else {
        MsgBox("Ошибка: буфер не содержит текст.")
    }
}

F4:: {
    if (CurrentMode = 1) {
        global cookiesFile, cookies, proxy

        if (FileExist(cookiesFile)) {
            cookies := FileRead(cookiesFile)
        } else {
            MsgBox("Ошибка: Файл с куками не найден.")
            return
        }

        if (A_Clipboard != cookies) {
            A_Clipboard := cookies
        }

        SendInput("^a")
        Sleep(10)
        SendInput("^v")
        SendInput("{TAB}")
        Sleep(100)

        if (A_Clipboard != proxy) {
            A_Clipboard := proxy
        }

        SendInput("^a")
        SendInput("^v")
        Send("{ENTER}")
    }
    else if (CurrentMode = 2) {
        if (A_Clipboard != proxy) {
            A_Clipboard := proxy
        }

        Sleep(50)
        SendInput("^v")
        SendInput("+{Enter}")
        Sleep(100)

        if (A_Clipboard != cookies) {
            A_Clipboard := cookies
        }

        SendInput("^v")
        Send("+{ENTER}")
    }
}

GenerateRandomPassword(length) {
    chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
    password := ""
    Loop length {
        index := Random(1, StrLen(chars))
        password .= SubStr(chars, index, 1)
    }
    return password
}

F6:: {
    if (CurrentMode = 1) {
        global proxy, password
        password := GenerateRandomPassword(Random(9, 17))

        A_Clipboard := ""
        ClipWait(0.5)

        SendInput(proxy)
        SendInput("{TAB}")
        SendInput(password)
        SendInput("{TAB}")
        SendInput(password)
        SendInput("{ENTER}")
    }
    else if (CurrentMode = 2) {
        Text := "Выберите три игры, в которые вы играли за последнюю неделю. Это необходимо для входа в аккаунт.`n`nВерхняя часть: 1️⃣ 2️⃣ 3️⃣`nНижняя часть: 4️⃣ 5️⃣ 6️⃣`n`nНапишите ИСКЛЮЧИТЕЛЬНО цифрами, например: 1, 4, 6. Спасибо! 😊"
        clipboardBackup := A_Clipboard
        A_Clipboard := Text
        Sleep(50)
        Send("^v")
        SendInput("{Enter}")
        Sleep(50)
        A_Clipboard := clipboardBackup
    }
}

F7:: {
    if (CurrentMode = 1) {
        global password
        A_Clipboard := ""
        ClipWait(0.5)
        A_Clipboard := password
        Sleep(50)
        SendInput(password)
        SendInput("{ENTER}")
    }
    else if (CurrentMode = 2) {
        SendInput("Пришлите код, который пришёл на на вашу почту. Это необходимо для входа в аккаунт. Спасибо{!} 😊")
        SendInput("{Enter}")
    }
}

F8:: {
    Text := "Пополнение вашего счета завершено 🎉`n`nПожалуйста, проверьте ваш аккаунт и убедитесь, что все на месте ❤️`n`nЕсли вы предоставляли пароль, обязательно смените его для безопасности вашего аккаунта 🔒`n`nЖелаю вам классной игры и жду вас снова в нашем магазине (спасибо, что выбрали нас) 🌟`n`nПожалуйста, оставьте отзыв о нашей работе, чтобы другие могли узнать о вашем опыте! Спасибо большое за вашу поддержку 😊"
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

F9:: {
    Text := "Пожалуйста, оставайтесь на связи 🙏`nЯ сейчас захожу и начну работу. Войдите в свою почту и ожидайте код. Не уходите, чтобы не ждать своей очереди. Спасибо за понимание 😊"
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

F10:: {
    Text := "let balanceRobux = 10000;`nlet send = 1;`nlet massage = function(num = 0) {...}" ; Сокращённый для читаемости
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

F11:: {
    Text := "Дождитесь обновления кода в вашем приложении-аутентификаторе и введите новый код сразу после его получения. Это необходимо для успешного входа в аккаунт."
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad1:: {
    Text := 'Зайдите в приложение Roblox с мобильного устройства с залогиненного аккаунта и нажмите левую кнопку "Approve", чтобы мы могли войти. Спасибо!'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad2:: {
    Text := 'Вообще я бeру рoбуксы у знакомого, зовут robuxswap io...'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad3:: {
    Text := 'Есть у меня постaвщик, robuxswap io зовётся...'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad4:: {
    Text := 'Раньше я просто скидывал робуксы на robuxswap io...'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad5:: {
    Text := 'Говорят, где-то в глубинах интеpнетa есть robuxswap io...'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad6:: {
    Text := 'Чeстно скажу — я нe основной продавец...'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad8:: {
    global userId
    userIdFile := A_ScriptDir "\userId.txt"
    if (FileExist(userIdFile)) {
        userId := Trim(FileRead(userIdFile))
    } else {
        MsgBox("Файл userId.txt не найден.")
        return
    }

    Text := "Заказ выполнен, робуксы находятся в ожидании (pending) в течение 5 дней. Вы можете проверить мой инвентарь: https://www.roblox.com/users/" . userId . "/inventory#!/game-passes"
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad9:: {
    Text := 'https://www.youtube.com/watch?v=7kXOVc7S-HM, если ютуб не грузит: https://drive.google.com/...'
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)
    Send("^v")
    SendInput("{Enter}")
    Sleep(50)
    A_Clipboard := clipboardBackup
}
