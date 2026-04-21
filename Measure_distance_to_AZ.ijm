/*
 * Macro to measure the distance of SVs to the AZ
 By Ramirez-Franco J.
 Based on this:
 http://forum.imagej.net/t/quantifying-distance-of-multiple-points-from-a-freehand-line/3287
 https://gist.github.com/lacan/74f550a21ea97f46c74f1a110583586d#file-points_to_curve_distance-ijm
 */
macro "Semiautomated quantification of Distance of SVs to AZ, [F9]"
//Prompt to open a new image or to use open image
{
	want_to_open = getBoolean ("Is the file already open?");
			if (want_to_open==1) {
				}
			else if (want_to_open==0) 
				{
				path_to_file = File.openDialog("Please select the image to open");
				open(path_to_file);
				}

//Setting global scale if it is not set				
if (is("global scale"))
    {print("Global scale is ON");}
else
    {setTool(4);
	waitForUser("Applying global scale", "Seems global scale is OFF; This is probably the first image... \nPlease draw a line over the scale bar using SHIFT, then press OK");
    getLine(x1, y1, x2, y2, lineWidth);
    length = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    Dialog.create("Setting scale");
	Dialog.addMessage("Please input line length in nanometers");
	Dialog.addNumber("Nanometers:", 200);
	Dialog.show();
	nm = Dialog.getNumber();
	run("Set Scale...", "distance="+length+" known="+nm+" unit=nm global");}

//Creating subdirectories
 name = getTitle();
 imgn = getImageID();
	selectImage(imgn);
	filename_clean = File.nameWithoutExtension();
	source_info = getInfo("image.filename");
	img_name = getTitle();
	path_to_parent = File.directory;
	
	//function to get foldername
	path_to_parent = File.directory;
	path_to_parent = replace(path_to_parent, "\\", "/");
	if (endsWith(path_to_parent, "/"))
    path_to_parent = substring(path_to_parent, 0, lengthOf(path_to_parent)-1);
	pos = lastIndexOf(path_to_parent, "/");
	folderName = substring(path_to_parent, pos+1);
	print(folderName);

	path_to_results = path_to_parent +"/"+folderName+"_results/";////ROIsets and coordinates at the end of the analysis.////////////
	File.makeDirectory(path_to_results);///////////////////////////////////////////////////////////////////////////
 	roiManager("Show All");
 	roiManager("Reset");
 	run("Clear Results");

// 1. Draw Curve
setTool("freeline");
waitForUser("Draw a freehand curve correspondig to the AZ and click OK");
run("Fit Spline");
Roi.setName("Curve");
roiManager("Add");

// 2. Draw Points
setTool("multipoint");
waitForUser("Click on the limit of each SV closer to the AZ and click OK");
Roi.setName("Points");
roiManager("Add");

// 3. Make Distance Map
getDimensions(x,y,c,z,t);
newImage(name+" - Distance Map", "8-bit white", x, y, 1);
setForegroundColor(0, 0, 0);
roiManager("Select",0);
run("Draw", "slice");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Exact Euclidean Distance Transform (3D)");

// 4. Measure Points
roiManager("Select", 1);
run("Measure");

// Saving results and printing the saved things
roiManager("save", path_to_results+filename_clean+"_ROIset.zip");
saveAs("Results", path_to_results+filename_clean+"_Distances.txt");//Use .csv alternativvely for excel direct compatibility
setOption("Changes", false);
close("Results");
close("ROI Manager");
run("Close All");
print("Distances in nanometers appear in the MEAN column");
print("These results are saved as"+path_to_results+filename_clean+"_Distances.txt");
print("Roiset saved as "+path_to_results+filename_clean+"_ROIset.zip");
}
