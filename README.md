# termostato_2

A new Flutter project.

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
