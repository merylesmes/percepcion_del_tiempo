document.addEventListener('DOMContentLoaded', function () {
    const startButton = document.querySelector('.button_start'); // Botón de inicio
    const startScreen = document.querySelector('.start_screen'); // Pantalla inicial
    const appScreen = document.querySelector('.app'); // Contenedor del reloj
    const finalTimeScreen = document.querySelector('.final_time'); // Pantalla para la hora final
    const timeDisplay = document.querySelector('.time_display'); // Elemento para mostrar la hora final

    // Evento para el clic del botón "Comenzar"
    startButton.addEventListener('click', function () {
        // Ocultar la pantalla inicial
        startScreen.style.display = 'none';
        // Mostrar la pantalla del reloj
        appScreen.style.display = 'block'; // Asegurarse de que esté visible

        // Iniciar el p5.js
        new p5(s => {
            let numSegundos = 120;
            let numMinutos = 60;
            let numHoras = 24;

            let radioBase = 100;
            let incrementoRadio = 50;
            let rotacionSegundos = 0;
            let rotacionMinutos = 0;
            let rotacionHoras = 0;

            let velocidadSegundos = 0.01;
            let velocidadMinutos = 0.005;
            let velocidadHoras = 0.002;

            let nivelesSegundos = new Array(numSegundos).fill(0);
            let nivelesMinutos = new Array(numMinutos).fill(0);
            let nivelesHoras = new Array(numHoras).fill(0);

            let conexiones = []; // Lista de conexiones
            let contadorSeg = 0; // Contador de segundos
            let contadorMin = 0; // Contador de minutos
            let contadorHor = 0; // Contador de horas
            let clockStarted = false; // Para asegurar que solo se muestra la hora final una vez
            let finalTime = ''; // Variable para almacenar la hora final

            s.setup = () => {
                // Establece el tamaño del lienzo para ocupar toda la ventana
                s.createCanvas(window.innerWidth, window.innerHeight);
                s.frameRate(60);
                s.noCursor(); // Opcional: para ocultar el cursor mientras se ve el reloj
            }

            s.draw = () => {
                s.background(20);
                s.translate(s.width / 2, s.height / 2); // Centrar el contenido en la pantalla

                // Actualizar rotaciones según la velocidad
                rotacionSegundos += velocidadSegundos;
                rotacionMinutos += velocidadMinutos;
                rotacionHoras += velocidadHoras;

                // Dibujar los tres anillos
                dibujarAnillo(numSegundos, radioBase + 2 * incrementoRadio, rotacionSegundos, s.color(0, 100, 255), nivelesSegundos, true);
                dibujarAnillo(numMinutos, radioBase + incrementoRadio, rotacionMinutos, s.color(255, 200, 0), nivelesMinutos, true);
                dibujarAnillo(numHoras, radioBase, rotacionHoras, s.color(255, 50, 50), nivelesHoras, false);

                // Mostrar contadores
                s.noStroke(); // Asegúrate de que no hay contorno en el texto
                s.fill(255);
                s.textSize(16);
                s.text("Segundos: " + contadorSeg, -s.width / 2 + 20, -s.height / 2 + 30);
                s.text("Minutos: " + contadorMin, -s.width / 2 + 20, -s.height / 2 + 50);
                s.text("Horas: " + contadorHor, -s.width / 2 + 20, -s.height / 2 + 70);
                
                // Dibujar las conexiones (telarañas)
                dibujarConexiones();
                // Si no se ha iniciado el reloj, iniciar y establecer el temporizador
                if (!clockStarted) {
                    clockStarted = true;

                    // Mostrar la hora final después de 10 segundos
                    setTimeout(() => {
                        // Calcular la hora final
                        finalTime = getFinalTime();
                        // Mostrar la hora final en la pantalla
                        timeDisplay.textContent = `Hora Final: ${finalTime}`;
                        finalTimeScreen.style.display = 'block'; // Mostrar la pantalla con la hora final
                        finalTimeScreen.style.transition = 'opacity 1s'; // Añadir una transición suave
                        finalTimeScreen.style.opacity = '1'; // Asegurar que sea visible
                    

                        s.noLoop();
                        // Ocultar el reloj después de 10 segundos
                        appScreen.style.display = 'none'; // Ocultar el reloj
                    }, 10000); // Esperar 10 segundos
                }

                
            }

            // Función para calcular la hora final en formato HH:MM:SS
            function getFinalTime() {
                const hours = String(contadorHor).padStart(2, '0');
                const minutes = String(contadorMin).padStart(2, '0');
                const seconds = String(contadorSeg).padStart(2, '0');
                return `${hours}:${minutes}:${seconds}`;
            }

            // Función para dibujar un anillo con divisiones
            function dibujarAnillo(numDivisiones, radio, rotacion, c, niveles, crecerHaciaFuera) {
                s.strokeWeight(2);
                s.noFill();
                s.stroke(c);

                for (let i = 0; i < numDivisiones; i++) {
                    let anguloInicio = s.TWO_PI / numDivisiones * i + rotacion;
                    let x1 = s.cos(anguloInicio) * radio;
                    let y1 = s.sin(anguloInicio) * radio;

                    let radioModificado = crecerHaciaFuera ? radio + niveles[i] * 50 : radio - niveles[i] * 50;
                    let x2 = s.cos(anguloInicio) * radioModificado;
                    let y2 = s.sin(anguloInicio) * radioModificado;

                    s.line(x1, y1, x2, y2);
                }
            }

            // Función de interacción con teclas
            s.keyPressed = () => {
                let indice = 0;
                if (s.key === 'm') {
                    añadirMinutos(indice);
                } else if (s.key === 'h') {
                    añadirHoras(indice);
                } else if (s.key === 's') {
                    añadirSegundos(indice);
                }
            }

            // Funciones para añadir segundos, minutos y horas
            function añadirSegundos(indice) {
                if (contadorSeg === 60) {
                    contadorSeg = 0;
                    añadirMinutos(indice);
                } else {
                    indice = getIndiceActivo(numSegundos, rotacionSegundos);
                    nivelesSegundos[indice] = s.constrain(nivelesSegundos[indice] + 0.1, 0, 1);
                    contadorSeg++;
                }
            }

            function añadirMinutos(indice) {
                if (contadorMin === 60) {
                    añadirHoras(indice);
                    contadorMin = 0;
                } else {
                    indice = getIndiceActivo(numMinutos, rotacionMinutos);
                    nivelesMinutos[indice] = s.constrain(nivelesMinutos[indice] + 0.1, 0, 1);
                    contadorMin++;
                }
            }

            function añadirHoras(indice) {
                if (contadorHor === 24) {
                    contadorHor = 0;
                } else {
                    indice = getIndiceActivo(numHoras, rotacionHoras);
                    nivelesHoras[indice] = s.constrain(nivelesHoras[indice] + 0.1, 0, 1);
                    contadorHor++;
                }
            }

            // Función para obtener el índice activo según el ángulo
            function getIndiceActivo(numDivisiones, rotacion) {
                let anguloPorDivision = s.TWO_PI / numDivisiones;
                return Math.floor((rotacion / anguloPorDivision) % numDivisiones);
            }

            // Función para dibujar las conexiones (telarañas)
            function dibujarConexiones() {
                s.strokeWeight(1);

                for (let conexion of conexiones) {
                    let [indice1, tipo1, indice2, tipo2] = conexion;

                    // Obtener las coordenadas de los dos puntos
                    let [x1, y1] = getCoordenadas(indice1, tipo1);
                    let [x2, y2] = getCoordenadas(indice2, tipo2);

                    // Asignar color según el tipo de conexión
                    if (tipo1 === 0) {
                        s.stroke(0, 100, 255, 100);  // Conexión de segundos (azul)
                    } else if (tipo1 === 1) {
                        s.stroke(255, 200, 0, 100);  // Conexión de minutos (amarillo)
                    } else if (tipo1 === 2) {
                        s.stroke(255, 50, 50, 100);  // Conexión de horas (rojo)
                    }

                    // Dibujar una línea entre los dos puntos
                    s.line(x1, y1, x2, y2);
                }
            }

        });
    });
});
