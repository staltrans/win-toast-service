# win-toast-service

Сервис + User-агент для показа системных Toast-уведомлений в интерактивной сессии Windows.

Схема работы
- MyService пишет события в Application EventLog с Source = "MyServiceApp" и EventID = 1001.
- Scheduled Task с триггером On an event запускает MyAgent от текущего пользователя.
- MyAgent показывает Toast, используя AppUserModelID из ярлыка в профиле пользователя.

Сборка
dotnet publish src/MyService -c Release -r win-x64 -o out\service
dotnet publish src/MyAgent -c Release -r win-x64 -o out\agent

Установка (от администратора)
1) Клонировать репо:
git clone https://github.com/staltrans/win-toast-service.git C:\Install\MyApp

2) Запустить инсталлятор:
Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File 'C:\Install\MyApp\tools\Installer.ps1'" -Verb RunAs

Тестирование
- Запустить службу: sc start MyServiceApp
- Вызвать событие теста: MyService пишет EventID=1001 → Scheduled Task запускает MyAgent → Toast отображается.

Примечания
- Для корректной работы Toast у ярлыка должен быть тот же AppUserModelID, что и в коде агента.
- Тестируйте в VM перед продакшеном.
