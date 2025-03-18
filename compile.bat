@echo off
title flutter compiler
flutter pub get
flutter build apk
explorer.exe %~dp0build/app/outputs/flutter-apk/
pause