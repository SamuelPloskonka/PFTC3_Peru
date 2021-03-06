###########################
### CALCULATE LEAF AREA ###
###########################


#### LOAD LIBRARY
devtools::install_github("richardjtelford/LeafArea")
library(LeafArea)


#### Function to calculate leaf area
loop.files <-  function(files){
  
  file.copy(files, new.folder)
  #if(grepl("-NA$", files)){
  #newfile <- basename(files)
  #file.rename(paste0(new.folder, "/", newfile), paste0(new.folder,
  #"/", gsub("-NA$", "", newfile)))
  #}
  print(files)
  area <- try(run.ij(set.directory = new.folder, distance.pixel = 237, known.distance = 2, log = TRUE, low.size = 0.005, trim.pixel = 60, trim.pixel2 = 150, save.image = TRUE))
  if(inherits(area, "try-error")){
    return(data.frame(LeafArea = NA))
  }
  file.copy(dir(new.folder, full.names = TRUE, pattern = "\\.tif"), output.folder)
  Sys.sleep(0.1)
  if(any(!file.remove(dir(new.folder, full.names = TRUE) ))) stop()
  res <- data.frame(ID = names(unlist(area[[2]])), LeafArea = (unlist(area[[2]])))
  return(res)
}


# test run.ij
# run.ij(set.directory = "/Volumes/INTENSO/LeafScans/20-03-12/Problems/", distance.pixel = 237, known.distance = 2, log = TRUE, low.size = 0.1, trim.pixel = 58, trim.pixel2 = 150, save.image = TRUE)



###########################################################################
#### Calculate leaf area for 2020 data
# make a list of files, temporary folder and output folder
list.of.files <- dir(path = paste0("/Volumes/INTENSO/PFTC5_Peru_2020_LeafScans/20-03-15"), pattern = "jpeg|jpg", recursive = TRUE, full.names = TRUE)
new.folder <- "/Volumes/INTENSO/PFTC5_Peru_2020_LeafScans/Temp"
output.folder <- "/Volumes/INTENSO/PFTC5_Peru_2020_LeafScans/Output/20-03-15"

# Run function
LeafArea.raw <- plyr::ldply(list.of.files, loop.files)

# save data as csv
dim(LeafArea.raw)
write_csv(LeafArea.raw, path = "traits/data/2020/LeafArea.raw_20-03-15.csv")


###########################################################################
#### Calculate leaf area for 2018 data
list.of.files <- dir(path = paste0("/Volumes/PFT3/Peru_leaves"), pattern = "jpeg|jpg", recursive = TRUE, full.names = TRUE)
new.folder <- "/Volumes/PFT3/Temp"
output.folder <- "/Volumes/PFT3/Output_Peru_10-07-2018"

LeafArea.raw <- plyr::ldply(list.of.files, loop.files)

dim(LeafArea.raw)
save(LeafArea.raw, file = "traits/data/LeafArea.raw.Rdata")

# remove duplicate leaves
LeafArea %>% 
  group_by(ID) %>% 
  filter()


###########################################################################
#### Sean leaf areas without loop

file.list.sean <- list.files(path = "C:/Users/cpo082/Desktop/leaf
                             data/SEAN_cropped")

sean_area <- run.ij (set.directory = "C:/Users/cpo082/Desktop/leaf
                     data/SEAN_cropped", distance.pixel = 237, known.distance = 2, log =
                       TRUE, save.image = TRUE, low.size = 0.05)

sean_cropped_LA_new <- data.frame(ID = names(unlist(sean_area
                                                           [[2]])), LeafArea = (unlist(sean_area[[2]])))

save(sean_cropped_LA_new, file = "C:/Users/cpo082/Desktop/leaf
     data/sean_cropped_LA_new.Rdata")

