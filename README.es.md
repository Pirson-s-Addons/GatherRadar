<h1 align="center">GatherRadar</h1>

<p align="center">
  <b>Rastreador de hierbas y menas para World of Warcraft: hierbas, minería, tesoros y bancos de peces en el minimapa y el mapa del mundo</b>
</p>

<p align="center">
<a href="https://github.com/Pirson-s-Addons/GatherRadar/releases/latest">
<img src="https://img.shields.io/github/v/release/Pirson-s-Addons/GatherRadar?style=for-the-badge&color=A78BFA">
</a>
<img src="https://img.shields.io/badge/WoW_Forever-1.60.1-C4B5FD?style=for-the-badge">
<a href="LICENSE">
<img src="https://img.shields.io/badge/License-MIT-E9D5FF?style=for-the-badge">
</a>
</p>

<p align="center">
<a href="README.md">🇬🇧 English</a>
</p>

---

## Qué hace

**GatherRadar** convierte Buscar hierbas, Buscar minerales, Buscar tesoros y Buscar peces en un radar de recolección de verdad. Cada nodo del minimapa lleva el **icono de lo que da** (Flor de paz, Mineral de cobre, un cofre...) con un aro que te dice tu probabilidad de subir habilidad, y cada nodo que recoges o ves se **recuerda** en el minimapa y en el **mapa del mundo**, para que planees tu ruta de un vistazo.

## Funciones

- **Iconos en el minimapa**: el icono real del objeto en cada hierba, filón, cofre y banco de peces, redondo y con un aro del color de la ventana de profesión (naranja, amarillo, verde, gris; rojo si aún no tienes habilidad).
- **Recuerda cada nodo**: los que recoges (posición exacta) y, si quieres, los que el escáner ve en el minimapa. Lo que está ahora brilla; lo recordado sale atenuado, porque quizá ya lo recogió otro.
- **Pines en el mapa del mundo** con todos los nodos guardados de la zona. Mayús + clic derecho en un pin lo borra.
- **Sin duplicados**: dos nodos del mismo tipo a menos de 15 yardas (tú eliges) son el mismo sitio y se queda solo uno.
- **Importa GatherMate2_Data**: si tienes GatherMate2 y GatherMate2_Data, con un clic añades los nodos de Wowhead que te faltan. Los tuyos nunca se sustituyen.
- **Flecha al nodo más cercano** con su nombre y distancia, dando prioridad a lo que hay ahora en el minimapa.
- **Compartir con el grupo**: tus compañeros con GatherRadar ven los nodos que encuentras, y tú los suyos, en vivo.
- **Panel de sesión**: nodos recogidos y materiales conseguidos, con iconos, total y por hora.
- **Aprende tu idioma**: los nombres de los nodos en el idioma de tu cliente se aprenden al recoger, así que funciona en todos los idiomas.
- Opciones en el propio panel del juego **Opciones → AddOns**, 20 idiomas, sin librerías.

## Instalación

1. Descarga el zip de [CurseForge](https://www.curseforge.com/wow/addons/gatherradar) o de la [última versión](https://github.com/Pirson-s-Addons/GatherRadar/releases/latest).
2. Extrae la carpeta `GatherRadar` en `World of Warcraft/_classic_beta_/Interface/AddOns/`.
3. Reinicia WoW y activa el addon.

## Uso

- Activa **Buscar hierbas**, **Buscar minerales**, **Buscar tesoros** o **Buscar peces** en el menú de rastreo del minimapa. GatherRadar hace el resto.
- `/gr` abre las opciones. `/gr session` muestra el panel de sesión, `/gr arrow` la flecha, `/gr import` importa GatherMate2_Data.
- **Opciones → AddOns → GatherRadar → General**: qué se ve y dónde, el radar y el tamaño de los iconos.
- **Opciones → AddOns → GatherRadar → Datos**: nodos guardados, duplicados, importar GatherMate2_Data y borrar.

## Notas

- Un addon no puede preguntar al juego dónde están los nodos: GatherRadar lee el minimapa con un ratón virtual, los mismos puntos que ves tú. Sin un rastreo activado solo salen los nodos recordados.
- Los bancos de peces se guardan solo desde el minimapa (el botín de pesca sale del corcho, no del banco).
- En un idioma que no sea el inglés, las hierbas funcionan desde el principio; los nombres de menas y cofres se aprenden la primera vez que los minas o abres. Los bancos de peces, de momento, solo se reconocen en inglés.

---

**Autor**: Pirson · [GitHub](https://github.com/Pirson-s-Addons) · [CurseForge](https://www.curseforge.com/members/pirson/projects) · Licencia MIT
