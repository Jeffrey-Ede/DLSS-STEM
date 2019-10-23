// $BACKGROUND$

// Scans sample and saves images with microscope settings


//Global variables
string save_loc = "//flexo.ads.warwick.ac.uk/Shared38/ARM200/Users/Jeffrey-Ede/dlss-stem/";

number true=1, false=0;
number pi = 3.141592654;




//***Main program***
number signalIndex, dataDepth, acquire, imageID
number dim=103;
number dwellT=5;//us
//Create scan parameters (Width, Height, Rotation, dwell time, line sync)
number paramID = DSCreateParameters(dim,dim,0,dwellT,0)
//First detector
signalIndex = 0
dataDepth = 4
acquire = 1
imageID = 0
DSSetParametersSignal( paramID, signalIndex, dataDepth, acquire, imageID )
//Second detector.
signalIndex = 1
dataDepth = 4
acquire = 1
imageID = 1
DSSetParametersSignal( paramID, signalIndex, dataDepth, acquire, imageID )

DSStartAcquisition(paramID,0,1)

//		SaveImage( img1, save_loc + "/img.dm3" );
