import java.util.Date;
import controlP5.*;

static final int TIME = 0;
static final int LATITUDE = 1;
static final int LONGITUDE = 2;
static final int MAGNITUDE = 3;
static final int DEPTH = 4;

static final int TIMESPAN = 1000 * 60 * 60 * 24 * 12 / 30;

int totalCount;
Quake[] quakes;
int quakeCount;
float minX, maxX;
float minY, maxY;
float minMagnitude, maxMagnitude;
float minDepths, maxDepths;
long minTime, maxTime;

float mapX1, mapY1;
float mapX2, mapY2;

long timer;

PImage mapImage;
PFont font;

float closestDist;
Quake closestQuake;

boolean animationStop;
float speed;

public void setup() {
    size(1024, 768);
    frameRate(30);

    mapImage = loadImage("map.png");

    mapX1 = 0;
    mapX2 = width - mapX1;
    mapY1 = 0;
    mapY2 = height -mapY1;
    animationStop = false;

    mapImage.resize(int(mapX2 - mapX1), int(mapY2 - mapY1));
    font =  loadFont("ArialMT-48.vlw");
    readData();

    timer = minTime;
    speed = 1;

    smooth();
    noStroke();

    ControlP5 controlP5 = new ControlP5(this);
    controlP5.addSlider("speed", 0.1, 20, 1, width - 150, height - 50, 100, 20);
}

public void draw() {
    background(255);
    image(mapImage, 0, 0);

    fill(255, 255);
    textFont(font);
    Date date = new Date(timer);

    textSize(30);
    text(date.getYear(), 20, 40);
    textSize(35);
    text(nf(date.getMonth() + 1, 2, 0) + "/" + nf(date.getDate(), 2, 0), 20, 70);
    textSize(20);
    text(nf(date.getHours(), 2, 0) + " : " + nf(date.getMinutes(), 2, 0), 20, 90);

    closestDist = MAX_FLOAT;
    closestQuake = null;

    for(int i=0; i<quakeCount; i++) {
	quakes[i].draw();
	float d = quakes[i].mouseDistance();
	if(d  < closestDist) {
	    closestDist = d;
	    closestQuake = quakes[i];
	}
    }

    if(closestDist ==  MAX_FLOAT) {
	animationStop = false;
	timer += TIMESPAN * speed;
    } else {
	animationStop = true;

	drawTooltip();
    }

    if(maxTime < timer) {
	timer = minTime;
    }
}

void stop() {

    super.stop();
}

float TX(float x) {
    return map(x, minX, maxX, mapX1, mapX2);
}

float TY(float y) {
    return map(y, minY, maxY, mapY2, mapY1);
}

void readData() {
    String[] lines = loadStrings("cleaneddata.csv");
    parseInfo(lines[0]);
    
    quakes = new Quake[totalCount];
    for (int i=1; i<lines.length; i++) {
	quakes[quakeCount] = parseQuake(lines[i]);
	quakeCount++;
    }
}

void parseInfo(String line) {
    String infoString = line.substring(2);
    String[] infoPieces = split(infoString, ',');
    totalCount = int(infoPieces[0]);
    minX = float(infoPieces[3]);
    maxX = float(infoPieces[4]);
    minY = float(infoPieces[1]);
    maxY = float(infoPieces[2]);
    minMagnitude = float(infoPieces[5]);
    maxMagnitude = float(infoPieces[6]);
    minDepths = float(infoPieces[7]);
    maxDepths = float(infoPieces[8]);
    minTime = Long.parseLong(infoPieces[9]);
    maxTime = Long.parseLong(infoPieces[10]);
}

Quake parseQuake(String line) {
    String pieces[] = split(line, ',');
    long time = Long.parseLong(pieces[TIME]);
    float latitude = float(pieces[LATITUDE]);
    float longitude = float(pieces[LONGITUDE]);
    float magnitude = float(pieces[MAGNITUDE]);
    float depth = float(pieces[DEPTH]);

    return new Quake(time, latitude, longitude, magnitude, depth);
}

void drawTooltip() {
    if(closestQuake != null) {
	fill(255, 200);
	roundrect(mouseX, mouseY, 150, 60, 10);
	fill(0);
	textSize(13);
	Date date = new Date(closestQuake.time);
	text(date.getYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate() + " " + nf(date.getHours(), 2, 0) + ":" + nf(date.getMinutes(), 2, 0), mouseX + 5, mouseY + 15);
	text("マグニチュード : " + str(closestQuake.magnitude), mouseX + 5, mouseY + 35);
	text("震源の深さ : " + str(closestQuake.depth) + "m", mouseX + 5, mouseY + 55);
    }
}

void roundrect(int x, int y, int w, int h, int r) {
    noStroke();

    rectMode(CORNER);

    int  ax, ay, hr;

    ax=x+w-1;
    ay=y+h-1;
    hr = r/2;

    rect(x, y, w, h);
    arc(x, y, r, r, radians(180.0), radians(270.0));
    arc(ax, y, r,r, radians(270.0), radians(360.0));
    arc(x, ay, r,r, radians(90.0), radians(180.0));
    arc(ax, ay, r,r, radians(0.0), radians(90.0));
    rect(x, y-hr, w, hr);
    rect(x-hr, y, hr, h);
    rect(x, y+h, w, hr);
    rect(x+w,y,hr, h);

}
