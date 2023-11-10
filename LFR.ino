int ir[8] = {12, 13, A0, A1, A2, A3, A4, A5};
int mot[4] = {3, 9, 10, 11};

int dir[8];
int base = 255;
int num_Highs;
int rs, ls;

void readData(int ir[] , int dir[]) {

  for( int i = 0; i < 8; i++) {
    dir[i] = digitalRead(ir[i]);
  }
}

float getPOS(int ir[], int dir[]){
  num_Highs = 0;
  readData(ir, dir);

  float sum = 0;

  for( int i=0; i<8; i++) {
    num_Highs += dir[i];
    sum += (dir[i]) ? (i-3.5) : 0;
  }

  if(!num_Highs) 
    return 0;
  
  return sum / num_Highs;

}

void motorCalls(float pid) {
  if (!num_Highs) { // Sensor at full white ,. Move backwards
    motorRun(mot[0], mot[1], 0, base);
    motorRun(mot[2], mot[3], 0, base);
    delay(40);
    return;
  }

  ls = ((base + pid) > 255) ? 255 : ((base + pid) < 0) ? 0 : (base + pid);
  rs = ((base - pid) > 255) ? 255 : ((base - pid) < 0) ? 0 : (base - pid);

  if (!num_Highs || (num_Highs > 3)) { // Hard turns detected / Sensors at full white,. using value from pid and make turn
  motorRun(mot[0], mot[1], !(ls > rs), base);
  motorRun(mot[2], mot[3], !(rs > ls), base);
  delay(40);
  }
  else { // PID run
    motorRun(mot[0], mot[1], 1, rs);
    motorRun(mot[2], mot[3], 1, ls);
  }
}

void motorRun(int m1, int m2, bool dir, int spd) {

  if(!dir) {
    digitalWrite(m1, HIGH);
    analogWrite(m2, 255-spd);
    return;
  }
  digitalWrite(m2, HIGH);
  analogWrite(m1, 255-spd);
}

void pid(float error) {

  static float I = 0;
  static float prevError = 0;

  float P = error;
  I += error;
  float D = error - prevError;
  prevError += (error - prevError);

  float Kp = 100.0, Ki = 0.0, Kd = 1.0;

  float pid = P * Kp + I * Ki + D * Kd;

  motorCalls(pid);
}

void setup() {
  for(int i=0; i<8; i++) {
    pinMode(ir[i],INPUT);
  }
  for(int i=0; i<4; i++) {
    pinMode(mot[i],OUTPUT);
  }
}

void loop() {
  float pos = getPOS(ir, dir);
  
  pid( pos );
}
