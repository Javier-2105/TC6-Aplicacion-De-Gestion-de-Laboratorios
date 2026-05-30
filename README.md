# LabControl

**LabControl** es una aplicación móvil completa y profesional desarrollada en **Flutter** y **Dart**, diseñada específicamente para la gestión de laboratorios escolares de computación en nivel preparatoria. 

El proyecto cuenta con persistencia local robusta y funciona de manera 100% autónoma sin requerir conexiones a internet, bases de datos externas o llamadas a servicios en la nube.

---

## 🎓 Información Académica

* **Proyecto**: LabControl (Gestión de Laboratorio Escolar)
* **Desarrollador**: Rodolfo Javier Platas Molina
* **Identificación**: `TC6 Platas Molina Rodolfo Javier 23328061310458`
* **Tecnologías**: Flutter, Dart, SQLite, M3 Design.

---

## 🚀 Características Clave

1. **Persistencia Local SQLite (`sqflite`)**: Todo el sistema operativo, computadoras, inventario, agenda de reservas y bitácora de mantenimientos se almacenan localmente.
2. **Dashboard Dinámico y Estadísticas**: Gráficos de pastel (`fl_chart`) que ilustran en tiempo real los estados de los equipos del aula.
3. **Control de Reservas sin Conflictos**: Sistema de agenda que verifica de forma autónoma la coincidencia de laboratorio, fecha y horario de reserva, evitando colisiones de grupos.
4. **Rejilla Visual Interactiva**: Representación visual de las computadoras registradas (Verde = Disponible, Amarillo = Mantenimiento, Rojo = Dañada, Gris = Fuera de Servicio).
5. **Generador de Reportes PDF**: Emisión local de reportes en PDF de todas las áreas del sistema listos para guardar o imprimir.
6. **Icono Personalizado**: Logotipo tecnológico premium empaquetado para plataformas Android e iOS.
7. **Arquitectura Limpia**: Código estructurado por capas (`data`, `providers`, `ui`, `services`).

---

## 📂 Estructura del Directorio

```
lib/
├── main.dart             # Inicialización de la App y proveedores de estado
├── data/
│   ├── db_helper.dart    # Gestor local de SQLite, creación de tablas y mock data
│   └── models/           # Entidades (Usuario, Computadora, Inventario, Reserva, etc.)
├── providers/
│   ├── auth_provider.dart # Estado local de la sesión activa
│   └── lab_provider.dart # Estado global de los CRUDs e interacción con SQLite
├── services/
│   └── pdf_service.dart  # Generador de reportes PDF locales
└── ui/
    ├── splash_screen.dart # Pantalla de carga animada
    ├── login_screen.dart  # Inicio de sesión local
    ├── register_screen.dart # Registro local de usuarios administradores
    ├── dashboard_screen.dart # Panel administrativo central con estadísticas
    ├── computadoras/      # Interfaz de gestión y rejilla visual de computadoras
    ├── inventario/        # Interfaz de gestión de periféricos y equipos de red
    ├── reservas/          # Agenda con tira de días y turnos de la tarde (1:00 PM a 8:00 PM)
    ├── fallas/            # Historial y bitácora de reportes de fallas
    ├── mantenimiento/     # Registro de reparaciones y costos
    └── software/          # Catálogo de programas instalables en los equipos
```

---

## 🛠️ Requisitos de Instalación

1. Instalar la SDK de [Flutter](https://flutter.dev/docs/get-started/install) (versión 3.11.0 o superior).
2. Tener configurada la SDK de Android o un emulador activo.
3. Clonar este repositorio e ingresar al directorio principal:
   ```bash
   git clone <url-del-repositorio>
   cd labcontrol
   ```
4. Descargar las dependencias locales del proyecto:
   ```bash
   flutter pub get
   ```
5. Generar los iconos de lanzamiento para las plataformas nativas:
   ```bash
   flutter pub run flutter_launcher_icons
   ```
6. Compilar la aplicación y generar el APK instalable de Android:
   ```bash
   flutter build apk
   ```

---

## 📈 Turnos y Horarios de Reserva
La aplicación está configurada por defecto para operar en el **Turno de la Tarde (1:00 PM a 8:00 PM)**, segmentado en los siguientes bloques interactivos:
* `13:00 - 14:20`
* `14:20 - 15:40`
* `15:40 - 17:00`
* `17:00 - 18:20`
* `18:20 - 20:00`
