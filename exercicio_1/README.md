
# Registro de Eventos Flutter

Este aplicativo Flutter permite registrar eventos com data, hora e descrição, salvando cada evento em uma lista persistida em arquivo JSON.

## Funcionalidades

- Formulário para inserir data, hora e descrição do evento
- Lista de eventos exibida em cards estilizados
- Persistência dos eventos em arquivo JSON local
- Interface moderna e responsiva

## Como rodar o projeto

1. **Pré-requisitos:**
	- Flutter instalado ([instalação oficial](https://docs.flutter.dev/get-started/install))
	- Dart SDK

2. **Instale as dependências:**
	Abra o terminal na pasta do projeto e execute:
	```sh
	flutter pub get
	```

3. **Execute o app:**
	```sh
	flutter run
	```

## Sobre a persistência dos eventos

Os eventos são salvos automaticamente em um arquivo `events.json` na pasta de documentos do sistema, usando o pacote `path_provider`. Esse arquivo não aparece na pasta do projeto, mas é gerenciado pelo próprio app.

## Estrutura do projeto

- `lib/main.dart`: Código principal do app
- `pubspec.yaml`: Dependências do projeto

## Autor

Jonas
