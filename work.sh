echo "start"; date;
for f in 01_band/*.jp2; do gdal_translate ${f} 01_band/`basename ${f} .jp2`.tif; done;
mkdir 2_8bit; mkdir 3_merge; 
for f in 01_band/*.tif; do gdal_calc.py -A ${f} --calc="(A<=0)*0 + (A>0)*(A<=3500)*A/14 + (A>3500)*250" --type=Byte --outfile 2_8bit/`basename ${f}`; done; echo "end"; date; 
gdal_merge.py -o 3_merge/rgb.tif -co PHOTOMETRIC=RGB -separate 2_8bit/band04.tif 2_8bit/band03.tif 2_8bit/band02.tif; 
gdal2tiles.py -s "EPSG:32635" -z "9-15" --xyz 3_merge/rgb.tif;

