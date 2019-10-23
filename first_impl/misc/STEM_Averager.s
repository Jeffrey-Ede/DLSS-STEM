// STEM Averaging script. Use this script to capture STEM images sequentially. This can be done in slow or fast mode. 
// Slow mode will produce high quality images, which may be useful for recording dynamic sequences or doing time-lapse
// imaging with long delays (eg 30s) between frames. Fast mode can capture images at a few frames per second. Summing such image 
// rapid acquisition series using drift correction, can eliminate the drift-induced shearing during long, single frame acquisition. 
// Images can be saved into a 3D Stack which is a convenient, single image format, allowing movie-like playback.
// Subsequent alignment of such stacks can be done using the 'Stack Alignment' script (available from this site).
// Acquired images can also be spooled directly to hard disk, enabling very long
// sequences to be recorded without running out of memory (RAM); a potential problem when using 3D Stacks to store data.
// Spooled images, or images extracted from a 3D Stack, can be converted into an avi movie, through the use of ImageJ.
// This enables STEM movies to be captured. Detailed instructions appear below.

// D. R. G. Mitchell, adminnospam@dmscripting.com (remove the nospam to make this address work, www.dmscripting.com
// version:20190509, v2.1, May 2019.

// Update in v2.1 - added a popup menu with which to select the imaging channel

// This script has specific hardware dependencies and requires DigiScan. 
// It has been tested on a JEOL ARM200F, using GMS 2.32 (542) and DigiScan II. There are no guarantees that
// it will work with other systems, as DigiScan functions do not work with all hardware variations.
// If it does not work on your system most likely I will not be able to troubleshoot the problem. 
// However, you are welcome to ask.

// This script is provided in good faith. However, no warranty as to its fitness for purpose is provided.
// Users assume all risks when using it. The author is not responsible for any losses or damages 
// incurred via the use of the script.


// Dialog Parameters:

// Set the acquisition parameters to suit. X and Y size are the scan size in pixels.


// The Dwell is the per pixel dwell time in microseconds. 


// Frames is the number of frames you wish to acquire. 


// Delay is the delay between frames. Note there can be a considerable hardware
// overhead to sequential acquisitions. This varies with acquisition mode.  
// The maximum frame rate in slow mode (Cont. check box is deselected) is about one every 3s. 
// If the delay is shorter than the hardware overhead - then it is ignored.
// In slow mode, delays are useful if you want to do time-lapse imaging. Here delays may be many
// tens of seconds, with frame acquisition times of perhaps 5-20s. A delay of 0s in this mode
// means that the frame rate is set by the acquisition time and the setup overhead.
// In Continuous (Cont. check box is selected) mode, the overhead between frames becomes very small. 
// Here the smallest Delay value which can be set is the frame acquisition time. Typically this is very fast; 
// eg for a 1k x 1k image with a dwell of 0.5us the minimum Delay value is 0.524s. Longer delays can be set, 
// though typically Continuous (Cont.) mode is used to get the fastest possible acquisition. Therefore the 
// smallest possible Delay value would be used typically. Entering zero in this field will return the shortest possible
// delay for the settings selected. 


// Est. Time gives an approximate estimate of the total time required acquire the sequence. 


// Sum will display a rolling summation of all the images. This is not drift- or distortion-corrected and so
// if significant drift is present, this image will blur.


// Continuous acquisition (Cont. check box is selected) is very fast, with far less overhead. The delay
// reported is the Delay field is almost entirely the acquisition time per frame. Digiscan will performn
// continuous acquisition and the script will grab periodic captures of the updating image with negligible
// overhead between frames. 1k x 1k images can be acquired about 0.5s apart, which is useful for movies or
// for subsequent summing (with drift correction) to eliminate the shearing effects of drift on a long
// acquisition single frame.

// Settings for ensuring the fastest possible acquisition. 
// 		Smaller frame sizes (eg 512 x 512). Be aware that distorted scanning may result from very small
//		frame sizes eg 256 x 256, and very short dwells (eg 1us). For small frame sizes, increase the
// 		dwell time to the point where the scan is not distorted (eg 2us)
//		Use 2 Byte acquisition.
//		Set the Cont. check box to selected.
//		Set the Dwell to 0 - it will default to its fastest setting.
// 		Set the Delay to 0 - it will default to its fastest settting.
// 		ALWAYS set the Dwell and Delay to 0 AFTER setting all other parameters, as changing some settings
// 		can modify these two values.

// Since the Cont. (continous - fast) part of this script captures images from a live image, it is essential 
// that at least one full frame has been acquired before the script starts capturing. A parameter to allow 
// sufficient time for this can be adjusted in File/Global Info/Global Tags/STEM Averaging/Default Values/DigiScan Settling Time (s)
// The default value is 2 (seconds) which is in addition to the frame acquisiton time. 
// If you find the lower section of your first frame is blank, increase this settling time until the blank
// region of the first image is no longer present. Try increasing in steps of 0.5s.


// Slow acquisition (Cont. check box is not selected). This will acquire individual frames from DigiScan.
// Digiscan has a fairly long overhead (several seconds) for each new frame, so typically, this mode would
// be used to acquire a series of images with long (>30s) delays between each frame. Typically, such
// frames would use long dwells to produce high quality invidual frames using typical imaging exposure times
// of say 5-20s per frame. 

// Images from both Continuous and Slow acquisitions are saved directly into a single 3D Stack image. These can be played through
// using the Slice tool, or subsequently aligned/extracted using the Stack Alignment script available from
// the same website. The number of frames which can be captured depends on the frame size, the number of frames
// set in Frames and the available RAM. 3D Stack images are huge (1k x 1k image of 10 layers is around 120MB).
// If you try and capture large numbers (eg >100) of very large (eg 2k x 2k frames) you may run out of 
// RAM and an error will be reported. Reduce the frame size or number of frames. 
// Always save a Stack as soon as it is acquired and do not have several open.
// If DigitalMicrograph runs out of memory a crash may occur and you may loose data. Or it may start using the hard disk as
// a temporary memory. This will make the computer run very slowly. Give the computer time to catch up.

// An alternative to saving to a 3D Stack is to use the Spool option (see below) which writes images directly to disk. 
// Here the number of frames depends only on available disk space.


// Spool. When selected, acquired frames are no longer saved into a 3D Stack (with the potential limitation of
// running out of RAM). Instead, each frame is written directly to hard disk, with frames labelled:
// Frame 00001, Frame 00002 etc. Images can be saved in either .dm4 or .tif formats by selecting the appropriate 
// dialog setting. Acqusition parameters are written to the .dm4 images as tags and the images are 
// calibrated. The .tif images have no such information and must be calibrated seperately. A small text file 
// containing image calibration and acquisition information will be written with TIFF files to facilitate this.


// STEM Channel: This sets which channel DigiScan signals are sourced from. This is only active when Cont is NOT selected.
// since Cont. mode simply sources whatever signal is being displayed on the screen. The mapping of your STEM signals will
// vary depending on which detector channel is physically plugged into which port on DigiScan. 
// On my JEOL ARM microscopes I have four signal channels and these can be changed (in the microscope user interface)
// to display any of the available detector outputs on that channel. So Channel 0 can be any signal - as set by the user. 
// The types of detectors will also vary between microscopes. I have four STEM detectors : BF, ADF1, ADF2 and BSE. 
// For this reason STEM channels here are simply labelled 0, 1, 2, 3  . . 9. You may manually edit the STEM channels
// to reflect your configuration - although if you change your signal assignments in the microscope you will need to re-edit
// the singal names here. If your signal assignments are fixed then editing the names in the Global Tags will work fine.
// Otherwise, I would recommend leaving the channels labelled 0, 1, 2, etc and simply remember your signal assignments.
// This script needs to be run once in order to create the STEM Channels tag group.
// Under File/Global Info/Global Tags/STEM Averaging you will find a tag group called 'STEM Channels'.
// Open this and you will see: Imaging channel 0 = 0, Imaging channel 1 = 1 etc. Change the numerical values to
// short (four characters max) labels like ADF1, BF, BSE, GADF, GBF etc (G signifies a Gatan detector). Leave any channels which
// do not have detectors as they are. Avoid labels longer than 4 characters otherwise the formatting of the dialog will 
// get messed up. 
// The default set of channels names (0, 1, 2 . . ) can be recreated by deleting the entire parent STEM Averaging tag group
// and running the script again.


// Invidual frames saved in .dm4 format can be assembled into a 3D Stack for subsequent alignment and 
// (movie-like) playing,using the Stack Alignment script available from the same website. Open all the images
// in DigitalMicrograph and run the Stack Alignment script and select the Merge option.
// The offline computer used to assemble the stack must have enough RAM to be able to handle the
// very large image (stack) which results. An error will be reported if the RAM is anadequate. 32 bit versions
// of DigitalMicrograph will only be able to handle data files up to 2GB. The 64 bit version can handle any
// size, provided the RAM is adequate.

// Bit depth specifies the bit depth of the acquisition. Digiscan can produce 2 byte output faster than 4 byte.
// The minimum dwell time for 4 byte images is 0.8us, while that for 2 byte is 0.5us. Use 2 byte to get the 
// very fastest output. Note, the stack and sum images which this script outputs will always be 4 byte
// regardless of this setting. Where 2 byte is selected, the dynamic range will be scaled to 2 byte at source, and
// then ported into a 4 byte image.  


// Making Movies:

// Spooled Images:
// The STEM Averager script can spool a sequence of images directly to disk and label them Frame 00001, Frame 00002 etc. 
// This movie making method requires images to be in TIFF format (.tif). Note if you have spooled images in .dm4 format, 
// you can batch convert them in DigitalMicrograph into suitable TIFF files by using File/Batch Convert (in DigitalMicrograph).
// Point the Batch Converter at the folder of .dm4 images, specify the file type as .dm4 and choose the Save Display As option
// with the TIFF Format selected. You’ll end up with a folder containing both .dm4 and .tif images – remove the .dm4 files
// from the folder and then continue below to convert the TIFFs into a movie. 

// 3D Stack Images:
// The STEM Average script can save images directly into a 3D Stack. You can extract the individual images from a stack and save
// them to a folder. Open the 3D Stack in DigitalMicrograph and have it front-most. Run the ‘Stack Alignment’ script – available
// from http://www.dmscripting.com/stack_alignment.html, and click on the Split button. This will split the stack into its
// component images. Choose the Delete option, in order to close the 3D Stack after image extraction - to free up RAM.
// For large stacks of several hundred frames, you will need a lot of RAM for this procedure. If you run low on RAM, 
// Windows will spool data to disk and the computer will run very slowly. Give it time to catch up. 
// Run the ‘Multiple Saves as Hi-Res TIFF Files’ script available from this site. Save all the open .dm4 files to a folder as .tifs.
// Continue with the movie making procedure below.

// Provided you do not alter any file names, the above scripts will ensure that your files are correctly labelled so that they
// get imported into ImageJ in the correct sequence.

// Open the ImageJ program – this is a free download from (https://imagej.net/Welcome).
// In ImageJ select File/Import/Image Sequence and point at the first .tif image exported by the above scripts. 
// The image sequence is loaded. This will need a lot of RAM. For very large sequences, close all non-essential programs to
// free-up RAM, before starting. If the program runs low on RAM, it will spool data to hard disk and will make things slow.
// Give the computer time to catch up.

// The image sequence loaded into ImageJ is a single stack – you can scroll through it by moving the slider at the bottom.
// Stack files can be huge – do not have more than one stack  open at any time.

// To save the stack as a movie select File/Save As and choose the AVI option. 

// You will be prompted to select a format.
//	JPEG will compress the movie and reduce its size by a factor of around 5x, compared with the Uncompressed option.
//	Uncompressed - movies will be large, the size being given by the individual frame size multiplied by the number of frames.
// You will be prompted to select the frames per seconds (fps).
//	The STEM Averager script can save a 1k x 1k frame every 0.5s or so. So the true maximum frame rate will be around 2fps. 
// You can use any frame rate you like, to speed up or slow down the movie. Simply divide the total number of frames by the
// target frame rate (in fps) and you will get the movie run time eg a movie of 200 frames played at 5 fps, will run for 40s.

// Double click on the saved movie file to run it in Windows Media Player or similar. 


// Default values

// The x size of the STEM image

number defaultxsize=1024 
if(!getpersistentnumbernote("STEM Averaging:Default Values:Frame X Size", defaultxsize))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Frame X Size", defaultxsize)
	}

// The y size of the STEM image

number defaultysize=1024 
if(!getpersistentnumbernote("STEM Averaging:Default Values:Frame Y Size", defaultysize))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Frame Y Size", defaultysize)
	}

// The default acquisition time / us per pixel

number defaultacquiretime=1
if(!getpersistentnumbernote("STEM Averaging:Default Values:Acquisition time (us)", defaultacquiretime))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Acquisition time (us)", defaultacquiretime)
	}

// The default delay time / s

number defaultdelaytime=0
if(!getpersistentnumbernote("STEM Averaging:Default Values:Delay time (s)", defaultdelaytime))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Delay time (s)", defaultdelaytime)
	}

// The default number of frames

number defaultnoofframes=10
if(!getpersistentnumbernote("STEM Averaging:Default Values:Numbe of frames", defaultnoofframes))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Numbe of frames", defaultnoofframes)
	}

// The default minimum exposure time

number defaultminexposure=0.02
if(!getpersistentnumbernote("STEM Averaging:Default Values:Minimum exposure (s)", defaultminexposure))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Minimum exposure (s)", defaultminexposure)
	}

// The show sum checkbox value 

number defaultshowsum=1
if(!getpersistentnumbernote("STEM Averaging:Default Values:Show sum (0-1)", defaultshowsum))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Show sum (0-1)", defaultshowsum)
	}
	
// The Bit depth radio to decide whether data is 2 or 4byte

number defaultbitdepthradio=1

if(!getpersistentnumbernote("STEM Averaging:Default Values:Bit Depth", defaultbitdepthradio))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Bit Depth", defaultbitdepthradio)
	}


// This creates an array of STEM Channel tags. These are initially labelled 0, 1, 2 . . 9. These may be manually
// edited to make them more meaningful eg ADF1, BF, ADF2, SE, GatanBF etc.

string channelname
if(!getpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 0", channelname))
	{
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 0", "0")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 1", "1")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 2", "2")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 3", "3")
		
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 4", "4")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 5", "5")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 6", "6")
		
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 7", "7")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 8", "8")
		setpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel 9", "9")
	}

// The Channel popup menu selects which STEM signal is imaged with 

number defaultchannelpopup=0

if(!getpersistentnumbernote("STEM Averaging:Default Values:Imaging channel (0-9)", defaultchannelpopup))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Imaging channel (0-9)", defaultchannelpopup)
	}

// The display size of the images is pixels (this is the xsize - in screen pixels)

number defaultdisplayxsize=400

if(!getpersistentnumbernote("STEM Averaging:Default Values:Displayed Image X Size", defaultdisplayxsize))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Displayed Image X Size", defaultdisplayxsize)
	}

// The digiscanoverhead is the time taken to process the image at minimum exposure - this is used to estimate
// the exposure time

number defaultdigiscanoverhead=3.2 // time is s per minimum exposure frame

if(!getpersistentnumbernote("STEM Averaging:Default Values:DigiScan Overhead", defaultdigiscanoverhead))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:DigiScan Overhead", defaultdigiscanoverhead)
	}

// The status of the check box - either single acquire frames (slow) or if set, take samples from 
// a continuously acquiring image

number defaultcontinuous=0 

if(!getpersistentnumbernote("STEM Averaging:Default Values:Continuous Acquisition", defaultcontinuous))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Continuous Acquisition", defaultcontinuous)
	}
	
// The setting of the spool (to hard disk) check box
	
number defaultspool=0 

if(!getpersistentnumbernote("STEM Averaging:Default Values:Spool to Disk", defaultspool))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Spool to Disk", defaultspool)
	}

// The spool (to hard disk) format -either .dm4 (0) or .tif (TIFF) (1)

number defaultformat=0 

if(!getpersistentnumbernote("STEM Averaging:Default Values:Format (0 dm4) (1 TIFF)", defaultformat))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:Format (0 dm4) (1 TIFF)", defaultformat)
	}

// During fast scan aquisition a delay is applied before capturing data. This delay consists of the settling time
// specified here (which is the setup overhead for DigiScan to start acquiring data). The script will apply this delay
// plus 2x the frame acquisition time, in order to ensure that a full frame has been acquired before the script 
// starts taking snapshots of it. If you get frames which are incomplete at the start of your acquisition, you can
// increase the settling time value to allow complete frame acquisition.
	
number defaultsettlingtime=2

if(!getpersistentnumbernote("STEM Averaging:Default Values:DigiScan Settling Time (s)", defaultsettlingtime))
	{
		setpersistentnumbernote("STEM Averaging:Default Values:DigiScan Settling Time (s)", defaultsettlingtime)
	}
	
	
	
// Global Variables
	
number true=1, false=0 // thread control parameters
string savepath="" // path for spooling data when the Spool check box is set


// An interface is used to define methods which are called by a class (in this case the Acquisition_Thread) before it is
// is defined in a subsequent class - in this the Dialog_UI. The thread accesses the StopPressed() method of the dialog 

Interface ThreadInterface
	{
		void StopPressed(object self);
		void DialogReset(object self, number enabledstatus);
	}
 	

// The thread object which does the acquisition in the backgound

Class Acquisition_Thread : Thread
{

	// Control signals for the thread
		
 	Object StartSignal
 	Object StopSignal
 	
 	
 	// The thread gets access to the dialog by the dialog passing in its ID. From this, the thread can access the Dialog object
 	
 	number DialogID // the id of the main dialog


	// default object constructor
	
	Acquisition_Thread( object self )
		{
		}


	// default object destructor
	
	~Acquisition_Thread( object self )
		{
		}


	// initialize Boolean constants and signals
	
	object init( object self )
		{
			StartSignal = NewSignal(0)
			StopSignal = NewSignal(0)
			return self
		}


	// The stop signal for the thread

		void Stop( object self )
			{
				// stop anything running in DigiScan and generate stop signal
				dsstopacquisition(-1) // -1 stops all processes
				StopSignal.SetSignal()

			}


// A function which will zoom the passed in image to be displayed at the indicated size
// (in pixels). The size (newxsize) is that of the x (horizontal) axis. The y axis is 
// scaled proportionately

void zoomtosize(object self, image img, number newxsize)
	{
		// If the passed in size is <128 do nothing. 

		if(newxsize<128) return


		// Get some info on the image and show it

		number xsize, ysize
		getsize(img, xsize, ysize)
		number newysize=ysize*(newxsize/xsize)
		showimage(img)


		// Source the displays, documents and windows and set the new 
		// content area of the image to the desired value

		imagedisplay imgdisp=img.imagegetimagedisplay(0)
		imagedocument imgdoc=getfrontimagedocument()
		documentwindow docwin=getdocumentwindow(0)
		docwin.windowsetcontentsize(newxsize, newysize)


		// Compute the transform from image to display and maximise the image to fit the new window

		number i2voffx, i2voffy, i2vscalex, i2vscaley, vtop, vleft, vbottom, vright
		imgdisp.ComponentGetChildToviewTransform(i2voffx, i2voffy, i2vscalex, i2vscaley)
		objecttransformtransformrect(i2voffx, i2voffy, i2vscalex, i2vscaley, 0, 0, ysize, xsize,vtop, vleft, vbottom, vright)
		ImageDocumentMaximizeRectInView( imgDoc, vtop, vleft, vbottom, vright ) 
	}
	
			
	// A function which the dialog calls to pass in its ID to the thread. Once the thread has the dialog's ID
	// It can find and access the dialog object

	void LinkToDialog(object self, number ID)
		{
			DialogID=ID
				
		}


	// Starts the thread to do the acquisition

	void StartSlowAcquisition( object self )
		{
			number do_break=false
			object Called_Dialog=GetScriptObjectFromID(DialogID)
			number currentframes=0, displayxsize
			number paramid // The ID of the parameter set passed to DigiScan
			
			getpersistentnumbernote("STEM Averaging:Default Values:Displayed Image X Size", displayxsize)


			// Loop the thread until a stop signal is encountered
			
			while( true )
				{
					// Variables
					
					number counter=1
					number xsize, ysize, exposure, delay, interval, frames, sumcheck
					number aligncheck, contcheck, spoolcheck, formatradio, bitdepthradio, channelpopup_val
					
					
					// Get the values from the dialog
									
					Try
						{
							if(Called_Dialog.ScriptObjectIsValid())
								{
									Called_Dialog.dlggetvalue("xsizefield", xsize)
									Called_Dialog.dlggetvalue("ysizefield", ysize)
									Called_Dialog.dlggetvalue("exposurefield",exposure)

									Called_Dialog.dlggetvalue("delayfield",delay)
									Called_Dialog.dlggetvalue("framesfield",frames)
									Called_Dialog.dlggetvalue("showsumcheckbox",sumcheck)
									
									Called_Dialog.dlggetvalue("contcheckbox",contcheck)
									Called_Dialog.dlggetvalue("spoolcheckbox",spoolcheck)
									Called_Dialog.dlggetvalue("formatradio",formatradio)
									
									Called_Dialog.dlggetvalue("bitdepthradio",bitdepthradio)
									Called_Dialog.dlggetvalue("channelpopup",channelpopup_val)
									channelpopup_val=channelpopup_val-1 // minus 1 because menu selection for channel zero is menu position 1

									string time=gettime(1)
									result("\n\n\nAcquisition started: "+time+"\n\nFrame X = "+xsize+ "\nFrame Y = "+ysize+"\nDwell / pxl = "+exposure+" us\nDelay = "+delay+" s"+"\nFrames = "+frames+"\n")
								}
						}
					catch
						{
							exit(0)
						}


					// A timing variable for recording the cumulative exposuretime
					
					number StartTicks=0
					
					
					// Some image variables - img stores the returned output from DigiScan. Imgsum is a rolling sum of the acquired
					// images. Imgstack is a 3D image is which each image is stacked 
					
					image imgstack, img, imgsum
					
					
					// Use a Try/Catch loop so that any exception can be used to end the thread.
					// This is important as otherwise a thread could continue indefinitely
					
					Try 
						{
							// Infinite processing loop which listens for a stop signal
							
							while(true)
								{
								
								// Create an images to save into

								number dataType=dlggetvalue(Called_Dialog.lookupelement("bitdepthradio"))

								number bitdepth
								if(datatype==0) bitdepth=2
								else bitdepth=4
			
								number signed=0
								img:= IntegerImage( "Img "+currentframes, bitdepth, signed, xsize, ysize )   
								number imageid=img.imagegetid() // this image's id is passed into the parameter set given to DigiScan
								imgsum=IntegerImage("Sum Image", bitdepth, signed, xsize, ysize )   
								
								if(spoolcheck==0) // only create the stack image if the spool check box is off
									{
										try imgstack=integerimage("",bitdepth, signed, xsize, ysize, frames)
										catch
											{
												showalert("Insufficient memory - reduce the size/number of images.",2)
												self.stoppressed()
											}
										
										number exposuretime=(exposure*xsize*ysize)/1e6
										setname(imgstack, "Stack "+frames+" frames "+exposure+"s exp "+format(delay,"%5.2f")+"s interval")
										self.zoomtosize(imgstack, displayxsize)								
										showimage(imgstack)
										documentwindow docwin=getdocumentwindow(0)
										docwin.windowsetframeposition(0,0)
									}
								
								
								// Display and position the running image

								showimage(img)
								setname(img, "Frame 0 : 0.00s")
								self.zoomtosize(img, displayxsize)								
								documentwindow docwin=getdocumentwindow(0)
								docwin.windowsetframeposition(0,0)
								updateimage(img)
								
								number top, left, bottom, right
								docwin.windowgetframebounds(top, left, bottom, right)
			
								
								// display the sum image if the sum checkbox is checked

								if(sumcheck==1)
									{
										showimage(imgsum)
										self.zoomtosize(imgsum, displayxsize)								
										documentwindow sumwin=getdocumentwindow(0)
										sumwin.windowsetframeposition(right, top)
										updateimage(imgsum)
									}

								
								// Create a DigiScan parameter set and apply them to DigiScan
										
								number signalIndex = channelpopup_val // The signal is set in the STEM channel menu
								number rotation = 0   // degree of rotation
								number continuous=contcheck // have continuous or single frame acquisitions
								number lineSynch = 0 // do not use line synching

								number synchronous = 0 // 0 = return immediately, 1 = return when finished
						
								number selected=1 // acquire signal
								paramID = DSCreateParameters( xsize, ysize, rotation, exposure, linesynch )
								DSSetParametersSignal( paramID, signalIndex, bitdepth, selected, imageID )
					
										
								// Loop while capturing the frames - initialise some timers
								
								number cumulativeexposure=0
								number beginticks=getostickcount()

								while(currentframes<frames)
									{
										// Listen for a stop signal from the Stop button in the dialog
										// Be careful when using very short waitforstopsignal values <0.02s
										// as thread control may become erratic.

										number waitforstopsignal=0.05 // dwell in seconds
										StartSignal.WaitOnSignal(waitforstopsignal, StopSignal) // wait <interval> second for stop signal
										try
											{
												number id=called_dialog.scriptobjectgetid()
											}
										catch
											{
												dsstopacquisition(-1) // stop DigiScan acquisitions if running
												do_break = true
												Break
											}
																	
					
										// Set the image names to reflect the frame and elapsed time
										
										currentframes=currentframes+1
										string time=gettime(2)
										number nowticks=getostickcount()
										if(currentframes!=1) cumulativeexposure=CalcOSSecondsBetween(beginticks, nowTicks)

										result("\nAcquiring Frame = "+currentframes+" : "+format(cumulativeexposure, "%5.2f")+" s")
										openandsetprogresswindow("Acquiring . . .","Frame : "+currentframes+"/"+frames,"")
										number roundedtime=round(cumulativeexposure*100)/100
										
										if(spoolcheck==0) // add tags to the stack image, but only if spool check box is set to 0
											{
												setnumbernote(imgstack, "STEM Averager:Exposure Times (s):Frame "+currentframes,roundedtime)
											}
		
										// Do the acquisition but ensure DigiScan in not busy before starting

										while(dsisacquisitionactive()) 
											{
											}
										DSStartAcquisition( paramID, continuous, synchronous )


										 // This delay loop takes care of DigiScan overhead.
										 // It loops until the acquisition has finished - it then passes control back to the script. Note an arbitrary large
										 // number of 500 is used in a for{} loop instead of a while{} loop, in case there is a glitch
										 // in Digiscan. The for{} loop ensures control will pass back to the script eventually, whereas
										 // a While{} loop could hang indefinitely										 
										 
										number i
										for(i=0; i<500; i++)
											{
												updateimage(img) // note these updates take time - without them, the loop is not long enough
												updateimage(imgsum)
												if(!dsisacquisitionactive()) break
											}
											
								
										// If this is first frame copy the tags and calibration from the img to the stack
										// and also to the sum image
										
										taggroup acqtags=img.imagegettaggroup()
										
										if(currentframes==1) 
											{
													if(spoolcheck==0)
														{
															taggroup stacktags=imgstack.imagegettaggroup()
															TagGroupCopyTagsFrom( stacktags, acqtags ) 
															imagecopycalibrationfrom(imgstack, img)
															
															imagedisplay stackdisp=imgstack.imagegetimagedisplay(0)
															stackdisp.applydatabar()
															
		
															// Record the acquisition information onto the image stack
												
															setnumbernote(imgstack, "STEM Averager:Settings:Dwell (us)",exposure)
															setnumbernote(imgstack, "STEM Averager:Settings:Frames",frames)
															setnumbernote(imgstack, "STEM Averager:Settings:Bit Depth",bitdepth)

															setnumbernote(imgstack, "STEM Averager:Settings:Delay (s)",delay)
															setnumbernote(imgstack, "STEM Averager:Settings:X Size",xsize)
															setnumbernote(imgstack, "STEM Averager:Settings:Y Size",ysize)
															setnumbernote(imgstack, "STEM Averager:Settings:Cont Check Box",contcheck)
														} 
												
												imagedisplay imgdisp=img.imagegetimagedisplay(0)
												imgdisp.applydatabar()
												
												if(sumcheck==1) // sumimg will only exist if the sum check box is set
													{
														taggroup sumtags=imgsum.imagegettaggroup()
														TagGroupCopyTagsFrom( sumtags, acqtags ) 
														imagecopycalibrationfrom(imgsum, img)
														
																
														// Record the acquisition information onto the image stack
												
														setnumbernote(imgsum, "STEM Averager:Settings:Dwell (us)",exposure)
														setnumbernote(imgsum, "STEM Averager:Settings:Frames",frames)
														setnumbernote(imgsum, "STEM Averager:Settings:Bit Depth",bitdepth)

														setnumbernote(imgsum, "STEM Averager:Settings:Delay (s)",delay)
														setnumbernote(imgsum, "STEM Averager:Settings:X Size",xsize)
														setnumbernote(imgsum, "STEM Averager:Settings:Y Size",ysize)
														setnumbernote(imgsum, "STEM Averager:Settings:Cont Check Box",contcheck)

														imagedisplay sumdisp=imgsum.imagegetimagedisplay(0)
														sumdisp.applydatabar()
													}
												
												
													// Add the settings onto the running image
												
													setnumbernote(img, "STEM Averager:Settings:Dwell (us)",exposure)
													setnumbernote(img, "STEM Averager:Settings:Frames",frames)
													setnumbernote(img, "STEM Averager:Settings:Bit Depth",bitdepth)
													setnumbernote(img, "STEM Averager:Settings:Delay (s)",delay)
													
													setnumbernote(img, "STEM Averager:Settings:X Size",xsize)
													setnumbernote(img, "STEM Averager:Settings:Y Size",ysize)
													setnumbernote(img, "STEM Averager:Settings:Cont Check Box",contcheck)
	
													
											}
										
										
										// Save the current image into the 3D stack or spool it to hard disk
										
										if(spoolcheck==0)
											{
												imgstack[0,0,(currentframes-1), xsize, ysize, currentframes]=img
											}
										else // The spool option is set so save the image to the specified path
											{
												string framename="00000"+currentframes
												framename="Frame "+right(framename,5)

												string filestring=pathconcatenate(savepath, framename)
												deletenote(img, "STEM Averager:Frame Time (s)")
												setnumbernote(img, "STEM Averager:Frame Time (s)",roundedtime)

												
												// Save the file in the format specified in the format dialog
					
												if(formatradio==0) saveasgatan(img, filestring,1)
												else 
													{
														// We need to remove the scalebar from the image for TIFF saving - as the scale bar would be
														// burnt into every image and would make alignment/movie making impossible

														imagedisplay imgdisp=img.imagegetimagedisplay(0)
														component scalebar=imgdisp.componentgetnthchildoftype(31,0)
														scalebar.componentremovefromparent()

														saveastiff(img, filestring)
														
														
														// Reapply the data bar
														
														imgdisp.applydatabar()
													}
											}

	
										// If the sum check box is set, show the sum image
										
										if(sumcheck==1) 
											{
												imgsum=imgsum+img
												setname(imgsum, "Frames Summed "+currentframes)
												updateimage(imgsum)
											}
																				
										setname(img, "Frame "+currentframes+" of "+frames+"  Time "+format(cumulativeexposure,"%5.2f")+" s")
										updateimage(img)


										// This is the delay between frames. It keeps track of cumulative time
										// Due to processing overhead if the delay is very short, it may not get
										// used. For longer delays eg several seconds, then the delay will get invoked
										// but due to the overhead, the delay used may be shorter than indicated to keep
										// the timing of the acquistion series running on time.
											
										nowticks=getostickcount()
										number elapsedtime=CalcOSSecondsBetween(beginticks, nowticks)
										elapsedtime=elapsedtime/currentframes
										
										
										if(currentframes<frames) // avoid applying the delay after the last frame
										{
										
										while(elapsedtime<delay)
											{
												number NowTicks=GetOSTickCount()
												
												
												// note include the time taken to test for a stop signal in the delay loop
												
												ElapsedTime=CalcOSSecondsBetween(beginTicks, NowTicks)
												elapsedtime=elapsedtime/currentframes													
													
													
												// Keep checking for a stop signal
																						
												number waitforstopsignal=0.05 // dwell in seconds
												
												StartSignal.WaitOnSignal(waitforstopsignal, StopSignal) // wait <interval> second for stop signal
												try
													{
														number id=called_dialog.scriptobjectgetid()
													}
												catch
													{
														dsstopacquisition(-1) // stop DigiScan acquisitions if running
														do_break = true
														Break
													}															
											}
									
									}
									
									
								// Check to see if the required number of frames has been acquired - end if yes
								
								if(currentframes>=frames)
									{
										// remove DigiScan parameters from memory
										 
										DSDeleteParameters( paramID )
										number endticks=getostickcount()
										cumulativeexposure=CalcOSSecondsBetween(beginticks, endticks)
										
										if(spoolcheck==0) setname(imgstack, "Stack "+frames+" frames "+exposure+"s exp "+format(delay,"%5.2f")+"s interval")

										result("\n\nTotal elapsed time : "+cumulativeexposure+" s")
										result("\n\nAcquisition Completed.")
										
										
								if(spoolcheck==1 && formatradio==1) // Spool to .tif option is selected
									{
										// If the option to spool to .tif is selected, capture the image
										// calibrations and append them to a text file saved with the TIFFS
										// .dm4 files have an innate calibration. Also add the dialog settings
										// as unlike the .dm4 files, these values cannot be appended as tags
													
										number scale=img.imagegetdimensionscale(0)
										string unitstring=img.imagegetdimensionunitstring(0)
										documentwindow textwin=newscriptwindow("",-200,-200,0,0) // display off screen
										textwin.editorwindowaddtext("Pixel size ="+scale+" "+unitstring)
						
										textwin.editorwindowaddtext("\nDwell Time = "+exposure+" us")
										textwin.editorwindowaddtext("\nX Size = "+xsize+" pixels")
										textwin.editorwindowaddtext("\nY Size = "+ysize+" pixels")
										
										textwin.editorwindowaddtext("\nDelay = "+delay+" s")
										textwin.editorwindowaddtext("\nFrame Exposure = "+exposure+" s")
										textwin.editorwindowaddtext("\nFrames = "+frames)
																
										textwin.editorwindowaddtext("\nCont. (continuous (fast) acquisition) (0=No, 1=Yes) = "+contcheck)
										textwin.editorwindowaddtext("\nBit Depth (0=2byte, 1=4byte) = "+bitdepthradio)
										textwin.editorwindowaddtext("\nFormat(0=.dm4, 1=.tif) = "+formatradio)
										
										string textpath=pathconcatenate(savepath, "Image Data.txt")
										editorwindowsavetofile(textwin, textpath)
										textwin.windowclose(0)
									}

																				
										// Delete unwanted images
										
										deleteimage(img)
										if(sumcheck!=1) deleteimage(imgsum) // summing wasn't done - so delete the image

										self.stoppressed()
									}
									
									
								// Update the Progress Bar
						
								called_dialog.dlgsetprogress("progbar",currentframes/frames)
							}
						}
						}
					Catch // If any exceptions occur or a stop signal is received stop the thread.
						{
							// A break was encountered, set clean up and break out of the Try/Catch loop
																					
							if(img.imageisvalid()) deleteimage(img)
							if(imgsum.imageisvalid() && sumcheck!=1) deleteimage(imgsum)
							openandsetprogresswindow("","","")


							// remove parameters from memory
							
							DSDeleteParameters( paramID )


							// Stop the thread
							
							dsstopacquisition(-1)
							do_break = true
							Break
						}
						
				// Stop the thread
							
				// The Dialog object has been sourced previously. It is checked to make sure it is valid (in case it has
				// been closed). If valid, the dialog's StopPressed() method is invoked. The thread has already stopped, but
				// this method resets all the dialog buttons, fields and LED. It also tells the thread to stop, but it has
				// already stopped so this is ignored.
				
				try
					{
						Called_Dialog.DialogReset(1)
						dsstopacquisition(-1)

						If(do_break) break
						StartSignal.ResetSignal()
					}
				catch exit(0)
			}
		}	
	}



// The Class for the dialog

Class Dialog_UI : UIFrame
	{
		Object Acquisition_Thread
		Number ScanIsOn, Step, Interval, Range, frames, capturedframes
		Number taskid // the id of the periodic measurement task
		number stackid, fastscanid, sumid // the image ids of the various images
		number fastticks // a global variable to keep track of time
		
		
// Ensures sensible values are used for the acquisition setuup and
// updates the total time whenever any of the relevant parameters are changed

void setupchanged(object self, taggroup tg)
	{
		number exposure=dlggetvalue(self.lookupelement("exposurefield"))
		
		
		// Ensure the x size field value is even and within sensible limits
		// constrain it to be between 256 and 2048 and an integral power of 2
		
		number xsize=dlggetvalue(self.lookupelement("xsizefield"))
		number log2val=log2(xsize)
		if(log2val<8) log2val=8
		number remainder=mod(log2val,1)
		log2val=log2val-remainder
		xsize=2**log2val

		if(xsize<256) xsize=256
		if(xsize>2048) xsize=2048
		dlgvalue(self.lookupelement("xsizefield"), xsize)
		
		
		// Ensure the y size field value is even and within sensible limits
		
		number ysize=dlggetvalue(self.lookupelement("ysizefield"))
		log2val=log2(ysize)
		if(log2val<8) log2val=8
		remainder=mod(log2val,1)
		log2val=log2val-remainder
		ysize=2**log2val

		if(ysize<256) ysize=256
		if(ysize>2048) ysize=2048
		dlgvalue(self.lookupelement("ysizefield"), ysize)


		// Source the DigiScan minimum pixel time - this varies with image bit depth
		
		number dataType=dlggetvalue(self.lookupelement("bitdepthradio"))
		number bitdepth
		if(datatype==0) bitdepth=2
		else bitdepth=4
		number minexposure=DSGetMinPixelTime( bitdepth, 1)


		// ensure that the exposure is not lower than the minimum allowed

		if(exposure<minexposure)
			{
				exposure=minexposure
				dlgvalue(self.lookupelement("exposurefield"), exposure)
			}


		// Keep the parameters within bounds and update the total time 
		// when changes are made
		
		frames=dlggetvalue(self.lookupelement("framesfield"))
		if(frames<2) dlgvalue(self.lookupelement("framesfield"), 2)

		number delay=dlggetvalue(self.lookupelement("delayfield"))
		if(delay<0) dlgvalue(self.lookupelement("delayfield"), 0)
		
		number secsperframe=(xsize*ysize*exposure)/1e6 // note exposure is in us

		number contcheck, totaltime
		contcheck=dlggetvalue(self.lookupelement("contcheckbox"))

		if(contcheck==0) // Single frame (Slow) DigiScan Acquisition - apply the overhead to the total time calculations
			{
				number digiscanoverhead
				getpersistentnumbernote("STEM Averaging:Default Values:DigiScan Overhead", digiscanoverhead)
				number truedelay=delay-(digiscanoverhead+secsperframe) // Delays shorter than the overhead are zero
				if(truedelay<0) truedelay=0
				totaltime=(frames*digiscanoverhead)+(secsperframe*frames)+((frames-1)*truedelay )
			}
		else // Continuous acquition (Fast) is being used so no overhead // note the delay/dwell/size are checked to make sure the exposure < delay - otherwise the delay is increased
			{
				// For fast continuous acquisition, the delay between frames is only valid
				// when the total exposure is less than it. Otherwise, a complete frame will not have
				// been captured before the image is captured.
				// If the acquisition time is longer that the delay, the delay needs to be increased
				// to the frame exposure time
						
				if(secsperframe>delay) 
					{
						dlgvalue(self.lookupelement("delayfield"), secsperframe)
						totaltime=frames*secsperframe
					}
				else totaltime=frames*delay
			}
			
		dlgvalue(self.lookupelement("totaltimefield"), totaltime)
	}

void channelpopup_changed(object self, taggroup tg)
	{
		number menuval=tg.dlggetvalue()-1 // note -1 because the first selection position of the menu is 1 and we want zero
		setpersistentnumbernote("STEM Averaging:Default Values:Imaging channel (0-9)", menuval)
	}

// A function which will zoom the passed in image to be displayed at the indicated size
// (in pixels). The size (newxsize) is that of the x (horizontal) axis. The y axis is 
// scaled proportionately

void zoomtosize(object self, image img, number newxsize)
	{
		// If the passed in size is <128 do nothing. 

		if(newxsize<128) return


		// Get some info on the image and show it

		number xsize, ysize
		getsize(img, xsize, ysize)
		number newysize=ysize*(newxsize/xsize)
		showimage(img)


		// Source the displays, documents and windows and set the new 
		// content area of the image to the desired value

		imagedisplay imgdisp=img.imagegetimagedisplay(0)
		imagedocument imgdoc=getfrontimagedocument()
		documentwindow docwin=getdocumentwindow(0)
		docwin.windowsetcontentsize(newxsize, newysize)


		// Compute the transform from image to display and maximise the image to fit the new window

		number i2voffx, i2voffy, i2vscalex, i2vscaley, vtop, vleft, vbottom, vright
		imgdisp.ComponentGetChildToviewTransform(i2voffx, i2voffy, i2vscalex, i2vscaley)
		objecttransformtransformrect(i2voffx, i2voffy, i2vscalex, i2vscaley, 0, 0, ysize, xsize,vtop, vleft, vbottom, vright)
		ImageDocumentMaximizeRectInView( imgDoc, vtop, vleft, vbottom, vright ) 
	}
	
		
		// Create a greenLED for 'On'

		  image greenled(object self)
			{
				// Create a green LED  with a black border and some colour gradation
				
				rgbimage greenled=RGBImage("",4,20,20)
				greenled=rgb(240,240,240)
				greenled=tert(iradius<10, rgb(0,230-(iradius*15),0),greenled)
				greenled=tert(iradius>7 && iradius<10, rgb(0,0,0),greenled)
				return greenled
			}
			
		
		// Create a grey LED for 'Off' 

		  image greyled(object self)
			{	
				// Create a grey led graphic with a black border and some colour gradation

				rgbimage greyled=RGBImage("",4,20,20)
				greyled=rgb(240,240,240)
				greyled=tert(iradius<10, rgb(180-(iradius*10),180-iradius*10,180-iradius*10), greyled) // make the led grey with some highlights
				greyled=tert(iradius>7 && iradius<10, rgb(0,0,0),greyled)
				return greyled
			}



		// Function to create the dialog

		TagGroup CreateDialog_UI( object self )
			{
				TagGroup Dialog_UI = DLGCreateDialog("STEM Av.")


				// Create a box for the counting parameters		
		
				taggroup countbox_items
				taggroup countbox=dlgcreatebox("STEM Acqusition",countbox_items).dlgexternalpadding(3,3).dlginternalpadding(8,5)


				// The x size field

				taggroup xsizefield, label
				label=DLGCreateLabel("X Size / pxls")
				number xsize
				getpersistentnumbernote("STEM Averaging:Default Values:Frame X Size", xsize)
				
				xsizefield=DLGCreateIntegerField(xsize, 7).DLGIdentifier("xsizefield").dlgchangedmethod("setupchanged")
				taggroup xsizegroup=dlggroupitems(label, xsizefield).dlgtablelayout(1,2,0)


				// The y size field

				taggroup ysizefield
				label=DLGCreateLabel("Y Size / pxls")
				number ysize
				getpersistentnumbernote("STEM Averaging:Default Values:Frame Y Size", ysize)
				
				ysizefield=DLGCreateIntegerField(ysize, 7).DLGIdentifier("ysizefield").dlgchangedmethod("setupchanged")
				taggroup ysizegroup=dlggroupitems(label, ysizefield).dlgtablelayout(1,2,0)


				// The exposure field

				taggroup exposurefield
				number exposuretime
				getpersistentnumbernote("STEM Averaging:Default Values:Acquisition time (us)", exposuretime)
				label=DLGCreateLabel("Dwell / us")
				exposurefield=DLGCreateRealField(exposuretime, 7, 3).DLGIdentifier("exposurefield").dlgchangedmethod("setupchanged")
				taggroup exposuregroup=dlggroupitems(label, exposurefield).dlgtablelayout(1,2,0)


				// The delay field

				taggroup delayfield
				number delaytime
				getpersistentnumbernote("STEM Averaging:Default Values:Delay time (s)", delaytime)
				label=DLGCreateLabel("Delay / s")
				delayfield=DLGCreaterealField(delaytime, 7,3).DLGIdentifier("delayfield").dlgchangedmethod("setupchanged")
				taggroup delaygroup=dlggroupitems(label, delayfield).dlgtablelayout(1,2,0)
				

				// The frames field

				taggroup framesfield
				getpersistentnumbernote("STEM Averaging:Default Values:Numbe of frames", frames)
				label=DLGCreateLabel("Frames")
				framesfield=DLGCreateintegerField(frames, 7).DLGIdentifier("framesfield").dlgchangedmethod("setupchanged")
				taggroup framesgroup=dlggroupitems(label, framesfield).dlgtablelayout(1,2,0)


				// The totaltime field

				taggroup totaltimefield
				if(frames<1) dlgvalue(self.lookupelement("framesfield"), 1)

				number contcheck, totaltime
				getpersistentnumbernote("STEM Averaging:Default Values:Continuous Acquisition", contcheck)

				if(contcheck==0) // Single frame (Slow) DigiScan Acquisition - apply the overhead to the total time calculations
					{
						number digiscanoverhead
						getpersistentnumbernote("STEM Averaging:Default Values:DigiScan Overhead", digiscanoverhead)
						number secsperframe=(xsize*ysize*exposuretime)/1e6 // note exposure is in us

						number truedelay=delaytime-(digiscanoverhead+secsperframe) // Delays shorter than the overhead are zero
						if(truedelay<0) truedelay=0
						totaltime=(frames*digiscanoverhead)+(secsperframe*frames)+((frames-1)*truedelay )	
					}
				else // Continuous acquition (Fast) is being used so no overhead // note the delay/dwell/size are checked to make sure the exposure < delay - otherwise the delay is increased
					{
						totaltime=frames*delaytime
					}
				
				label=DLGCreateLabel("Est. Time / s")
				totaltimefield=DLGCreateRealField(totaltime, 7,3).DLGIdentifier("totaltimefield").dlgenabled(0)
				taggroup totaltimegroup=dlggroupitems(label, totaltimefield).dlgtablelayout(1,2,0)
				
				
				// The show sum checkbox
				
				number showsum
				getpersistentnumbernote("STEM Averaging:Default Values:Show sum (0-1)", showsum)
				taggroup showsumcheckbox=dlgcreatecheckbox("Sum", showsum).dlgexternalpadding(10,0).dlgidentifier("showsumcheckbox")
												
				
				// The Cont (continuous) checkbox
				
				taggroup modelabel=dlgcreatelabel("Mode")
				number continuous
				getpersistentnumbernote("STEM Averaging:Default Values:Continuous Acquisition", continuous)
				taggroup contcheckbox=dlgcreatecheckbox("Cont.", continuous).dlgidentifier("contcheckbox").dlganchor("West").dlgexternalpadding(0,3).dlgchangedmethod("setupchanged")
				label=dlgcreatelabel("").dlgexternalpadding(1,0)
				taggroup contgroup=dlggroupitems(label, contcheckbox).dlgtablelayout(2,1,0).dlganchor("West")


				// The Spool (spool to disk) Check box
				
				number spool
				getpersistentnumbernote("STEM Averaging:Default Values:Spool to Disk", spool)
				taggroup spoolcheckbox=dlgcreatecheckbox("Spool", spool).dlgexternalpadding(10,0).dlgidentifier("spoolcheckbox")
				

				// The Channel popup menu
				
				number popupmenu_val
				getpersistentnumbernote("STEM Averaging:Default Values:Imaging channel (0-9)", popupmenu_val)
				popupmenu_val=popupmenu_val+1 // note +1 because the first selection position is position 1 - we stored
				// the channel for this position as zero

				TagGroup channelpopup_items
				TagGroup channelpopup = DLGCreatePopup(channelpopup_items, popupmenu_val, "channelpopup_changed").dlgidentifier("channelpopup")

				number i
				string channellabel
				for(i=0; i<10; i++)
					{
						getpersistentstringnote("STEM Averaging:STEM Channels:Imaging channel "+i, channellabel)
						channelpopup_items.DLGAddPopupItemEntry(channellabel)
					}
				
				label=dlgcreatelabel("STEM Channel")
				taggroup channelpopup_group=dlggroupitems(label, channelpopup).dlgtablelayout(1,2,0)

				
				// The bit depth radio
				
				taggroup bitdepthitems
				number bitdepth
				getpersistentnumbernote("STEM Averaging:Default Values:Bit Depth", bitdepth)
				
				taggroup bitlabel=dlgcreatelabel("Bit Depth")
				taggroup bitdepthradio=dlgcreateradiolist(bitdepthitems,bitdepth, "setupchanged").dlgidentifier("bitdepthradio")
				bitdepthradio.dlgaddelement(dlgcreateradioitem("2 Byte",0))
				bitdepthradio.dlgaddelement(dlgcreateradioitem("4 Byte",1))
				taggroup bitdepthgroup=dlggroupitems(bitlabel, bitdepthradio).dlgtablelayout(1,2,0).dlganchor("North")
				
				
				// The format radio
				
				number spoolformat
				taggroup spoolformatitems
				getpersistentnumbernote("STEM Averaging:Default Values:Format (0 dm4) (1 TIFF)", spoolformat)
				taggroup formatlabel=dlgcreatelabel("Format")
				taggroup formatradio=dlgcreateradiolist(spoolformatitems,spoolformat).dlgidentifier("formatradio")
				formatradio.dlgaddelement(dlgcreateradioitem(".dm4",0))
				formatradio.dlgaddelement(dlgcreateradioitem(".tif",1))
				taggroup formatradiogroup=dlggroupitems(formatlabel, formatradio).dlgtablelayout(1,2,0).dlganchor("North").dlgexternalpadding(0,5)

				
				// Assemble the STEM Setup part of the dialog
				
				taggroup spacer=dlgcreatelabel("").dlgexternalpadding(0,0)

				taggroup topcheckboxgroup=dlggroupitems(modelabel,showsumcheckbox, contgroup).dlgtablelayout(1,3,0)
				taggroup checkboxgroup=dlggroupitems(topcheckboxgroup, spoolcheckbox, channelpopup_group).dlgtablelayout(1,3,0).dlganchor("North")

				
				taggroup leftgroup=dlggroupitems(xsizegroup, exposuregroup, delaygroup, checkboxgroup).dlgtablelayout(1,4,0).dlganchor("North").dlgexternalpadding(3,0)
				taggroup righttopgroup=dlggroupitems(ysizegroup, framesgroup, totaltimegroup,bitdepthgroup).dlgtablelayout(1,4,0).dlganchor("North").dlgexternalpadding(3,0)
				taggroup rightgroup=dlggroupitems(righttopgroup, formatradiogroup).dlgtablelayout(1,2,0)
				taggroup allgroup=dlggroupitems(leftgroup, rightgroup).dlgtablelayout(2,1,0)
							
				countbox_items.dlgaddelement(allgroup)
				Dialog_UI.dlgaddelement(countbox)


				// The control box

				taggroup controlbox_items
				taggroup controlbox=dlgcreatebox("Control",controlbox_items).dlgexternalpadding(3,0).dlginternalpadding(13,8)
				taggroup startbutton=dlgcreatepushbutton("Start","startpressed").dlgidentifier("startbutton")
				taggroup stopbutton=dlgcreatepushbutton("Stop","stoppressed").dlgidentifier("stopbutton")


				// Create a colour LED to show the status

				taggroup graphicitems
				taggroup colourled=dlgcreategraphic(20,20).dlgexternalpadding(0,2).dlgidentifier("colourled")
				image colourgraphic:=rgbimage("",4,20,20)
				colourgraphic=self.greyled()

				taggroup imagebitmap=dlgcreatebitmap(colourgraphic)
				dlgaddbitmap(colourled, imagebitmap).dlgexternalpadding(10,0)
				
				
				// Creates the progress bar

				taggroup progressbar=dlgcreateprogressbar("progbar").dlgfill("X")


				// Create the button box and contents
				
				taggroup controlgroup=dlggroupitems(colourled, startbutton, stopbutton).dlgtablelayout(3,1,0)
				taggroup allcontrolgroup=dlggroupitems(controlgroup, progressbar).dlgtablelayout(1,2,0)
				controlbox_items.dlgaddelement(allcontrolgroup)
				Dialog_UI.dlgaddelement(controlbox)

				taggroup footer=dlgcreatelabel("D. R. G. Mitchell v2.1, May 2019").dlgexternalpadding(0,2)
				Dialog_UI.dlgaddelement(footer)
				return Dialog_UI
		}


	// Save the dialog position and settings on close
	
	void abouttoclosedocument(object self)
		{
			// Get the dialog position and save it
			
			documentwindow docwin=getdocumentwindow(0)
			number top, left
			windowgetframeposition(docwin, left, top)
			setpersistentnumbernote("STEM Averaging:Dialog Position:Top",top)
			setpersistentnumbernote("STEM Averaging:Dialog Position:Left",left)
			
			
			// Get the current dialog values and save them
			
			number xsize, ysize, exposure, delay, showsum, aligncheck, contcheck, bitdepthradio, spoolcheck, formatradio
			
			xsize=dlggetvalue(self.lookupelement("xsizefield"))
			ysize=dlggetvalue(self.lookupelement("ysizefield"))
			exposure=dlggetvalue(self.lookupelement("exposurefield"))
			
			setpersistentnumbernote("STEM Averaging:Default Values:Frame X Size", xsize)
			setpersistentnumbernote("STEM Averaging:Default Values:Frame Y Size", ysize)
			setpersistentnumbernote("STEM Averaging:Default Values:Acquisition time (us)", exposure)

			delay=dlggetvalue(self.lookupelement("delayfield"))
			frames=dlggetvalue(self.lookupelement("framesfield"))
			showsum=dlggetvalue(self.lookupelement("showsumcheckbox"))
			contcheck=dlggetvalue(self.lookupelement("contcheckbox"))
			spoolcheck=dlggetvalue(self.lookupelement("spoolcheckbox"))
			// Note the STEM Channel menu saves its value when it is changed.
			bitdepthradio=dlggetvalue(self.lookupelement("bitdepthradio"))
			formatradio=dlggetvalue(self.lookupelement("formatradio"))
			
			setpersistentnumbernote("STEM Averaging:Default Values:Delay time (s)", delay)
			setpersistentnumbernote("STEM Averaging:Default Values:Numbe of frames", frames)
			setpersistentnumbernote("STEM Averaging:Default Values:Show sum (0-1)", showsum)
			setpersistentnumbernote("STEM Averaging:Default Values:Continuous Acquisition", contcheck)
			setpersistentnumbernote("STEM Averaging:Default Values:Spool to Disk", spoolcheck)

			setpersistentnumbernote("STEM Averaging:Default Values:Bit Depth", bitdepthradio)
			setpersistentnumbernote("STEM Averaging:Default Values:Format (0 dm4) (1 TIFF)", formatradio)
		}


		// default object constructor
		
		Dialog_UI( object self )
			{
				ScanIsOn = 0
				self.super.init( self.CreateDialog_UI() )
			}


		// default object destructor
		
		~Dialog_UI( object self )
			{
				If( ScanIsOn ) 
				self.Stop()	// stop scan before UI destruction
			}


	// Initialise function

		void init( object self, number ID )
			{
				// Create the thread and pass in the ID of the dialog, so that the thread can 
				// access the dialog's functions
				
				Acquisition_Thread = Alloc(Acquisition_Thread)
				Acquisition_Thread.LinkToDialog(ID)
				return
			}
			
			
			// Function called by the StartImageRecorder() - periodic measurement thread
			// to stop the recording
			
			void StopImageRecorder(object self)
				{
					RemoveMainThreadTask( taskID )
					capturedframes=0
				}
			
			
	// This is the periodic task which monitors the continuously acquiring DigiScan image 
	// and captures the data
	
	void StartImageRecorder(object self)
		{
			// trap for closure of the dialog
					
			if( !self.LookUpElement( "progbar" ).TagGroupIsValid() ) self.StopImageRecorder()


			// Report the progess of the acquisition
						
			capturedframes=capturedframes+1


			// Source the images
			
			self.DLGSetProgress( "progbar", capturedframes/Frames )
			
			number spool=dlggetvalue(self.lookupelement("spoolcheckbox"))
			image stackimg
			
			
			// The sum check box must be set for the sum image to exist
			
			number sumcheck=dlggetvalue(self.lookupelement("showsumcheckbox"))
			image sumimg
			if(sumcheck==1) sumimg:=getimagefromid(sumid)
			image fastscanimg:=getimagefromid(fastscanid)
		
			
			// The stackimg will only exist if the spool option is not set
			
			if(spool==0) stackimg:=getimagefromid(stackid)
			 
			 
			 // Source the dialog settings
			 
			number exposure=dlggetvalue(self.lookupelement("exposurefield"))
			number xsize=dlggetvalue(self.lookupelement("xsizefield"))
			number ysize=dlggetvalue(self.lookupelement("ysizefield"))
			number delay=dlggetvalue(self.lookupelement("delayfield"))
			number exptime=(xsize*ysize*exposure)/1e6 // dwell is in us
			
			number frames=dlggetvalue(self.lookupelement("framesfield"))
			number bitdepthradio=dlggetvalue(self.lookupelement("bitdepthradio"))
			number formatradio=dlggetvalue(self.lookupelement("formatradio"))
			number contcheck=dlggetvalue(self.lookupelement("contcheckbox"))
			
			number bitdepthval
			if(bitdepthradio==0) bitdepthval=2
			else bitdepthval=4
			number nowticks=gethighrestickcount()
			number elapsedtime=CalcHighResSecondsBetween(fastticks, nowticks)
			
			
			// If this is the first frame and the save format is .dm4  add a scale bar to the running image.
			// This ensures that any spooled .dm4 images have a scale bar attached.
			// However, in the case of .tif selection  the scale bar is left off the displayed image. This
			// ensures that any spooled .tif images do not have a scale bar burnt in. Such a scale bar 
			// would make aligning - movie making etc problematic. Instead, when saving as .tif
			// a small text file containing calibration and other acquisition info is written with the .tifs.
			
			if(capturedframes==1 && formatradio==0) 
				{
					imagedisplay imgdisp=fastscanimg.imagegetimagedisplay(0)
					imgdisp.applydatabar()
				}

					
			// Add the current image to the stack image - but only if the spool checkbox is set to 0
			
			if(spool==0)
				{
					number plane=capturedframes-1
					stackimg[icol, irow, plane]=fastscanimg
				}
			else // The spool option is set on so save the image to the specified path
				{
					number timeinms=round(elapsedtime*1000)
					
					string framename="00000"+capturedframes
					framename="Frame "+right(framename,5)
					string filestring=pathconcatenate(savepath, framename)
					number roundedtime=round((elapsedtime*100))/100

					deletenote(fastscanimg, "STEM Averager:Frame Time (s)")
					setnumbernote(fastscanimg, "STEM Averager:Frame Time (s)",roundedtime)
					
					
					// Save the file in the format specified in the format dialog
					
					if(formatradio==0) saveasgatan(fastscanimg, filestring,1)
					else 
						{
							// To maximise speed, no scale bar is put on the running image. This avoids the
							// need to remove it, save as tiff, then add it back again - slow.
							
							saveastiff(fastscanimg, filestring)
						}
				}

			
			// If the option to display a sum image is shown then update the sum image
			
			if(sumcheck==1) 
				{
					sumimg=sumimg+fastscanimg
					setname(sumimg, "Frames Summed "+capturedframes)
					if(capturedframes==1) // Once a frame has been captured, the calibration will be present - add a scale bar
						{
							imagecopycalibrationfrom(sumimg, fastscanimg)
							imagedisplay sumdisp=sumimg.imagegetimagedisplay(0)
							sumdisp.applydatabar()
						}
				}
				
			setname(fastscanimg, "Frame "+capturedframes+" of "+frames+"  Time "+format(elapsedtime, "%5.2f")+" s")
			number roundedtime=round(elapsedtime*100)/100
			number averageframetime=elapsedtime/(capturedframes-1)


			// Add tags to the stack image - which will only exist if spool==0

			if(spool==0)
				{
					setnumbernote(stackimg, "STEM Averager:Exposure Times (s):Frame "+capturedframes,roundedtime)
					setname(stackimg, "Stack "+capturedframes+" frames "+format(exptime,"%5.2f")+"s exp "+format(averageframetime, "%5.2f")+"s interval")
				}
				
			result("\nCaptured frame : "+capturedframes+" of "+frames+" time : "+format(elapsedtime, "%5.2f")+" s")
			openandsetprogresswindow("Frame : "+capturedframes+" of "+frames, "Elapse time "+format(elapsedtime, "%5.2f")+" s","")
		

			// Terminate the periodic task when it is complete
			
			if(capturedframes==frames) 		
				{
					// Tidy up the images and apply calibrations etc
					
					image img:=getimagefromid(fastscanid)
					
					
					// If the option to sum check box is set - the sum image will exist
					// Calibrate it
					
					if(sumcheck==1)
						{
							imagecopycalibrationfrom(sumimg, img)
							imagedisplay sumdisp=getimagefromid(sumid).imagegetimagedisplay(0)
							sumdisp.applydatabar()
						}
								
					if(spool==0) // the stack image only exists if spool is zero
						{
							image stackimg:=getimagefromid(stackid)
							imagecopycalibrationfrom(stackimg, img)		 
							imagedisplay stackdisp=stackimg.imagegetimagedisplay(0)
							stackdisp.applydatabar()
						}
						
					if(spool==1 && formatradio==1) // Spool to .tif option is selected
						{
							// If the option to spool to .tif is selected, capture the image
							// calibrations and append them to a text file saved with the TIFFS
							// .dm4 files have an innate calibration. Also add the dialog settings
							// as unlike the .dm4 files, these values cannot be appended as tags
										
							number scale=img.imagegetdimensionscale(0)
							string unitstring=img.imagegetdimensionunitstring(0)
							documentwindow textwin=newscriptwindow("",-200,-200,0,0) // display off screen
							textwin.editorwindowaddtext("Pixel size ="+scale+" "+unitstring)
						
							textwin.editorwindowaddtext("\nDwell Time = "+exposure+" us")
							textwin.editorwindowaddtext("\nX Size = "+xsize+" pixels")
							textwin.editorwindowaddtext("\nY Size = "+ysize+" pixels")
							
							textwin.editorwindowaddtext("\nDelay = "+delay+" s")
							textwin.editorwindowaddtext("\nFrame Exposure = "+exptime+" s")
							textwin.editorwindowaddtext("\nFrames = "+frames)
							
							textwin.editorwindowaddtext("\nCont. (continuous (fast) acquisition) (0=No, 1=Yes) = "+contcheck)
							textwin.editorwindowaddtext("\nBit Depth (0=2byte, 1=4byte) = "+bitdepthradio)
							textwin.editorwindowaddtext("\nFormat(0=.dm4, 1=.tif) = "+formatradio)
							
							string textpath=pathconcatenate(savepath, "Image Data.txt")
							editorwindowsavetofile(textwin, textpath)
							textwin.windowclose(0)
						}
						
						
					deleteimage(img)

					result("\n\nMeasurement complete\n")
					

					// Stop the thread
					
					self.stopimagerecorder()
					openandsetprogresswindow("","","")
					self.stoppressed()
				}
	}
			
			
	// Function to start the thread for fast acquistion (Cont check box on)

	void startfast( object self )
		{
			number currentframes=0, displayxsize
			number paramid // The ID of the parameter set passed to DigiScan
			
			getpersistentnumbernote("STEM Averaging:Default Values:Displayed Image X Size", displayxsize)


			// Variables
					
			number counter=1
			number xsize, ysize, exposure, delay, interval, frames, sumcheck, aligncheck, contcheck, channelpopup_val
					
			self.dlggetvalue("xsizefield", xsize)
			self.dlggetvalue("ysizefield", ysize)
			self.dlggetvalue("exposurefield",exposure)

			self.dlggetvalue("delayfield",delay)
			self.dlggetvalue("framesfield",frames)
									
			self.dlggetvalue("showsumcheckbox",sumcheck)
			self.dlggetvalue("contcheckbox",contcheck)
			self.dlggetvalue("channelpopup",channelpopup_val)
			channelpopup_val=channelpopup_val-1 // This is because channel 0 is returned as position 1 - hence the minus 1
			
			string time=gettime(1)
			result("\n\n\nAcquisition started: "+time+"\n\nFrame X = "+xsize+ "\nFrame Y = "+ysize+"\nDwell / pxl = "+exposure+" us\nDelay = "+format(delay, "%5.2f")+" s"+"\nFrames = "+frames+"\n")
			
	
			// Some image variables - img stores the returned output from DigiScan. Imgsum is a rolling sum of the acquired
			// images. Imgstack is a 3D image is which each image is stacked 
					
			image imgstack, img, imgsum
					
			number dataType
			self.dlggetvalue("bitdepthradio", datatype)
			number bitdepth
			if(datatype==0) bitdepth=2
			else bitdepth=4
			
			number signed=0
			img:= IntegerImage( "Img "+currentframes, bitdepth, signed, xsize, ysize )   
			fastscanid=img.imagegetid() // this image's id is passed into the parameter set given to DigiScan
			imgsum=IntegerImage("Sum Image", bitdepth, signed, xsize, ysize )   
			sumid=imgsum.imagegetid()
			
			
			// Get the spool checkbox status - if this is set to on, then do not write the data to 
			// a 3D stack
			
			number spool=dlggetvalue(self.lookupelement("spoolcheckbox"))
			
			
			// Create the 3D stack to hold the data - if it is too big for the memory - bail out

			// The 3D stack is created if the spool option is not selected. If spool is selected, files are written to 
			// disk instead
			
			if(spool==0)
				{
						try imgstack=integerimage("",bitdepth, signed, xsize, ysize, frames)
						catch
							{
								showalert("Insufficient memory - reduce the size/number of images.",2)
								self.stoppressed()
								return
							}
						stackid=imgstack.imagegetid()					
											
						setname(imgstack, "Stack "+frames+" frames "+exposure+"us dwell "+format(delay,"%5.2f")+"s delay")
						self.zoomtosize(imgstack, displayxsize)								
						showimage(imgstack)
						documentwindow docwin=getdocumentwindow(0)
						docwin.windowsetframeposition(0,0)
				}

						
								
			// Display and position the running image

			showimage(img)
			setname(img, "Frame 0 : 0.00s")
			self.zoomtosize(img, displayxsize)								
			documentwindow docwin=getdocumentwindow(0)
			docwin.windowsetframeposition(0,0)
			updateimage(img)
			
								
			number top, left, bottom, right
			docwin.windowgetframebounds(top, left, bottom, right)
	
								
			// display the sum image if the sum checkbox is checked

			if(sumcheck==1)
				{
					showimage(imgsum)
					self.zoomtosize(imgsum, displayxsize)								
					documentwindow sumwin=getdocumentwindow(0)
					sumwin.windowsetframeposition(right, top)
					updateimage(imgsum)
				}

								
			// Create a DigiScan parameter set and apply them to DigiScan
										
			number signalIndex = channelpopup_val // The stem signal source is set in teh STEM Channel menu
			number rotation = 0   // degree of rotation
			number continuous=contcheck // have continuous or single frame acquisitions
			number lineSynch = 0 // do not use line synching

			number synchronous = 0 // 0 = return immediately, 1 = return when finished
			number selected=1 // acquire signal
			paramID = DSCreateParameters( xsize, ysize, rotation, exposure, linesynch )
			DSSetParametersSignal( paramID, signalIndex, bitdepth, selected, fastscanid )
								
								
			// Start the continuous acquisition

			DSStartAcquisition( paramID, continuous, synchronous )
			
			
			// Call the task to periodically grab data from the front-most image
			
			capturedframes=0
						
			
			// ensure that DigiScan has set up the images and has acquired the first image
			// before capturing. The settling time (set in the Global Info - gives DigiScan time to set up.
			
			number frametime=((xsize*ysize*exposure)/1e6)
			number settlingtime
			
			getpersistentnumbernote("STEM Averaging:Default Values:DigiScan Settling Time (s)", settlingtime)
			number totaldelay=(frametime*3)+settlingtime // allow 3 full frames of capture before starting
			delay(totaldelay*60) // note delays work in 60ths of a second
			
		
			
			// Add the periodic task to record the images
			// and set the timing variable (global) to keep track of elapsed time
			
			fastticks=gethighrestickcount()
			
			// After giving DigiScan enough time to ensure a full image has bee acquired, capture
			// and image after each frame
			
			
			taskid = self.AddMainThreadPeriodicTask( "StartImageRecorder", delay ) // delay is the value
			// shown in the dialog. The default is for this to be the frametime, but the user may extend this
			// if they choose to do so


			// Save the settings to the stack image - just in case they are needed in future
			
			if(spool==0) // The imgstack image only exists if spool is set to 0
				{
					setnumbernote(imgstack, "STEM Averager:Settings:Dwell (us)",exposure)
					setnumbernote(imgstack, "STEM Averager:Settings:Frames",frames)
					setnumbernote(imgstack, "STEM Averager:Settings:Bit Depth",bitdepth)

					setnumbernote(imgstack, "STEM Averager:Settings:Delay (s)",delay)
					setnumbernote(imgstack, "STEM Averager:Settings:X Size",xsize)
					setnumbernote(imgstack, "STEM Averager:Settings:Y Size",ysize)
					setnumbernote(imgstack, "STEM Averager:Settings:Cont Check Box",contcheck)
				}
			else // put this info the running image as this will get saved on each spooled image
				{
					setnumbernote(img, "STEM Averager:Settings:Dwell (us)",exposure)
					setnumbernote(img, "STEM Averager:Settings:Frames",frames)
					setnumbernote(img, "STEM Averager:Settings:Bit Depth",bitdepth)

					setnumbernote(img, "STEM Averager:Settings:Delay (s)",delay)
					setnumbernote(img, "STEM Averager:Settings:X Size",xsize)
					setnumbernote(img, "STEM Averager:Settings:Y Size",ysize)
					setnumbernote(img, "STEM Averager:Settings:Cont Check Box",contcheck)
				}


			if(sumcheck==1) // if the sum check box is set, copy all the tags to it
				{
					taggroup imgtags, sumtags
					imgtags=imagegettaggroup(img)
					sumtags=imagegettaggroup(imgsum)
					taggroupcopytagsfrom(sumtags, imgtags)
				}
				
			return
		}
		
		
	// Function to start the slow acquistion (Cont check box off)
	// This sets up DigiScan to run in continuous mode and adds a periodic event thread to capture the
	// output periodically

	void startslow( object self )
		{
			Acquisition_Thread.init().StartThread("StartSlowAcquisition")
			return
		}


	// Responds when the start button is pressed

	void startpressed(object self)
		{
			// Set field and button status
			
			self.dialogreset(0)
			self.setelementisenabled("startbutton",0)
	
	
			// If the spool check box is set, capture a save to path
			
			number spool=dlggetvalue(self.lookupelement("spoolcheckbox"))
			number formatradio=dlggetvalue(self.lookupelement("formatradio"))
			
			if(spool==1) // spool the files to disk
				{
					if(!saveasdialog("Save spooled files to", "Do Not Change Me", savepath))
						{
							self.setelementisenabled("startbutton",1)
							self.dialogreset(1)
							return
						}
						

					savepath=pathextractdirectory(savepath,0) // remove the file name and use only the path
					string testpath
					
					if(formatradio==0) testpath=pathconcatenate(savepath, "Frame 00001.dm4") // The name of the first file - format set to .dm4 in dialog
					else testpath=pathconcatenate(savepath, "Frame 00001.tif") // format set to .tif in dialog
					

					// Check to see if it is present at the chosen path - if yes, warn about overwriting
					
					if(doesfileexist(testpath))						
						{
							if(twobuttondialog("Data exists in this selected location.","Cancel?", "Overwrite?"))
								{
									// Cancel was pressed - reset the dialog
									
									self.dialogreset(1)
									self.setelementisenabled("startbutton",1)
									return
								}
						}		
				}
	

			// Call the function to start the thread
					
			number contcheck=dlggetvalue(self.lookupelement("contcheckbox"))
			if(contcheck==0) self.StartSlow()
			else self.startFast()
			scanison=true
			
			
			// Set the Green LED on
			
			taggroup ledstatus=self.lookupelement("colourled")
			self.LookupElement("colourled").DLGGetElement(0).DLGBitmapData(self.greenled())
		}


	void DialogReset(object self, number enabledstatus)
		{
			// Reset the fields and button status

			self.setelementisenabled("xsizefield", enabledstatus)
			self.setelementisenabled("ysizefield", enabledstatus)
			self.setelementisenabled("exposurefield", enabledstatus)
			self.setelementisenabled("delayfield", enabledstatus)
			
			self.setelementisenabled("framesfield", enabledstatus)
			self.setelementisenabled("showsumcheckbox", enabledstatus)
			self.setelementisenabled("contcheckbox", enabledstatus)
			self.setelementisenabled("spoolcheckbox", enabledstatus)
			
			self.setelementisenabled("bitdepthradio", enabledstatus)
			self.setelementisenabled("formatradio", enabledstatus)
			self.setelementisenabled("channelpopup", enabledstatus)
			
			if(enabledstatus==1) self.setelementisenabled("startbutton",1)

				
			// Set the LED to grey
				
			taggroup ledstatus=self.lookupelement("colourled")
			self.LookupElement("colourled").DLGGetElement(0).DLGBitmapData(self.greyled())
			openandsetprogresswindow("","","")

			
			// Reset the progress bar
											
			self.dlgsetprogress("progbar",0)
		}


	// Responds when the stop button is pressed

	void stoppressed(object self)
		{
		
			// If the fast continuous acquisition mode is running - it will be stopped
			
			self.stopimagerecorder()
			openandsetprogresswindow("","","")

		
			// Call the function to stop the slow acquisition thread and reset the dialog
			
			scanison=false
			self.DialogReset(1)


			// Catches the exception if the thread is stopped but is not yet running
			
			try self.stop()
			catch
				{
					exit(0)
				}
		}


	// Function to stop the thread

	void stop( object self )
		{
			Acquisition_Thread.Stop()
			return
		}	
		
	}


// Contain the main script as a function. This will ensure all script objects are destructed properly

void main()
	{
		// Create the dialog
		
		number xpos, ypos
		getpersistentnumbernote("STEM Averaging:Dialog Position:Top",ypos)
		getpersistentnumbernote("STEM Averaging:Dialog Position:Left",xpos)

		object Dialog_UI = Alloc(Dialog_UI)
		Dialog_UI.Display("STEM Averaging")
		documentwindow docwin=getdocumentwindow(0)
		windowsetframeposition(docwin, xpos, ypos)

		
		// Get the dialog object's ID and pass it into the thread via the init() function
		
		number dialogID=Dialog_UI.ScriptObjectGetID()
		Dialog_UI.init(dialogID)
		Return
	}


main()