# termostato_2

## +・・・・・・・・・・・・・・・・・・・・・・

## Instalación rápida de las dependencias

## -・・・・・・・・・・・・・・・・・・・・・・

- flutter clean
- flutter pub get
- flutterfire configure (ejecutar en poweshell de vscode) `Esto me genero demasiados problemas`
-- posteriormente, ejecutar la aplicación

## +・・・・・・・・・・・・・・・・・・・・・-

## Instalación lenta de flutter

## -・・・・・・・・・・・・・・・・・・・・・-

## instalación de firebase para flutter

1) instalar firebase tools:
<https://firebase.google.com/docs/cli?hl=es&authuser=0#windows-npm>
 npm install -g firebase-tools
2) dart pub global activate flutterfire_cli
3) firebase Login
4) flutterfire configure (No ejecutar en bash, si no en powershell de vscode)
5) instalar firebase core y cloud fire store
<https://pub.dev/packages/firebase_core/install>
 flutter pub add firebase_core
<https://pub.dev/packages/cloud_firestore/install>
 flutter pub add cloud_firestore
En casos extremos:

- firebase --versión
- firebase Login --reauth
- flutter clean
- flutter pub get
En casos aun más extremos
- flutter pub upgrade --force

## ー・－・－・ー・－・－・

## Método de instalación de las dependencias de abajo

## ・－・－・ー・－・－・ー

- flutter pub get

## Instalación de firebase authentication

flutter pub add firebase_auth

## Instalación de toastification ( No es necesario )

flutter pub add toastification

## Instalación para encriptar

- dart pub global activate encrypt

- flutter pub add encrypt

- flutter pub add flutter_secure_storage

- dart pub add bcrypt

## Instalación de base de datos pequeña

flutter pub add shared_preferences

## Instalación de Firebase Realtime Database

flutter pub add firebase_database
