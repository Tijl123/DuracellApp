int sensor1 = A0;
int sensor2 = A1;
int sensor3 = A2;

int val1 = 0;
int val2 = 0;
int val3 = 0;
String output = "";

void setup() {
  Serial.begin(9600);           //  setup serial
}

void loop() {
  val1 = analogRead(sensor1);  // read the input pin
  val2 = analogRead(sensor2);
  val3 = analogRead(sensor3);
  output = String(val1) + ";" + String(val2) + ";" + String(val3);
  Serial.println(output);          // debug value
}
