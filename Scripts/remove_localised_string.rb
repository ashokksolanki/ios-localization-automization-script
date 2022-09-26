#!/usr/bin/ruby

# Base directory
baseDirectory = "path-to-localization-folder-/Localization"
localisedStringFileName = "Localizable.strings"

# Get all language directory and extract un-translated strings and write to file
directories = Dir.entries("./#{baseDirectory}").select  do |entry|
    if entry.include?(".lproj")        
        file = File.join("./#{baseDirectory}",entry)
        File.directory?(file) && !(entry =='.' || entry == '..')     
    else
        false
    end
end

#check if value is valid string
def isValidKeyValueLocalisationString(value) 
    return value.include?("=") && value.scan(/"/).count == 4  && value.chars.last == ";"
end

# map strings to key-value pair
def getFileStringMapping(fileData)
    fileStringMapping = Hash.new
    for value in fileData do
        if isValidKeyValueLocalisationString(value)
            key, keyValue = extractKeyValueFromLocalisationString(value)
            fileStringMapping[key] = keyValue
        end
    end   
    return fileStringMapping    
end

#key value extraction
def extractKeyValueFromLocalisationString(value)
    key = value.partition("=").first
    keyValue = value.partition("=").last
    keyValue = keyValue.partition(";").first
    return key, keyValue
end

# New string to add
keyToRemove = ARGV[0]
keyToRemove = "\"#{keyToRemove}\" "

for directory in directories do
    dirName = directory.partition(".").first
    
        # Localised file data with key value pairing
        localisedFile = File.open("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", "r")
        localisedFileData = localisedFile.readlines.map(&:chomp)
        localisedValuesArray = Array.new
        keyValueMapping = getFileStringMapping(localisedFileData)
        puts keyValueMapping
        puts keyToRemove
        puts "#{keyToRemove}"
        if keyValueMapping.key?(keyToRemove)
            for value in localisedFileData do
                key, keyValue = extractKeyValueFromLocalisationString(value)
                if key != keyToRemove
                    if isValidKeyValueLocalisationString(value)
                        localisedValuesArray.push(value)
                    end    
                end
            end 
            # Sorting array to write in sorted way
            localisedValuesArray.sort!
            # write to file
            File.write("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", localisedValuesArray.join("\n"), mode: "w")

            puts "String removed successfully"
        else
            puts "String with given key doesn't exist"
        end
        
end
