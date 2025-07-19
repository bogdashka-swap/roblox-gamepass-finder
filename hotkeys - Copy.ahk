    ; Инициализация глобальных переменных
    global userId := ""
    global cookies := ""
    global proxy := ""
    global password := ""  ; Добавляем переменную password
    ; Путь к временным файлам
    global cookiesFile := A_Temp "\cookies.txt"
	global CurrentMode := 2  ; Инициализируем переменную как глобальную
	
; Используем скан-коды для Q, W и E
+sc10:: ; Shift + Q (скан-код для клавиши "Q")
{
    global CurrentMode := 1
   ; MsgBox "Режим переключен на 1"
    return
}

+sc11:: ; Shift + W (скан-код для клавиши "W")
{
    global CurrentMode := 2
    ;MsgBox "Режим переключен на 2"
    return
}

+sc12:: ; Shift + E (скан-код для клавиши "E")
{
    global CurrentMode := 3
   ; MsgBox "Режим переключен на 3"
    return
}

    F1:: {
        SendInput("^a") ; Выделить
        Sleep(10)
        Send("https:{/}{/}www.roblox.com{/}NewLogin{?}ReturnUrl={%}2Fmy{%}2Faccount{#}{!}{/}info") ; Выделить все
        Send("{Enter}") ; Нажать Enter
    }
    ; Горячая клавиша F3 для копирования куков
    F3:: {
			if (CurrentMode = 1) {
				global cookies, cookiesFile
				Send("^c") ; Ctrl+C для копирования
				ClipWait(5) ; Увеличить ожидание до 5 секунд
				Sleep(100)
				cookies := A_Clipboard

				if (cookies != "") {
					if (FileExist(cookiesFile)) {
						FileDelete(cookiesFile) ; Удаляем старый файл, если он существует
					}
					FileAppend(cookies, cookiesFile) ; Сохраняем куки в файл
				} else {
					MsgBox("Ошибка: Буфер обмена пуст или не удалось скопировать куки.")
				}

			}
			else if (CurrentMode = 2) {
				; Отправляем команду для копирования выделенного текста
				Send("^c") ; Ctrl+C для копирования
				ClipWait(2)
				Sleep(100)
				global cookies := A_Clipboard
			}	
    }
	

    ; Горячая клавиша F2 для вставки куков
    F2:: {
			; Отправляем команду для копирования выделенного текста
			Send("^c") ; Ctrl+C для копирования
			ClipWait(2)
			Sleep(100)
			global proxy := A_Clipboard
	}

    ; Горячая клавиша F4 для работы с файлами и куками
    F4:: {
		if (CurrentMode = 1) {
			;MsgBox("1: " . CurrentMode)
			global cookiesFile, cookies

			; Читаем куки из файла, если он существует
			if (FileExist(cookiesFile)) {
				cookies := FileRead(cookiesFile) ; Читаем куки
			} else {
				MsgBox("Ошибка: Файл с куками не найден.")
				return
			}

			; Отладочные сообщения для проверки значений переменных
			;MsgBox("Куки: " . cookies)
			;MsgBox(cookies==A_Clipboard)

			if (A_Clipboard != cookies) {
				A_Clipboard := cookies ; Устанавливаем куки в буфер обмена если их нету там!
			}

			SendInput("^a") ; Выделить
			Sleep(10)
			SendInput("^v") ; Вставить куки
			SendInput("{TAB}") ; Нажать TAB
			Sleep(100)

			if (A_Clipboard != proxy) {
				A_Clipboard := proxy
			}
			SendInput("^a") ; Выделить
			SendInput("^v") ; Вставить proxy
			Send("{ENTER}")
		}
		else if (CurrentMode = 2) {
			;MsgBox("2: " . CurrentMode)
			if (A_Clipboard != proxy) {
				A_Clipboard := proxy
			}

			Sleep(50)
			SendInput("^v") ; Вставить proxy
			SendInput("+{Enter}") ; шифт энтер
			Sleep(100)

			if (A_Clipboard != cookies) {
				A_Clipboard := cookies
			}
			SendInput("^v") ; Вставить cookies
			Send("+{ENTER}")
		}
   }

    ; Функция для генерации случайного пароля
    GenerateRandomPassword(length) {
        chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
        password := ""
        Loop length {
            index := Random(1, StrLen(chars))
            password .= SubStr(chars, index, 1)
        }
        return password
    }

    ; Горячая клавиша F8 для генерации пароля и вставки proxy и password
    F6:: {
		if (CurrentMode = 1) {
			global proxy, password

			; Генерация случайного пароля длиной от 9 до 16 символов
			password := GenerateRandomPassword(Random(9, 17))

			; Вставляем переменную proxy
			SendInput(proxy)
			SendInput("{TAB}") ; Нажимаем TAB

			; Вставляем переменную password
			SendInput(password)
			SendInput("{TAB}") ; Нажимаем TAB

			; Вставляем переменную password еще раз
			SendInput(password)
			SendInput("{ENTER}") ; Нажимаем ENTER
		}
		else if (CurrentMode = 2) {
			; Текст для вставки
			Text := "Выберите три игры, в которые вы играли за последнюю неделю. Это необходимо для входа в аккаунт.`n`nВерхняя часть: 1️⃣ 2️⃣ 3️⃣`nНижняя часть: 4️⃣ 5️⃣ 6️⃣`n`nНапишите ИСКЛЮЧИТЕЛЬНО цифрами, например: 1, 4, 6. Спасибо! 😊"
			
			; Сохраняем текущий буфер обмена
			clipboardBackup := A_Clipboard
			A_Clipboard := Text
			Sleep(50) ; Небольшая пауза для обработки
			
			; Вставляем текст
			Send("^v") ; Используем Ctrl+V для вставки
			SendInput("{Enter}")
			; Восстанавливаем предыдущий буфер обмена
			Sleep(50) ; Еще одна пауза для безопасности
			A_Clipboard := clipboardBackup
		}
    }

    ; Горячая клавиша F7 для вставки только password
    F7:: {
		if (CurrentMode = 1) {
			global password
			A_Clipboard := password
			; Вставляем переменную password
			SendInput(password)
			SendInput("{ENTER}") ; Нажимаем ENTER
		}
		else if (CurrentMode = 2) {
			SendInput("Пришлите код, который пришёл на на вашу почту. Это необходимо для входа в аккаунт. Спасибо{!} 😊") ; Выделить все
			SendInput("{Enter}") ; Нажать Enter
		}
	}




F8:: {
    ; Текст для вставки
    Text := "Пополнение вашего счета завершено 🎉`n`nПожалуйста, проверьте ваш аккаунт и убедитесь, что все на месте ❤️`n`nЕсли вы предоставляли пароль, обязательно смените его для безопасности вашего аккаунта 🔒`n`nЖелаю вам классной игры и жду вас снова в нашем магазине (спасибо, что выбрали нас) 🌟`n`nПожалуйста, оставьте отзыв о нашей работе, чтобы другие могли узнать о вашем опыте! Спасибо большое за вашу поддержку 😊"
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}


F9:: {
    ; Текст для вставки
    Text := "Пожалуйста, оставайтесь на связи 🙏`nЯ сейчас захожу и начну работу. Войдите в свою почту и ожидайте код. Не уходите, чтобы не ждать своей очереди. Спасибо за понимание 😊"
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

F10:: {
    ; Текст для вставки
    Text := "let balanceRobux = 10000;`nlet send = 1;`nlet massage = function(num = 0) {`n    try {`n        // Находим все элементы с классом 'chat-message'`n        let messages = document.querySelectorAll('.chat-message');`n`n        // Переменная для хранения последнего значения робуксов`n        let lastPay = 0;`n`n        // Проходим по всем сообщениям`n        messages.forEach(function(message) {`n            // Проверяем, есть ли метка 'оповещение'`n            let isNotification = message.querySelector('.chat-msg-author-label.label-primary');`n`n            // Если это оповещение`n            if (isNotification) {`n                // Ищем текст, содержащий информацию о робуксах`n                let messageText = message.textContent || '';`n`n                // Пытаемся найти числовое значение робуксов, включая нецелые`n                let robuxMatch = messageText.match(/(\d+(\.\d+)?)\s*ед\.\s*робуксов/);`n`n                // Если нашли, записываем это число в переменную lastPay`n                if (robuxMatch) {`n                    // Округляем до ближайшего целого числа вниз`n                    lastPay = Math.floor(parseFloat(robuxMatch[1]));`n                }`n            }`n        });`n`n        // Выводим результат в консоль`n        console.log('Последняя оплата робуксов: ' + lastPay);`n`n        // Инициализация переменной msg`n        let msg = '';`n`n        // Определяем количество робуксов для вычислений`n        let sume = Math.ceil(num / 0.7) || Math.ceil(lastPay / 0.7);`n`n        if (sume > balanceRobux) {`n            let x = sume / balanceRobux;`n            let sumeTimes = Math.ceil(x); // Сколько раз нужно купить`n            let sumeNext = Math.ceil(sume / sumeTimes); // Цена одного геймпаса`n            msg = 'Укажите цену геймпаса = ' + sumeNext + ', я куплю его ' + sumeTimes + ' раз(а). Общая сумма: ' + sume + ', вы получите: ' + Math.ceil(sume * 0.7) +'\n Проверьте, чтобы галочка (Enable regional pricing) была ОТКЛЮЧЕНА.';`n            console.log(msg);`n        } else {`n            msg = 'Укажите цену геймпаса = ' + sume+'\n Проверьте, чтобы галочка (Enable regional pricing) была ОТКЛЮЧЕНА.';`n            console.log(msg + '\nSend = ' + send);`n        }`n`n        // Попытка вставить сообщение в текстовое поле`n        try {`n            if (send) {`n                document.querySelector('#comments > textarea').value = msg;`n                document.querySelector('div.chat-form-btn > button').click();`n            }`n        } catch (err) {`n            console.log('Не удалось вставить сообщение: ' + err);`n        }`n    } catch (err) {`n        console.log('Ошибка обработки: ' + err);`n    }`n};`n`nmassage();"
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    ;SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

F11:: {
    ; Текст для вставки
    Text := "Дождитесь обновления кода в вашем приложении-аутентификаторе и введите новый код сразу после его получения. Это необходимо для успешного входа в аккаунт."
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad1:: {
    ; Текст для вставки
    Text := 'Зайдите в приложение Roblox с мобильного устройства с залогиненного аккаунта и нажмите левую кнопку "Approve", чтобы мы могли войти. Спасибо!'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad2:: {
    ; Текст для вставки
    Text := 'Вообще я бeру рoбуксы у знакомого, зовут robuxswap io. Свой человек, уже не первый год у него берy. Тут на плeeрке просто перепродаю, потому что нельзя по-другому, а так можно было бы и дешевле. Кто знает — тот знает 😏'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad3:: {
    ; Текст для вставки
    Text := 'Есть у меня постaвщик, robuxswap io зовётся. Рaботает где-то в теневом мире pобуксов... я у него бeрy дешевле, но тут, нa плeеркe, приходится делать официально — с надбавкой. Но знатоки знают, как его найти 😉'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad4:: {
    ; Текст для вставки
    Text := 'Раньше я просто скидывал робуксы на robuxswap io нaпрямyю, по хорошемy кyрсу. Но plаyеrok всё усложнил, теперь только так. Хотя те, кто давно в теме, знают, где искать robux swap 😄'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad5:: {
    ; Текст для вставки
    Text := 'Говорят, где-то в глубинах интеpнетa есть robuxswap io — старый торгoвец робуксами. Я у него бeрy, потому что нaдёжный. А сюдa выкладываю, ну… для тех, кто ещё не нашёл путь к нему 🕵️'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad6:: {
    ; Текст для вставки
    Text := 'Чeстно скажу — я нe основной продавец. Я просто бeрy на robuxswap io по ноpмальной цене, но из-за фп комиccии выходит немного дoрoжe. Хотя если кому интересно, как экономить — есть способы 😉'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}

Numpad8:: {
    global userId

    ; Читаем содержимое файла userId.txt (файл должен быть в той же папке, что и скрипт)
    userIdFile := A_ScriptDir "\userId.txt"
    if (FileExist(userIdFile)) {
        userId := Trim(FileRead(userIdFile)) ; Считываем и удаляем лишние пробелы/переводы строк
    } else {
        MsgBox("Файл userId.txt не найден.")
        return
    }

    ; Текст для вставки
    Text := "Заказ выполнен, робуксы находятся в ожидании (pending) в течение 5 дней. Вы можете проверить мой инвентарь, чтобы убедиться, что я действительно купил геймпасс: https://www.roblox.com/users/" . userId . "/inventory#!/game-passes"

    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50)

    ; Вставляем текст
    Send("^v")
    SendInput("{Enter}")

    ; Восстанавливаем буфер обмена
    Sleep(50)
    A_Clipboard := clipboardBackup
}

Numpad9:: {
    ; Текст для вставки
    Text := 'https://www.youtube.com/watch?v=7kXOVc7S-HM, если ютуб не грузит: https://drive.google.com/file/d/1Hmg61u_-5LwzjzLn2uqU8YWhsRicsRNs/view?usp=drive_link'
    
    ; Сохраняем текущий буфер обмена
    clipboardBackup := A_Clipboard
    A_Clipboard := Text
    Sleep(50) ; Небольшая пауза для обработки
    
    ; Вставляем текст
    Send("^v") ; Используем Ctrl+V для вставки
    SendInput("{Enter}")
    ; Восстанавливаем предыдущий буфер обмена
    Sleep(50) ; Еще одна пауза для безопасности
    A_Clipboard := clipboardBackup
}