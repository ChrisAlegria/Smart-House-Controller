#include <BluetoothSerial.h>
#include <Servo.h>
#include <DHT.h>

// Instancia de la clase Bluetooth
BluetoothSerial BT;

// Puertos GPIO para LEDs RGB y servo
int redLed = 21, greenLed = 19, blueLed = 18;
int redColor = 0, greenColor = 0, blueColor = 0;

// Servo
Servo myServo;
int servoPin = 5;

// Sensor DHT
#define DHTPIN 4  // Pin conectado al sensor DHT
#define DHTTYPE DHT11  // Cambia a DHT22 si usas ese modelo
DHT dht(DHTPIN, DHTTYPE);

// Inicialización de Bluetooth, puertos y periféricos
void setup() {
  Serial.begin(9600);
  BT.begin("ESP32");

  pinMode(redLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  pinMode(blueLed, OUTPUT);

  // Inicialización de LED
  analogWrite(redLed, 0);
  analogWrite(greenLed, 0);
  analogWrite(blueLed, 0);

  // Inicialización del servo
  myServo.attach(servoPin);

  // Inicialización del sensor DHT
  dht.begin();
}

void loop() {
  if (BT.available()) {
    // Leer los valores desde el Bluetooth
    String data = BT.readStringUntil('\n');
    parseData(data); 
  }
  
  // Leer y enviar la temperatura
  float temp = dht.readTemperature();
  if (!isnan(temp)) {
    String tempStr = "TEMP," + String(temp);
    BT.println(tempStr);
  }

  delay(2000);  // Intervalo para leer la temperatura
}

void parseData(String data) {
  if (data.startsWith("RGB,")) {
    parseRGB(data.substring(4));
  } else if (data.startsWith("SERVO,")) {
    parseServo(data.substring(6));
  } else {
    Serial.println("Comando no reconocido");
  }
}

void parseRGB(String data) {
  int commaIndex1 = data.indexOf(',');
  int commaIndex2 = data.lastIndexOf(',');

  if (commaIndex1 > 0 && commaIndex2 > commaIndex1) {
    redColor = data.substring(0, commaIndex1).toInt();
    greenColor = data.substring(commaIndex1 + 1, commaIndex2).toInt();
    blueColor = data.substring(commaIndex2 + 1).toInt();

    Serial.print(redColor);
    Serial.print(", ");
    Serial.print(greenColor);
    Serial.print(", ");
    Serial.println(blueColor);

    analogWrite(redLed, redColor);
    analogWrite(greenLed, greenColor);
    analogWrite(blueLed, blueColor);
  } else {
    Serial.println("Valor RGB incorrecto");
  }
}

void parseServo(String data) {
  int angle = data.toInt();
  if (angle >= 0 && angle <= 180) {
    myServo.write(angle);
    Serial.print("Servo movido a: ");
    Serial.println(angle);
  } else {
    Serial.println("Ángulo de servo incorrecto");
  }
}
