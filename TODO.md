#  TODO

- DPI bypass framework: NE loopback restriction for cellular network
- tvOS ByeByeDPI (VPN client) support: Adapt Tun2SOCKS for tvOS
- Theos ipa build



## DPI bypass framework. Заметки
Сторонние iOS byedpi/goodbyedpi репы, найденные на просторах git'а:

https://github.com/RumbleOrg/Rumble
ObjC, реализация по образу и подобию ByeByeDPIAndroid (byedpi + hev-socks-tunnel), сборка исключительно под jailbreak устройства. Развивается в форках

https://github.com/andrej34786/dpi-ios
Swift, реализация по образу и подобию ByeByeDPIAndroid (указано в Readme, но на деле пока ничего нет - проект в зачаточном состоянии). Не развивается, смысла как-то глубоко анализировать и перенимать реализации - нет

https://github.com/xctrailer04/DPIBypass
Swift, порт Goodbye DPI под iOS (lwIP + GoodbyeDPI). Работа над проектом идет. Генерится больше нейронкой. Как заглохнет активность коммитов, проверить реализацию и работу приложения
