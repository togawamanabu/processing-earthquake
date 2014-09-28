int YEAR = 0;
int MONTH = 1;
int DAY = 2;
int TIME = 3;
int LATITUDE = 4;
int LONGITUDE = 5;
int MAGNITUDE = 6;
int DEPTHS = 7;

void setup() {
    String[] lines = loadStrings("../neic-earthquake-data.csv");

    float minX = 10000;
    float maxX = -1;
    float minY = 10000;
    float maxY = -1;
    float minMagnitude = 1;
    float maxMagnitude = -1;
    float minDepths = 10000;
    float maxDepths = -1;
    long minDatetime = Long.MAX_VALUE;
    long maxDatetime = 0;

    String[] cleaned = new String[lines.length];
    int placeCount = 0;

    for(int row = 1; row < lines.length; row++) {
	String[] data = split(lines[row], ',');
	if(data.length < 8) continue;

	float lat = float(trim(data[LATITUDE]));
	float lon = float(trim(data[LONGITUDE]));
	if (lat > maxX) maxX = lat;
	if (lat < minX) minX = lat;
	if (lon > maxY) maxY = lon;
	if (lon < minY) minY = lon;

	float magnitude = float(trim(data[MAGNITUDE]));
	float depths = float(trim(data[DEPTHS]));
	if (magnitude > maxMagnitude) maxMagnitude = magnitude;
	if (magnitude < minMagnitude) minMagnitude = magnitude;
	if (depths > maxDepths) maxDepths = depths;
	if (depths < minDepths) minDepths = depths;
	
	int h = int(trim(data[TIME]).substring(0,2));
	int m = int(trim(data[TIME]).substring(2,4));

	println("original:" + data[TIME] + " h:" + str(h) + " m:" + str(m));

	long dd = new Date(int(trim(data[YEAR])), int(trim(data[MONTH])), int(trim(data[DAY])), h, m).getTime();
	dd += 1000 * 60 * 60 * 9;
	if (dd > maxDatetime) maxDatetime = dd;
	if (dd < minDatetime) minDatetime = dd;
	
	cleaned[placeCount++] = 
	    dd + "," +
	    lat + "," + 
	    lon + "," +
	    data[MAGNITUDE] + "," + 
	    data[DEPTHS] + ",";
    }

    PrintWriter csv = createWriter("../cleaneddata.csv");
    csv.println("# " + placeCount + "," + minX + "," + maxX + 
		"," + minY + "," + maxY + 
		"," + minMagnitude + "," + maxMagnitude + 
		"," + minDepths + "," + maxDepths + 
		"," + minDatetime + "," + maxDatetime);

    for (int i=0; i<placeCount; i++) {
	csv.println(cleaned[i]);
    }

    csv.flush();
    csv.close();

    println("Finished.");
    exit();
}

