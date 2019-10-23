// $BACKGROUND$

// Scans sample and saves images with microscope settings


//Global variables
string save_loc = "//flexo.ads.warwick.ac.uk/Shared38/ARM200/Users/Jeffrey-Ede/dlss-stem/";
number Camb=4096, Camr=4096//Global values, for Orius SC600 camera
object img_src;
number binning=8; //Could be a dialogue
number expo=0.1; //Could be a dialogue
image img1;
number true=1, false=0;
number pi = 3.141592654;

//Function UpdateCameraImage
//Gets next available frame from the camera 
void UpdateCameraImage(object img_src, image img)
{
  // Wait for next frame
  number acq_params_changed = 0;
  number max_wait = 0.2;
  if (!img_src.IMGSRC_AcquireTo(img,true,max_wait,acq_params_changed))
  {   
	while (!img_src.IMGSRC_AcquireTo(img,false,max_wait,acq_params_changed))
	{
	} 
  }
}

//Function EMChangeMode
//Asks user to change mode - will keep doing so until they comply
//Space bar to exit loop
void EMChangeMode(string mode_want)
{
	string mode_is=EMGetImagingOpticsMode();
	number clickedOK=true;
	while (!(mode_is==mode_want))//not in desired mode
	{
	clickedOK=true;
	external sem=NewSemaphore();
	try
	{
	 ModelessDialog("Please put the microscope in "+mode_want+" mode","OK",sem);
	 GrabSemaphore(sem);
	 ReleaseSemaphore(sem);
	 FreeSemaphore(sem);
	}
	catch
	{
	 FreeSemaphore(sem);
	 clickedOK=false;
	 break;
	}
	mode_is=EMGetImagingOpticsMode();
	}
	// Give user some way out 
	if (spacedown()) throw("User aborted")
}//End of EMChangeMode

void save_image(number i, string save_loc_num, object img_src)
{
	image img;

	UpdateCameraImage(img_src, img);
	SaveImage( img, save_loc_num + i + ".dm3" );
}

//MAIN PROGRAM

//Works in imaging mode
//EMChangeMode("MAG1")
external sem = NewSemaphore();
try
{
	ModelessDialog("Please IMAGE!","OK",sem)
	GrabSemaphore(sem)
	ReleaseSemaphore(sem)
	FreeSemaphore(sem)
}
catch
{
	FreeSemaphore(sem)
	break;
}

//Start the camera running in fast mode
//Use current camera
object camera = CMGetCurrentCamera();
// Create standard parameters
number data_type=2;
number kUnprocessed = 1;
number kDarkCorrected = 2;
number kGainNormalized = 3;
number processing = kGainNormalized;
// Define camera parameter set
object acq_params = camera.CM_CreateAcquisitionParameters_FullCCD(processing,expo,binning,binning);
acq_params.CM_SetDoContinuousReadout(true);
acq_params.CM_SetQualityLevel(0);//What this does is unclear
object acquisition = camera.CM_CreateAcquisition(acq_params);
object frame_set_info = acquisition.CM_ACQ_GetDetector().DTCTR_CreateFrameSetInfo();
img_src = alloc(CM_AcquisitionImageSource).IMGSRC_Init(acquisition,frame_set_info,0);
CM_ClearDarkImages()//May not be necessary
img1:= acquisition.CM_CreateImageForAcquire( "Live" );
img1.DisplayAt(10,30);

number proc_period = 1.0;

number cmd_num = 1;

img_src.IMGSRC_BeginAcquisition();

while (true)
{
    try
	{
		UpdateCameraImage(img_src, img1);
		SaveImage( img1, save_loc + "/img.dm3" );
	}
	catch
	{
	break;
	}
	
	sleep(proc_period);
}