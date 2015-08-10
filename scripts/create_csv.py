from glob import glob

files = glob("*duplicates_marked*.bam")

print ",".join(["samplename", "description", "sampletype", "cell"])
for file in files:
    sampletype, cell = file.split("_")[1:3]
    description = sampletype + "_" + cell
    print ",".join([file, description, sampletype, cell])

