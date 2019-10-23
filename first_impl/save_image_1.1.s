// $BACKGROUND$

// Scans sample and saves images with microscope settings


//Global variables
string save_loc = "//flexo.ads.warwick.ac.uk/Shared38/ARM200/Users/Jeffrey-Ede/dlss-stem/";

number true=1, false=0;
number pi = 3.141592654;




//***Main program***
Object StartSignal;
Object StopSignal;

startsignal=NewSignal(0)
stopsignal=NewSignal(0)

object self
number sz = 256;//image size
number dwell=100;//dwell time us
number used_signals = 2;
number dataDepth = 4;
number lineSync = 0;

image signals = IntegerImage("signals", 4, 0, 1, used_signals);

signals.setpixel(0,0,0)
signals.setpixel(0,1,1)

image acquire_image_ids := IntegerImage("acquire_image_ids", 4, 0, 1, used_signals)

// 0 - JEOL ADF
// 1 - JEOL BF
// 2 - Gatan BF/ADF
// 3 - Gatan HAADF

image img := IntegerImage("DS acquire " + DSGetSignalName(0), dataDepth, 0, sz, sz)

acquire_image_ids.setpixel(0, 0, imagegetid(img))

img.DisplayAt(50,50);
img.SetWindowSize(1000,1000);
stopsignal.resetsignal()

/*
try
{
	number waitforstopsignal = 0.02
	StartSignal.WaitOnSignal(waitforstopsignal, StopSignal)
	number _PID = DSCreateParameters(sz, sz, 0, dwell, lineSync)
	DSSetParametersSignal(_PID, 0, dataDepth, 1, acquire_image_ids.getpixel(0,0));
	// set the final parameters and acquire the first image
	number continuous = 0  // 0 = single frame, 1 = continuous
	number synchronous = 1  // 0 = return immediately, 1 = return when finished
	DSStartAcquisition(_PID, continuous, synchronous)
	//DSWaitUntilFinished() // only if we want synchronous to be 0 for some reason?
	DSDeleteParameters(_PID)	
}
catch
{
	stopsignal.resetsignal()
	Break
}
*/

number proc_period = 0.2

void main()
{
	try
	{
	while (true)
	{
		try
		{
			number waitforstopsignal = 0.02
			StartSignal.WaitOnSignal(waitforstopsignal, StopSignal)
			number _PID = DSCreateParameters(sz, sz, 0, dwell, lineSync)
			DSSetParametersSignal(_PID, 0, dataDepth, 1, acquire_image_ids.getpixel(0,0));
			// set the final parameters and acquire the first image
			number continuous = 0  // 0 = single frame, 1 = continuous
			number synchronous = 1  // 0 = return immediately, 1 = return when finished
			DSStartAcquisition(_PID, continuous, synchronous)
			//DSWaitUntilFinished() // only if we want synchronous to be 0 for some reason?
			DSDeleteParameters(_PID)	

			SaveImage( img, save_loc + "/img.dm3" );
			
		}
		catch
		{
			stopsignal.resetsignal()
			Break
		}
		if (spacedown()) throw("User aborted")
		sleep(proc_period);
	}
	}
	catch
	{
	break;
	}
	
}


main()



//		SaveImage( img1, save_loc + "/img.dm3" );
