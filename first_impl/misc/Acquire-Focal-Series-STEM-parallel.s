// Acquire Focal Series - STEM
// Created for STEM by M. Sarahan, March 2010
// Based on the Acquire Focal Series script by David Mitchell
// version 1.0

// Set to acquire two signals in parallel by default (was created for 
// a JEOL 2100F with Gatan BF/DF and a JEOL HAADF detector.)
// Requires a Digiscan (possibly a Digiscan 2) scan controller, 
// but should work on any microscope that uses the Digiscan.

If (SHIFTdown())
{
	documentwindow reswin
	reswin =getresultswindow(1)
	if(reswin.windowisvalid()) windowclose(reswin,0)
	reswin =getresultswindow(1)
	WindowSetFramePosition( reswin, 140, 800 ) 
	WindowSetFrameSize( reswin, 800, 220 ) 
	WindowSetTitle( reswin, "Instructions") 

	result("1 This script will create and save a through-focus series of images. "+"\n"\
	+"2 Follow the prompts at the start. When you create the folder to save your images into - "+"\n"\
	+"  make sure you: a) Select the folder location (eg Desktop), b) Create the folder and c) Press Save."+"\n"\
	+"3 Do Not enter anything into the filename box when creating your folder."+"\n"\
	+"4 The program will then work through your images starting at the current focus and going positive (overfocus)."+"\n")
	exit(0)
}

number true = 1, false = 0, currentFocus=-400
number topLeftX = 140, topLeftY = 24, targetsize=1024, xpos=topleftx, ypos=toplefty
number screenW, screenH
GetScreenSize(screenW, screenH)

number step = 10, maxFocus = 400, imgs = 0, setNumber = 1, dim = 512, dwellT = 5

 // get some information
 // prompt input for set number
 if (!GetNumber("Label number for this Set of Images?",1,setNumber))
 exit(0)
 // prompt input for focus step
 if (!GetNumber("Defocus step(nm)?",10,step))
 exit(0)
 // prompt input for the initial defocus position
 if (!GetNumber("Starting defocus (nm)?",-400,currentFocus))
 exit(0)
 // prompt input for max defocus
 if (!GetNumber("Maximum defocus?",-currentFocus,maxFocus))
 exit(0)
  // prompt input for image dimensions
 if (!GetNumber("Image dimensions?",512,dim))
 exit(0)
  // prompt input for pixel dwell time
 if (!GetNumber("Pixel dwell time (us)?",5,dwellT))
 exit(0)

string name=" ", pathname
if (!saveasdialog("","Select the save location - then click Save", pathname)) Exit (0)

number stringlength
stringlength=len(pathname)
pathname=left(pathname,stringlength-42)
image acqImg, acqImg2


// Image acquisition starts here

 number top = 0,left = 0
 number indx = 1,focus = currentFocus, paramID=0
 string nameImg, nameImg2
 number signalIndex, dataDepth, acquire, imageID

 // EMSetupCommunication()

while (currentFocus <= maxFocus)
	{
		EMChangeFocus(focus)
		// The EMChangeFocus command sends the amount of lens change. On the first pass through it is zero.
		// On subsequent iterations it is set to the focal step.
		focus=step
		
		//Create scan parameters (Width, Height, Rotation, dwell time, line sync)
		paramID = DSCreateParameters(dim,dim,82,dwellT,0)
		
		//This is your first detector
		signalIndex = 0
		dataDepth = 4
		acquire = 1
		imageID = 0
		DSSetParametersSignal( paramID, signalIndex, dataDepth, acquire, imageID )
		//This is your second detector.
		// Comment the lines between the brackets if you don't have 
		// two detectors or don't want to use two detectors.
		// {
		signalIndex = 1
		dataDepth = 4
		acquire = 1
		imageID = 0
		DSSetParametersSignal( paramID, signalIndex, dataDepth, acquire, imageID )
		// }
		
		DSStartAcquisition(paramID,0,1)
		
		image acqImg := GetFrontImage()
		// set the filename for detector 1 here
		nameImg = "JEOL_" + round(currentFocus) + "nm"
		
		//Save the image to a folder
		nameImg=pathname+nameImg
    	SaveasGatan(acqImg,nameImg)
    	
    	acqImg2 := FindNextImage(acqImg)
		// set the filename for detector 2 here
		nameImg2 = "Gatan_" + round(currentFocus) + "nm"
		
		//Save the image to a folder
		nameImg2=pathname+nameImg2
    	SaveasGatan(acqImg2,nameImg2)
    	
    	DeleteImage(acqImg)
    	DeleteImage(acqImg2)
    	delay(30)
		currentfocus+=focus
	}

// finish and change focus back to 0

EMChangeFocus(-(currentFocus-focus))

beep()
openandsetprogresswindow("","","")
