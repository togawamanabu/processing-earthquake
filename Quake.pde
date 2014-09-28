class Quake {
    long time;
    float latitude;
    float longitude;
    float magnitude;
    float depth;
    int alpha;
    boolean visible;

    int soundCount;

    static final int MAX_R = 10;

    public Quake(long time, float latitude, float longitude, float magnitude, float depth) {
	this.time = time;
	this.latitude = latitude;
	this.longitude = longitude;
	if(magnitude < 1) magnitude= 1;
	this.magnitude = magnitude;
	this.depth = depth;
	this.alpha = 200;
	this.soundCount = 0;
    }

    void draw() {
	if(!visible) {
	    if(timer <= time && time < timer + TIMESPAN * speed) {
		visible = true;
		alpha = 200;
	    }
	}

	if(visible) {
	    if(!animationStop) {
		alpha -= 5;
	    } 

	    if(this.mouseDistance() != MAX_FLOAT) {
		alpha = 255;
	    }

	    int xx = (int)TX(longitude);
	    int yy = (int)TY(latitude);
	    //	set(xx, yy, #000000);
	    float percent = norm(depth, minDepths, maxDepths);
	    color fillcolor;

	    if(6 <= magnitude) {
		fillcolor= lerpColor(#ff3030, #330a0a, percent, HSB);
	    } else if(5 <= magnitude && magnitude < 6) {
		fillcolor= lerpColor(#ff9831, #663d14, percent, HSB);
	    } else {
		fillcolor = lerpColor(#ffff31, #666614, percent, HSB);
	    }
	    fill(fillcolor, alpha);
	    float r = map(magnitude, minMagnitude, maxMagnitude, 1, MAX_R);
	    r = r*r * 1.5;
	    ellipse(xx, yy, r, r);
	}

	if(alpha <= 0) {
	    visible = false;
	}
    }

    float mouseDistance() {
	if(!visible) {
	    return MAX_FLOAT;
	}

	float r = map(magnitude, minMagnitude, maxMagnitude, 1, MAX_R);
	float d = dist((int)TX(longitude), (int)TY(latitude), mouseX, mouseY);
	r = r*r * 1.5;
	if (d < r/2 + 2) {
	    return d;
	} else {
	    return MAX_FLOAT;
	}
    }
}
