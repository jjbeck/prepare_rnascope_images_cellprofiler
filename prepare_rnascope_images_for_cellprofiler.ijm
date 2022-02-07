input = "D:/Arc_subpopulations";

//set directory and get folders in directory
dirList = getDirectory(input);

count = 1;
prepareFiles(dirList); 

//Recursively go through folders inside main directory
//perform z-project, max intensity, greyscale, and saving on each channel
//save in folder called "imagej" in each child directory

function prepareFiles(dir) {
   //get folders and files in main directory
   list = getFileList(dir);
   for (i=0; i<list.length; i++) {
      if (endsWith(list[i], "/"))
         listFiles(""+dir+list[i]);
      else
      	 //only perfomr function on files that end with .czi
      	 if (endsWith(list[i], ".czi")) {
      	 	//constraint to only run on .czi files within a folder titled "rnascope"
      	 	if (dir.contains("rnascope")) {
      	 		indexForSub = indexOf(dir, "/");
      	 		windowPrefix = substring(dir, indexForSub-3);
   				//don't run on control slides or 10x whole brain images
         		if(list[i].contains("whole_brain") || list[i].contains("negative") || list[i].contains("positive")) {
         			continue
         		}
         		open(dir + list[i]);

         		//run z-project, max intensity, greyscale on probe of interest
         		selectWindow(windowPrefix+ list[i] + " - C=0");
         		run("Z Project...", "projection=[Max Intensity]");
         		//run("Brightness/Contrast...");
				run("Enhance Contrast", "saturated=0.35");
				run("RGB Color");
				run("16-bit");
				saveLocation = input + "/" + windowPrefix + "imagej/" + replace(list[i], ".czi", "_" + substring(windowPrefix, 0, 3)+ ".tif");
				if (File.exists(input + "/" + windowPrefix + "imagej/")) {
					saveAs("Tiff", saveLocation);
				} else {
					print("doesn't exist");
					File.makeDirectory(input + "/" + windowPrefix + "imagej/");
					saveAs("Tiff", saveLocation);
				}

				//run z-project, max intensity, greyscale on pomc
				selectWindow(windowPrefix+ list[i] + " - C=1");
				run("Z Project...", "projection=[Max Intensity]");
         		//run("Brightness/Contrast...");
				run("Enhance Contrast", "saturated=0.35");
				run("RGB Color");
				run("16-bit");
				saveLocation = input + "/" + windowPrefix + "imagej/" + replace(list[i], ".czi", "_" + "pomc.tif");
				saveAs("Tiff", saveLocation);

				//run z-project, max intensity, greyscale on agrp
				selectWindow(windowPrefix+ list[i] + " - C=2");
				run("Z Project...", "projection=[Max Intensity]");
         		//run("Brightness/Contrast...");
				run("Enhance Contrast", "saturated=0.35");
				run("RGB Color");
				run("16-bit");
				saveLocation = input + "/" + windowPrefix + "imagej/" + replace(list[i], ".czi", "_" + "agrp.tif");
				saveAs("Tiff", saveLocation);

				//run z-project, max intensity, greyscale on dapi
				selectWindow(windowPrefix+ list[i] + " - C=3");
				run("Z Project...", "projection=[Max Intensity]");
         		//run("Brightness/Contrast...");
				run("Enhance Contrast", "saturated=0.35");
				run("RGB Color");
				run("16-bit");
				saveLocation = input + "/" + windowPrefix + "imagej/" + replace(list[i], ".czi", "_" + "dapi.tif");
				saveAs("Tiff", saveLocation);

				//close all windows
				close("*");
      	 }
      }
   }
}